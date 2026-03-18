import 'dart:math';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../widgets/hero_selector.dart';

/// Τύπος πράξης για το tab 4 ετών.
enum OperationMode { addition, subtraction, mixed }

/// Επίπεδο δυσκολίας για μικρότερα παιδιά.
enum KidLevel { low, normal }

/// Tab 2: Αριθμητική για παιδιά ~4 ετών.
class ArithmeticGame extends StatefulWidget {
  const ArithmeticGame({super.key});

  @override
  State<ArithmeticGame> createState() => _ArithmeticGameState();
}

class _ArithmeticGameState extends State<ArithmeticGame> {
  final Random _random = Random();
  final TextEditingController _answerController = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();

  int _left = 0;
  int _right = 0;
  String _operator = '+';
  int _correctAnswer = 0;

  String _message = 'Μετράω και γράφω/λέω την απάντηση!';
  Color _messageColor = Colors.black87;

  OperationMode _mode = OperationMode.mixed;
  KidLevel _level = KidLevel.low;

  bool _speechAvailable = false;
  bool _isListening = false;

  // Μετρητής συνεχόμενων σωστών απαντήσεων για bonus εμφάνιση.
  int _correctStreak = 0;

  HeroOption _bonusHero = arithmeticHeroOptions.first;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _generateQuestion();
  }

  /// Προετοιμάζει τη φωνητική αναγνώριση.
  Future<void> _initSpeech() async {
    _speechAvailable = await _speech.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    _speech.stop();
    super.dispose();
  }

  /// Δημιουργεί απλή πράξη + ή - με βάση mode/level.
  void _generateQuestion() {
    final max = _level == KidLevel.low ? 5 : 10;

    // Αν είναι mixed, διαλέγουμε τυχαία πρόσθεση ή αφαίρεση.
    final useAddition = switch (_mode) {
      OperationMode.addition => true,
      OperationMode.subtraction => false,
      OperationMode.mixed => _random.nextBool(),
    };

    if (useAddition) {
      _operator = '+';
      if (_level == KidLevel.low) {
        // Στο low level αποφεύγουμε το 0 στην πρόσθεση.
        _left = _random.nextInt(4) + 1; // 1..4
        _right = _random.nextInt(5 - _left) + 1; // 1..(5-left)
      } else {
        _left = _random.nextInt(max + 1);

        // Περιορίζουμε ώστε το άθροισμα να μην ξεπερνά το max.
        _right = _random.nextInt(max - _left + 1);
      }
      _correctAnswer = _left + _right;
    } else {
      _operator = '−';
      _left = _random.nextInt(max + 1);

      // Για να μην έχουμε αρνητικά αποτελέσματα, right <= left.
      _right = _random.nextInt(_left + 1);
      _correctAnswer = _left - _right;
    }

    _answerController.clear();
    _message = 'Μετράω και γράφω/λέω την απάντηση!';
    _messageColor = Colors.black87;
    setState(() {});
  }

  /// Ελέγχει αν η απάντηση είναι σωστή.
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
          _bonusHero = arithmeticHeroOptions[
            _random.nextInt(arithmeticHeroOptions.length)
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

  /// Ενεργοποιεί/απενεργοποιεί τη φωνητική απάντηση.
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
        final spoken = result.recognizedWords.replaceAll(RegExp(r'[^0-9]'), '').trim();
        if (spoken.isNotEmpty) {
          _answerController.text = spoken;
        }

        if (result.finalResult && mounted) {
          setState(() => _isListening = false);
          _checkTypedAnswer();
        }
      },
    );
  }

  /// Παράγει αστεράκια για οπτική βοήθεια (μέτρημα).
  String _stars(int count) => List.generate(count, (_) => '⭐').join(' ');

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 700;
        final questionFont = isTablet ? 46.0 : 34.0;
        final buttonHeight = isTablet ? 64.0 : 54.0;

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight - 32),
              child: Column(
                children: [

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      ChoiceChip(
                        label: const Text('Πρόσθεση'),
                        selected: _mode == OperationMode.addition,
                        onSelected: (_) {
                          setState(() => _mode = OperationMode.addition);
                          _generateQuestion();
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Αφαίρεση'),
                        selected: _mode == OperationMode.subtraction,
                        onSelected: (_) {
                          setState(() => _mode = OperationMode.subtraction);
                          _generateQuestion();
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Μικτά'),
                        selected: _mode == OperationMode.mixed,
                        onSelected: (_) {
                          setState(() => _mode = OperationMode.mixed);
                          _generateQuestion();
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Χαμηλό 1-5'),
                        selected: _level == KidLevel.low,
                        onSelected: (_) {
                          setState(() => _level = KidLevel.low);
                          _generateQuestion();
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Κανονικό 0-10'),
                        selected: _level == KidLevel.normal,
                        onSelected: (_) {
                          setState(() => _level = KidLevel.normal);
                          _generateQuestion();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      child: Column(
                        children: [
                          Text(
                            '$_left $_operator $_right = ?',
                            style: TextStyle(
                              fontSize: questionFont,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal.shade700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _operator == '+'
                                ? '${_stars(_left)} + ${_stars(_right)}'
                                : '${_stars(_left)} − ${_stars(_right)}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: isTablet ? 26 : 20),
                          ),
                        ],
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
                  const SizedBox(height: 10),
                  if (_correctStreak >= 5)
                    Card(
                      color: Colors.amber.shade50,
                      margin: const EdgeInsets.only(top: 10),
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
                                'Bonus! 5 σωστές συνεχόμενες ⭐\nΕμφανίστηκε ο ${_bonusHero.name}!',
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
                        backgroundColor: Colors.purple.shade400,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _generateQuestion,
                      icon: const Icon(Icons.skip_next),
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
