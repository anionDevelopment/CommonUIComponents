import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The key under which the chosen mode is stored, so that it survives a restart of the application.
const String themeModeStorageKey = 'theme';

/// The place the chosen mode is kept between two starts of the application.
///
/// The store is an own abstraction and not simply a call to `shared_preferences`, because where the mode belongs
/// is a decision of the application: an application which keeps the settings of its users in its own database or
/// in its backend stores the mode there as well, so that the choice of a user is not bound to one device. The
/// implementation which is used by default is [SharedPreferencesThemeModeStore].
abstract interface class ThemeModeStore {
  /// Returns the stored mode, or [ThemeMode.system] if nothing was stored yet.
  Future<ThemeMode> load();

  /// Stores [mode].
  Future<void> save(ThemeMode mode);
}

/// Parses the value a [ThemeMode] was stored as (its [ThemeMode.name]) back into a [ThemeMode].
///
/// A missing or an unknown value results in [ThemeMode.system]. That is deliberately not an error: a value which
/// was written by another (for example a newer) version of the application must not prevent the application from
/// starting, and a user who did not choose anything yet has the same expectation as one whose stored value can
/// not be interpreted anymore, namely to follow the operating-system.
ThemeMode themeModeFromName(String? name) {
  return ThemeMode.values.firstWhere((ThemeMode mode) => mode.name == name, orElse: () => ThemeMode.system);
}

/// The default [ThemeModeStore]: it keeps the mode in the settings of the platform, using `shared_preferences`.
class SharedPreferencesThemeModeStore implements ThemeModeStore {
  /// Creates a store which reads and writes the mode under [themeModeStorageKey].
  const SharedPreferencesThemeModeStore();

  @override
  Future<ThemeMode> load() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return themeModeFromName(preferences.getString(themeModeStorageKey));
  }

  @override
  Future<void> save(ThemeMode mode) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(themeModeStorageKey, mode.name);
  }
}

/// A [ThemeModeStore] which only keeps the mode in memory and therefore forgets it when the application ends.
///
/// It exists for testcases and for an application which deliberately does not want to persist the choice at all.
class InMemoryThemeModeStore implements ThemeModeStore {
  /// Creates a store which starts with [initialMode].
  InMemoryThemeModeStore({ThemeMode initialMode = ThemeMode.system}) : _mode = initialMode;

  ThemeMode _mode;

  @override
  Future<ThemeMode> load() async => _mode;

  @override
  Future<void> save(ThemeMode mode) async {
    _mode = mode;
  }
}
