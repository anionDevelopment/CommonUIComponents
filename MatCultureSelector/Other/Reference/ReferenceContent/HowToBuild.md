# How to build

This codeunit is a flutter-package. It has no compiled build-result: what is built and published is its sourcecode, together with its unit-tests written in dart.

The build-result is therefore the copy of the sourcecode in `Other/Artifacts/BuildResult_SourceCode`, which `Other/Build/Build.py` completes with the readme and the license of the repository, because [pub.dev](https://pub.dev/) shows the readme of a package on its page and requires the license to be part of the package. It is published under the name `mat_culture_selector`, while the widget it contains is used as `MatCultureSelector`.
