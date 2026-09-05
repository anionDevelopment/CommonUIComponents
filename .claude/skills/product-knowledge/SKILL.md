---
name: product-knowledge
description: What MatCountrySelector is, how this repository is structured and which mechanisms exist for building and testing it. Use this before fixing a defect or developing a feature in this repository, to know where things belong and how to verify a change.
---

# MatCountrySelector

`mat_country_selector` is a flutter-widget which lets the user choose a country. It is published at pub.dev as
`mat_country_selector`.

Unlike its sibling `mat_culture_selector`, this widget does bring a list: the countries of ISO 3166-1, each with
its two-letter-code, its english name and its flag. An application which just wants a country-selector passes
nothing; an application which offers only some countries passes its own list. What the chosen country *means* is
still the application's business - the widget only reports which one was chosen.

It is the flutter-counterpart of `ngx-country-selector`, which offers the same thing for angular-applications.

## Structure of the repository

The repository follows the "common project structure": all sourcecode lives in code-units, and every code-unit
has its own `Other`-folder with its build-, quality-check- and reference-files. Use the
`work-with-common-project-structure`-skill when you need the details of that structure.

There is one code-unit, `MatCountrySelector`. It contains the dart-package `mat_country_selector`, which consists
of three parts only: `MatCountrySelector` (the widget), `MatCountry` (one country) and `allCountries` (the list of
all of them), all exported by `lib/mat_country_selector.dart`. Beside the package the code-unit contains the
example-application (`mat_country_selector/example`), which shows the widget and is only used to look at it during
development.

## The widget's contract, and what must not be broken

- `countries` (`List<MatCountry>`) is the list the user chooses from; it defaults to `allCountries`.
- `onCountrySelected` (`ValueChanged<String>`, required) is called with the `code` of the chosen country (for
  example `DE`), never with its name.
- `selectedCountry` (`String?`) optionally preselects one country by its code. A code which is not part of
  `countries` is treated as "nothing is chosen", so a stale preselection of the application cannot turn into a
  crash of the widget.
- `label` (`String`, default `'Country'`) is the visible label of the control itself.
- A country is shown as its flag followed by its english name, and it can be found by typing that name - which is
  what makes a list of almost 250 entries usable at all.

Consequences for a change of this codeunit:

- Do not let the widget apply the chosen country anywhere by itself. Keep it a "choice out"-control.
- Do not ship flag-pictures. A flag is derived from the country-code (two regional-indicator-letters), which every
  system draws itself.
- Do not use hard-coded colors. The widget takes its colors from the material-theme of the application.
- The country-list is data, not logic: it is generated from ISO 3166-1 and is not to be edited by hand entry by
  entry.

## Building and testing

`scbuildcodeunits` builds everything; the task `task bb` does the same. `task rd` starts the example-application
in a browser; `task uvrb` regenerates the baseline-images after an intended change of the appearance.

The build has no compiled result: a dart-package is published as sourcecode. `Other/Build/Build.py` therefore
builds no target and only sets the options with which ScriptCollection puts the readme of the code-unit
(`MatCountrySelector/ReadMe.md`), the license of the repository and its changelog (`Other/Resources/Changelog`,
rendered as one section per version) into the sourcecode-artifacts and makes the links of that readme absolute -
pub.dev shows the readme and the changelog of a package on its page, expects the license to be part of the package
and does not show that readme in the context of the repository.

Besides the widget-tests there are visual-regression-tests (`mat_country_selector/test/visual_regression`): they
render the widget - once closed, once with the list open - and compare the result with the baseline-images in
`Other/Resources/VisualRegressionBaselines`. That is what makes an unintended change of the appearance visible,
which a widget-test can not detect. They are skipped by a plain `flutter test` (see
`mat_country_selector/dart_test.yaml`) and run inside the "SCBuilder"-container defined in
`.ScriptCollection/OCIImages/ImageDefinition.csv` instead, because the rendered image is only reproducible in a
defined environment; they therefore require a reachable docker-daemon.
