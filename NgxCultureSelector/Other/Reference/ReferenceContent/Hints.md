# Hints

## Requirements

The following tools from the [tools-list](https://github.com/anionDev/ScriptCollection/blob/main/ScriptCollection/Other/Reference/ReferenceContent/Articles/RequirementsForCommonProjectStructure.md#Tools) are required to build this code-unit:

- `cyclonedx-npm`
- `docfx`
- `git`
- `gitversion`
- `ng`
- `npm`
- `python`
- `reportgenerator`
- `scriptcollection`

## IDE

The recommended IDE for this codeunit is [Visual Studio Code](https://code.visualstudio.com/).

## What this codeunit contains

The codeunit consists of one part only: `NgxCultureSelectorComponent`, the control which lets the user choose one culture from a list of cultures which the application passes in.

It is exported by `src/public-api.ts`, which is the entry-file of the package.

## How the component works

- `cultures` is the required list of cultures the user can choose from. The component does not validate or normalize its entries: whatever string is passed in (for example `en-GB`, `de` or `de-AT`) is shown and emitted as-is.
- `selectedCulture` optionally preselects one of the cultures.
- `cultureSelected` emits the culture the user chose. The component does not apply the chosen culture anywhere by itself (not to `document`, not to a translation-service, not to `localStorage`): which mechanism an application uses to switch its locale is its own decision.

Consequences for a change of this codeunit:

- Do not let the component apply the culture anywhere itself. Keep it a pure "list in, choice out" control.
- Do not hard-code a list of cultures. The whole point of the component is that the caller decides which cultures are offered.

## Usage

The usage of the package is documented in the `ReadMe.md` of the repository.
