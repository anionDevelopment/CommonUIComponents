import 'package:flutter/foundation.dart';

/// One culture the user can choose, together with the text which is shown for it.
@immutable
class MatCultureOption {
  /// The culture-identifier, for example "en-GB", "de" or "de-AT". This is the value which the
  /// `onCultureSelected`-callback of the culture-selector reports.
  final String culture;

  /// The text shown for this entry, typically the name of the language in English, for example "English (UK)".
  final String label;

  /// Creates an entry which offers [culture] under the text [label].
  const MatCultureOption({required this.culture, required this.label});

  @override
  bool operator ==(Object other) {
    return other is MatCultureOption && other.culture == culture && other.label == label;
  }

  @override
  int get hashCode => Object.hash(culture, label);

  @override
  String toString() => 'MatCultureOption(culture: $culture, label: $label)';
}
