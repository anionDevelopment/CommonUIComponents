import 'package:flutter/material.dart';
import 'package:mat_darkmode_toggle_button/mat_darkmode_toggle_button.dart';

/// The application which is used to look at the widget. It is not part of the published package in the sense that
/// nothing of it is imported by it; it only shows how the three parts of the package are put together.
Future<void> main() async {
  // Required because the mode is loaded before the application is shown, and loading it uses the platform.
  WidgetsFlutterBinding.ensureInitialized();
  final MatDarkmodeController controller = MatDarkmodeController();
  // The stored mode is loaded before the first frame. Doing it afterwards would show the application in the mode
  // "system" for a moment before it switches to the mode the user actually chose.
  await controller.loadPersistedMode();
  runApp(DemoApplication(controller: controller));
}

/// Declares the two themes of the application and lets the mode decide which of them is used.
class DemoApplication extends StatelessWidget {
  /// Creates the application which shows the mode of [controller].
  const DemoApplication({super.key, required this.controller});

  /// The controller which holds the mode the user chose.
  final MatDarkmodeController controller;

  @override
  Widget build(BuildContext context) {
    return MatDarkmodeScope(
      controller: controller,
      builder: (BuildContext context, ThemeMode mode) => MaterialApp(
        title: 'mat_darkmode_toggle_button',
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
        darkTheme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark)),
        themeMode: mode,
        home: const DemoPage(),
      ),
    );
  }
}

/// Shows the widget together with the modes it offers.
class DemoPage extends StatelessWidget {
  /// Creates the page.
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      // All colors are taken from the theme, so this page follows the chosen mode as well.
      appBar: AppBar(
        title: const Text('mat_darkmode_toggle_button'),
        backgroundColor: theme.colorScheme.surfaceContainer,
        // The widget finds its controller in the surrounding MatDarkmodeScope, so nothing has to be passed here.
        actions: const <Widget>[MatDarkmodeToggleButton(), SizedBox(width: 16)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: <Widget>[
            Text('Color scheme', style: theme.textTheme.headlineSmall),
            Text(
              'Choose whether the appearance follows the operating-system or is set explicitly.',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const MatDarkmodeToggleButton(showLabels: true),
          ],
        ),
      ),
    );
  }
}
