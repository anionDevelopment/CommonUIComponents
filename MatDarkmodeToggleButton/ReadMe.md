# mat_darkmode_toggle_button

## Purpose

`mat_darkmode_toggle_button` is a flutter-widget which lets the user choose the color-scheme of an application between the three modes `system`, `light` and `dark`. The choice is kept over restarts of the application.

## Idea

Apps and applications usually have a light- and a dark-appearance, and the operating-systems have that setting as well. Most users want the application to simply follow their operating-system, but they also want to be able to overrule that for one application.

A two-state switch can not express that: it only knows "light" and "dark" and therefore loses exactly the mode which most users want. This widget therefore offers all three modes at the same time, each of them reachable with one tap.

This package is the flutter-equivalent of [ngx-darkmode-toggle-button](https://github.com/anionDev/NgxDarkmodeToggleButton), which does the same for angular-applications.

## Example

![The widget in the mode light](Other/Reference/Technical/Images/ToggleButtonLight.png)
![The widget in the mode dark](Other/Reference/Technical/Images/ToggleButtonDark.png)

The three modes are visible at the same time and the active one is highlighted. In the mode `dark` the same page is dark and the third button is the highlighted one.

## Requirements

- Flutter 3.35 or newer
- A `MaterialApp` which declares both a `theme` and a `darkTheme` (the widget uses material-3-components and chooses between those two themes, it does not bring a theme of its own)

## Installation

The package is published at [pub.dev/packages/mat_darkmode_toggle_button](https://pub.dev/packages/mat_darkmode_toggle_button).

```
flutter pub add mat_darkmode_toggle_button
```

## Usage

### 1. Declare the two themes once

The package does not build a theme and does not exchange one at runtime. It only decides which of the two themes the application already declared is used, by setting the `themeMode` of the `MaterialApp`:

```dart
MaterialApp(
  theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
  darkTheme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark)),
  themeMode: mode,
  home: const HomePage(),
)
```

Own widgets must take their colors from the theme (`Theme.of(context).colorScheme.onSurface` and so on). A hard-coded color stays as it is when the mode changes.

### 2. Load the stored mode before the first frame

Without this the application is visible in the mode `system` for a moment after every start before it switches to the mode the user actually chose:

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final MatDarkmodeController controller = MatDarkmodeController();
  await controller.loadPersistedMode();
  runApp(MyApplication(controller: controller));
}
```

### 3. Put the scope around the application

`MatDarkmodeScope` rebuilds the application when the mode changes and makes the controller reachable for every widget below it, so the controller does not have to be passed through the widget-tree:

```dart
class MyApplication extends StatelessWidget {
  const MyApplication({super.key, required this.controller});

  final MatDarkmodeController controller;

  @override
  Widget build(BuildContext context) {
    return MatDarkmodeScope(
      controller: controller,
      builder: (BuildContext context, ThemeMode mode) => MaterialApp(
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
        darkTheme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark)),
        themeMode: mode,
        home: const HomePage(),
      ),
    );
  }
}
```

### 4. Use the widget

Anywhere below the scope, for example in an app-bar or on a settings-page:

```dart
AppBar(
  title: const Text('My application'),
  actions: const <Widget>[MatDarkmodeToggleButton()],
)
```

By default the buttons only show their icon, which is what fits into an app-bar. On a settings-page there is usually space for the labels:

```dart
const MatDarkmodeToggleButton(showLabels: true)
```

The labels can be replaced, for example by translated texts:

```dart
MatDarkmodeToggleButton(
  semanticsLabel: 'Farbschema',
  lightLabel: 'Hell',
  systemLabel: 'System',
  darkLabel: 'Dunkel',
)
```

If the widget is used without a `MatDarkmodeScope` then the controller is passed to it directly:

```dart
MatDarkmodeToggleButton(controller: controller)
```

### 5. Read or set the mode from code

The controller is a `ValueListenable<ThemeMode>`, so the mode can be read and written from anywhere - for example to store it in the profile of the user:

```dart
controller.addListener(() {
  final ThemeMode mode = controller.value;
  // for example: send the mode to the backend of your application
});

await controller.setMode(ThemeMode.dark);
```

Below a `MatDarkmodeScope` the controller is reached with `MatDarkmodeScope.of(context)`.

## Behavior

| Mode | `MaterialApp.themeMode` | Result |
| --- | --- | --- |
| `ThemeMode.system` | `ThemeMode.system` | follows the operating-system-theme |
| `ThemeMode.light` | `ThemeMode.light` | always `MaterialApp.theme`, the operating-system is ignored |
| `ThemeMode.dark` | `ThemeMode.dark` | always `MaterialApp.darkTheme`, the operating-system is ignored |

The mode is stored under the key `theme`, by default with `shared_preferences`. A missing or an invalid value is treated as `ThemeMode.system`, which is also the default for a user who did not choose anything yet.

Where the mode is stored is a decision of the application, so the store is exchangeable: an application which keeps the settings of its users in its own database or in its backend implements `ThemeModeStore` and passes it to the controller, so that the choice of a user is not bound to one device:

```dart
MatDarkmodeController(store: MyOwnThemeModeStore())
```

The package brings two implementations: `SharedPreferencesThemeModeStore` (the default) and `InMemoryThemeModeStore`, which forgets the choice when the application ends and which is what the testcases use.

## Structure

The flutter-package is located in `mat_darkmode_toggle_button` and consists of three parts, all of them exported by `lib/mat_darkmode_toggle_button.dart`:

- `MatDarkmodeController` holds the chosen mode and stores it in a `ThemeModeStore`.
- `MatDarkmodeScope` provides the controller to the widgets below it and applies the mode.
- `MatDarkmodeToggleButton` is the control itself.

The testcases are located beside them in `mat_darkmode_toggle_button/test`, and `mat_darkmode_toggle_button/example` contains the demo-application.

## Build and test

The codeunit is built and tested by the scripts of the CommonProjectStructure, so by the pipeline of the repository (`task bb` in the repository-root).

Beside the unit-tests there are visual-regression-tests in `mat_darkmode_toggle_button/test/visual_regression`, which compare a screenshot of a demo-page with a baseline-image in `Other/Resources/VisualRegressionBaselines`. They run inside a container so that the result does not depend on the operating-system of the developer, and a plain `flutter test` therefore skips them (see `mat_darkmode_toggle_button/dart_test.yaml`). After an intended change of the appearance the baseline-images are regenerated with `task uvrb`; the two example-images of this readme are generated by the same run.

The demo-application is started with `task rd`.

## Further information

- Which requirements have to be fulfilled to run the scripts of this codeunit is documented in [Hints.md](./Other/Reference/ReferenceContent/Hints.md).
- How this codeunit is built is documented in [HowToBuild.md](./Other/Reference/ReferenceContent/HowToBuild.md).
