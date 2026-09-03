import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Runs before every test-file of this package.
///
/// Without this, `flutter test` renders text with a placeholder test-font (solid boxes instead of glyphs) and every
/// `Icons.*` as nothing at all, because it does not load the fonts a real build bundles. That would make the
/// baseline-images of the visual-regression-tests under "test/visual_regression" show boxes instead of the icons
/// which are the whole point of this widget, so the two fonts a material-application uses are loaded here once for
/// the whole test-run.
///
/// Both font-files ship inside the Flutter-SDK itself (they are the exact files `flutter build` bundles into every
/// material-application), so they are read from there via the `FLUTTER_ROOT`-environment-variable which
/// `flutter test` sets for the process it spawns. They are deliberately not copied into this repository: a copy
/// would be a second, silently diverging state of a file which the used Flutter-version already defines.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final String? flutterRoot = Platform.environment['FLUTTER_ROOT'];
  if (flutterRoot != null) {
    final Directory fontFolder = Directory('$flutterRoot/bin/cache/artifacts/material_fonts');
    await _loadFont('Roboto', fontFolder, 'roboto-regular.ttf');
    await _loadFont('MaterialIcons', fontFolder, 'materialicons-regular.otf');
  }
  return testMain();
}

/// Loads the font-file [fileName] from [folder] as the font-family [family].
///
/// The file is looked up case-insensitively, because the Flutter-SDK does not spell these file-names the same way
/// in every version (for example "MaterialIcons-Regular.otf" and "materialicons-regular.otf"). On the Windows-host
/// of a developer that difference does not matter, but the visual-regression-container runs on Linux, where it
/// decides between a readable icon and no icon at all.
Future<void> _loadFont(String family, Directory folder, String fileName) async {
  final File? fontFile = folder
      .listSync()
      .whereType<File>()
      .where((File file) => file.uri.pathSegments.last.toLowerCase() == fileName.toLowerCase())
      .firstOrNull;
  if (fontFile == null) {
    throw StateError('The font-file "$fileName" does not exist in "${folder.path}", so the tests would render it as boxes respectively as nothing.');
  }
  final ByteData fontData = fontFile.readAsBytesSync().buffer.asByteData();
  final FontLoader fontLoader = FontLoader(family)..addFont(Future<ByteData>.value(fontData));
  await fontLoader.load();
}
