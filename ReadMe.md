# NgxCultureSelector

## Purpose

`ngx-culture-selector` is an angular-component which lets the user choose a culture (for example `en-GB`, `de`, `de-AT` or `fr`) from a configurable list of cultures.

## Idea

Applications which are available in several languages or regional variants usually need one control which lets the user switch between them. Which cultures are offered - and which text is shown for each of them - differs per application, so the component does not hard-code either: it takes the list as input and only reports which culture the user chose. Applying the chosen culture (for example switching the locale of the application) is deliberately left to the application which uses the component.

## Example

![The component with its dropdown open, listing the four cultures of the example above](Other/Reference/Technical/Images/CultureSelector.png)

The trigger always shows the label of the currently chosen culture. Clicking it opens a dropdown which lists the label of every culture that was passed in - this is the native behavior of the underlying `mat-select` and needs no further code.

## Requirements

- Angular 22
- Angular Material 22 (the component is built on `mat-select`)

## Installation

The package is published at [npmjs.com/package/@aniondev/ngx-culture-selector](https://www.npmjs.com/package/@aniondev/ngx-culture-selector).

```
npm install @aniondev/ngx-culture-selector
```

## Usage

### 1. Include the theme once

The component is built on Angular Material, so the application has to include a Material-3-theme exactly once in its `styles.scss`:

```scss
@use '@angular/material' as mat;

html {
  color-scheme: light dark;
  @include mat.theme((color: mat.$azure-palette, typography: Roboto, density: 0));
}
```

### 2. Use the component

The component is standalone, so it is imported directly by the component which shows it. Its trigger always shows the label of the currently chosen culture; clicking it opens a dropdown with the label of every culture that was passed in:

```typescript
import { Component } from '@angular/core';
import { NgxCultureOption, NgxCultureSelectorComponent } from '@aniondev/ngx-culture-selector';

@Component({
  selector: 'app-toolbar',
  imports: [NgxCultureSelectorComponent],
  template: `<ngx-culture-selector [cultures]="cultures" (cultureSelected)="onCultureSelected($event)" />`,
})
export class ToolbarComponent {
  protected readonly cultures: NgxCultureOption[] = [
    { culture: 'en-GB', label: 'English (UK)' },
    { culture: 'de', label: 'German' },
    { culture: 'de-AT', label: 'German (Austria)' },
    { culture: 'fr', label: 'French' },
  ];

  protected onCultureSelected(culture: string): void {
    // for example: switch the locale of the application
  }
}
```

### 3. Inputs and outputs

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `cultures` | `NgxCultureOption[]` | (required) | The cultures the user can choose from. Each entry has a `culture` (the identifier, for example `'en-GB'`) and a `label` (the text shown for it, typically the language-name in English, for example `'English (UK)'`). |
| `selectedCulture` | `string \| undefined` | `undefined` | The `culture` of the entry which is preselected. |
| `label` | `string` | `'Culture'` | The label of the control itself. Set it to a translated text if the application is localized. |
| `cultureSelected` | `EventEmitter<string>` (output) | - | Emits the `culture` of the entry the user chose. |

Both which cultures are offered and which text is shown for each of them are decided entirely by the caller - the component does not hard-code or know about any real-world culture. It also does not apply the chosen culture anywhere itself (for example to `document`, to a translation-service or to the `localStorage`): which mechanism an application uses to switch its locale is its own decision.

## Development

This repository implements the common project structure. The whole pipeline (build, linting, testcases) runs with:

```
task bb
```

The repository contains a small demo-application which shows the component (it is not part of the published package). It is started with `task rd` and it is also what the visual-regression-tests take their screenshots of. After an intended change of the appearance the baseline-screenshots are regenerated with `task uvrb`.

> **Note:** The script `NgxCultureSelector/Other/QualityCheck/UpdateVisualRegressionBaselines.py` is permitted to modify files in the `<repo>/Other` directory, specifically to update the readme example image at `Other/Reference/Technical/Images/CultureSelector.png` to always show the current appearance of the component.

## License

See `License.txt`.
