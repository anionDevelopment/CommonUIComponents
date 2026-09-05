import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mat_culture_selector/mat_culture_selector.dart';

/// The cultures the testcases offer. Which cultures these are does not matter for the widget - it is the caller
/// who decides that - so they are only an example of a list which contains a language with and without a region.
const List<MatCultureOption> _cultures = <MatCultureOption>[
  MatCultureOption(culture: 'en-GB', label: 'English (UK)'),
  MatCultureOption(culture: 'de', label: 'German'),
  MatCultureOption(culture: 'de-AT', label: 'German (Austria)'),
  MatCultureOption(culture: 'fr', label: 'French'),
];

/// Builds an application which shows nothing but the culture-selector under test.
Widget _applicationWith({
  required ValueChanged<String> onCultureSelected,
  String? selectedCulture,
  String? label,
  List<MatCultureOption> cultures = _cultures,
}) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: SizedBox(
          width: 320,
          child: MatCultureSelector(
            cultures: cultures,
            selectedCulture: selectedCulture,
            label: label ?? 'Culture',
            onCultureSelected: onCultureSelected,
          ),
        ),
      ),
    ),
  );
}

/// Opens the dropdown of the culture-selector which is currently shown.
Future<void> _openDropdown(WidgetTester tester) async {
  await tester.tap(find.byType(DropdownButton<String>));
  await tester.pumpAndSettle();
}

/// The dropdown the culture-selector is built on. The state which is asserted through it (which value it shows and
/// which entries it offers) is not readable from the rendered text alone: a dropdown builds all of its entries
/// even while it is closed and only paints the chosen one.
DropdownButton<String> _dropdownOf(WidgetTester tester) {
  return tester.widget<DropdownButton<String>>(find.byType(DropdownButton<String>));
}

void main() {
  testWidgets('offers one entry per provided culture, in the given order', (WidgetTester tester) async {
    await tester.pumpWidget(_applicationWith(onCultureSelected: (_) {}));

    final List<DropdownMenuItem<String>> entries = _dropdownOf(tester).items!;
    expect(entries.map((DropdownMenuItem<String> entry) => entry.value).toList(), <String>['en-GB', 'de', 'de-AT', 'fr']);
    expect(entries.map((DropdownMenuItem<String> entry) => (entry.child as Text).data).toList(), <String>['English (UK)', 'German', 'German (Austria)', 'French']);
  });

  testWidgets('shows the label of every provided culture when the dropdown is open', (WidgetTester tester) async {
    await tester.pumpWidget(_applicationWith(onCultureSelected: (_) {}));

    await _openDropdown(tester);

    for (final MatCultureOption culture in _cultures) {
      expect(find.text(culture.label), findsWidgets, reason: 'The label "${culture.label}" is not shown.');
    }
  });

  testWidgets('shows the preselected culture', (WidgetTester tester) async {
    await tester.pumpWidget(_applicationWith(onCultureSelected: (_) {}, selectedCulture: 'de-AT'));

    expect(_dropdownOf(tester).value, 'de-AT');
  });

  testWidgets('shows no culture as chosen if the preselected culture is not offered', (WidgetTester tester) async {
    await tester.pumpWidget(_applicationWith(onCultureSelected: (_) {}, selectedCulture: 'it'));

    expect(_dropdownOf(tester).value, isNull);
  });

  testWidgets('reports the culture-identifier of the culture the user chose', (WidgetTester tester) async {
    final List<String> chosenCultures = <String>[];
    await tester.pumpWidget(_applicationWith(onCultureSelected: chosenCultures.add));

    await _openDropdown(tester);
    // The label exists twice while the dropdown is open: once in the closed control (which builds all entries and
    // only paints the chosen one) and once in the open dropdown. The last one is the one of the open dropdown.
    await tester.tap(find.text('German (Austria)').last);
    await tester.pumpAndSettle();

    expect(chosenCultures, <String>['de-AT']);
  });

  testWidgets('shows the given label', (WidgetTester tester) async {
    await tester.pumpWidget(_applicationWith(onCultureSelected: (_) {}, label: 'Sprache'));

    expect(find.text('Sprache'), findsOneWidget);
  });

  testWidgets('shows "Culture" as label if none was given', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 320,
              child: MatCultureSelector(cultures: _cultures, onCultureSelected: (_) {}),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Culture'), findsOneWidget);
  });
}
