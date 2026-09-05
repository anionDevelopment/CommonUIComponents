import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mat_darkmode_toggle_button/mat_darkmode_toggle_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
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

  group('InMemoryThemeModeStore', () {
    test('returns the mode it was created with', () async {
      expect(await InMemoryThemeModeStore(initialMode: ThemeMode.dark).load(), ThemeMode.dark);
    });

    test('returns the mode which was saved last', () async {
      final InMemoryThemeModeStore store = InMemoryThemeModeStore();
      await store.save(ThemeMode.light);
      expect(await store.load(), ThemeMode.light);
    });
  });

  group('SharedPreferencesThemeModeStore', () {
    // The store is the only part of this package which touches the platform, so the testcases replace the
    // platform-side of "shared_preferences" by the values below instead of really writing to the device.
    const SharedPreferencesThemeModeStore store = SharedPreferencesThemeModeStore();

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    test('returns "system" for a user who did not choose anything yet', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      expect(await store.load(), ThemeMode.system);
    });

    test('returns the mode which was stored by a previous run', () async {
      for (final ThemeMode mode in ThemeMode.values) {
        SharedPreferences.setMockInitialValues(<String, Object>{themeModeStorageKey: mode.name});
        expect(await store.load(), mode);
      }
    });

    test('treats a value which can not be interpreted as "system" instead of failing', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{themeModeStorageKey: 'sepia'});
      expect(await store.load(), ThemeMode.system);
    });

    test('stores the mode under the documented key', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      await store.save(ThemeMode.dark);
      final SharedPreferences preferences = await SharedPreferences.getInstance();
      expect(preferences.getString(themeModeStorageKey), 'dark');
    });

    test('reads back every mode it stored', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      for (final ThemeMode mode in ThemeMode.values) {
        await store.save(mode);
        expect(await store.load(), mode);
      }
    });
  });
}
