/// Support for the visual-regression-tests of MatDarkmodeToggleButton.
///
/// Unlike the visual-regression-tests of a web-frontend (see the "automation-using-scriptcollection"-skill), this
/// codeunit does not render in a browser, so there is no "engine"-dimension a baseline has to be split by: the
/// widget-tree is rasterized by Flutter's own Skia-based renderer, which is expected to produce the same pixels
/// regardless of the host it runs on. Reproducibility across Windows and Linux is nevertheless not guaranteed on an
/// arbitrary developer-machine (installed system-fonts and their hinting/antialiasing differ), so both the
/// generation and the assertion of the baselines are only expected to be reproducible when they run inside the same
/// container (see `Other/QualityCheck/VisualRegressionContainer.py`); running them directly on a host is useful
/// during development but not authoritative.
///
/// Every test which uses [expectDemoToLookLikeBaseline] must pass `tags: visualRegressionTestTag` to `testWidgets`,
/// so that the normal `flutter test` (which every contributor and the non-visual part of `RunTestcases.py` run)
/// skips them (see "dart_test.yaml"): comparing against a baseline which was generated inside the container would
/// otherwise be flaky on a developer's own machine. The container-based scripts run them explicitly with
/// `--tags visual-regression --run-skipped` instead.
library;

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:mat_darkmode_toggle_button/mat_darkmode_toggle_button.dart';
import 'package:path/path.dart' as path;

/// The tag every visual-regression-testcase has to be declared with. See the library-comment above.
const String visualRegressionTestTag = 'visual-regression';

/// Amount of pixels (after the downscaling described at [_downscaleFactor]) a screenshot is allowed to differ from
/// its baseline. Chosen as a compromise: small enough to catch a real change of layout or color (which affects
/// whole regions, i.e. hundreds to thousands of downscaled pixels), large enough to tolerate the antialiasing- and
/// JPEG-compression-noise which remains even between two renders of the exact same widget-tree.
const int maximalAmountOfDifferentPixels = 40;

/// The factor screenshots are downscaled by (using a box/average-filter) before they are compared. Averaging a
/// block of pixels spreads out small per-pixel rendering-noise so it stays below
/// [_maximalDifferencePerColorChannel], while a part of the page which really changed keeps differing.
const int _downscaleFactor = 8;

/// The per-channel (red/green/blue) difference (0-255) a pixel has to exceed to count as "different" at all.
const int _maximalDifferencePerColorChannel = 32;

/// The JPEG-quality (0-100) the baselines are encoded with when they are (re-)generated.
const int _baselineJpegQuality = 92;

/// The size of the surface the demo-page is rendered on. It is fixed, because the amount of available space is
/// part of what a screenshot shows.
const Size _surfaceSize = Size(800, 300);

/// Identifies the part of the demo-page which the reference-image for the readme shows. See [_saveReferenceImage].
final Key _widgetUnderTestKey = UniqueKey();

/// The folder of the codeunit.
///
/// `flutter test` always runs with the current directory set to the package which contains the pubspec.yaml, i.e.
/// "MatDarkmodeToggleButton/mat_darkmode_toggle_button". Everything the tests read and write is located at the
/// codeunit-level, so that it is not specific to this one flutter-package.
Directory _codeunitFolder() => Directory.current.parent;

/// The folder the baseline-images are stored in. They are not git-ignored and belong to the repository (see the
/// "automation-using-scriptcollection"-skill).
Directory _baselinesFolder() => Directory(path.join(_codeunitFolder().path, 'Other', 'Resources', 'VisualRegressionBaselines'));

/// The folder the actual render and the visualized difference are written to when a comparison failed.
Directory _failuresFolder() => Directory(path.join(_codeunitFolder().path, 'Other', 'Artifacts', 'VisualRegressionTestResults'));

/// The folder the reference-images for the readme are written to.
///
/// It has to be inside the codeunit-folder because the visual-regression-tests run in a container which only has
/// that folder mounted; the update-script (see "Other/QualityCheck/UpdateVisualRegressionBaselines.py") copies the
/// images from here into the repository-level "Other/Reference/Technical/Images" afterwards. The folder is part of
/// "Other/Artifacts" and is therefore ignored by git, exactly like the other output of the
/// visual-regression-tests.
Directory _referenceImagesFolder() => Directory(path.join(_codeunitFolder().path, 'Other', 'Artifacts', 'ReferenceImages'));

/// The demo-page the screenshots are taken of.
///
/// It is what an application which uses this package looks like: two themes are declared once, the mode decides
/// which of them is used, and all colors come from that theme. The page is deliberately small - a screenshot of a
/// large page would mostly show content which has nothing to do with this widget and would therefore report a
/// difference for a change which is not one of this widget.
class _DemoPage extends StatelessWidget {
  const _DemoPage({required this.controller});

  final MatDarkmodeController controller;

  @override
  Widget build(BuildContext context) {
    return MatDarkmodeScope(
      controller: controller,
      builder: (BuildContext context, ThemeMode mode) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), fontFamily: 'Roboto'),
        darkTheme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark), fontFamily: 'Roboto'),
        themeMode: mode,
        home: Builder(
          builder: (BuildContext context) => Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: <Widget>[
                  Text('Color scheme', style: Theme.of(context).textTheme.headlineSmall),
                  Text(
                    'Choose whether the appearance follows the operating-system or is set explicitly.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                  // The repaint-boundary is what makes it possible to capture an image of exactly this widget
                  // (see [_saveReferenceImage]): "captureImage" can only capture a render-object which has its
                  // own layer, so without it the reference-image would show the whole page.
                  RepaintBoundary(key: _widgetUnderTestKey, child: const MatDarkmodeToggleButton()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Renders the demo-page in [mode] and asserts that it looks like the baseline-image [baselineName].
///
/// The mode is loaded from the store, exactly like a returning user would have it: that is the only state this
/// widget has, so the testcase does not have to tap anything.
///
/// If `flutter test --update-goldens` was used to run the test (which sets [autoUpdateGoldenFiles]) then the
/// baseline is (re-)generated from the current render instead of being compared against.
Future<void> expectDemoToLookLikeBaseline(WidgetTester tester, ThemeMode mode, String baselineName) async {
  tester.view.physicalSize = _surfaceSize;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final MatDarkmodeController controller = MatDarkmodeController(store: InMemoryThemeModeStore(initialMode: mode));
  addTearDown(controller.dispose);
  await controller.loadPersistedMode();
  await tester.pumpWidget(_DemoPage(controller: controller));
  await tester.pumpAndSettle();

  // The mode has to be applied, otherwise the screenshot would show the appearance of another mode than the one
  // the testcase is about - and a wrong baseline looks exactly like a correct one.
  final MaterialApp application = tester.widget<MaterialApp>(find.byType(MaterialApp));
  expect(application.themeMode, mode, reason: 'The demo-page does not use the mode the testcase is about.');

  final img.Image renderedPage = await _capture(tester, find.byType(_DemoPage), baselineName);
  _saveReferenceImage(baselineName, await _capture(tester, find.byKey(_widgetUnderTestKey), baselineName));

  final File baselineFile = File(path.join(_baselinesFolder().path, '$baselineName.jpg'));
  if (autoUpdateGoldenFiles) {
    baselineFile.parent.createSync(recursive: true);
    baselineFile.writeAsBytesSync(img.encodeJpg(renderedPage, quality: _baselineJpegQuality));
    // ignore: avoid_print
    print('Wrote visual-regression-baseline "${baselineFile.path}".');
    return;
  }
  if (!baselineFile.existsSync()) {
    fail(
      'No baseline-image exists for "$baselineName" (expected at "${baselineFile.path}"). Generate it with '
      '"task UpdateVisualRegressionBaselines" (see the "automation-using-scriptcollection"-skill) and commit it.',
    );
  }
  final img.Image? baseline = img.decodeJpg(baselineFile.readAsBytesSync());
  if (baseline == null) {
    fail('The baseline-image "${baselineFile.path}" could not be decoded as a JPEG-image.');
  }
  if (renderedPage.width != baseline.width || renderedPage.height != baseline.height) {
    fail(
      'The screenshot of "$baselineName" (${renderedPage.width}x${renderedPage.height}) has a different size than '
      'its baseline (${baseline.width}x${baseline.height}).',
    );
  }
  final int differentPixels = _countDifferentPixels(renderedPage, baseline);
  if (maximalAmountOfDifferentPixels < differentPixels) {
    final File actualFile = _preserveFailureArtifact(baselineName, 'actual', renderedPage);
    final File diffFile = _preserveFailureArtifact(baselineName, 'diff', _visualizeDifference(renderedPage, baseline));
    fail(
      'The screenshot of "$baselineName" differs from its baseline in $differentPixels pixel(s) after downscaling '
      '(allowed: $maximalAmountOfDifferentPixels). The actual render was written to "${actualFile.path}" and a '
      'visualization of the difference to "${diffFile.path}"; compare them with the baseline at '
      '"${baselineFile.path}". If the change of appearance was intended, regenerate the baseline with '
      '"task UpdateVisualRegressionBaselines".',
    );
  }
}

/// Captures an image of the widget [finder] points at. [baselineName] is only used for the error-message.
Future<img.Image> _capture(WidgetTester tester, Finder finder, String baselineName) async {
  // Both calls have to run inside the same "runAsync" (mirroring "matchesGoldenFile"'s own implementation):
  // "toImage"/"toByteData" complete via a real platform-callback, which never fires while only the fake-async zone
  // of the testcase is pumped. Calling them unwrapped does not throw, it returns a premature, truncated image and
  // then leaves that callback pending forever, which makes the whole test hang on exit.
  final ByteData? byteData = await tester.runAsync<ByteData?>(() async {
    final ui.Image capturedImage = await captureImage(tester.element(finder));
    final ByteData? data = await capturedImage.toByteData(format: ui.ImageByteFormat.png);
    capturedImage.dispose();
    return data;
  });
  final img.Image? decodedImage = img.decodePng(byteData!.buffer.asUint8List());
  if (decodedImage == null) {
    fail('The screenshot of "$baselineName" could not be decoded as a PNG-image, which should be impossible.');
  }
  return decodedImage;
}

/// Writes an unconditional, uncompared image of the widget itself into the reference-images-folder, from where the
/// update-script picks it up for the readme. This is deliberately not a visual-regression-test: nothing here is
/// compared with a baseline, the file is simply overwritten with the current appearance.
///
/// It only happens while the baselines are being regenerated (`--update-goldens`), which is exactly the run
/// `task uvrb` performs: a normal test-run must not touch a file which only the update-script owns.
void _saveReferenceImage(String baselineName, img.Image image) {
  if (!autoUpdateGoldenFiles) {
    return;
  }
  final Directory folder = _referenceImagesFolder();
  folder.createSync(recursive: true);
  File(path.join(folder.path, '$baselineName.png')).writeAsBytesSync(img.encodePng(image));
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

/// The biggest difference of the red-, green- and blue-channel of the two pixels. The alpha-channel is ignored: the
/// captured screenshot is fully opaque, and comparing it against a decoded JPEG (which never has an alpha-channel)
/// would otherwise always report a difference.
int _channelDifference(img.Pixel a, img.Pixel b) {
  final int redDifference = (a.r - b.r).abs().round();
  final int greenDifference = (a.g - b.g).abs().round();
  final int blueDifference = (a.b - b.b).abs().round();
  return <int>[redDifference, greenDifference, blueDifference].reduce((int value, int element) => value > element ? value : element);
}

/// Produces an image the same size as [rendered], where every pixel whose (upscaled) block differed from the
/// baseline by more than [_maximalDifferencePerColorChannel] is painted red and everything else is a dimmed,
/// grayscale copy of [rendered] - so a reviewer immediately sees which area of the page changed.
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
      final bool differs =
          _maximalDifferencePerColorChannel <
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
  final Directory folder = _failuresFolder();
  folder.createSync(recursive: true);
  final File file = File(path.join(folder.path, '${baselineName}_$suffix.png'));
  file.writeAsBytesSync(img.encodePng(image));
  return file;
}
