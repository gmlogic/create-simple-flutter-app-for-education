// NEW
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_models.dart';

// NEW
class AppController extends ChangeNotifier {
  AppController._(this._prefs, this._data);

  static const _storageKey = 'kids_education_app_data_v1';

  final SharedPreferences _prefs;
  final Random _random = Random();
  AppData _data;

  static Future<AppController> create() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    final data = raw == null
        ? AppData.defaults()
        : AppData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    final controller = AppController._(prefs, data._normalize());
    await controller._save();
    return controller;
  }

  List<ChildProfile> get children => _data.children;
  List<AppHero> get heroes => _data.heroes;
  List<AppMessage> get messages => _data.messages;
  GameSettings get settings => _data.settings;

  ChildProfile get activeChild =>
      _data.children.firstWhere((child) => child.id == _data.activeChildId);

  ChildStats get activeStats => statsFor(activeChild.id);

  ChildStats statsFor(String childId) {
    return _data.stats.firstWhere(
      (stat) => stat.childId == childId,
      orElse: () => ChildStats.empty(childId),
    );
  }

  List<AppHero> get activeHeroes {
    final filtered = heroes.where((hero) => hero.isActive).toList();
    return filtered.isEmpty ? heroes : filtered;
  }

  Future<void> _save() async {
    await _prefs.setString(_storageKey, _data.encode());
  }

  Future<void> _update(AppData data) async {
    _data = data._normalize();
    await _save();
    notifyListeners();
  }

  String parseMessage(String key, {AppHero? hero}) {
    final template = messages.firstWhere(
      (message) => message.key == key,
      orElse: () => AppMessage(id: key, key: key, text: key),
    );
    return template.text
        .replaceAll('[Child.Name]', activeChild.name)
        .replaceAll('[Hero.Name]', hero?.name ?? 'ήρωα');
  }

  Future<void> setActiveChild(String childId) async {
    final updatedChildren = children
        .map((child) => child.copyWith(isActive: child.id == childId))
        .toList();
    await _update(AppData(
      children: updatedChildren,
      activeChildId: childId,
      stats: _data.stats,
      heroes: heroes,
      messages: messages,
      settings: settings,
    ));
  }

  Future<void> addChild({required String name, required int age}) async {
    final id = 'child-${DateTime.now().millisecondsSinceEpoch}';
    final child = ChildProfile(id: id, name: name, age: age, isActive: false);
    await _update(AppData(
      children: [...children.map((e) => e.copyWith(isActive: false)), child.copyWith(isActive: true)],
      activeChildId: id,
      stats: [..._data.stats, ChildStats.empty(id)],
      heroes: heroes,
      messages: messages,
      settings: settings,
    ));
  }

  Future<void> updateChild(ChildProfile child, {required String name, required int age}) async {
    await _update(AppData(
      children: children
          .map((item) => item.id == child.id ? item.copyWith(name: name, age: age) : item)
          .toList(),
      activeChildId: _data.activeChildId,
      stats: _data.stats,
      heroes: heroes,
      messages: messages,
      settings: settings,
    ));
  }

  Future<void> deleteChild(String childId) async {
    final remaining = children.where((child) => child.id != childId).toList();
    if (remaining.isEmpty) return;
    final nextActiveId = remaining.any((child) => child.id == _data.activeChildId)
        ? _data.activeChildId
        : remaining.first.id;
    await _update(AppData(
      children: remaining
          .map((child) => child.copyWith(isActive: child.id == nextActiveId))
          .toList(),
      activeChildId: nextActiveId,
      stats: _data.stats.where((stat) => stat.childId != childId).toList(),
      heroes: heroes,
      messages: messages,
      settings: settings,
    ));
  }

  Future<void> updateHero(AppHero hero, {String? name, bool? isActive, String? assetPath}) async {
    await _update(AppData(
      children: children,
      activeChildId: _data.activeChildId,
      stats: _data.stats,
      heroes: heroes
          .map((item) => item.id == hero.id
              ? item.copyWith(name: name, isActive: isActive, assetPath: assetPath)
              : item)
          .toList(),
      messages: messages,
      settings: settings,
    ));
  }

  Future<void> addHero({required String name, required String assetPath}) async {
    final colors = [
      [0xFF42A5F5, 0xFF7E57C2],
      [0xFFFF7043, 0xFFFFCA28],
      [0xFF26A69A, 0xFF66BB6A],
    ][_random.nextInt(3)];
    await _update(AppData(
      children: children,
      activeChildId: _data.activeChildId,
      stats: _data.stats,
      heroes: [
        ...heroes,
        AppHero(
          id: 'hero-${DateTime.now().millisecondsSinceEpoch}',
          name: name,
          assetPath: assetPath,
          isActive: true,
          startColorValue: colors[0],
          endColorValue: colors[1],
        ),
      ],
      messages: messages,
      settings: settings,
    ));
  }

  Future<void> updateMessage(AppMessage message, String text) async {
    await _update(AppData(
      children: children,
      activeChildId: _data.activeChildId,
      stats: _data.stats,
      heroes: heroes,
      messages: messages
          .map((item) => item.id == message.id ? item.copyWith(text: text) : item)
          .toList(),
      settings: settings,
    ));
  }

  Future<void> updateMaxTriesForHero(int value) async {
    await _update(AppData(
      children: children,
      activeChildId: _data.activeChildId,
      stats: _data.stats,
      heroes: heroes,
      messages: messages,
      settings: settings.copyWith(maxTriesForHero: value),
    ));
  }

  Future<void> registerAnswer({required bool isCorrect}) async {
    final stats = statsFor(activeChild.id);
    final updated = stats.copyWith(
      correctAnswers: stats.correctAnswers + (isCorrect ? 1 : 0),
      wrongAnswers: stats.wrongAnswers + (isCorrect ? 0 : 1),
      totalAttempts: stats.totalAttempts + 1,
      streak: isCorrect ? stats.streak + 1 : 0,
    );
    await _update(AppData(
      children: children,
      activeChildId: _data.activeChildId,
      stats: [
        ..._data.stats.where((item) => item.childId != activeChild.id),
        updated,
      ],
      heroes: heroes,
      messages: messages,
      settings: settings,
    ));
  }

  AppHero randomHero() {
    final source = activeHeroes;
    return source[_random.nextInt(source.length)];
  }
}

extension on AppData {
  AppData _normalize() {
    final normalizedChildren = children.isEmpty ? AppData.defaults().children : children;
    final activeId = normalizedChildren.any((child) => child.id == activeChildId)
        ? activeChildId
        : normalizedChildren.first.id;
    final normalizedStats = [
      ...stats,
      for (final child in normalizedChildren)
        if (!stats.any((item) => item.childId == child.id)) ChildStats.empty(child.id),
    ];
    final normalizedHeroes = heroes.isEmpty ? AppData.defaults().heroes : heroes;
    final normalizedMessages = messages.isEmpty ? AppData.defaults().messages : messages;
    return AppData(
      children: normalizedChildren
          .map((child) => child.copyWith(isActive: child.id == activeId))
          .toList(),
      activeChildId: activeId,
      stats: normalizedStats,
      heroes: normalizedHeroes,
      messages: normalizedMessages,
      settings: settings,
    );
  }
}
