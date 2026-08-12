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

The codeunit consists of two parts only:

- `NgxDarkmodeService` holds the mode the user chose (`system`, `light` or `dark`) as a signal, stores it in the `localStorage` and applies it to the document.
- `NgxDarkmodeToggleButtonComponent` is the control which lets the user choose one of the three modes.

Both are exported by `src/public-api.ts`, which is the entry-file of the package.

## How the switching works

The component does not define a second theme and does not exchange any stylesheet at runtime. It only sets the attribute `data-theme` on the html-element, and the stylesheet of the application maps that attribute to the css-property `color-scheme`:

| Mode | Attribute `data-theme` | `color-scheme` |
| --- | --- | --- |
| `system` | not set | `light dark` |
| `light` | `light` | `light` |
| `dark` | `dark` | `dark` |

That is the reason why the mode `system` follows a change of the setting of the operating-system without any code: `color-scheme: light dark` reacts to it by itself. Everything else (the colors of the Material-components and of own components which use the system-tokens `--mat-sys-*`) follows from that.

Consequences for a change of this codeunit:

- Do not add a second theme and do not load a stylesheet at runtime. `mat.theme()` is included exactly once by the application which uses this package.
- Do not use hard-coded colors in the styles of this codeunit. A hard-coded color does not change when the scheme changes.
- Do not access `localStorage` or `window` while the service is constructed. The package has to be usable with server-side-rendering and prerendering, therefore those accesses happen in `afterNextRender`.

## Usage

The usage of the package is documented in the `ReadMe.md` of the repository.
