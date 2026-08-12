# ngx-darkmode-toggle-button

## Purpose

`ngx-darkmode-toggle-button` is an angular-component which lets the user choose the color-scheme of a web-application between the three modes `system`, `light` and `dark`. The choice is kept over reloads and sessions.

## Idea

Apps, web-sites and web-applications usually have a light- and a dark-appearance, and the operating-systems have that setting as well. Most users want the application to simply follow their operating-system, but they also want to be able to overrule that for one application.

A two-state toggle can not express that: it only knows "light" and "dark" and therefore loses exactly the mode which most users want. This component therefore offers all three modes at the same time, each of them reachable with one click.

## Requirements

- Angular 19
- Angular Material 19 (the component uses the Material-3-theming-API and the system-tokens `--mat-sys-*`)

## Installation

```
npm install @aniondev/ngx-darkmode-toggle-button
```

## Usage

### 1. Include the theme once

The component does not bring its own theme and does not exchange stylesheets at runtime. It only switches the css-property `color-scheme`, which Material-3 evaluates by itself. Include `mat.theme()` exactly once in your `styles.scss`:

```scss
@use '@angular/material' as mat;

html {
  color-scheme: light dark;              // this is the mode "system"
  @include mat.theme((color: mat.$azure-palette, typography: Roboto, density: 0));

  &[data-theme='light'] { color-scheme: light; }
  &[data-theme='dark']  { color-scheme: dark; }
}

body {
  background: var(--mat-sys-background);
  color: var(--mat-sys-on-background);
}
```

Own components must take their colors from the system-tokens (`var(--mat-sys-on-surface)` and so on). A hard-coded color stays as it is when the scheme changes.

### 2. Set the attribute before the first frame

Without this the page is drawn in the wrong scheme for a moment after a reload. Put this blocking script into the `<head>` of your `index.html`, before all stylesheets:

```html
<script>
  var t = localStorage.getItem('theme');
  if (t && t !== 'system') document.documentElement.setAttribute('data-theme', t);
</script>
```

The duplication of that logic is intended: the attribute has to be set before the application is bootstrapped.

### 3. Use the component

The component is standalone, so it is imported directly by the component which shows it:

```typescript
import { Component } from '@angular/core';
import { NgxDarkmodeToggleButtonComponent } from '@aniondev/ngx-darkmode-toggle-button';

@Component({
  selector: 'app-toolbar',
  standalone: true,
  imports: [NgxDarkmodeToggleButtonComponent],
  template: `<ngx-darkmode-toggle-button />`,
})
export class ToolbarComponent { }
```

The labels can be replaced, for example by translated texts:

```html
<ngx-darkmode-toggle-button
  aria-label="Farbschema"
  lightLabel="Hell"
  systemLabel="System"
  darkLabel="Dunkel" />
```

### 4. Read or set the mode from code

The chosen mode is available as a signal, so it can be read and written from anywhere - for example to store it in the profile of the user:

```typescript
import { Component, effect, inject } from '@angular/core';
import { NgxDarkmodeService, ThemeMode } from '@aniondev/ngx-darkmode-toggle-button';

@Component({ /* ... */ })
export class SettingsComponent {

  private readonly darkmodeService = inject(NgxDarkmodeService);

  public constructor() {
    effect(() => {
      const mode: ThemeMode = this.darkmodeService.mode();
      // for example: send the mode to the backend of your application
    });
  }

  public applyModeOfUserProfile(mode: ThemeMode): void {
    this.darkmodeService.mode.set(mode);
  }
}
```

## Behavior

| Mode | Attribute `data-theme` | `color-scheme` | Result |
| --- | --- | --- | --- |
| `system` | not set | `light dark` | follows the operating-system, also while the application is running |
| `light` | `light` | `light` | always light, the operating-system is ignored |
| `dark` | `dark` | `dark` | always dark, the operating-system is ignored |

The mode is stored in the `localStorage` under the key `theme`. A missing or an invalid value is treated as `system`, which is also the default for a user who did not choose anything yet.

With server-side-rendering or prerendering neither `localStorage` nor `window` is touched while the service is constructed: the stored value is read in `afterNextRender`.

## Demo

TODO

## Development

This repository implements the common project structure. The whole pipeline (build, linting, testcases) runs with:

```
task bb
```

## License

See `License.txt`.
