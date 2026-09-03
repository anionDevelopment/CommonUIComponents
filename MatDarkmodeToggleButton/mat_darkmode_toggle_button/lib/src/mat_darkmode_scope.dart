import 'package:flutter/material.dart';

import 'mat_darkmode_controller.dart';

/// Makes a [MatDarkmodeController] available to the widgets below it and rebuilds them when the mode changes.
///
/// It is placed above the `MaterialApp` of the application, because the `themeMode` of that `MaterialApp` is what
/// actually applies the mode:
///
/// ```dart
/// MatDarkmodeScope(
///   controller: controller,
///   builder: (BuildContext context, ThemeMode mode) => MaterialApp(
///     theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
///     darkTheme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark)),
///     themeMode: mode,
///     home: const HomePage(),
///   ),
/// )
/// ```
///
/// Every [MatDarkmodeToggleButton] below it then finds the controller by itself, so it does not have to be passed
/// through the widget-tree.
class MatDarkmodeScope extends StatelessWidget {
  /// Creates a scope which provides [controller] to the widgets [builder] creates.
  const MatDarkmodeScope({super.key, required this.controller, required this.builder});

  /// The controller which holds the mode.
  final MatDarkmodeController controller;

  /// Creates the widgets below this scope. It is called again whenever the mode changes.
  final Widget Function(BuildContext context, ThemeMode mode) builder;

  /// Returns the controller of the closest [MatDarkmodeScope] above [context].
  ///
  /// Throws if there is none, because a widget which asks for the controller can not do anything sensible without
  /// it and a silently created second controller would be a different one than the one the application uses.
  static MatDarkmodeController of(BuildContext context) {
    final _MatDarkmodeScopeMarker? marker = context.dependOnInheritedWidgetOfExactType<_MatDarkmodeScopeMarker>();
    if (marker == null) {
      throw FlutterError(
        'No MatDarkmodeScope was found above this widget.\n'
        'Either wrap the application in a MatDarkmodeScope (usually around its MaterialApp) or pass the '
        'MatDarkmodeController to the widget explicitly.',
      );
    }
    return marker.controller;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: controller,
      builder: (BuildContext context, ThemeMode mode, Widget? child) => _MatDarkmodeScopeMarker(
        controller: controller,
        // The builder is called below the marker and not beside it, so that the widgets it creates can already
        // find the controller with "MatDarkmodeScope.of".
        child: Builder(builder: (BuildContext context) => builder(context, mode)),
      ),
    );
  }
}

/// Carries the controller down the widget-tree. The rebuild on a change is done by the [ValueListenableBuilder]
/// of [MatDarkmodeScope], which is why this is a plain [InheritedWidget] and not an [InheritedNotifier].
class _MatDarkmodeScopeMarker extends InheritedWidget {
  const _MatDarkmodeScopeMarker({required this.controller, required super.child});

  final MatDarkmodeController controller;

  @override
  bool updateShouldNotify(_MatDarkmodeScopeMarker oldWidget) => controller != oldWidget.controller;
}
