import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mat_country_selector/mat_country_selector.dart';

import 'visual_regression.dart';

/// The countries the pictures show. A handful instead of all of them, so that the picture of the opened list
/// shows entries which are recognizable rather than the first few of an alphabet.
const List<MatCountry> _countries = <MatCountry>[
  MatCountry(code: 'DE', name: 'Germany'),
  MatCountry(code: 'FR', name: 'France'),
  MatCountry(code: 'GB', name: 'United Kingdom of Great Britain and Northern Ireland'),
  MatCountry(code: 'JP', name: 'Japan'),
];

/// Builds an application which shows nothing but the country-selector, so that the resulting picture is usable as
/// the example-picture of the readme without being cropped afterwards.
Widget _applicationWithTheCountrySelector() {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(colorSchemeSeed: Colors.blue, fontFamily: 'Roboto'),
    home: Scaffold(
      body: Center(
        child: SizedBox(
          width: 320,
          child: MatCountrySelector(
            countries: _countries,
            selectedCountry: 'DE',
            onCountrySelected: (String country) {},
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets(
    'the closed country-selector looks like its baseline',
    (WidgetTester tester) async {
      await expectWidgetToLookLikeBaseline(
        tester,
        _applicationWithTheCountrySelector(),
        'country_selector_closed',
        surfaceSize: const Size(400, 140),
      );
    },
    tags: visualRegressionTestTag,
  );

  testWidgets(
    'the opened country-selector looks like its baseline',
    (WidgetTester tester) async {
      await expectWidgetToLookLikeBaseline(
        tester,
        _applicationWithTheCountrySelector(),
        'country_selector_open',
        // The list is rendered below the closed control and needs the room for its entries, so this surface is
        // higher than the one of the closed control.
        surfaceSize: const Size(400, 340),
        interact: (WidgetTester tester) async {
          await tester.tap(find.byType(DropdownMenu<String>));
        },
      );
    },
    tags: visualRegressionTestTag,
  );
}
