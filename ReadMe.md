# CommonUIComponents

## Purpose

CommonUIComponents is the repository of the reusable user-interface-components of anionDev, in material design, for angular- and for flutter-applications.

Every component exists twice: once as an angular-component (`Ngx…`) and once as a flutter-widget (`Mat…`). The two are meant to do the same thing, so an application which is written in angular and one which is written in flutter offer their users the same control, and a decision about the behaviour of a component is made once and holds for both.

Development-state: active development.

## Code-units

| Code-unit | Component | Published as | State |
|---|---|---|---|
| `NgxCountrySelector` | Country-selector | npmjs.com: `@aniondev/ngx-country-selector` | enabled |
| `MatCountrySelector` | Country-selector | pub.dev: `mat_country_selector` | enabled |
| `NgxCultureSelector` | Culture-selector | npmjs.com: `@aniondev/ngx-culture-selector` | enabled |
| `MatCultureSelector` | Culture-selector | pub.dev: `mat_culture_selector` | enabled |
| `NgxDarkmodeToggleButton` | Darkmode-toggle-button | npmjs.com: `@aniondev/ngx-darkmode-toggle-button` | enabled |
| `MatDarkmodeToggleButton` | Darkmode-toggle-button | pub.dev: `mat_darkmode_toggle_button` | enabled |

What a component does, how it is installed and which parameters it has is documented in the readme of its code-unit - which is also what npmjs.com respectively pub.dev shows on the page of the package. Every one of those readmes shows the component in pictures which the visual-regression-tests generate, so the pictures can not drift apart from what the component really looks like.

## Development

This repository implements the common project structure. The whole pipeline (build, linting, testcases) of every code-unit runs with:

```
task bb
```

Every code-unit brings two tasks of its own: `task rd<kind><component>` starts its demo-application (for example `task rdngxcountry`), and `task uvrb<kind><component>` regenerates its baseline- and example-pictures after an intended change of its appearance (for example `task uvrbmatculture`). The visual-regression-tests run inside a container so that a rendered image is reproducible independently of the operating-system, which is why a plain test-run skips them.

## Contributing

See [Contributing.md](Contributing.md).

## License

See [License.txt](License.txt).
