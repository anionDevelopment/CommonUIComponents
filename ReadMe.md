# MatCountrySelector

## Purpose

MatCountrySelector is the repository of `mat_country_selector`, a flutter-widget which lets the user choose a country from the list of all countries, shown with their flag and their english name.

It is the flutter-counterpart of [ngx-country-selector](https://github.com/anionDev/NgxCountrySelector), which offers the same thing for angular-applications.

Development-state: active development.

## Code-units

| Code-unit | Content | State |
|---|---|---|
| `MatCountrySelector` | The widget itself, published on pub.dev as the package `mat_country_selector`, including its example-application. | enabled |

## Installation and usage

The package is published at [pub.dev/packages/mat_country_selector](https://pub.dev/packages/mat_country_selector) and is installed with `flutter pub add mat_country_selector`.

How the widget is used and which parameters it has is documented in the [readme of the code-unit](MatCountrySelector/ReadMe.md), which is also what pub.dev shows on the page of the package. It is documented there and not here so that both descriptions can not drift apart.

## Development

This repository implements the common project structure. The whole pipeline (build, linting, testcases) runs with:

```
task bb
```

The example-application which shows the widget is started with `task rd`.

Besides the widget-tests the repository has visual-regression-tests which render the widget and compare the result with the baseline-images in `MatCountrySelector/Other/Resources/VisualRegressionBaselines`. They run inside a container so that the result is reproducible independently of the operating-system, which is also why a plain `flutter test` skips them. After an intended change of the appearance the baseline-images are regenerated with `task uvrb`.

## Contributing

See [Contributing.md](Contributing.md).

## License

See [License.txt](License.txt).
