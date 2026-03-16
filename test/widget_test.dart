import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:create_simple_flutter_app_for_education/main.dart';

void main() {
  testWidgets(
      'multiplication tab checks correct answer and increments score once', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EducationApp());

    expect(find.text('Πολλαπλασιασμός'), findsOneWidget);
    expect(find.byKey(const Key('score_text')), findsOneWidget);

    await tester.enterText(
        find.byKey(const Key('multiplication_answer_field')), '6');
    await tester.tap(find.byKey(const Key('multiplication_check_button')));
    await tester.pump();

    expect(find.textContaining('Σωστά!'), findsOneWidget);
    expect(find.text('Πόντοι: 1'), findsOneWidget);

    await tester.tap(find.byKey(const Key('multiplication_check_button')));
    await tester.pump();
    expect(find.text('Πόντοι: 1'), findsOneWidget);
  });

  testWidgets('next question does not immediately repeat same multiplication', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EducationApp());

    final String firstQuestion = (tester.widget<Text>(
            find.byKey(const Key('multiplication_question_text'))))
        .data!;

    await tester.tap(find.byKey(const Key('multiplication_next_button')));
    await tester.pump();

    final String secondQuestion = (tester.widget<Text>(
            find.byKey(const Key('multiplication_question_text'))))
        .data!;

    expect(secondQuestion, isNot(firstQuestion));
  });

  testWidgets('age 4 tab shows addition exercise and feedback',
      (WidgetTester tester) async {
    await tester.pumpWidget(const EducationApp());

    await tester.tap(find.text('Ηλικία 4+'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('age4_question_text')), findsOneWidget);

    await tester.tap(find.byKey(const Key('age4_choice_2')));
    await tester.pump();

    expect(find.byKey(const Key('age4_feedback_text')), findsOneWidget);
  });
}
