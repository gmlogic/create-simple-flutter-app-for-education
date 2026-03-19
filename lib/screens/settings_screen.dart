// NEW
import 'package:flutter/material.dart';

import '../core/app_controller.dart';
import '../core/app_models.dart';
import '../widgets/hero_selector.dart';

// NEW
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({required this.controller, super.key});

  final AppController controller;

  Future<void> _showChildDialog(BuildContext context, {ChildProfile? child}) async {
    final nameController = TextEditingController(text: child?.name ?? 'Φίλε μου');
    final ageController = TextEditingController(text: '${child?.age ?? 4}');
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(child == null ? 'Νέο παιδί' : 'Επεξεργασία παιδιού'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Όνομα')),
            const SizedBox(height: 12),
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Ηλικία'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Άκυρο')),
          FilledButton(
            onPressed: () async {
              final age = int.tryParse(ageController.text.trim()) ?? 4;
              if (child == null) {
                await controller.addChild(name: nameController.text.trim().isEmpty ? 'Φίλε μου' : nameController.text.trim(), age: age);
              } else {
                await controller.updateChild(child, name: nameController.text.trim().isEmpty ? 'Φίλε μου' : nameController.text.trim(), age: age);
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Αποθήκευση'),
          ),
        ],
      ),
    );
  }

  Future<void> _showHeroDialog(BuildContext context, {AppHero? hero}) async {
    final nameController = TextEditingController(text: hero?.name ?? 'Νέος Hero');
    final assetController = TextEditingController(text: hero?.assetPath ?? 'assets/heroes/spidey.png');
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(hero == null ? 'Νέος hero' : 'Επεξεργασία hero'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Όνομα')),
            const SizedBox(height: 12),
            TextField(controller: assetController, decoration: const InputDecoration(labelText: 'Asset path')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Άκυρο')),
          FilledButton(
            onPressed: () async {
              if (hero == null) {
                await controller.addHero(
                  name: nameController.text.trim().isEmpty ? 'Hero' : nameController.text.trim(),
                  assetPath: assetController.text.trim().isEmpty ? 'assets/heroes/spidey.png' : assetController.text.trim(),
                );
              } else {
                await controller.updateHero(
                  hero,
                  name: nameController.text.trim(),
                  assetPath: assetController.text.trim(),
                );
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Αποθήκευση'),
          ),
        ],
      ),
    );
  }

  Future<void> _showMessageDialog(BuildContext context, AppMessage message) async {
    final textController = TextEditingController(text: message.text);
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Μήνυμα ${message.key}'),
        content: TextField(
          controller: textController,
          minLines: 2,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'Template',
            helperText: 'Υποστηρίζονται [Child.Name] και [Hero.Name]',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Άκυρο')),
          FilledButton(
            onPressed: () async {
              await controller.updateMessage(message, textController.text.trim());
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Αποθήκευση'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Childs'),
              Tab(text: 'Heroes'),
              Tab(text: 'Messages'),
              Tab(text: 'Game Settings'),
            ],
          ),
        ),
        body: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            return TabBarView(
              children: [
                ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Card(
                      child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.child_care)),
                        title: Text('Ενεργό παιδί: ${controller.activeChild.name}'),
                        subtitle: Text('Ηλικία ${controller.activeChild.age} • Προσπάθειες ${controller.activeStats.totalAttempts}'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...controller.children.map(
                      (child) => Card(
                        child: ListTile(
                          leading: Icon(child.isActive ? Icons.check_circle : Icons.circle_outlined, color: child.isActive ? Colors.green : Colors.grey),
                          title: Text(child.name),
                          subtitle: Text('Ηλικία ${child.age}'),
                          onTap: () => controller.setActiveChild(child.id),
                          trailing: Wrap(
                            spacing: 8,
                            children: [
                              IconButton(onPressed: () => _showChildDialog(context, child: child), icon: const Icon(Icons.edit_outlined)),
                              if (controller.children.length > 1)
                                IconButton(onPressed: () => controller.deleteChild(child.id), icon: const Icon(Icons.delete_outline)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: () => _showChildDialog(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Προσθήκη παιδιού'),
                    ),
                  ],
                ),
                ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    HeroSelector(
                      title: 'Ενεργοί heroes για bonus',
                      options: controller.heroes,
                      selectedIds: controller.activeHeroes.map((e) => e.id).toSet(),
                      onToggle: (heroId) {
                        final hero = controller.heroes.firstWhere((item) => item.id == heroId);
                        controller.updateHero(hero, isActive: !hero.isActive);
                      },
                    ),
                    const SizedBox(height: 12),
                    ...controller.heroes.map(
                      (hero) => Card(
                        child: ListTile(
                          leading: HeroAvatar(hero: hero),
                          title: Text(hero.name),
                          subtitle: Text(hero.assetPath),
                          trailing: IconButton(
                            onPressed: () => _showHeroDialog(context, hero: hero),
                            icon: const Icon(Icons.edit_outlined),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: () => _showHeroDialog(context),
                      icon: const Icon(Icons.add_photo_alternate_outlined),
                      label: const Text('Προσθήκη hero'),
                    ),
                  ],
                ),
                ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Card(
                      color: Colors.indigo.shade50,
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Variables: [Child.Name], [Hero.Name]'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...controller.messages.map(
                      (message) => Card(
                        child: ListTile(
                          title: Text(message.key),
                          subtitle: Text(message.text),
                          trailing: IconButton(
                            onPressed: () => _showMessageDialog(context, message),
                            icon: const Icon(Icons.edit_note),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Max tries για hero: ${controller.settings.maxTriesForHero}', style: const TextStyle(fontWeight: FontWeight.w700)),
                            Slider(
                              value: controller.settings.maxTriesForHero.toDouble(),
                              min: 1,
                              max: 10,
                              divisions: 9,
                              label: '${controller.settings.maxTriesForHero}',
                              onChanged: (value) => controller.updateMaxTriesForHero(value.round()),
                            ),
                            const Text('Όταν οι λάθος προσπάθειες φτάσουν αυτό το όριο, εμφανίζεται random hero και το counter μηδενίζεται.'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
