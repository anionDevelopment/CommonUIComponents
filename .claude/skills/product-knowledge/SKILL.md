---
name: product-knowledge
description: What ngx-culture-selector is, how this repository is structured and which mechanisms exist for building and testing it. Use this before fixing a defect or developing a feature in this repository, to know where things belong and how to verify a change.
---

# ngx-culture-selector

`ngx-culture-selector` is an angular-component which lets the user choose a culture (for example `en-GB`,
`de`, `de-AT` or `fr`) from a configurable list of cultures. It is published at npmjs.com as
`@aniondev/ngx-culture-selector`.

The component does not know anything about cultures itself and does not ship a fixed list: the list of
offered cultures is passed in by the caller, and the component only reports which entry the user chose.
Applying that choice (for example switching the locale of the application) is deliberately left to the
application which uses the component - the same way a native `<select>` does not decide what its options mean.

## Structure of the repository

The repository follows the "common project structure": all sourcecode lives in code-units, and every code-unit
has its own `Other`-folder with its build-, quality-check- and reference-files. Use the
`work-with-common-project-structure`-skill when you need the details of that structure.

There is one code-unit, `NgxCultureSelector`. It consists of one part only: `NgxCultureSelectorComponent`,
exported by `src/public-api.ts` together with the `NgxCultureOption` interface which describes one entry of
the `cultures`-list. Beside it the code-unit contains a small demo-application (`demo/`), which is not part of
the published package and is only used to look at the component during development and by the
visual-regression-tests.

## The component's contract, and what must not be broken

- `cultures` (`input.required<NgxCultureOption[]>()`) is the list the user chooses from. Every entry is
  `{ culture, label }`: `culture` is the identifier which `cultureSelected` emits, `label` is the text shown
  for it (typically the language-name in English). The component neither validates nor normalizes either
  field - whatever is passed in is shown and emitted unchanged.
- `selectedCulture` (`input<string | undefined>()`) optionally preselects one entry by its `culture`.
- `label` (`input<string>()`) is the visible label of the control itself (not of one entry), so applications
  can pass a translated text.
- `cultureSelected` (`output<string>()`) emits the `culture` (not the `label`) of the entry the user chose.
- The trigger showing the currently chosen label and the dropdown listing every entry's label on click are
  `mat-select`'s own native behavior - the component is a thin wrapper and must stay that way; do not
  reimplement the open/closed behavior or the trigger-rendering yourself.

Consequences for a change of this codeunit:

- Do not let the component apply the chosen culture anywhere by itself (not to `document`, not to a
  translation-service, not to `localStorage`). Keep it a pure "list in, choice out" control - that is what
  makes it reusable across applications with different i18n-setups.
- Do not hard-code a list of cultures or their labels anywhere in the component or its demo-usage examples in
  the reference docs; the caller-supplied list is the whole point of the component.
- Do not use hard-coded colors in the styles - the component takes its colors from the Material system-tokens
  (`--mat-sys-*`) so it follows the color-scheme of the application which uses it.

## Building and testing

`scbuildcodeunits` builds everything; the task `task bb` does the same. `task rd` starts the demo-application;
`task uvrb` regenerates the baseline-screenshots after an intended change of the appearance.

The build puts the readme and the license of the repository into the built npm-package and makes the links of
that readme absolute, because npmjs.com does not show it in the context of the repository (see
`NgxCultureSelector/Other/Build/Build.py`). So the repository keeps one single readme instead of a second one
which would drift.

Unit-tests use Angular Material's `MatSelectHarness` (`@angular/cdk/testing` + `@angular/material/select/testing`)
to drive the `mat-select`, because its dropdown is rendered into the CDK overlay and not into the fixture's own
DOM - poking the overlay directly (for example via `OverlayContainer`) was tried first and turned out to be
unreliable; the harness is the robust, officially supported way (see
`src/lib/ngx-culture-selector.component.spec.ts`).

Besides the unit-tests there are visual-regression-tests (`e2e/CultureSelector.spec.ts`): they open the
demo-application and compare a screenshot of it - once closed, once with the dropdown open - with the baseline
of the same browser and platform. That is what makes an unintended change of the appearance visible, which a
unit-test can not detect. They run inside the "Playwright"-container defined in
`.ScriptCollection/OCIImages/ImageDefinition.csv` and therefore require a reachable docker-daemon; without one,
`RunTestcases.py` fails at that step with a clear error, the same way it does in `ngx-darkmode-toggle-button`.
