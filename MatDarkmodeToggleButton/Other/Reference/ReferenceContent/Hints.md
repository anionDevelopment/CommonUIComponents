# Hints

## Requirements

The following tools from the [tools-list](https://github.com/anionDev/ScriptCollection/blob/main/ScriptCollection/Other/Reference/ReferenceContent/Articles/RequirementsForCommonProjectStructure.md#Tools) are required to build this code-unit:

- `docfx`
- `flutter`
- `git`
- `gitversion`
- `lcov_cobertura`
- `python`
- `reportgenerator`
- `scriptcollection`

The visual-regression-tests additionally require a reachable `docker`-daemon, because they run inside a container (see below).

To create a release the following tools are also required:

- `gh`

## IDE

The recommended IDE for this codeunit is [Visual Studio Code](https://code.visualstudio.com/).

## What this codeunit contains

The codeunit consists of three parts only:

- `MatDarkmodeController` holds the mode the user chose (`ThemeMode.system`, `ThemeMode.light` or `ThemeMode.dark`), loads it from and stores it in a `ThemeModeStore`.
- `MatDarkmodeScope` makes the controller reachable for the widgets below it and rebuilds them when the mode changes.
- `MatDarkmodeToggleButton` is the control which lets the user choose one of the three modes.

All of them are exported by `lib/mat_darkmode_toggle_button.dart`, which is the entry-file of the package.

## How the switching works

The package does not build a second theme and does not exchange any theme at runtime. It only decides which of the two themes the application already passes to its `MaterialApp` is used, by setting the `themeMode`:

| Mode | `MaterialApp.themeMode` | Result |
| --- | --- | --- |
| `system` | `ThemeMode.system` | follows the operating-system-theme |
| `light` | `ThemeMode.light` | always `MaterialApp.theme` |
| `dark` | `ThemeMode.dark` | always `MaterialApp.darkTheme` |

That is the reason why the mode `system` follows a change of the setting of the operating-system without any code: Flutter re-evaluates the platform-brightness by itself and `ThemeMode.system` reacts to it.

Consequences for a change of this codeunit:

- Do not define a theme in this codeunit and do not exchange one at runtime. Which colors an application uses is its own decision; this package only chooses between the two themes the application declared.
- Do not use hard-coded colors in the widgets of this codeunit. Take them from `Theme.of(context)` respectively from the `ColorScheme`, otherwise they stay as they are when the mode changes.
- Do not read or write the store while the controller is constructed. Loading is asynchronous (a `ThemeModeStore` usually performs I/O), therefore it happens in `loadPersistedMode`, which the application awaits before it runs.
- Do not add a further way to reach the controller. `MatDarkmodeScope` and the explicit `controller`-argument of the widget are the two intended ones; a third one (for example a global singleton) would make it unclear which instance is the current one.

## Usage

The usage of the package is documented in the `ReadMe.md` of the repository.
