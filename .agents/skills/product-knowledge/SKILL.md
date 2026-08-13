---
name: product-knowledge
description: What ngx-darkmode-toggle-button is, how this repository is structured and which mechanisms exist for building and testing it. Use this before fixing a defect or developing a feature in this repository, to know where things belong and how to verify a change.
---

# ngx-darkmode-toggle-button

`ngx-darkmode-toggle-button` is an angular-component which lets the user choose the color-scheme of a
web-application between the three modes `system`, `light` and `dark`. It is published at npmjs.com as
`@aniondev/ngx-darkmode-toggle-button`.

The reason for the product is the third mode: a two-state-toggle only knows light and dark and therefore loses
exactly the mode which most users want, namely "follow my operating-system". All three modes are offered at
the same time and each of them is reachable with one click.

## Structure of the repository

The repository follows the "common project structure": all sourcecode lives in code-units, and every code-unit
has its own `Other`-folder with its build-, quality-check- and reference-files. Use the
`work-with-common-project-structure`-skill when you need the details of that structure.

There is one code-unit, `NgxDarkmodeToggleButton`. It consists of two parts only: `NgxDarkmodeService` (holds
the chosen mode as a signal, stores it and applies it) and `NgxDarkmodeToggleButtonComponent` (the control).
Both are exported by `src/public-api.ts`. Beside them the code-unit contains a small demo-application, which
is not part of the published package but is what the visual-regression-tests take their screenshots of.

## How the switching works, and what must not be broken

The component does not define a second theme and does not exchange a stylesheet at runtime. It only sets the
attribute `data-theme` on the html-element, and the stylesheet of the application maps that attribute to the
css-property `color-scheme`:

| Mode | `data-theme` | `color-scheme` |
| --- | --- | --- |
| `system` | not set | `light dark` |
| `light` | `light` | `light` |
| `dark` | `dark` | `dark` |

That is why the mode `system` follows a change of the operating-system-setting without any code. Three
consequences for every change here:

- do not add a second theme and do not load a stylesheet at runtime (`mat.theme()` is included exactly once by
  the application which uses the package);
- do not use hard-coded colors in the styles - a hard-coded color does not change when the scheme changes;
- do not touch `localStorage` or `window` while the service is constructed: the package has to work with
  server-side-rendering and prerendering, so those accesses happen in `afterNextRender`.

The package deliberately brings no icon-font: which font an application uses is its decision, and a second one
would only add weight.

## Building and testing

`scbuildcodeunits` builds everything; the task `task bb` does the same. `task rd` starts the demo-application,
and `task uvrb` regenerates the baseline-screenshots after an intended change of the appearance.

Beside the unit-tests there are visual-regression-tests: they open the demo-application and compare a
screenshot with the baseline of the same browser. That is what makes an unintended change of the appearance
visible, which a unit-test can not detect.

The build puts the readme and the license of the repository into the built npm-package and makes the links of
that readme absolute, because npmjs.com does not show it in the context of the repository (see
`Other/Build/Build.py`). So the repository keeps one single readme instead of a second one which would drift.
