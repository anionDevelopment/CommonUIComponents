# MatDarkmodeToggleButton

`MatDarkmodeToggleButton` is a flutter-widget which lets the user choose the color-scheme of an application between the three modes `system`, `light` and `dark`. The choice is kept over restarts of the application.

The reason for the product is the third mode: a two-state switch only knows light and dark and therefore loses exactly the mode which most users want, namely "follow my operating-system". All three modes are offered at the same time and each of them is reachable with one tap.

This product is the flutter-equivalent of [ngx-darkmode-toggle-button](https://github.com/anionDev/NgxDarkmodeToggleButton), which does the same for angular-applications.

Development-state: active development.

## Example

![The widget in the mode light](Other/Reference/Technical/Images/ToggleButtonLight.png)
![The widget in the mode dark](Other/Reference/Technical/Images/ToggleButtonDark.png)

The three modes are visible at the same time and the active one is highlighted. In the mode `dark` the same page is dark and the third button is the highlighted one.

## Code-units

| Code-unit | Content | State |
|---|---|---|
| `MatDarkmodeToggleButton` | The flutter-package itself, published at pub.dev as `mat_darkmode_toggle_button`. | enabled |

## Usage

How the package is installed and used is documented in the readme of the code-unit: [MatDarkmodeToggleButton](./MatDarkmodeToggleButton/ReadMe.md).

## Prerequisites

- Flutter 3.35 or newer.
- The tools listed in the [Hints.md](./MatDarkmodeToggleButton/Other/Reference/ReferenceContent/Hints.md) of the code-unit.

## Development

This repository implements the common project structure. The whole pipeline (build, linting, testcases) runs with:

```
task bb
```

Further tasks:

| Task | Purpose |
|---|---|
| `task rd` | Starts the demo-application which shows the widget. |
| `task uvrb` | Regenerates the baseline-images of the visual-regression-tests and the two example-images of this readme. |

## License

See [License.txt](./License.txt).
