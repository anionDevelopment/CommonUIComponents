# NgxCountrySelector

## Purpose

NgxCountrySelector is the repository of `@aniondev/ngx-country-selector`, an angular-component which lets the user choose a country from the countries of ISO 3166-1, shown with their flag and their english name.

It is the angular-counterpart of [MatCountrySelector](https://github.com/anionDev/MatCountrySelector), which offers the same thing for flutter-applications.

Development-state: active development.

## Code-units

| Code-unit | Content | State |
|---|---|---|
| `NgxCountrySelector` | The component itself, published on npmjs.com as the package `@aniondev/ngx-country-selector`, including its demo-application. | enabled |

## Installation and usage

The package is published at [npmjs.com/package/@aniondev/ngx-country-selector](https://www.npmjs.com/package/@aniondev/ngx-country-selector) and is installed with `npm install @aniondev/ngx-country-selector`.

How the component is used and which parameters it has is documented in the [readme of the code-unit](NgxCountrySelector/ReadMe.md), which is also what npmjs.com shows on the page of the package. It is documented there and not here so that both descriptions can not drift apart.

## Development

This repository implements the common project structure. The whole pipeline (build, linting, testcases) runs with:

```
task bb
```

The demo-application which shows the component is started with `task rd`.

Besides the unit-tests the repository has visual-regression-tests which render the component in chromium, firefox and webkit and compare the result with the baseline-images in `NgxCountrySelector/Other/Resources/VisualRegressionBaselines`. They run inside a container so that the result is reproducible independently of the operating-system. After an intended change of the appearance the baseline-images are regenerated with `task uvrb`.

## Contributing

See [Contributing.md](Contributing.md).

## License

See [License.txt](License.txt).
