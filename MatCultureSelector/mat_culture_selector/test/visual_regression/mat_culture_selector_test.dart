import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mat_culture_selector/mat_culture_selector.dart';

import 'visual_regression.dart';

/// The cultures the pictures show. They are the same ones the readme and the example-application use, so that the
/// pictures of the readme really show the example which is documented next to them.
const List<MatCultureOption> _cultures = <MatCultureOption>[
  MatCultureOption(culture: 'en-GB', label: 'English (UK)'),
  MatCultureOption(culture: 'de', label: 'German'),
  MatCultureOption(culture: 'de-AT', label: 'German (Austria)'),
  MatCultureOption(culture: 'fr', label: 'French'),
];

/// Builds an application which shows nothing but the culture-selector, so that the resulting picture is usable as
/// the example-picture of the readme without being cropped afterwards.
Widget _applicationWithTheCultureSelector() {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(colorSchemeSeed: Colors.blue, fontFamily: 'Roboto'),
    home: Scaffold(
      body: Center(
        child: SizedBox(
          width: 320,
          child: MatCultureSelector(
            cultures: _cultures,
            selectedCulture: 'de-AT',
            onCultureSelected: (String culture) {},
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets(
    'the closed culture-selector looks like its baseline',
    (WidgetTester tester) async {
      await expectWidgetToLookLikeBaseline(
        tester,
        _applicationWithTheCultureSelector(),
        'culture_selector_closed',
        surfaceSize: const Size(400, 140),
      );
    },
    tags: visualRegressionTestTag,
  );

  testWidgets(
    'the opened culture-selector looks like its baseline',
    (WidgetTester tester) async {
      await expectWidgetToLookLikeBaseline(
        tester,
        _applicationWithTheCultureSelector(),
        'culture_selector_open',
        // The dropdown is rendered above the closed control and needs the room for all of its entries, so this
        // surface is higher than the one of the closed control.
        surfaceSize: const Size(400, 340),
        interact: (WidgetTester tester) async {
          await tester.tap(find.byType(DropdownButton<String>));
        },
      );
    },
    tags: visualRegressionTestTag,
  );
}
