import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:create_simple_flutter_app_for_education/app.dart';

void main() {
  testWidgets('App loads with both tabs', (WidgetTester tester) async {
    // Κάνουμε render το root widget όπως θα ξεκινούσε η εφαρμογή.
    await tester.pumpWidget(const KidsEducationApp());

    // Βεβαιωνόμαστε ότι εμφανίζονται και τα 2 tabs.
    expect(find.text('Προπαίδεια'), findsOneWidget);
    expect(find.text('4 ετών'), findsOneWidget);

    // Ελέγχουμε ότι υπάρχει TabBar στη δομή του UI.
    expect(find.byType(TabBar), findsOneWidget);
  });
}
