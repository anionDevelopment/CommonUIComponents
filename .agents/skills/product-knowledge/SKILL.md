---
name: product-knowledge
description: What mat_darkmode_toggle_button is, how this repository is structured and which mechanisms exist for building and testing it. Use this before fixing a defect or developing a feature in this repository, to know where things belong and how to verify a change.
---

# mat_darkmode_toggle_button

`mat_darkmode_toggle_button` is a flutter-widget which lets the user choose the color-scheme of an application
between the three modes `system`, `light` and `dark`. It is published at pub.dev as `mat_darkmode_toggle_button`.

The reason for the product is the third mode: a two-state-switch only knows light and dark and therefore loses
exactly the mode which most users want, namely "follow my operating-system". All three modes are offered at the
same time and each of them is reachable with one tap.

The product is the flutter-equivalent of `ngx-darkmode-toggle-button`
(https://github.com/anionDev/NgxDarkmodeToggleButton), which does the same for angular-applications. Both are
deliberately structured the same way, so a change of the concept belongs into both.

## Structure of the repository

The repository follows the "common project structure": all sourcecode lives in code-units, and every code-unit has
its own `Other`-folder with its build-, quality-check- and reference-files. Use the
`work-with-common-project-structure`-skill when you need the details of that structure.

There is one code-unit, `MatDarkmodeToggleButton`, which contains the flutter-package
`mat_darkmode_toggle_button`. The package consists of three parts only:

- `MatDarkmodeController` holds the chosen mode, loads it from and stores it in a `ThemeModeStore`;
- `MatDarkmodeScope` provides the controller to the widgets below it and rebuilds them when the mode changes;
- `MatDarkmodeToggleButton` is the control itself, a `SegmentedButton` with the three modes.

All of them are exported by `lib/mat_darkmode_toggle_button.dart`. Beside them the package contains a small
demo-application in `example`, which is not imported by the package itself.

## How the switching works, and what must not be broken

The package does not build a theme and does not exchange one at runtime. It only decides which of the two themes
the application already passes to its `MaterialApp` is used, by setting the `themeMode`:

| Mode | `MaterialApp.themeMode` | Result |
| --- | --- | --- |
| `system` | `ThemeMode.system` | follows the operating-system-theme |
| `light` | `ThemeMode.light` | always `MaterialApp.theme` |
| `dark` | `ThemeMode.dark` | always `MaterialApp.darkTheme` |

That is why the mode `system` follows a change of the operating-system-setting without any code. Four consequences
for every change here:

- do not define a theme in this codeunit and do not exchange one at runtime;
- do not use hard-coded colors - take them from `Theme.of(context)`, a hard-coded color does not change when the
  mode changes;
- do not read or write the store while the controller is constructed: loading is asynchronous, so it happens in
  `loadPersistedMode`, which the application awaits before it runs;
- do not add a third way to reach the controller beside `MatDarkmodeScope` and the explicit `controller`-argument.

Where the mode is stored is deliberately exchangeable (`ThemeModeStore`), because an application which keeps the
settings of its users in its own backend has to be able to store it there.

## Building and testing

`scbuildcodeunits` builds everything; the task `task bb` does the same. `task rd` starts the demo-application, and
`task uvrb` regenerates the baseline-images after an intended change of the appearance.

Beside the unit-tests there are visual-regression-tests (`test/visual_regression`), which compare a screenshot of a
demo-page with its baseline-image. They make an unintended change of the appearance visible, which a unit-test can
not detect. They run inside a container (see `Other/QualityCheck/VisualRegressionContainer.py`), because the
rendering-result otherwise depends on the operating-system, and they are skipped by a plain `flutter test` (see
`dart_test.yaml`) for exactly that reason.

This codeunit is a library, so it has no platform-target: `Other/Build/Build.py` calls
`tf.build("mat_darkmode_toggle_button", [])` and the build-result is the sourcecode (`SourceCode` and
`BuildResult_SourceCode` in `Other/Artifacts`).

What pub.dev expects beside the sourcecode is a readme, a license and a changelog. Those are the `ReadMe.md` of the
codeunit, the `License.txt` of the repository and `Other/Resources/Changelog`; the three `True`-arguments of the
`tf.build(...)`-call let ScriptCollection put them into the package of the sourcecode-artifacts. They are
deliberately not maintained a second time inside the flutter-package, and the packing is deliberately not
implemented in this repository. For the same reason the links of the codeunit-readme are relative: the build makes
them absolute, because pub.dev does not show the readme in the context of the repository.
