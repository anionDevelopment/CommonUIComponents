import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mat_darkmode_toggle_button/mat_darkmode_toggle_button.dart';

void main() {
  group('MatDarkmodeController', () {
    test('uses the mode "system" as long as the user did not choose another one', () {
      final MatDarkmodeController controller = MatDarkmodeController(store: InMemoryThemeModeStore());
      addTearDown(controller.dispose);
      expect(controller.value, ThemeMode.system);
    });

    test('accepts every supported mode', () async {
      final MatDarkmodeController controller = MatDarkmodeController(store: InMemoryThemeModeStore());
      addTearDown(controller.dispose);
      for (final ThemeMode mode in ThemeMode.values) {
        await controller.setMode(mode);
        expect(controller.value, mode);
      }
    });

    test('declares exactly the three modes of the specification', () {
      expect(ThemeMode.values, <ThemeMode>[ThemeMode.system, ThemeMode.light, ThemeMode.dark]);
    });

    test('notifies its listeners when the mode changes', () async {
      final MatDarkmodeController controller = MatDarkmodeController(store: InMemoryThemeModeStore());
      addTearDown(controller.dispose);
      int amountOfNotifications = 0;
      controller.addListener(() => amountOfNotifications++);
      await controller.setMode(ThemeMode.dark);
      expect(amountOfNotifications, 1);
    });

    test('does not notify its listeners when the mode which is already set is set again', () async {
      final MatDarkmodeController controller = MatDarkmodeController(store: InMemoryThemeModeStore());
      addTearDown(controller.dispose);
      await controller.setMode(ThemeMode.dark);
      int amountOfNotifications = 0;
      controller.addListener(() => amountOfNotifications++);
      await controller.setMode(ThemeMode.dark);
      expect(amountOfNotifications, 0);
    });

    test('stores the chosen mode', () async {
      final InMemoryThemeModeStore store = InMemoryThemeModeStore();
      final MatDarkmodeController controller = MatDarkmodeController(store: store);
      addTearDown(controller.dispose);
      await controller.setMode(ThemeMode.light);
      expect(await store.load(), ThemeMode.light);
    });

    test('applies the mode which was stored by a previous run', () async {
      final MatDarkmodeController controller = MatDarkmodeController(store: InMemoryThemeModeStore(initialMode: ThemeMode.dark));
      addTearDown(controller.dispose);
      await controller.loadPersistedMode();
      expect(controller.value, ThemeMode.dark);
    });
  });

  group('themeModeFromName', () {
    test('parses the name every mode is stored as', () {
      for (final ThemeMode mode in ThemeMode.values) {
        expect(themeModeFromName(mode.name), mode);
      }
    });

    test('treats a missing or an unknown value as "system"', () {
      expect(themeModeFromName(null), ThemeMode.system);
      expect(themeModeFromName(''), ThemeMode.system);
      expect(themeModeFromName('sepia'), ThemeMode.system);
    });
  });
}
