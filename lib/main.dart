import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const EducationApp());
}

class EducationApp extends StatelessWidget {
  const EducationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math Learning App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const LearningHomePage(),
    );
  }
}

class LearningHomePage extends StatelessWidget {
  const LearningHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Math Practice for Kids'),
          bottom: const TabBar(
            tabs: <Tab>[
              Tab(text: 'Πολλαπλασιασμός'),
              Tab(text: 'Ηλικία 4+'),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            MultiplicationPracticeTab(),
            AgeFourPracticeTab(),
          ],
        ),
      ),
    );
  }
}

enum DifficultyLevel {
  easy('Εύκολο', 1, 5),
  medium('Μεσαίο', 2, 10),
  hard('Δύσκολο', 4, 12);

  const DifficultyLevel(this.label, this.min, this.max);

  final String label;
  final int min;
  final int max;
}

typedef IntPair = (int, int);

class QuestionDeck {
  QuestionDeck({required this.questions, Random? random})
      : _random = random ?? Random() {
    _reshuffle();
  }

  final List<IntPair> questions;
  final Random _random;
  late List<IntPair> _queue;
  int _index = 0;

  IntPair current() => _queue[_index];

  IntPair next() {
    _index++;
    if (_index >= _queue.length) {
      final IntPair previous = _queue.last;
      _reshuffle();
      if (_queue.length > 1 && _queue.first == previous) {
        final IntPair first = _queue.first;
        _queue[0] = _queue[1];
        _queue[1] = first;
      }
      _index = 0;
    }
    return _queue[_index];
  }

  void replaceQuestions(List<IntPair> updatedQuestions) {
    questions
      ..clear()
      ..addAll(updatedQuestions);
    _reshuffle();
    _index = 0;
  }

  void _reshuffle() {
    _queue = List<IntPair>.from(questions)..shuffle(_random);
  }
}

class MultiplicationPracticeTab extends StatefulWidget {
  const MultiplicationPracticeTab({super.key});

  @override
  State<MultiplicationPracticeTab> createState() =>
      _MultiplicationPracticeTabState();
}

class _MultiplicationPracticeTabState extends State<MultiplicationPracticeTab> {
  final TextEditingController _answerController = TextEditingController();
  late QuestionDeck _deck;

  DifficultyLevel _difficulty = DifficultyLevel.easy;
  int _score = 0;
  String _feedback = 'Διάλεξε επίπεδο και λύσε την πράξη.';
  bool _alreadyScoredCurrentQuestion = false;

  @override
  void initState() {
    super.initState();
    _deck = QuestionDeck(questions: _createQuestions(_difficulty));
  }

  List<IntPair> _createQuestions(DifficultyLevel level) {
    final List<IntPair> pairs = <IntPair>[];
    for (int left = level.min; left <= level.max; left++) {
      for (int right = level.min; right <= level.max; right++) {
        pairs.add((left, right));
      }
    }
    return pairs;
  }

  void _checkAnswer() {
    final IntPair current = _deck.current();
    final int? userAnswer = int.tryParse(_answerController.text.trim());
    final int correct = current.$1 * current.$2;

    if (userAnswer == correct) {
      setState(() {
        _feedback = 'Σωστά! ${current.$1} × ${current.$2} = $correct';
        if (!_alreadyScoredCurrentQuestion) {
          _score++;
          _alreadyScoredCurrentQuestion = true;
        }
      });
      return;
    }

    setState(() {
      _feedback = 'Λάθος. Δοκίμασε ξανά.';
    });
  }

  void _nextQuestion() {
    setState(() {
      _deck.next();
      _answerController.clear();
      _alreadyScoredCurrentQuestion = false;
      _feedback = 'Επόμενη πράξη!';
    });
  }

  void _changeDifficulty(DifficultyLevel level) {
    setState(() {
      _difficulty = level;
      _deck.replaceQuestions(_createQuestions(level));
      _answerController.clear();
      _alreadyScoredCurrentQuestion = false;
      _feedback = 'Άλλαξες επίπεδο: ${level.label}';
    });
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final IntPair current = _deck.current();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Text('Επίπεδο:'),
              const SizedBox(width: 12),
              DropdownButton<DifficultyLevel>(
                key: const Key('difficulty_dropdown'),
                value: _difficulty,
                onChanged: (DifficultyLevel? value) {
                  if (value != null) {
                    _changeDifficulty(value);
                  }
                },
                items: DifficultyLevel.values
                    .map(
                      (DifficultyLevel level) =>
                          DropdownMenuItem<DifficultyLevel>(
                        value: level,
                        child: Text(level.label),
                      ),
                    )
                    .toList(),
              ),
              const Spacer(),
              Text('Πόντοι: $_score', key: const Key('score_text')),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            '${current.$1} × ${current.$2} = ?',
            key: const Key('multiplication_question_text'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 18),
          TextField(
            key: const Key('multiplication_answer_field'),
            controller: _answerController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Απάντηση',
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            key: const Key('multiplication_check_button'),
            onPressed: _checkAnswer,
            child: const Text('Έλεγχος'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            key: const Key('multiplication_next_button'),
            onPressed: _nextQuestion,
            child: const Text('Επόμενη πράξη'),
          ),
          const SizedBox(height: 16),
          Text(
            _feedback,
            key: const Key('multiplication_feedback_text'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

class AgeFourPracticeTab extends StatefulWidget {
  const AgeFourPracticeTab({super.key});

  @override
  State<AgeFourPracticeTab> createState() => _AgeFourPracticeTabState();
}

class _AgeFourPracticeTabState extends State<AgeFourPracticeTab> {
  final List<IntPair> _ageFourQuestions = <IntPair>[
    (1, 1),
    (1, 2),
    (2, 1),
    (2, 2),
    (3, 1),
  ];

  int _questionIndex = 0;
  String _feedback = 'Μέτρα τα αστεράκια και απάντησε.';

  void _checkChoice(int selected) {
    final IntPair current = _ageFourQuestions[_questionIndex];
    final int correct = current.$1 + current.$2;

    setState(() {
      _feedback =
          selected == correct ? 'Μπράβο! Σωστό!' : 'Πολύ κοντά! Δοκίμασε ξανά.';
    });
  }

  void _next() {
    setState(() {
      _questionIndex = (_questionIndex + 1) % _ageFourQuestions.length;
      _feedback = 'Νέα ερώτηση!';
    });
  }

  @override
  Widget build(BuildContext context) {
    final IntPair current = _ageFourQuestions[_questionIndex];
    final int sum = current.$1 + current.$2;
    final List<int> choices = <int>[sum - 1, sum, sum + 1]
      ..removeWhere((int value) => value < 0);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Πόσο κάνει; ${current.$1} + ${current.$2}',
            key: const Key('age4_question_text'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 14),
          Text(
            '${'⭐' * current.$1} + ${'⭐' * current.$2}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: choices
                .map(
                  (int choice) => ElevatedButton(
                    key: Key('age4_choice_$choice'),
                    onPressed: () => _checkChoice(choice),
                    child: Text('$choice'),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            key: const Key('age4_next_button'),
            onPressed: _next,
            child: const Text('Επόμενη ερώτηση'),
          ),
          const SizedBox(height: 16),
          Text(
            _feedback,
            key: const Key('age4_feedback_text'),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
