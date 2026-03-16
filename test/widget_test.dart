import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:create_simple_flutter_app_for_education/main.dart';

void main() {
  testWidgets('shows success feedback and increases score for correct answer', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EducationApp());

    expect(find.text('2 × 3 = ?'), findsOneWidget);
    expect(find.text('Πόντοι: 0'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('answer_field')), '6');
    await tester.tap(find.byKey(const Key('check_button')));
    await tester.pump();

    expect(find.text('Σωστό! Μπράβο!'), findsOneWidget);
    expect(find.text('Πόντοι: 1'), findsOneWidget);
  });

  testWidgets('moves to next exercise when tapping next button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EducationApp());

    expect(find.text('2 × 3 = ?'), findsOneWidget);

    await tester.tap(find.byKey(const Key('next_button')));
    await tester.pump();

    expect(find.text('4 × 5 = ?'), findsOneWidget);
    expect(find.text('Νέα άσκηση!'), findsOneWidget);
  });
}
