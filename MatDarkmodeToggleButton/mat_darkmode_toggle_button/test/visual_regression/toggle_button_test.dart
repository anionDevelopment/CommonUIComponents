import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'visual_regression.dart';

void main() {
  testWidgets(
    'The demo-page looks like the baseline-image in the mode light',
    (WidgetTester tester) async {
      await expectDemoToLookLikeBaseline(tester, ThemeMode.light, 'toggle_button_light');
    },
    tags: visualRegressionTestTag,
  );

  testWidgets(
    'The demo-page looks like the baseline-image in the mode dark',
    (WidgetTester tester) async {
      await expectDemoToLookLikeBaseline(tester, ThemeMode.dark, 'toggle_button_dark');
    },
    tags: visualRegressionTestTag,
  );
}
