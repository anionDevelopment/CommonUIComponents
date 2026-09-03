# How to build

This codeunit is a Flutter-package (a widget-library), so it has no compiled artifact of its own: its build-result is its sourcecode, including its unit-tests and its visual-regression-tests written in Dart.

The build is `Other/Build/Build.py`, which delegates to ScriptCollection (`tf.build("mat_darkmode_toggle_button", [])`). The empty list of targets is what says that this codeunit is a library and not an application for a platform. It produces the artifacts `SourceCode` and `BuildResult_SourceCode` in `Other/Artifacts`, which contain the git-tracked files of the codeunit and which are what another codeunit of the same repository would consume as a dependency.

The package is published at pub.dev under the name `mat_darkmode_toggle_button`, while the widget it contains is used as `MatDarkmodeToggleButton`.

Beside the sourcecode pub.dev expects a readme, a license and a changelog. Those are the `ReadMe.md` of this codeunit, the `License.txt` of the repository and the changelog of the repository (`Other/Resources/Changelog`); the build puts them into the package of the sourcecode-artifacts as `README.md`, `LICENSE` and `CHANGELOG.md`, which is what the three `True`-arguments of the `tf.build(...)`-call mean. They are deliberately not maintained a second time inside the flutter-package, because a copy of a readme, of a license or of a changelog only drifts apart from its original.

Therefore the links of `ReadMe.md` are relative: the build makes every link which points into the repository absolute, because pub.dev does not show the readme in the context of the repository and could not resolve a relative one.
