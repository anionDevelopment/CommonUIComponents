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
exported by `src/public-api.ts`. Beside it the code-unit contains a small demo-application (`demo/`), which is
not part of the published package and is only used to look at the component during development.

## The component's contract, and what must not be broken

- `cultures` (`input.required<string[]>()`) is the list the user chooses from. The component neither validates
  nor normalizes it - whatever string is passed in is shown and emitted unchanged.
- `selectedCulture` (`input<string | undefined>()`) optionally preselects one entry.
- `label` (`input<string>()`) is the visible label of the control, so applications can pass a translated text.
- `cultureSelected` (`output<string>()`) emits the culture the user chose.

Consequences for a change of this codeunit:

- Do not let the component apply the chosen culture anywhere by itself (not to `document`, not to a
  translation-service, not to `localStorage`). Keep it a pure "list in, choice out" control - that is what
  makes it reusable across applications with different i18n-setups.
- Do not hard-code a list of cultures anywhere in the component or its demo-usage examples in the reference
  docs; the caller-supplied list is the whole point of the component.
- Do not use hard-coded colors in the styles - the component takes its colors from the Material system-tokens
  (`--mat-sys-*`) so it follows the color-scheme of the application which uses it.

## Building and testing

`scbuildcodeunits` builds everything; the task `task bb` does the same. `task rd` starts the demo-application.

The build puts the readme and the license of the repository into the built npm-package and makes the links of
that readme absolute, because npmjs.com does not show it in the context of the repository (see
`NgxCultureSelector/Other/Build/Build.py`). So the repository keeps one single readme instead of a second one
which would drift.

Unit-tests use Angular Material's `OverlayContainer` to reach into the `mat-select`-dropdown, because its
options are rendered into the CDK overlay and not into the fixture's own DOM (see
`src/lib/ngx-culture-selector.component.spec.ts`).
