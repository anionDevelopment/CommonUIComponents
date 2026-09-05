import 'package:flutter/material.dart';

import 'all_countries.dart';
import 'mat_country.dart';

/// Lets the user choose one country, shown with its flag and its english name.
///
/// Unlike a selector which is handed its entries, this widget brings the countries with it: [allCountries], the
/// list of ISO 3166-1. An application which wants "a country-selector" therefore passes nothing but the callback,
/// and one which offers only some countries passes its own [countries]. What the chosen country *means* - a
/// nationality, a place of residence, a shipping-destination - is the application's business; the widget reports
/// the code of the country and does nothing else with it.
///
/// The entries can be found by typing: with almost 250 of them, scrolling to "Netherlands" is not a way to pick a
/// country, so the underlying [DropdownMenu] filters the list by what was typed - matched against the same text
/// which is shown, the flag and the english name.
///
/// The widget takes the width it is given, like every other material form-field, so it has to be placed somewhere
/// with a bounded width (for example inside a [SizedBox], an [Expanded] or a [Column]).
class MatCountrySelector extends StatelessWidget {
  /// The countries the user can choose from, in the order they are offered. Defaults to [allCountries]; the
  /// [MatCountry.code]-values have to be distinct.
  final List<MatCountry> countries;

  /// The code of the country which is preselected, or `null` if none is chosen yet.
  final String? selectedCountry;

  /// The label of the control itself. Set it to a translated text if the application is localized.
  final String label;

  /// The text shown while nothing is chosen yet.
  final String? hint;

  /// Called with the [MatCountry.code] of the country the user chose.
  final ValueChanged<String> onCountrySelected;

  /// Creates a country-selector which offers [countries] and reports the choice of the user to
  /// [onCountrySelected].
  const MatCountrySelector({
    super.key,
    required this.onCountrySelected,
    this.countries = allCountries,
    this.selectedCountry,
    this.label = 'Country',
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      // The chosen country is what the widget was given, so a rebuild with another one shows that other one: the
      // key makes the menu (which otherwise keeps its own first selection) follow it.
      key: ValueKey<String?>(_chosenCountry()),
      initialSelection: _chosenCountry(),
      label: Text(label),
      hintText: hint,
      enableFilter: true,
      requestFocusOnTap: true,
      menuHeight: _menuHeight,
      expandedInsets: EdgeInsets.zero,
      onSelected: _onSelected,
      dropdownMenuEntries: <DropdownMenuEntry<String>>[
        for (final MatCountry country in countries) DropdownMenuEntry<String>(value: country.code, label: country.label),
      ],
    );
  }

  /// How tall the opened list may become. Without a limit it would try to be as tall as 249 entries.
  static const double _menuHeight = 320;

  /// The country the menu shows as the chosen one, or `null` if it shows none.
  ///
  /// This is [selectedCountry], but only if [countries] really contains it: a country which is not offered (for
  /// example because the application preselected one which it does not offer any more) is treated as "nothing is
  /// chosen" instead of being shown as a selection which cannot be found in the list.
  String? _chosenCountry() {
    if (selectedCountry == null) {
      return null;
    }
    for (final MatCountry country in countries) {
      if (country.code == selectedCountry) {
        return selectedCountry;
      }
    }
    return null;
  }

  void _onSelected(String? code) {
    // The menu only reports the value of one of its entries, and none of them is null; the check exists because
    // the signature of the callback allows it.
    if (code != null) {
      onCountrySelected(code);
    }
  }
}
