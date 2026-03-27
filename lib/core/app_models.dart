// NEW
import 'dart:convert';

import 'package:flutter/material.dart';

// NEW
class ChildProfile {
  const ChildProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.isActive,
  });

  final String id;
  final String name;
  final int age;
  final bool isActive;

  ChildProfile copyWith({
    String? id,
    String? name,
    int? age,
    bool? isActive,
  }) {
    return ChildProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'isActive': isActive,
      };

  factory ChildProfile.fromJson(Map<String, dynamic> json) => ChildProfile(
        id: json['id'] as String,
        name: json['name'] as String? ?? 'Φίλε μου',
        age: json['age'] as int? ?? 4,
        isActive: json['isActive'] as bool? ?? false,
      );
}

// NEW
class ChildStats {
  const ChildStats({
    required this.childId,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.totalAttempts,
    required this.streak,
  });

  final String childId;
  final int correctAnswers;
  final int wrongAnswers;
  final int totalAttempts;
  final int streak;

  ChildStats copyWith({
    String? childId,
    int? correctAnswers,
    int? wrongAnswers,
    int? totalAttempts,
    int? streak,
  }) {
    return ChildStats(
      childId: childId ?? this.childId,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      wrongAnswers: wrongAnswers ?? this.wrongAnswers,
      totalAttempts: totalAttempts ?? this.totalAttempts,
      streak: streak ?? this.streak,
    );
  }

  Map<String, dynamic> toJson() => {
        'childId': childId,
        'correctAnswers': correctAnswers,
        'wrongAnswers': wrongAnswers,
        'totalAttempts': totalAttempts,
        'streak': streak,
      };

  factory ChildStats.fromJson(Map<String, dynamic> json) => ChildStats(
        childId: json['childId'] as String,
        correctAnswers: json['correctAnswers'] as int? ?? 0,
        wrongAnswers: json['wrongAnswers'] as int? ?? 0,
        totalAttempts: json['totalAttempts'] as int? ?? 0,
        streak: json['streak'] as int? ?? 0,
      );

  factory ChildStats.empty(String childId) => ChildStats(
        childId: childId,
        correctAnswers: 0,
        wrongAnswers: 0,
        totalAttempts: 0,
        streak: 0,
      );
}

// NEW
class AppHero {
  const AppHero({
    required this.id,
    required this.name,
    required this.assetPath,
    required this.isActive,
    required this.startColorValue,
    required this.endColorValue,
  });

  final String id;
  final String name;
  final String assetPath;
  final bool isActive;
  final int startColorValue;
  final int endColorValue;

  Color get startColor => Color(startColorValue);
  Color get endColor => Color(endColorValue);

  AppHero copyWith({
    String? id,
    String? name,
    String? assetPath,
    bool? isActive,
    int? startColorValue,
    int? endColorValue,
  }) {
    return AppHero(
      id: id ?? this.id,
      name: name ?? this.name,
      assetPath: assetPath ?? this.assetPath,
      isActive: isActive ?? this.isActive,
      startColorValue: startColorValue ?? this.startColorValue,
      endColorValue: endColorValue ?? this.endColorValue,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'assetPath': assetPath,
        'isActive': isActive,
        'startColorValue': startColorValue,
        'endColorValue': endColorValue,
      };

  factory AppHero.fromJson(Map<String, dynamic> json) => AppHero(
        id: json['id'] as String,
        name: json['name'] as String,
        assetPath: json['assetPath'] as String,
        isActive: json['isActive'] as bool? ?? true,
        startColorValue: json['startColorValue'] as int? ?? 0xFF3454D1,
        endColorValue: json['endColorValue'] as int? ?? 0xFF5C6BC0,
      );
}

// NEW
class AppMessage {
  const AppMessage({
    required this.id,
    required this.key,
    required this.text,
  });

  final String id;
  final String key;
  final String text;

  AppMessage copyWith({
    String? id,
    String? key,
    String? text,
  }) {
    return AppMessage(
      id: id ?? this.id,
      key: key ?? this.key,
      text: text ?? this.text,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'key': key,
        'text': text,
      };

  factory AppMessage.fromJson(Map<String, dynamic> json) => AppMessage(
        id: json['id'] as String,
        key: json['key'] as String,
        text: json['text'] as String,
      );
}

// NEW
class GameSettings {
  const GameSettings({required this.maxTriesForHero});

  final int maxTriesForHero;

  GameSettings copyWith({int? maxTriesForHero}) =>
      GameSettings(maxTriesForHero: maxTriesForHero ?? this.maxTriesForHero);

  Map<String, dynamic> toJson() => {'maxTriesForHero': maxTriesForHero};

  factory GameSettings.fromJson(Map<String, dynamic> json) =>
      GameSettings(maxTriesForHero: json['maxTriesForHero'] as int? ?? 3);
}

// NEW
class AppData {
  const AppData({
    required this.children,
    required this.activeChildId,
    required this.stats,
    required this.heroes,
    required this.messages,
    required this.settings,
  });

  final List<ChildProfile> children;
  final String activeChildId;
  final List<ChildStats> stats;
  final List<AppHero> heroes;
  final List<AppMessage> messages;
  final GameSettings settings;

  Map<String, dynamic> toJson() => {
        'children': children.map((e) => e.toJson()).toList(),
        'activeChildId': activeChildId,
        'stats': stats.map((e) => e.toJson()).toList(),
        'heroes': heroes.map((e) => e.toJson()).toList(),
        'messages': messages.map((e) => e.toJson()).toList(),
        'settings': settings.toJson(),
      };

  String encode() => jsonEncode(toJson());

  factory AppData.fromJson(Map<String, dynamic> json) => AppData(
        children: (json['children'] as List<dynamic>? ?? const [])
            .map((e) => ChildProfile.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        activeChildId: json['activeChildId'] as String? ?? 'child-default',
        stats: (json['stats'] as List<dynamic>? ?? const [])
            .map((e) => ChildStats.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        heroes: (json['heroes'] as List<dynamic>? ?? const [])
            .map((e) => AppHero.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        messages: (json['messages'] as List<dynamic>? ?? const [])
            .map((e) => AppMessage.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        settings: GameSettings.fromJson(
          Map<String, dynamic>.from(json['settings'] as Map? ?? const {}),
        ),
      );

  static AppData defaults() {
    const child = ChildProfile(
      id: 'child-default',
      name: 'Φίλε μου',
      age: 4,
      isActive: true,
    );

    return AppData(
      children: const [child],
      activeChildId: child.id,
      stats: [ChildStats.empty(child.id)],
      heroes: const [
        AppHero(
          id: 'spidey',
          name: 'Spidey',
          assetPath: 'assets/heroes/spidey.png',
          isActive: true,
          startColorValue: 0xFFE53935,
          endColorValue: 0xFF3949AB,
        ),
        AppHero(
          id: 'ironman',
          name: 'Iron Man',
          assetPath: 'assets/heroes/ironman.png',
          isActive: true,
          startColorValue: 0xFFB71C1C,
          endColorValue: 0xFFFFC107,
        ),
        AppHero(
          id: 'cap',
          name: 'Cap',
          assetPath: 'assets/heroes/cap.png',
          isActive: true,
          startColorValue: 0xFF0D47A1,
          endColorValue: 0xFFD32F2F,
        ),
        AppHero(
          id: 'tails',
          name: 'Tails',
          assetPath: 'assets/heroes/tails.png',
          isActive: true,
          startColorValue: 0xFFFFB300,
          endColorValue: 0xFFF57C00,
        ),
        AppHero(
          id: 'spider_tails',
          name: 'Spider Tails',
          assetPath: 'assets/heroes/spider_tails.png',
          isActive: true,
          startColorValue: 0xFFF57C00,
          endColorValue: 0xFFE53935,
        ),
      ],
      messages: const [
        AppMessage(id: 'msg-bravo', key: 'msgBravo', text: 'Μπράβο [Child.Name]'),
        AppMessage(
          id: 'msg-win',
          key: 'msgWin',
          text: 'Μπράβο [Child.Name], κέρδισες έναν [Hero.Name]',
        ),
      ],
      settings: const GameSettings(maxTriesForHero: 3),
    );
  }
}
