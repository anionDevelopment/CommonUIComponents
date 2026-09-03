import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mat_darkmode_toggle_button/mat_darkmode_toggle_button.dart';

/// Wraps [child] into the smallest application a material-widget needs to be shown in a testcase.
Widget _applicationWith(Widget child) {
  return MaterialApp(home: Scaffold(body: Center(child: child)));
}

void main() {
  late MatDarkmodeController controller;

  setUp(() {
    controller = MatDarkmodeController(store: InMemoryThemeModeStore());
  });

  tearDown(() {
    controller.dispose();
  });

  group('MatDarkmodeToggleButton', () {
    testWidgets('offers all three modes at the same time', (WidgetTester tester) async {
      await tester.pumpWidget(_applicationWith(MatDarkmodeToggleButton(controller: controller)));
      final SegmentedButton<ThemeMode> button = tester.widget(find.byType(SegmentedButton<ThemeMode>));
      expect(button.segments.map((ButtonSegment<ThemeMode> segment) => segment.value), <ThemeMode>[
        ThemeMode.light,
        ThemeMode.system,
        ThemeMode.dark,
      ]);
    });

    testWidgets('marks the mode which is currently chosen', (WidgetTester tester) async {
      await controller.setMode(ThemeMode.dark);
      await tester.pumpWidget(_applicationWith(MatDarkmodeToggleButton(controller: controller)));
      final SegmentedButton<ThemeMode> button = tester.widget(find.byType(SegmentedButton<ThemeMode>));
      expect(button.selected, <ThemeMode>{ThemeMode.dark});
    });

    testWidgets('changes the mode when the user chooses another one', (WidgetTester tester) async {
      await tester.pumpWidget(_applicationWith(MatDarkmodeToggleButton(controller: controller)));
      await tester.tap(find.byIcon(Icons.dark_mode));
      await tester.pumpAndSettle();
      expect(controller.value, ThemeMode.dark);
    });

    testWidgets('shows the new mode as chosen after the user changed it', (WidgetTester tester) async {
      await tester.pumpWidget(_applicationWith(MatDarkmodeToggleButton(controller: controller)));
      await tester.tap(find.byIcon(Icons.light_mode));
      await tester.pumpAndSettle();
      final SegmentedButton<ThemeMode> button = tester.widget(find.byType(SegmentedButton<ThemeMode>));
      expect(button.selected, <ThemeMode>{ThemeMode.light});
    });

    testWidgets('shows only the icons by default and the labels on request', (WidgetTester tester) async {
      await tester.pumpWidget(_applicationWith(MatDarkmodeToggleButton(controller: controller)));
      expect(find.text('Light'), findsNothing);
      await tester.pumpWidget(_applicationWith(MatDarkmodeToggleButton(controller: controller, showLabels: true)));
      expect(find.text('Light'), findsOneWidget);
      expect(find.text('System'), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);
    });

    testWidgets('uses the controller of the surrounding scope if none is given', (WidgetTester tester) async {
      await tester.pumpWidget(
        MatDarkmodeScope(
          controller: controller,
          builder: (BuildContext context, ThemeMode mode) => MaterialApp(
            themeMode: mode,
            home: const Scaffold(body: Center(child: MatDarkmodeToggleButton())),
          ),
        ),
      );
      await tester.tap(find.byIcon(Icons.dark_mode));
      await tester.pumpAndSettle();
      expect(controller.value, ThemeMode.dark);
    });

    testWidgets('states clearly that it needs a controller if there is neither one nor a scope', (WidgetTester tester) async {
      await tester.pumpWidget(_applicationWith(const MatDarkmodeToggleButton()));
      expect(tester.takeException(), isA<FlutterError>().having((FlutterError error) => error.message, 'message', contains('MatDarkmodeScope')));
    });
  });

  group('MatDarkmodeScope', () {
    testWidgets('applies the chosen mode to the application', (WidgetTester tester) async {
      await controller.setMode(ThemeMode.dark);
      late ThemeMode modeOfApplication;
      await tester.pumpWidget(
        MatDarkmodeScope(
          controller: controller,
          builder: (BuildContext context, ThemeMode mode) {
            modeOfApplication = mode;
            return MaterialApp(themeMode: mode, home: const SizedBox.shrink());
          },
        ),
      );
      expect(modeOfApplication, ThemeMode.dark);
      await controller.setMode(ThemeMode.light);
      await tester.pumpAndSettle();
      expect(modeOfApplication, ThemeMode.light);
    });

    testWidgets('provides the controller to the widgets below it', (WidgetTester tester) async {
      late MatDarkmodeController foundController;
      await tester.pumpWidget(
        MatDarkmodeScope(
          controller: controller,
          builder: (BuildContext context, ThemeMode mode) {
            foundController = MatDarkmodeScope.of(context);
            return const MaterialApp(home: SizedBox.shrink());
          },
        ),
      );
      expect(foundController, same(controller));
    });
  });
}
