import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'theme_mode_store.dart';

/// Holds the mode the user chose and stores it in a [ThemeModeStore].
///
/// The mode is applied by the `themeMode` of the `MaterialApp` of the application and by nothing else (see
/// `MatDarkmodeScope`), so neither a second theme nor an exchange of a theme at runtime is required. The mode
/// [ThemeMode.system] lets flutter decide, which is why it follows the operating-system - including a change of
/// the system-preference while the application is running, because flutter re-evaluates the platform-brightness
/// by itself.
///
/// The controller is a [ValueListenable], so it can be used with a `ValueListenableBuilder` directly, and it is a
/// [ChangeNotifier], so [dispose] has to be called by whoever created it.
class MatDarkmodeController extends ChangeNotifier implements ValueListenable<ThemeMode> {
  /// Creates a controller which reads and writes the mode in [store].
  ///
  /// Nothing is loaded here: a [ThemeModeStore] usually performs I/O, so the stored mode is only available
  /// asynchronously. Until [loadPersistedMode] has completed, the mode is [initialMode].
  MatDarkmodeController({ThemeModeStore? store, ThemeMode initialMode = ThemeMode.system})
    : _store = store ?? const SharedPreferencesThemeModeStore(),
      _mode = initialMode;

  final ThemeModeStore _store;

  ThemeMode _mode;

  /// The mode the user chose. Change it with [setMode].
  @override
  ThemeMode get value => _mode;

  /// Loads the mode which was stored by a previous run of the application and applies it.
  ///
  /// Call this once before the application is shown (see the ReadMe). Doing it afterwards is possible as well,
  /// but then the application is visible in the mode [ThemeMode.system] for a moment before it switches to the
  /// mode the user actually chose.
  Future<void> loadPersistedMode() async {
    _setValue(await _store.load());
  }

  /// Sets the mode to [mode] and stores it.
  ///
  /// The returned future completes when the mode was written to the store. It does not have to be awaited to make
  /// the user-interface follow the new mode: that already happens synchronously, before the store is written.
  Future<void> setMode(ThemeMode mode) async {
    if (_mode == mode) {
      // Writing the same value again would neither change the user-interface nor the store, so the notification
      // and the I/O are skipped instead of being performed for nothing.
      return;
    }
    _setValue(mode);
    await _store.save(mode);
  }

  void _setValue(ThemeMode mode) {
    if (_mode == mode) {
      return;
    }
    _mode = mode;
    notifyListeners();
  }
}
