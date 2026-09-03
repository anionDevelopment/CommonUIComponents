import 'package:flutter/material.dart';
import 'package:mat_culture_selector/mat_culture_selector.dart';

void main() {
  runApp(const ExampleApplication());
}

/// The application which is used to look at the culture-selector. It is not part of the published package.
class ExampleApplication extends StatelessWidget {
  /// Creates the example-application.
  const ExampleApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mat_culture_selector',
      theme: ThemeData(colorSchemeSeed: Colors.blue),
      home: const ExamplePage(),
    );
  }
}

/// The page which shows the culture-selector and the culture the user chose.
class ExamplePage extends StatefulWidget {
  /// Creates the page of the example-application.
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  /// The cultures this example offers. Which cultures an application offers - and which text it shows for each of
  /// them - is entirely its own decision; these four are only an example.
  static const List<MatCultureOption> _cultures = <MatCultureOption>[
    MatCultureOption(culture: 'en-GB', label: 'English (UK)'),
    MatCultureOption(culture: 'de', label: 'German'),
    MatCultureOption(culture: 'de-AT', label: 'German (Austria)'),
    MatCultureOption(culture: 'fr', label: 'French'),
  ];

  String? _chosenCulture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Culture', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            const Text('Choose one of the cultures which the application offers.'),
            const SizedBox(height: 16),
            SizedBox(
              width: 320,
              child: MatCultureSelector(
                cultures: _cultures,
                selectedCulture: _chosenCulture,
                onCultureSelected: _onCultureSelected,
              ),
            ),
            if (_chosenCulture != null) ...<Widget>[
              const SizedBox(height: 16),
              Text('Chosen culture: $_chosenCulture'),
            ],
          ],
        ),
      ),
    );
  }

  void _onCultureSelected(String culture) {
    // An application would apply the chosen culture here, for example by switching its own locale. This example
    // only shows which culture was chosen.
    setState(() {
      _chosenCulture = culture;
    });
  }
}
