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

The codeunit contains one dart-package, `mat_country_selector`, which is published to [pub.dev](https://pub.dev/).

The package consists of three parts only:

- `MatCountrySelector`, the widget which lets the user choose one country.
- `MatCountry`, the type which describes one country: its two-letter-code, its english name and its flag.
- `allCountries`, the list of all countries of ISO 3166-1, which the widget offers unless the application passes its own list.

All three are exported by `lib/mat_country_selector.dart`, which is the entry-file of the package.

## The contract of the widget

- `countries` is the list the user chooses from. It defaults to `allCountries`, so an application which just wants "a country-selector" passes nothing; an application which offers only a few countries passes its own list.
- `onCountrySelected` is called with the code of the country the user chose (for example `DE`), not with its name.
- `selectedCountry` optionally preselects one country by its code. A code which is not part of `countries` is treated as "nothing is chosen": the underlying menu requires its value to be one of its entries and would otherwise fail to build, which would turn a stale preselection of the application into a crash.
- `label` is the visible label of the control itself (not of one entry), so applications can pass a translated text.
- The widget does not apply the chosen country anywhere by itself: what a country means for an application (a shipping-address, a nationality, a flag next to a name) is that application's business.

## What must not be broken

- Do not turn the list of countries into something the application has to bring along: offering all countries out of the box is the point of this widget, and that list is the one piece of knowledge it does contain.
- Do not put a flag-image into the package. A flag is the two regional-indicator-letters of the country-code, which every system draws itself - a picture would have to be licensed, would have to be updated and would be one more thing to ship.
- Do not use hard-coded colors. The widget takes its colors from the material-theme of the application which uses it.

## Building and testing

`scbuildcodeunits` builds everything; the task `task bb` does the same. `task rd` starts the example-application in a browser; `task uvrb` regenerates the baseline-images of the visual-regression-tests after an intended change of the appearance.

The build has no compiled result: a dart-package is published as sourcecode. `Other/Build/Build.py` therefore builds no target and only completes the sourcecode-artifacts with the readme of the code-unit, the license of the repository and its changelog.
