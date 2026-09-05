import 'package:flutter/foundation.dart';

/// One country the user can choose: its code, its english name and the flag which belongs to that code.
@immutable
class MatCountry {
  /// The two-letter-code of the country as ISO 3166-1 defines it, in upper case - for example "DE", "GB" or "JP".
  /// This is the value the `onCountrySelected`-callback of the country-selector reports.
  final String code;

  /// The english name of the country, for example "Germany".
  final String name;

  /// Creates the country [code] with the english name [name].
  const MatCountry({required this.code, required this.name});

  /// The flag of this country as an emoji, derived from [code] rather than shipped as a picture.
  ///
  /// A flag-emoji is nothing but the two letters of the country-code written as "regional indicator symbols", the
  /// letters A to Z at code-point 0x1F1E6 and upwards; every system draws the pair of them as the flag it knows
  /// for that country. Deriving it has three consequences which a picture would not have: nothing has to be
  /// licensed, nothing has to be updated when a flag changes, and a country whose flag a system does not know
  /// simply shows the two letters instead of a broken image.
  String get flag {
    if (code.length != 2) {
      return '';
    }
    return String.fromCharCodes(code.toUpperCase().codeUnits.map((letter) => _firstRegionalIndicator + letter - _a));
  }

  /// What is shown for this country: its flag and its english name.
  String get label => '$flag $name';

  static const int _firstRegionalIndicator = 0x1f1e6;
  static const int _a = 0x41;

  @override
  bool operator ==(Object other) => other is MatCountry && other.code == code && other.name == name;

  @override
  int get hashCode => Object.hash(code, name);

  @override
  String toString() => 'MatCountry(code: $code, name: $name)';
}
