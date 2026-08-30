# NgxCultureSelector

## Purpose

`ngx-culture-selector` is an angular-component which lets the user choose a culture (for example `en-GB`, `de`, `de-AT` or `fr`) from a configurable list of cultures.

## Idea

Applications which are available in several languages or regional variants usually need one control which lets the user switch between them. Which cultures are offered differs per application, so the component does not hard-code a list: it takes the list of cultures as input and only reports which one the user chose. Applying the chosen culture (for example switching the locale of the application) is deliberately left to the application which uses the component.

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

The component is standalone, so it is imported directly by the component which shows it:

```typescript
import { Component } from '@angular/core';
import { NgxCultureSelectorComponent } from '@aniondev/ngx-culture-selector';

@Component({
  selector: 'app-toolbar',
  imports: [NgxCultureSelectorComponent],
  template: `<ngx-culture-selector [cultures]="cultures" (cultureSelected)="onCultureSelected($event)" />`,
})
export class ToolbarComponent {
  protected readonly cultures = ['en-GB', 'de', 'de-AT', 'fr'];

  protected onCultureSelected(culture: string): void {
    // for example: switch the locale of the application
  }
}
```

### 3. Inputs and outputs

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `cultures` | `string[]` | (required) | The list of cultures the user can choose from, for example `['en-GB', 'de', 'de-AT', 'fr']`. |
| `selectedCulture` | `string \| undefined` | `undefined` | The culture which is preselected. |
| `label` | `string` | `'Culture'` | The label of the control. Set it to a translated text if the application is localized. |
| `cultureSelected` | `EventEmitter<string>` (output) | - | Emits the culture the user chose. |

The component itself does not apply the chosen culture anywhere (for example to `document`, to a translation-service or to the `localStorage`): which mechanism an application uses to switch its locale is its own decision.

## Development

This repository implements the common project structure. The whole pipeline (build, linting, testcases) runs with:

```
task bb
```

The repository contains a small demo-application which shows the component (it is not part of the published package). It is started with `task rd`.

## License

See `License.txt`.
