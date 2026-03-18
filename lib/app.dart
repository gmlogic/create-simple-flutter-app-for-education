import 'package:flutter/material.dart';

import 'home_page.dart';

/// Το κεντρικό widget της εφαρμογής.
///
/// Εδώ ορίζουμε global ρυθμίσεις όπως τίτλο, theme και αρχική σελίδα.
class KidsEducationApp extends StatelessWidget {
  const KidsEducationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Κρύβει το debug banner (πάνω δεξιά) για πιο "καθαρό" UI.
      debugShowCheckedModeBanner: false,
      title: 'Μαθαίνω Παίζοντας',
      theme: ThemeData(
        // Seed color: από αυτό το χρώμα το Material 3 παράγει χρωματική παλέτα.
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3454D1)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F9FC),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            foregroundColor: Colors.white,
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      // Η αρχική οθόνη της εφαρμογής (με τα 2 tabs).
      home: const HomePage(),
    );
  }
}
