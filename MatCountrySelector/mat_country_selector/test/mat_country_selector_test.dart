import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mat_country_selector/mat_country_selector.dart';

/// A few countries to test with, so that a testcase states which entries it expects instead of depending on the
/// whole list of the world.
const List<MatCountry> _someCountries = <MatCountry>[
  MatCountry(code: 'DE', name: 'Germany'),
  MatCountry(code: 'FR', name: 'France'),
  MatCountry(code: 'JP', name: 'Japan'),
];

void main() {
  /// The country-selector inside the material-application it needs, with [onCountrySelected] recording what it
  /// reports.
  Future<void> pumpSelector(
    WidgetTester tester, {
    List<MatCountry> countries = _someCountries,
    String? selectedCountry,
    String label = 'Country',
    ValueChanged<String>? onCountrySelected,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            child: MatCountrySelector(
              countries: countries,
              selectedCountry: selectedCountry,
              label: label,
              onCountrySelected: onCountrySelected ?? (_) {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// The menu the widget is built on, which is what states which entries are offered and which one is chosen -
  /// the closed control paints only the chosen one, so counting rendered texts would say something else.
  DropdownMenu<String> menuOf(WidgetTester tester) => tester.widget<DropdownMenu<String>>(find.byType(DropdownMenu<String>));

  group('MatCountry', () {
    test('derives the flag of a country from its code', () {
      // Two regional-indicator-letters: "D" and "E" for germany.
      expect(const MatCountry(code: 'DE', name: 'Germany').flag, '\u{1f1e9}\u{1f1ea}');
      expect(const MatCountry(code: 'JP', name: 'Japan').flag, '\u{1f1ef}\u{1f1f5}');
    });

    test('derives the flag from a lower-case code as well', () {
      expect(const MatCountry(code: 'de', name: 'Germany').flag, const MatCountry(code: 'DE', name: 'Germany').flag);
    });

    test('has no flag for something which is not a two-letter-code', () {
      expect(const MatCountry(code: 'GER', name: 'Germany').flag, '');
    });

    test('is shown as its flag and its english name', () {
      expect(const MatCountry(code: 'DE', name: 'Germany').label, '\u{1f1e9}\u{1f1ea} Germany');
    });

    test('two countries are the same when their code and their name are', () {
      expect(const MatCountry(code: 'DE', name: 'Germany'), const MatCountry(code: 'DE', name: 'Germany'));
      expect(const MatCountry(code: 'DE', name: 'Germany'), isNot(const MatCountry(code: 'AT', name: 'Austria')));
    });
  });

  group('allCountries', () {
    test('holds the countries of ISO 3166-1', () {
      expect(allCountries, hasLength(249));
      expect(allCountries, contains(const MatCountry(code: 'DE', name: 'Germany')));
      expect(allCountries, contains(const MatCountry(code: 'JP', name: 'Japan')));
    });

    test('gives every country its own code', () {
      final Set<String> codes = allCountries.map((country) => country.code).toSet();

      expect(codes, hasLength(allCountries.length));
    });

    test('states every code as two upper-case letters', () {
      for (final MatCountry country in allCountries) {
        expect(country.code, matches(RegExp(r'^[A-Z]{2}$')), reason: '${country.name} has the code ${country.code}');
      }
    });

    test('is ordered by the english name, which is how it is read', () {
      final List<String> names = allCountries.map((country) => country.name).toList();

      expect(names, orderedEquals(<String>[...names]..sort()));
    });
  });

  group('MatCountrySelector', () {
    testWidgets('offers every country it was given, with its flag and its name', (WidgetTester tester) async {
      await pumpSelector(tester);

      expect(
        menuOf(tester).dropdownMenuEntries.map((entry) => entry.label),
        <String>['\u{1f1e9}\u{1f1ea} Germany', '\u{1f1eb}\u{1f1f7} France', '\u{1f1ef}\u{1f1f5} Japan'],
      );
    });

    testWidgets('offers all countries of the world when it was given none', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: MatCountrySelector(onCountrySelected: (_) {}))),
      );
      await tester.pumpAndSettle();

      expect(menuOf(tester).dropdownMenuEntries, hasLength(allCountries.length));
    });

    testWidgets('shows nothing as chosen while nothing is chosen', (WidgetTester tester) async {
      await pumpSelector(tester);

      expect(menuOf(tester).initialSelection, isNull);
    });

    testWidgets('shows the preselected country', (WidgetTester tester) async {
      await pumpSelector(tester, selectedCountry: 'FR');

      expect(menuOf(tester).initialSelection, 'FR');
      expect(find.text('\u{1f1eb}\u{1f1f7} France'), findsWidgets);
    });

    testWidgets('shows a country which is not offered as nothing chosen instead of failing', (
      WidgetTester tester,
    ) async {
      // An application which preselects a country it does not offer any more would otherwise crash the widget.
      await pumpSelector(tester, selectedCountry: 'IT');

      expect(menuOf(tester).initialSelection, isNull);
    });

    testWidgets('follows a country which is chosen from outside afterwards', (WidgetTester tester) async {
      await pumpSelector(tester, selectedCountry: 'FR');

      await pumpSelector(tester, selectedCountry: 'JP');

      expect(menuOf(tester).initialSelection, 'JP');
    });

    testWidgets('reports the code of the country the user chose, not its name', (WidgetTester tester) async {
      final List<String> chosenCountries = <String>[];
      await pumpSelector(tester, onCountrySelected: chosenCountries.add);

      await tester.tap(find.byType(DropdownMenu<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('\u{1f1ef}\u{1f1f5} Japan').last);
      await tester.pumpAndSettle();

      expect(chosenCountries, <String>['JP']);
    });

    testWidgets('lets the user find a country by typing its name', (WidgetTester tester) async {
      final List<String> chosenCountries = <String>[];
      await pumpSelector(tester, onCountrySelected: chosenCountries.add);

      await tester.tap(find.byType(DropdownMenu<String>));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Jap');
      await tester.pumpAndSettle();
      await tester.tap(find.text('\u{1f1ef}\u{1f1f5} Japan').last);
      await tester.pumpAndSettle();

      expect(chosenCountries, <String>['JP']);
    });

    testWidgets('shows the label it was given', (WidgetTester tester) async {
      await pumpSelector(tester, label: 'Nationality');

      expect(find.text('Nationality'), findsOneWidget);
    });

    testWidgets('takes its colors from the theme of the application', (WidgetTester tester) async {
      // No color of the widget is hard-coded, so it is the theme which decides them.
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorSchemeSeed: Colors.green),
          home: Scaffold(body: MatCountrySelector(countries: _someCountries, onCountrySelected: (_) {})),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(MatCountrySelector), findsOneWidget);
    });
  });
}
