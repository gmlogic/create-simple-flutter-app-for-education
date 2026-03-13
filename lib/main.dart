import 'package:flutter/material.dart';

void main() {
  runApp(const EducationApp());
}

class EducationApp extends StatelessWidget {
  const EducationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multiplication Learning App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MultiplicationHomePage(),
    );
  }
}

class MultiplicationHomePage extends StatefulWidget {
  const MultiplicationHomePage({super.key});

  @override
  State<MultiplicationHomePage> createState() => _MultiplicationHomePageState();
}

class _MultiplicationHomePageState extends State<MultiplicationHomePage> {
  final TextEditingController _answerController = TextEditingController();

  final List<(int, int)> _exercises = <(int, int)>[
    (2, 3),
    (4, 5),
    (6, 7),
    (8, 9),
  ];

  int _exerciseIndex = 0;
  int _score = 0;
  String _feedback = 'Γράψε την απάντηση και πάτησε «Έλεγχος».';
  bool _answeredCorrectly = false;

  (int, int) get _currentExercise => _exercises[_exerciseIndex];

  void _checkAnswer() {
    final int? userAnswer = int.tryParse(_answerController.text.trim());
    final int correctAnswer = _currentExercise.$1 * _currentExercise.$2;

    if (userAnswer == correctAnswer) {
      setState(() {
        _feedback = 'Σωστό! Μπράβο!';
        if (!_answeredCorrectly) {
          _score++;
          _answeredCorrectly = true;
        }
      });
      return;
    }

    setState(() {
      _feedback = 'Όχι ακόμα. Δοκίμασε ξανά!';
    });
  }

  void _nextExercise() {
    setState(() {
      _exerciseIndex = (_exerciseIndex + 1) % _exercises.length;
      _answerController.clear();
      _feedback = 'Νέα άσκηση!';
      _answeredCorrectly = false;
    });
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (int left, int right) = _currentExercise;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Προπαίδεια για παιδιά'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Πόντοι: $_score',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            Text(
              '$left × $right = ?',
              key: const Key('exercise_text'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 20),
            TextField(
              key: const Key('answer_field'),
              controller: _answerController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Απάντηση',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              key: const Key('check_button'),
              onPressed: _checkAnswer,
              child: const Text('Έλεγχος'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              key: const Key('next_button'),
              onPressed: _nextExercise,
              child: const Text('Επόμενη άσκηση'),
            ),
            const SizedBox(height: 20),
            Text(
              _feedback,
              key: const Key('feedback_text'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
