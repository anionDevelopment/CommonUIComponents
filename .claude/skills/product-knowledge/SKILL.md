---
name: product-knowledge
description: What MatCultureSelector is, how this repository is structured and which mechanisms exist for building and testing it. Use this before fixing a defect or developing a feature in this repository, to know where things belong and how to verify a change.
---

# MatCultureSelector

`mat_culture_selector` is a flutter-widget which lets the user choose a culture (for example `en-GB`, `de`,
`de-AT` or `fr`) from a configurable list of cultures. It is published at pub.dev as `mat_culture_selector`.

The widget does not know anything about cultures itself and does not ship a fixed list: the list of offered
cultures is passed in by the caller, and the widget only reports which entry the user chose. Applying that
choice (for example switching the locale of the application) is deliberately left to the application which
uses the widget - the same way a native dropdown does not decide what its entries mean.

It is the flutter-counterpart of `ngx-culture-selector`, which offers the same thing for angular-applications.

## Structure of the repository

The repository follows the "common project structure": all sourcecode lives in code-units, and every code-unit
has its own `Other`-folder with its build-, quality-check- and reference-files. Use the
`work-with-common-project-structure`-skill when you need the details of that structure.

There is one code-unit, `MatCultureSelector`. It contains the dart-package `mat_culture_selector`, which
consists of two parts only: `MatCultureSelector` (the widget) and `MatCultureOption` (one entry of the
`cultures`-list), both exported by `lib/mat_culture_selector.dart`. Beside the package the code-unit contains
the example-application (`mat_culture_selector/example`), which shows the widget and is only used to look at it
during development.

## The widget's contract, and what must not be broken

- `cultures` (`List<MatCultureOption>`, required) is the list the user chooses from. Every entry is
  `MatCultureOption(culture:, label:)`: `culture` is the identifier which `onCultureSelected` reports, `label`
  is the text shown for it (typically the language-name in English). The widget neither validates nor
  normalizes either field - whatever is passed in is shown and reported unchanged.
- `onCultureSelected` (`ValueChanged<String>`, required) is called with the `culture` (not the `label`) of the
  entry the user chose.
- `selectedCulture` (`String?`) optionally preselects one entry by its `culture`. A value which is not part of
  `cultures` is treated as "nothing is chosen": the underlying `DropdownButton` requires its value to be one of
  its entries and would otherwise fail to build, which would turn a stale preselection of the application into
  a crash.
- `label` (`String`, default `'Culture'`) is the visible label of the control itself (not of one entry), so
  applications can pass a translated text.
- The closed control showing the currently chosen label, the floating label and the dropdown listing every
  entry's label on tap are the native behavior of `DropdownButton` inside an `InputDecorator` - the widget is a
  thin wrapper and must stay that way; do not reimplement the open/closed behavior or the rendering of the
  closed control yourself.

Consequences for a change of this codeunit:

- Do not let the widget apply the chosen culture anywhere by itself (not to the locale of the application, not
  to a translation-package, not to a persisted setting). Keep it a pure "list in, choice out" control - that is
  what makes it reusable across applications with different i18n-setups.
- Do not hard-code a list of cultures or their labels anywhere in the widget; the caller-supplied list is the
  whole point of it.
- Do not use hard-coded colors. The widget takes its colors from the material-theme of the application which
  uses it.

## Building and testing

`scbuildcodeunits` builds everything; the task `task bb` does the same. `task rd` starts the
example-application in a browser; `task uvrb` regenerates the baseline-images after an intended change of the
appearance.

The build has no compiled result: a dart-package is published as sourcecode. `Other/Build/Build.py` therefore
only completes the sourcecode-artifacts with the readme and the license of the repository (pub.dev shows the
readme of a package on its page and requires the license to be part of the package) and makes the links of that
readme absolute, because pub.dev does not show it in the context of the repository. So the repository keeps one
single readme instead of a second one which would drift.

The widget-tests (`mat_culture_selector/test`) assert the state of the widget partly through the
`DropdownButton` it is built on (which value it shows, which entries it offers) instead of through the rendered
text: a dropdown builds all of its entries even while it is closed and only paints the chosen one, so counting
rendered texts would not tell which entry is actually shown.

Besides the widget-tests there are visual-regression-tests
(`mat_culture_selector/test/visual_regression`): they render the widget - once closed, once with the dropdown
open - and compare the result with the baseline-images in `Other/Resources/VisualRegressionBaselines`. That is
what makes an unintended change of the appearance visible, which a widget-test can not detect. They are skipped
by a plain `flutter test` (see `mat_culture_selector/dart_test.yaml`) and run inside the "SCBuilder"-container
defined in `.ScriptCollection/OCIImages/ImageDefinition.csv` instead, because the rendered image is only
reproducible in a defined environment; they therefore require a reachable docker-daemon. The same
baseline-images are the two example-pictures of the readme (see
`Other/QualityCheck/UpdateVisualRegressionBaselines.py`), so those pictures can not drift apart from what the
tests assert.
