# mat_country_selector

## Purpose

`mat_country_selector` is a flutter-widget which lets the user choose a country, shown with its flag and its english name.

## Idea

Almost every application which asks for a country asks for the same list: the countries of ISO 3166-1. So this widget brings that list with it instead of asking the application for it - an application which wants a country-selector passes nothing but a callback. An application which offers only some countries (the countries it ships to, for example) passes its own list.

What the chosen country *means* stays the application's business: the widget reports the two-letter-code of the country the user chose and does nothing else with it.

Because a list of almost 250 entries cannot be scrolled through sensibly, the entries can be found by typing: the list filters by what was typed, matched against the same text which is shown.

The flags are not pictures. A flag-emoji is the two letters of the country-code written as regional-indicator-symbols, which every system draws itself - so nothing has to be licensed, nothing has to be updated when a flag changes, and a system which does not know a flag simply shows the two letters.

## Requirements

- Flutter 3.24 or newer
- Material design (the widget is built on `DropdownMenu`)

## Installation

The package is published at [pub.dev/packages/mat_country_selector](https://pub.dev/packages/mat_country_selector).

```
flutter pub add mat_country_selector
```

## Usage

### 1. Enable material design once

The widget is built on material design, so the application has to be a material-application. That is the case as soon as its widget-tree is below a `MaterialApp`:

```dart
MaterialApp(
  theme: ThemeData(colorSchemeSeed: Colors.blue),
  home: const MyPage(),
)
```

### 2. Use the widget

The closed control shows the country which is chosen; tapping it opens the list, and typing filters it. Like every other material form-field the widget takes the width it is given, so it is placed somewhere with a bounded width (here a `SizedBox`):

```dart
import 'package:flutter/material.dart';
import 'package:mat_country_selector/mat_country_selector.dart';

class AddressForm extends StatefulWidget {
  const AddressForm({super.key});

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  String? _chosenCountry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: MatCountrySelector(
        selectedCountry: _chosenCountry,
        onCountrySelected: _onCountrySelected,
      ),
    );
  }

  void _onCountrySelected(String country) {
    setState(() {
      _chosenCountry = country;
    });
    // for example: store "DE" as the country of the address
  }
}
```

### 3. Parameters

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `onCountrySelected` | `ValueChanged<String>` | (required) | Called with the `code` of the country the user chose, for example `'DE'`. |
| `countries` | `List<MatCountry>` | `allCountries` | The countries the user can choose from, in the order they are offered. Pass an own list to offer only some of them; their `code`-values have to be distinct. |
| `selectedCountry` | `String?` | `null` | The `code` of the country which is preselected. A code which is not part of `countries` is treated as "nothing is chosen". |
| `label` | `String` | `'Country'` | The label of the control itself. Set it to a translated text if the application is localized. |
| `hint` | `String?` | `null` | The text shown while nothing is chosen yet. |

`MatCountry` describes one country: its `code` (the two-letter-code of ISO 3166-1), its `name` (the english name) and its `flag` (derived from the code). `allCountries` is the list of all 249 of them, ordered by their english name.

The widget does not apply the chosen country anywhere itself and knows nothing about what a country means for an application - a nationality, a place of residence, a shipping-destination are all the same choice to it.

## Example-application

The package contains a small application which shows the widget (`mat_country_selector/example`). It is started with `flutter run` in that folder, or with `task rd` from the root of the repository.

## License

See the [license](../License.txt) of the repository.
