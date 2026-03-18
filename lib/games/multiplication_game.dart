import 'dart:math';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../widgets/difficulty_selector.dart';
import '../widgets/hero_selector.dart';

/// Επίπεδα δυσκολίας για την προπαίδεια.
enum Difficulty { easy, medium, hard }

/// Tab 1: Παιχνίδι προπαίδειας.
class MultiplicationGame extends StatefulWidget {
  const MultiplicationGame({super.key});

  @override
  State<MultiplicationGame> createState() => _MultiplicationGameState();
}

class _MultiplicationGameState extends State<MultiplicationGame> {
  // Random generator για τυχαίες ερωτήσεις.
  final Random _random = Random();

  // Controller για το TextField της απάντησης.
  final TextEditingController _answerController = TextEditingController();

  // Speech-to-text αντικείμενο για φωνητική εισαγωγή.
  final stt.SpeechToText _speech = stt.SpeechToText();

  Difficulty _difficulty = Difficulty.easy;
  int _a = 1;
  int _b = 1;
  int _correctAnswer = 1;

  // Μήνυμα feedback προς το παιδί.
  String _message = 'Πληκτρολόγησε ή μίλα για την απάντηση.';
  Color _messageColor = Colors.black87;

  bool _speechAvailable = false;
  bool _isListening = false;

  // Μετρητής συνεχόμενων σωστών απαντήσεων για bonus εμφάνιση.
  int _correctStreak = 0;

  HeroOption _bonusHero = multiplicationHeroOptions.first;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _generateQuestion();
  }

  /// Αρχικοποίηση speech-to-text.
  Future<void> _initSpeech() async {
    _speechAvailable = await _speech.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    // Πάντα κάνουμε dispose controllers/services για σωστή διαχείριση μνήμης.
    _answerController.dispose();
    _speech.stop();
    super.dispose();
  }

  /// Δημιουργεί νέα ερώτηση ανάλογα με τη δυσκολία.
  void _generateQuestion() {
    if (_difficulty == Difficulty.easy) {
      // Εύκολο: αριθμοί 1..5
      _a = _random.nextInt(5) + 1;
      _b = _random.nextInt(5) + 1;
    } else if (_difficulty == Difficulty.medium) {
      // Μεσαίο: αριθμοί 1..10
      _a = _random.nextInt(10) + 1;
      _b = _random.nextInt(10) + 1;
    } else {
      // Δύσκολο: μόνο 6..9 × 6..9 για να αποφεύγονται οι εύκολες πράξεις με 10.
      _a = _random.nextInt(4) + 6;
      _b = _random.nextInt(4) + 6;
    }

    _correctAnswer = _a * _b;
    _answerController.clear();
    _message = 'Πληκτρολόγησε ή μίλα για την απάντηση.';
    _messageColor = Colors.black87;
    setState(() {});
  }

  /// Ελέγχει την απάντηση που πληκτρολόγησε (ή έδωσε με φωνή) το παιδί.
  void _checkTypedAnswer() {
    final text = _answerController.text.trim();
    final answer = int.tryParse(text);

    setState(() {
      if (answer == null) {
        _message = 'Βάλε έναν αριθμό πρώτα.';
        _messageColor = Colors.deepOrange;
        return;
      }

      if (answer == _correctAnswer) {
        _correctStreak++;
        if (_correctStreak >= 5) {
          _bonusHero = multiplicationHeroOptions[
            _random.nextInt(multiplicationHeroOptions.length)
          ];
        }
        _message = 'Μπράβο!';
        _messageColor = Colors.green.shade700;
      } else {
        _correctStreak = 0;
        _message = 'Δοκίμασε ξανά';
        _messageColor = Colors.red.shade700;
      }
    });
  }

  /// Ξεκινά ή σταματά τη φωνητική αναγνώριση.
  Future<void> _toggleVoiceInput() async {
    if (!_speechAvailable) {
      setState(() {
        _message = 'Η φωνητική εισαγωγή δεν υποστηρίζεται στη συσκευή.';
        _messageColor = Colors.deepOrange;
      });
      return;
    }

    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
      return;
    }

    setState(() => _isListening = true);
    await _speech.listen(
      localeId: 'el_GR',
      onResult: (result) {
        // Κρατάμε μόνο ψηφία, για να πάρουμε αριθμητική απάντηση.
        final spoken = result.recognizedWords.replaceAll(RegExp(r'[^0-9]'), '').trim();
        if (spoken.isNotEmpty) {
          _answerController.text = spoken;
        }

        // Όταν τελειώσει η αναγνώριση, κάνουμε αυτόματο έλεγχο.
        if (result.finalResult && mounted) {
          setState(() => _isListening = false);
          _checkTypedAnswer();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 700;
        final questionFont = isTablet ? 48.0 : 36.0;
        final buttonHeight = isTablet ? 64.0 : 54.0;

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight - 32),
              child: Column(
                children: [

                  DifficultySelector(
                    selected: _difficulty,
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _difficulty = value);
                      _generateQuestion();
                    },
                  ),
                  if (_difficulty == Difficulty.hard)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'Δύσκολο: πράξεις μόνο 6..9 × 6..9 (π.χ. 9×6, 8×7)',
                        style: TextStyle(fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      child: Text(
                        '$_a × $_b = ?',
                        style: TextStyle(
                          fontSize: questionFont,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo.shade700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _answerController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: isTablet ? 30 : 24, fontWeight: FontWeight.w700),
                    decoration: InputDecoration(
                      hintText: 'Γράψε την απάντηση',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _checkTypedAnswer(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: buttonHeight,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: _checkTypedAnswer,
                            icon: const Icon(Icons.check_circle),
                            label: const Text('Έλεγχος', style: TextStyle(fontSize: 18)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        height: buttonHeight,
                        width: buttonHeight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isListening ? Colors.red : Colors.purple,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: _toggleVoiceInput,
                          child: Icon(_isListening ? Icons.mic_off : Icons.mic, size: 24),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_correctStreak >= 5)
                    Card(
                      color: Colors.lightBlue.shade50,
                      margin: const EdgeInsets.only(top: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: HeroAvatar(hero: _bonusHero, size: 54),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Bonus! 5 σωστές συνεχόμενες 🎉\nΕμφανίστηκε ο ${_bonusHero.name}!',
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Text(
                    _message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isTablet ? 26 : 22,
                      fontWeight: FontWeight.bold,
                      color: _messageColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: buttonHeight,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.orange.shade600,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _generateQuestion,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Επόμενη ερώτηση', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
