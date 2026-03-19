// UPDATED
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:create_simple_flutter_app_for_education/app.dart';

void main() {
  testWidgets('App boots', (WidgetTester tester) async {
    await tester.pumpWidget(const KidsEducationApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
