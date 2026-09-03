# How to build

This codeunit is a Flutter-package (a widget-library), so it has no compiled artifact of its own: its build-result is its sourcecode, including its unit-tests and its visual-regression-tests written in Dart.

The build is `Other/Build/Build.py`, which delegates to ScriptCollection (`tf.build("mat_darkmode_toggle_button", [])`). The empty list of targets is what says that this codeunit is a library and not an application for a platform. It produces the artifacts `SourceCode` and `BuildResult_SourceCode` in `Other/Artifacts`, which contain the git-tracked files of the codeunit and which are what another codeunit of the same repository would consume as a dependency.

The package is published at pub.dev under the name `mat_darkmode_toggle_button`, while the widget it contains is used as `MatDarkmodeToggleButton`. Beside the sourcecode pub.dev expects a readme and a license: those are the `ReadMe.md` of this codeunit and the `License.txt` of the repository. They are deliberately not maintained a second time inside the flutter-package, because a copy of a readme and of a license only drifts apart from its original. Packing them into the published package is done by the build as soon as ScriptCollection offers the corresponding option for a flutter-codeunit; until then the package can not be published yet.
