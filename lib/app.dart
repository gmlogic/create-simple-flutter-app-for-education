// UPDATED
import 'package:flutter/material.dart';

import 'core/app_controller.dart';
import 'home_page.dart';

/// Το κεντρικό widget της εφαρμογής.
class KidsEducationApp extends StatefulWidget {
  const KidsEducationApp({super.key});

  @override
  State<KidsEducationApp> createState() => _KidsEducationAppState();
}

// UPDATED
class _KidsEducationAppState extends State<KidsEducationApp> {
  late final Future<AppController> _controllerFuture = AppController.create();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppController>(
      future: _controllerFuture,
      builder: (context, snapshot) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Μαθαίνω Παίζοντας',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3454D1)),
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFFF7F9FC),
            cardTheme: CardThemeData(
              elevation: 1.5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: Colors.white,
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                foregroundColor: Colors.white,
              ),
            ),
            filledButtonTheme: FilledButtonThemeData(
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                foregroundColor: Colors.white,
              ),
            ),
          ),
          home: snapshot.hasData
              ? HomePage(controller: snapshot.data!)
              : const Scaffold(body: Center(child: CircularProgressIndicator())),
        );
      },
    );
  }
}
