# How to build

This codeunit is a flutter-package. It has no compiled build-result: what is built and published is its sourcecode, together with its unit-tests written in dart.

The build-result is therefore the copy of the sourcecode in `Other/Artifacts/BuildResult_SourceCode`, which is completed with the readme of this codeunit as well as the license and the changelog of the repository, because [pub.dev](https://pub.dev/) shows the readme and the changelog of a package on its page and expects the license to be part of the package. That is done by ScriptCollection itself: `Other/Build/Build.py` only sets the corresponding options of `build`. It is published under the name `mat_culture_selector`, while the widget it contains is used as `MatCultureSelector`.
