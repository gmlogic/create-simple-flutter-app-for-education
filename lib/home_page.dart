import 'package:flutter/material.dart';

import 'games/arithmetic_game.dart';
import 'games/multiplication_game.dart';

/// Η σελίδα που περιέχει το TabBar, τα 2 παιχνίδια και το drawer ρυθμίσεων.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Μαθαίνω Παίζοντας',
      applicationVersion: '1.0.0',
      applicationLegalese: 'Educational Flutter app for young children.',
      children: const [
        Text(
          'Η εφαρμογή βοηθά μικρά παιδιά να εξασκούνται σε προπαίδεια, πρόσθεση και αφαίρεση με χρωματιστό και φιλικό περιβάλλον.',
        ),
        SizedBox(height: 12),
        Text(
          'Το μικρόφωνο χρησιμοποιείται μόνο για φωνητική εισαγωγή απαντήσεων όταν το επιλέξει ο γονέας ή το παιδί.',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // DefaultTabController: διαχειρίζεται ποιο tab είναι ενεργό.
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: Drawer(
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF3F51B5), Color(0xFF5C6BC0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.settings, color: Colors.white, size: 30),
                      SizedBox(height: 10),
                      Text(
                        'Ρυθμίσεις',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Δες bonus πληροφορίες και χρήσιμες ρυθμίσεις.',
                        style: TextStyle(color: Color(0xFFE8ECFF)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(12),
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.auto_awesome,
                                      color: Color(0xFF5C6BC0)),
                                  SizedBox(width: 8),
                                  Text(
                                    'Bonus heroes',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Μετά από 5 σωστές συνεχόμενες απαντήσεις εμφανίζεται τυχαία εικόνα ήρωα από τα local assets στο assets/heroes/.',
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Κάθε νέο bonus μπορεί να εμφανίσει διαφορετικό hero για πιο διασκεδαστική εμπειρία.',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.mic, color: Color(0xFF5C6BC0)),
                                  SizedBox(width: 8),
                                  Text(
                                    'Φωνητική εισαγωγή',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Για να δουλέψει το μικρόφωνο, η συσκευή πρέπει να επιτρέψει πρόσβαση στο microphone permission.',
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Αν δεν λειτουργεί, ελέγξτε τις ρυθμίσεις εφαρμογής σε Android/iPhone/iPad/macOS και επιτρέψτε το μικρόφωνο.',
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Η φωνητική απάντηση ενεργοποιείται μόνο όταν πατηθεί το κουμπί με το μικρόφωνο μέσα στο παιχνίδι.',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        tileColor: Colors.white,
                        leading: const Icon(Icons.info_outline),
                        title: const Text('About'),
                        subtitle: const Text('Πληροφορίες για την εφαρμογή'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _showAboutDialog(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          foregroundColor: Colors.white,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          title: const Text('Μαθηματικά για Παιδιά'),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3F51B5), Color(0xFF5C6BC0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
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
          child: const TabBarView(
            children: [
              MultiplicationGame(),
              // ArithmeticGame(),R
            ],
          ),
        ),
      ),
    );
  }
}
