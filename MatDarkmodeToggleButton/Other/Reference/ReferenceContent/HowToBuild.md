# How to build

This codeunit is a Flutter-package (a widget-library), so it has no compiled artifact of its own: its build-result is its sourcecode, including its unit-tests and its visual-regression-tests written in Dart.

The build produces the following artifacts in `Other/Artifacts`:

- `SourceCode` and `BuildResult_SourceCode` contain the git-tracked files of the codeunit. They are what another codeunit of the same repository would consume as a dependency.
- `BuildResult_PubPackage` contains the folder which is published to [pub.dev](https://pub.dev). It is the package-folder plus the `README.md` and the `LICENSE` of the repository, and `Other/Build/Build.py` verifies with `dart pub publish --dry-run` that it is publishable.

The package is published under the name `mat_darkmode_toggle_button`, while the widget it contains is used as `MatDarkmodeToggleButton`.
