import 'package:flutter/material.dart';

import 'mat_darkmode_controller.dart';
import 'mat_darkmode_scope.dart';

/// Lets the user choose between the three modes [ThemeMode.light], [ThemeMode.system] and [ThemeMode.dark].
///
/// All three modes are visible at the same time and every one of them is reachable with one tap. A two-state
/// switch is deliberately not used: it can not express [ThemeMode.system], which is the mode most users want,
/// because it follows the setting of their operating-system.
///
/// The colors are taken from the theme of the application, so the widget follows the chosen mode itself without
/// any further code.
class MatDarkmodeToggleButton extends StatelessWidget {
  /// Creates the control.
  ///
  /// If [controller] is not given then the controller of the closest [MatDarkmodeScope] is used.
  const MatDarkmodeToggleButton({
    super.key,
    this.controller,
    this.semanticsLabel = 'Color scheme',
    this.lightLabel = 'Light',
    this.systemLabel = 'System',
    this.darkLabel = 'Dark',
    this.showLabels = false,
  });

  /// The controller which holds the mode. If it is null then [MatDarkmodeScope.of] is used.
  final MatDarkmodeController? controller;

  /// The label of the whole control. Set it to a translated text if the application is localized.
  final String semanticsLabel;

  /// The label of the button for the light-mode. It is used as its tooltip and, if [showLabels] is set, as its
  /// caption.
  final String lightLabel;

  /// The label of the button which follows the operating-system.
  final String systemLabel;

  /// The label of the button for the dark-mode.
  final String darkLabel;

  /// Whether the buttons show their label beside their icon. By default they only show the icon, which is what
  /// fits into an app-bar; a settings-page usually has the space for the labels.
  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    final MatDarkmodeController usedController = controller ?? MatDarkmodeScope.of(context);
    return Semantics(
      container: true,
      label: semanticsLabel,
      child: ValueListenableBuilder<ThemeMode>(
        // The widget listens to the controller itself instead of relying on a rebuild from outside, so that it
        // also shows the current mode when it was used with an explicitly passed controller and without a scope.
        valueListenable: usedController,
        builder: (BuildContext context, ThemeMode mode, Widget? child) => SegmentedButton<ThemeMode>(
          // The checkmark of the selected segment is not shown: which segment is selected is already visible by
          // its highlighted background, and the checkmark would replace exactly the icon which says what the
          // segment means.
          showSelectedIcon: false,
          segments: <ButtonSegment<ThemeMode>>[
            _segment(ThemeMode.light, Icons.light_mode, lightLabel),
            _segment(ThemeMode.system, Icons.computer, systemLabel),
            _segment(ThemeMode.dark, Icons.dark_mode, darkLabel),
          ],
          selected: <ThemeMode>{mode},
          onSelectionChanged: (Set<ThemeMode> selection) => usedController.setMode(selection.single),
        ),
      ),
    );
  }

  ButtonSegment<ThemeMode> _segment(ThemeMode mode, IconData icon, String label) {
    return ButtonSegment<ThemeMode>(
      value: mode,
      icon: Icon(icon),
      label: showLabels ? Text(label) : null,
      tooltip: label,
    );
  }
}
