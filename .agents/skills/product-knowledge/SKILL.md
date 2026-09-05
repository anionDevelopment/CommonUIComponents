---
name: product-knowledge
description: What NgxCountrySelector is, how this repository is structured and which mechanisms exist for building and testing it. Use this before fixing a defect or developing a feature in this repository, to know where things belong and how to verify a change.
---

# NgxCountrySelector

`@aniondev/ngx-country-selector` is an angular-component which lets the user choose a country. It is published at
npmjs.com.

Unlike its sibling `ngx-culture-selector`, this component does bring a list: the countries of ISO 3166-1, each
with its two-letter-code, its english name and its flag. An application which just wants a country-selector binds
nothing but the output; an application which offers only some countries passes its own list. What the chosen
country *means* is still the application's business - the component only reports which one was chosen.

It is the angular-counterpart of `mat_country_selector`, which offers the same thing for flutter-applications.

## Structure of the repository

The repository follows the "common project structure": all sourcecode lives in code-units, and every code-unit
has its own `Other`-folder with its build-, quality-check- and reference-files. Use the
`work-with-common-project-structure`-skill when you need the details of that structure.

There is one code-unit, `NgxCountrySelector`. It contains the angular-library which is published as
`@aniondev/ngx-country-selector` and consists of three parts only: `NgxCountrySelectorComponent` (the component),
`NgxCountry` (one country) and `allCountries` (the list of all of them), all exported by `src/public-api.ts`.
Beside the library the code-unit contains the demo-application (`demo`), which shows the component and is only
used to look at it during development.

## The contract of the component, and what must not be broken

- `countries` (`NgxCountry[]`) is the list the user chooses from; it defaults to `allCountries`.
- `countrySelected` (`output<string>`) emits the `code` of the chosen country (for example `DE`), never its name.
- `selectedCountry` (`string | undefined`) optionally preselects one country by its code.
- `label` (`string`, default `'Country'`) is the visible label of the control itself.
- A country is shown as its flag followed by its english name. `mat-select` finds an option by the letters which
  are typed while the list is open, so a list of almost 250 entries stays usable without a search-field of its
  own.

Consequences for a change of this codeunit:

- Do not let the component apply the chosen country anywhere by itself. Keep it a "choice out"-control.
- Do not ship flag-pictures. A flag is derived from the country-code (two regional-indicator-letters), which every
  system draws itself.
- Do not use hard-coded colors. The component takes its colors from the material-theme of the application.
- The country-list is data, not logic: it is generated from ISO 3166-1 and is not to be edited by hand entry by
  entry.

## Building and testing

`scbuildcodeunits` builds everything; the task `task bb` does the same. `task rd` starts the demo-application;
`task uvrb` regenerates the baseline-images after an intended change of the appearance.

Besides the unit-tests (`src/lib/*.spec.ts`, run by karma in a headless chromium) there are visual-regression-tests
(`e2e`): they render the component in chromium, firefox and webkit and compare the result with the baseline-images
in `Other/Resources/VisualRegressionBaselines`. They run inside the container defined in
`.ScriptCollection/OCIImages/ImageDefinition.csv`, because a rendered image is only reproducible in a defined
environment; they therefore require a reachable docker-daemon.
