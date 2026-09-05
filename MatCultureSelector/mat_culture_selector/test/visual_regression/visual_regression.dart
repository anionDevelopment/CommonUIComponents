/// Support for the visual-regression-tests of MatCultureSelector.
///
/// Unlike the visual-regression-tests of a web-frontend (see the "automation-using-scriptcollection"-skill), this
/// codeunit does not render in a browser, so there is no "engine"-dimension a baseline has to be split by: the
/// widget-tree is rasterized by Flutter's own Skia-based renderer, which is expected to produce the same pixels
/// regardless of the host it runs on. Reproducibility across Windows and Linux is nevertheless not guaranteed on
/// an arbitrary developer-machine (the version of the Flutter-SDK and therefore of the fonts it ships differ), so
/// both the generation and the assertion of the baselines are only expected to be reproducible when they run
/// inside the same container (see `Other/QualityCheck/VisualRegressionContainer.py`); running them directly on a
/// host is useful during development but not authoritative.
///
/// Every test which uses [expectWidgetToLookLikeBaseline] must pass `tags: visualRegressionTestTag` to
/// `testWidgets`, so that the normal `flutter test` (which every contributor and the non-visual part of
/// `RunTestcases.py` run) can exclude them: comparing against a baseline which was generated inside the container
/// would otherwise be flaky on a developer's own machine. The container-based scripts run them explicitly with
/// `--tags visual-regression --run-skipped` instead (see `dart_test.yaml`).
///
/// The baseline-images are additionally the example-pictures of the readme (see
/// `Other/QualityCheck/UpdateVisualRegressionBaselines.py`), which is why they are stored losslessly as png and
/// why every testcase renders the widget on a surface which shows nothing but the widget itself.
library;

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;

/// The tag every visual-regression-testcase has to be declared with. See the library-comment above.
const String visualRegressionTestTag = 'visual-regression';

/// Amount of pixels (after the downscaling described at [_downscaleFactor]) a rendered image is allowed to differ
/// from its baseline. Chosen as a compromise: small enough to catch a real change of layout or color (which
/// affects whole regions, so hundreds of downscaled pixels), large enough to tolerate the antialiasing-noise which
/// remains even between two renders of the exact same widget-tree.
const int maximalAmountOfDifferentPixels = 20;

/// The factor images are downscaled by (using a box/average-filter) before they are compared. Averaging a block of
/// pixels spreads out small per-pixel rendering-noise so that it stays below [_maximalDifferencePerColorChannel],
/// while a part of the image which really changed keeps differing. Mirrors the `downscale_factor` of
/// `TFCPS_VisualRegressionTests.check_screenshots_are_similar`.
const int _downscaleFactor = 4;

/// The per-channel (red/green/blue) difference (0-255) a pixel has to exceed to count as "different" at all.
const int _maximalDifferencePerColorChannel = 32;

/// The folder which contains the baseline-images.
///
/// `flutter test` always runs with the current directory set to the package which contains the pubspec.yaml, so
/// "mat_culture_selector". The baselines live next to it, at codeunit-level (see
/// "Other/Resources/VisualRegressionBaselines" in the "automation-using-scriptcollection"-skill), so that they are
/// not specific to this one dart-package.
Directory _baselinesDirectory() {
  return Directory(path.join(Directory.current.parent.path, 'Other', 'Resources', 'VisualRegressionBaselines'));
}

/// The folder the images of a failed comparison are written to. It is part of "Other/Artifacts" and therefore
/// ignored by git, like every other output of a testrun.
Directory _failuresDirectory() {
  return Directory(path.join(Directory.current.parent.path, 'Other', 'Artifacts', 'VisualRegressionTestResults'));
}

/// Renders [widgetUnderTest] on a surface of the size [surfaceSize], optionally runs [interact] to reach a
/// transient state (for example an opened dropdown) before capturing it, and then asserts that the result looks
/// like its baseline-image [baselineName].
///
/// If the testrun was started with `flutter test --update-goldens` (which sets [autoUpdateGoldenFiles]) then the
/// baseline is (re-)generated from the current render instead of being compared against.
Future<void> expectWidgetToLookLikeBaseline(
  WidgetTester tester,
  Widget widgetUnderTest,
  String baselineName, {
  required Size surfaceSize,
  Future<void> Function(WidgetTester tester)? interact,
}) async {
  tester.view.physicalSize = surfaceSize;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(widgetUnderTest);
  await tester.pumpAndSettle();

  if (interact != null) {
    await interact(tester);
    await tester.pumpAndSettle();
  }

  // Both calls have to run inside the same `runAsync` (mirroring `matchesGoldenFile`'s own implementation):
  // `toImage`/`toByteData` complete via a real platform-callback, which never fires while only the fake-async zone
  // of `testWidgets` is pumped. Calling them unwrapped does not throw, it returns a premature, truncated image and
  // then leaves that callback pending forever, which makes the whole test hang on exit.
  final ByteData? renderedBytes = await tester.runAsync<ByteData?>(() async {
    final ui.Image capturedImage = await captureImage(tester.element(find.byWidget(widgetUnderTest)));
    final ByteData? data = await capturedImage.toByteData(format: ui.ImageByteFormat.png);
    capturedImage.dispose();
    return data;
  });
  final img.Image? rendered = img.decodePng(renderedBytes!.buffer.asUint8List());
  if (rendered == null) {
    fail('The image of "$baselineName" could not be decoded as a png-image, which should be impossible.');
  }

  final File baselineFile = File(path.join(_baselinesDirectory().path, '$baselineName.png'));

  if (autoUpdateGoldenFiles) {
    baselineFile.parent.createSync(recursive: true);
    baselineFile.writeAsBytesSync(img.encodePng(rendered));
    return;
  }

  if (!baselineFile.existsSync()) {
    fail(
      'No baseline-image exists for "$baselineName" (expected at "${baselineFile.path}"). Generate it with '
      '"task UpdateVisualRegressionBaselines" (see the "automation-using-scriptcollection"-skill) and commit it.',
    );
  }
  final img.Image? baseline = img.decodePng(baselineFile.readAsBytesSync());
  if (baseline == null) {
    fail('The baseline-image "${baselineFile.path}" could not be decoded as a png-image.');
  }

  if (rendered.width != baseline.width || rendered.height != baseline.height) {
    fail(
      'The image of "$baselineName" (${rendered.width}x${rendered.height}) has a different size than its baseline '
      '(${baseline.width}x${baseline.height}).',
    );
  }

  final int differentPixels = _countDifferentPixels(rendered, baseline);
  if (maximalAmountOfDifferentPixels < differentPixels) {
    final File actualFile = _preserveFailureArtifact(baselineName, 'actual', rendered);
    final File differenceFile = _preserveFailureArtifact(baselineName, 'diff', _visualizeDifference(rendered, baseline));
    fail(
      'The image of "$baselineName" differs from its baseline in $differentPixels pixel(s) after downscaling '
      '(allowed: $maximalAmountOfDifferentPixels). The actual render was written to "${actualFile.path}" and a '
      'visualization of the difference to "${differenceFile.path}"; compare them with the baseline at '
      '"${baselineFile.path}". If the change of appearance was intended, regenerate the baseline with '
      '"task UpdateVisualRegressionBaselines".',
    );
  }
}

int _countDifferentPixels(img.Image rendered, img.Image baseline) {
  final img.Image downscaledRendered = _downscale(rendered);
  final img.Image downscaledBaseline = _downscale(baseline);
  int differentPixels = 0;
  for (int y = 0; y < downscaledRendered.height; y++) {
    for (int x = 0; x < downscaledRendered.width; x++) {
      if (_maximalDifferencePerColorChannel < _channelDifference(downscaledRendered.getPixel(x, y), downscaledBaseline.getPixel(x, y))) {
        differentPixels++;
      }
    }
  }
  return differentPixels;
}

img.Image _downscale(img.Image image) {
  if (_downscaleFactor < 2) {
    return image;
  }
  return img.copyResize(
    image,
    width: (image.width / _downscaleFactor).ceil().clamp(1, image.width),
    height: (image.height / _downscaleFactor).ceil().clamp(1, image.height),
    interpolation: img.Interpolation.average,
  );
}

/// The biggest difference of the red-, green- and blue-channel of the two pixels. The alpha-channel is ignored
/// because both images are fully opaque.
int _channelDifference(img.Pixel a, img.Pixel b) {
  final int redDifference = (a.r - b.r).abs().round();
  final int greenDifference = (a.g - b.g).abs().round();
  final int blueDifference = (a.b - b.b).abs().round();
  return <int>[redDifference, greenDifference, blueDifference].reduce((int value, int element) => value > element ? value : element);
}

/// Produces an image of the same size as [rendered] in which every pixel whose block differed from the baseline by
/// more than [_maximalDifferencePerColorChannel] is painted red and everything else is a dimmed, grayscale copy of
/// [rendered] - so a reviewer immediately sees which area changed.
img.Image _visualizeDifference(img.Image rendered, img.Image baseline) {
  final img.Image downscaledRendered = _downscale(rendered);
  final img.Image downscaledBaseline = _downscale(baseline);
  final img.Image visualization = img.Image.from(rendered)..convert(numChannels: 3);
  final double blockWidth = rendered.width / downscaledRendered.width;
  final double blockHeight = rendered.height / downscaledRendered.height;
  for (int y = 0; y < rendered.height; y++) {
    for (int x = 0; x < rendered.width; x++) {
      final int blockX = (x / blockWidth).floor().clamp(0, downscaledRendered.width - 1);
      final int blockY = (y / blockHeight).floor().clamp(0, downscaledRendered.height - 1);
      final bool differs = _maximalDifferencePerColorChannel <
          _channelDifference(downscaledRendered.getPixel(blockX, blockY), downscaledBaseline.getPixel(blockX, blockY));
      if (differs) {
        visualization.setPixelRgb(x, y, 255, 0, 0);
      } else {
        final img.Pixel original = rendered.getPixel(x, y);
        final int gray = ((original.r + original.g + original.b) / 3 * 0.5).round();
        visualization.setPixelRgb(x, y, gray, gray, gray);
      }
    }
  }
  return visualization;
}

File _preserveFailureArtifact(String baselineName, String suffix, img.Image image) {
  final Directory directory = _failuresDirectory();
  directory.createSync(recursive: true);
  final File file = File(path.join(directory.path, '${baselineName}_$suffix.png'));
  file.writeAsBytesSync(img.encodePng(image));
  return file;
}
