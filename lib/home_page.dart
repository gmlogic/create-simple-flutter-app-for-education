import 'package:flutter/material.dart';

import 'games/arithmetic_game.dart';
import 'games/multiplication_game.dart';

/// Η σελίδα που περιέχει το TabBar και τα 2 παιχνίδια.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // DefaultTabController: διαχειρίζεται ποιο tab είναι ενεργό.
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          title: const Text('Μαθηματικά για Παιδιά'),
          centerTitle: true,
          // Πιο επαγγελματικό και καθαρό gradient.
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3F51B5), Color(0xFF5C6BC0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Τα 2 tabs της εφαρμογής.
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Color(0xFFE0E6FF),
            labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            tabs: [
              Tab(icon: Icon(Icons.grid_3x3), text: 'Προπαίδεια'),
              Tab(icon: Icon(Icons.star), text: '4 ετών'),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF8FAFF), Color(0xFFF1F4FB)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          // TabBarView: το περιεχόμενο που αλλάζει όταν αλλάζει tab.
          child: const TabBarView(
            children: [
              MultiplicationGame(),
              ArithmeticGame(),
            ],
          ),
        ),
      ),
    );
  }
}
