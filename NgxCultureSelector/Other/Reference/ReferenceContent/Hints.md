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

It is exported by `src/public-api.ts`, which is the entry-file of the package, together with the `NgxCultureOption` interface which describes one entry of that list.

## How the component works

- `cultures` is the required list of `NgxCultureOption`s (`{ culture, label }`) the user can choose from. The component does not validate or normalize the entries: whatever is passed in (for example `{ culture: 'de-AT', label: 'German (Austria)' }`) is shown and emitted as-is.
- `selectedCulture` optionally preselects one of the cultures by its `culture`-identifier.
- The component is a thin wrapper around `mat-select`: the trigger showing the label of the currently chosen entry, and the dropdown listing the labels of all entries, are `mat-select`'s own native behavior - the component does not implement any of that itself.
- `cultureSelected` emits the `culture`-identifier of the entry the user chose (not the label). The component does not apply the chosen culture anywhere by itself (not to `document`, not to a translation-service, not to `localStorage`): which mechanism an application uses to switch its locale is its own decision.

Consequences for a change of this codeunit:

- Do not let the component apply the culture anywhere itself. Keep it a pure "list in, choice out" control.
- Do not hard-code a list of cultures or their labels. The whole point of the component is that the caller decides which cultures are offered and which text is shown for them (for example a translated language-name instead of an English one).

## Usage

The usage of the package is documented in the `ReadMe.md` of the repository.
