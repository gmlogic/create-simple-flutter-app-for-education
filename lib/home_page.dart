// UPDATED
import 'package:flutter/material.dart';

import 'build_info.dart';
import 'core/app_controller.dart';
import 'games/arithmetic_game.dart';
import 'games/multiplication_game.dart';
import 'screens/settings_screen.dart';

/// Η σελίδα που περιέχει το TabBar, τα 2 παιχνίδια και πρόσβαση στα settings.
class HomePage extends StatelessWidget {
  const HomePage({required this.controller, super.key});

  final AppController controller;

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Μαθαίνω Παίζοντας',
      applicationVersion: '1.0.0',
      applicationLegalese: 'Educational Flutter app for young children.',
      children: [
        const Text('Παιδικό design με πιο επαγγελματικό ύφος και προσωποποιημένες ρυθμίσεις.'),
        const SizedBox(height: 4),
        Text('Build datetime: ${DateTime.parse(BuildInfo.buildDate).toLocal()}'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final child = controller.activeChild;
        final stats = controller.activeStats;
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            drawer: Drawer(
              child: SafeArea(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF3F51B5),
                            Color(0xFF5C6BC0)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.auto_awesome, color: Colors.white),
                          const SizedBox(height: 10),
                          Text(
                            'Γεια σου ${child.name}!',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Σειρά σωστών: ${stats.streak} • Σύνολο προσπαθειών: ${stats.totalAttempts}',
                            style: const TextStyle(color: Color(0xFFE8ECFF)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.settings_suggest_outlined),
                        title: const Text('Settings'),
                        subtitle: const Text('Childs, Heroes, Messages, Game Settings'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SettingsScreen(controller: controller),
                            ),
                          );
                        },
                      ),
                    ),
                    const Card(
                      child: ListTile(
                        leading: Icon(Icons.mic_none_outlined),
                        title: Text('Auto voice'),
                        subtitle: Text('Ξεκινά αυτόματα σε κάθε νέα ερώτηση χωρίς mic button.'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.person_outline),
                        title: Text('Ενεργό παιδί: ${child.name}'),
                        subtitle: Text('Ηλικία ${child.age}'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.info_outline),
                        title: const Text('About'),
                        onTap: () => _showAboutDialog(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            appBar: AppBar(
              foregroundColor: Colors.white,
              title: Column(
                children: [
                  const Text('Μαθηματικά για Παιδιά'),
                  Text(
                    child.name,
                    style: const TextStyle(fontSize: 12, color: Color(0xFFE0E6FF)),
                  ),
                ],
              ),
              centerTitle: true,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF3F51B5),
                      Color(0xFF5C6BC0)
                    ],
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
                tabs: [
                  Tab(icon: Icon(Icons.grid_3x3), text: 'Προπαίδεια'),
                  Tab(icon: Icon(Icons.star), text: '4 ετών'),
                ],
              ),
            ),
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFF8FAFF),
                    Color(0xFFF1F4FB)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: TabBarView(
                children: [
                  MultiplicationGame(controller: controller),
                  ArithmeticGame(controller: controller),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
