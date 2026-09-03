# Hints

## Requirements

The following tools from the [tools-list](https://github.com/anionDev/ScriptCollection/blob/main/ScriptCollection/Other/Reference/ReferenceContent/Articles/RequirementsForCommonProjectStructure.md#Tools) are required to build this code-unit:

- `docfx`
- `flutter`
- `git`
- `gitversion`
- `python`
- `scriptcollection`

Additionally a reachable docker-daemon is required, because the visual-regression-tests are executed inside a container (see below).

## IDE

The recommended IDE for this codeunit is [Visual Studio Code](https://code.visualstudio.com/).

## What this codeunit contains

The codeunit contains one dart-package, `mat_culture_selector`, which is published to [pub.dev](https://pub.dev/).

The package consists of two parts only:

- `MatCultureSelector`, the widget which lets the user choose one culture from a list of cultures which the application passes in.
- `MatCultureOption`, the type which describes one entry of that list.

Both are exported by `lib/mat_culture_selector.dart`, which is the entry-file of the package.

Besides the package the codeunit contains its example-application (`mat_culture_selector/example`), which shows the widget and is not part of what the package offers.

## How the widget works

- `cultures` is the required list of `MatCultureOption`s (`culture` and `label`) the user can choose from. The widget does not validate or normalize the entries: whatever is passed in (for example `MatCultureOption(culture: 'de-AT', label: 'German (Austria)')`) is shown and reported as-is.
- `selectedCulture` optionally preselects one of the cultures by its culture-identifier. A value which is not part of `cultures` is treated as "nothing is chosen": the material-dropdown requires its value to be one of its entries and would otherwise fail to build, which would turn a stale preselection of the application into a crash.
- The widget is a thin wrapper around `DropdownButton` inside an `InputDecorator`: the closed control showing the label of the chosen entry, the floating label of the control and the dropdown listing the labels of all entries are the native behavior of these material-widgets - the widget does not implement any of that itself.
- `onCultureSelected` is called with the culture-identifier of the entry the user chose (not with its label). The widget does not apply the chosen culture anywhere by itself (neither to the locale of the application, nor to a translation-package, nor to a persisted setting): which mechanism an application uses to switch its locale is its own decision.

Consequences for a change of this codeunit:

- Do not let the widget apply the culture anywhere itself. Keep it a pure "list in, choice out" control.
- Do not hard-code a list of cultures or their labels. The whole point of the widget is that the caller decides which cultures are offered and which text is shown for them (for example a translated language-name instead of an English one).

## Testcases

The codeunit has two kinds of testcases, and they are executed separately:

- The widget-tests in `mat_culture_selector/test` are executed by every `flutter test` and by `Other/QualityCheck/RunTestcases.py`.
- The visual-regression-tests in `mat_culture_selector/test/visual_regression` render the widget and compare the result with the baseline-images in `Other/Resources/VisualRegressionBaselines`. They are skipped by a plain `flutter test` (see `mat_culture_selector/dart_test.yaml`) and are executed inside a container instead (see `Other/QualityCheck/VisualRegressionContainer.py`), because the rendered image is only reproducible in a defined environment. The same baseline-images are the example-pictures of the readme of the repository.

After an intended change of the appearance the baseline-images have to be regenerated with `task UpdateVisualRegressionBaselines` and have to be committed together with the change which caused them.

## Usage

The usage of the package is documented in the `ReadMe.md` of this codeunit, which is also what pub.dev shows on the page of the package.
