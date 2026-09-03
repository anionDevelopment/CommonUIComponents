import 'package:flutter/material.dart';

import 'mat_culture_option.dart';

/// Lets the user choose one culture from a list of cultures.
///
/// The closed control always shows the label of the currently chosen culture; tapping it opens a dropdown which
/// lists the labels of every culture that was passed in - this is the native behavior of the material-widgets it
/// is built on and needs no further code. The widget does not know anything about cultures itself: both the list
/// of offered cultures and the text shown for each of them are passed in by the caller, and the chosen entry's
/// [MatCultureOption.culture] is reported as-is through [onCultureSelected]. Applying the choice (for example
/// switching the locale of the application) is deliberately left to the application which uses the widget.
///
/// The widget takes the width it is given, like every other material form-field, so it has to be placed
/// somewhere with a bounded width (for example inside a [SizedBox], an [Expanded] or a [Column]).
class MatCultureSelector extends StatelessWidget {
  /// The cultures the user can choose from, each with its culture-identifier and the text shown for it.
  ///
  /// The entries are shown in the given order. Their [MatCultureOption.culture]-values have to be distinct.
  final List<MatCultureOption> cultures;

  /// The culture-identifier which is preselected, or null if no culture is chosen yet.
  final String? selectedCulture;

  /// The label of the control itself. Set it to a translated text if the application is localized.
  final String label;

  /// Called with the culture-identifier of the culture the user chose.
  final ValueChanged<String> onCultureSelected;

  /// Creates a culture-selector which offers [cultures] and reports the choice of the user to [onCultureSelected].
  const MatCultureSelector({
    super.key,
    required this.cultures,
    required this.onCultureSelected,
    this.selectedCulture,
    this.label = 'Culture',
  });

  @override
  Widget build(BuildContext context) {
    final String? chosenCulture = _chosenCulture();
    return InputDecorator(
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      isEmpty: chosenCulture == null,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: chosenCulture,
          isDense: true,
          isExpanded: true,
          onChanged: _onChanged,
          items: cultures.map(_toDropdownItem).toList(),
        ),
      ),
    );
  }

  /// The culture which the dropdown shows as the chosen one, or null if it shows none.
  ///
  /// This is [selectedCulture], but only if [cultures] really contains it: a [DropdownButton] requires its value
  /// to be the value of one of its items and throws otherwise. A `selectedCulture` which is not offered (for
  /// example because the application preselected a culture which it does not offer anymore) would therefore not
  /// simply show up as "nothing is chosen" but would make the whole widget fail to build, so it is treated as
  /// "nothing is chosen" here.
  String? _chosenCulture() {
    if (selectedCulture == null) {
      return null;
    }
    for (final MatCultureOption option in cultures) {
      if (option.culture == selectedCulture) {
        return selectedCulture;
      }
    }
    return null;
  }

  DropdownMenuItem<String> _toDropdownItem(MatCultureOption option) {
    return DropdownMenuItem<String>(value: option.culture, child: Text(option.label));
  }

  void _onChanged(String? culture) {
    // The dropdown only reports the value of one of its items, and none of them is null, so this is never null in
    // practice; the check exists because the signature of the callback of the dropdown allows it.
    if (culture != null) {
      onCultureSelected(culture);
    }
  }
}
