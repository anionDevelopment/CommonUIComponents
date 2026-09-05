import 'package:flutter/material.dart';
import 'package:mat_country_selector/mat_country_selector.dart';

void main() {
  runApp(const ExampleApplication());
}

/// The application which is used to look at the country-selector. It is not part of the published package.
class ExampleApplication extends StatelessWidget {
  /// Creates the example-application.
  const ExampleApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mat_country_selector',
      theme: ThemeData(colorSchemeSeed: Colors.blue),
      home: const ExamplePage(),
    );
  }
}

/// The page which shows the country-selector and the country the user chose.
class ExamplePage extends StatefulWidget {
  /// Creates the page of the example-application.
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  /// The country the user chose, as its code - which is the whole result the widget reports.
  String? _chosenCountry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('mat_country_selector')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: 320,
                // No list is passed, so the widget offers every country there is - which is what most applications
                // want from it.
                child: MatCountrySelector(selectedCountry: _chosenCountry, onCountrySelected: _onCountrySelected),
              ),
              const SizedBox(height: 24),
              Text(_chosenCountry == null ? 'No country chosen yet.' : 'Chosen country: $_chosenCountry'),
            ],
          ),
        ),
      ),
    );
  }

  void _onCountrySelected(String country) {
    setState(() {
      _chosenCountry = country;
    });
    // for example: store it as the country of the user
  }
}
