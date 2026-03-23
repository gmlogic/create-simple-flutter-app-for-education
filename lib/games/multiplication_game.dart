// UPDATED
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../core/app_controller.dart';
import '../core/app_models.dart';
import '../widgets/difficulty_selector.dart';
import '../widgets/hero_selector.dart';

/// Επίπεδα δυσκολίας για την προπαίδεια.
enum Difficulty { easy, medium, hard }

/// Tab 1: Παιχνίδι προπαίδειας.
class MultiplicationGame extends StatefulWidget {
  const MultiplicationGame({required this.controller, super.key});

  final AppController controller;

  @override
  State<MultiplicationGame> createState() => _MultiplicationGameState();
}

class _MultiplicationGameState extends State<MultiplicationGame> {
  final Random _random = Random();
  final TextEditingController _answerController = TextEditingController();
  final FocusNode _answerFocusNode = FocusNode();
  final stt.SpeechToText _speech = stt.SpeechToText();

  Difficulty _difficulty = Difficulty.easy;
  int _a = 1;
  int _b = 1;
  int _correctAnswer = 1;
  int _tries = 0;

  String _message = 'Πες ή γράψε την απάντηση.';
  Color _messageColor = Colors.black87;

  bool _speechAvailable = false;
  bool _isListening = false;

  // ΜΗΝ αλλάξει.
  int _correctStreak = 0;

  AppHero? _bonusHero;

  int get _maxTriesForHero => widget.controller.settings.maxTriesForHero;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _generateQuestion();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusAnswerField());
  }

  Future<void> _initSpeech() async {
    _speechAvailable = await _speech.initialize();
    if (mounted) {
      setState(() {});
      _startAutoVoice();
    }
  }

  void _focusAnswerField() {
    if (!_answerFocusNode.hasFocus) {
      _answerFocusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    _answerFocusNode.dispose();
    _speech.stop();
    _speech.cancel();
    super.dispose();
  }

  void _generateQuestion() {
    if (_difficulty == Difficulty.easy) {
      _a = _random.nextInt(5) + 1;
      _b = _random.nextInt(5) + 1;
    } else if (_difficulty == Difficulty.medium) {
      _a = _random.nextInt(10) + 1;
      _b = _random.nextInt(10) + 1;
    } else {
      _a = _random.nextInt(4) + 6;
      _b = _random.nextInt(4) + 6;
    }

    _correctAnswer = _a * _b;
    _answerController.clear();
    _message = 'Πες ή γράψε την απάντηση.';
    _messageColor = Colors.black87;
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusAnswerField();
      _startAutoVoice();
    });
  }

  Future<void> _checkTypedAnswer() async {
    final text = _answerController.text.trim();
    final answer = int.tryParse(text);

    if (answer == null) {
      setState(() {
        _message = 'Βάλε έναν αριθμό πρώτα.';
        _messageColor = Colors.deepOrange;
      });
      return;
    }

    if (answer == _correctAnswer) {
      _correctStreak++;
      _tries = 0;
      await widget.controller.registerAnswer(isCorrect: true);
      setState(() {
        _message = widget.controller.parseMessage('msgBravo');
        _messageColor = Colors.green.shade700;
      });
    } else {
      _correctStreak = 0;
      _tries++;
      await widget.controller.registerAnswer(isCorrect: false);
      setState(() {
        _message = 'Δοκίμασε ξανά';
        _messageColor = Colors.red.shade700;
        if (_tries >= _maxTriesForHero) {
          _bonusHero = widget.controller.randomHero();
          _tries = 0;
          _message = widget.controller.parseMessage('msgWin', hero: _bonusHero);
        }
      });
    }
  }

  Future<void> _startAutoVoice() async {
    if (!_speechAvailable || !mounted) return;
    await _speech.stop();
    await _speech.cancel();
    setState(() => _isListening = true);
    await _speech.listen(
      localeId: 'el_GR',
      onResult: (result) async {
        final spoken = result.recognizedWords.toLowerCase().trim();
        if (spoken.contains('καθάρισε')) {
          _answerController.clear();
        } else if (spoken.contains('επόμενη')) {
          _generateQuestion();
        } else if (spoken.contains('έλεγχος')) {
          await _checkTypedAnswer();
        } else {
          final digits = spoken.replaceAll(RegExp(r'[^0-9]'), '').trim();
          if (digits.isNotEmpty) {
            _answerController.text = digits;
          }
        }

        if (result.finalResult && mounted) {
          setState(() => _isListening = false);
          _focusAnswerField();
        }
      },
    );
  }

  Widget _buildStatusCard() {
    final stats = widget.controller.activeStats;
    return Card(
      color: const Color(0xFFF1F5FF),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: [
            _StatusChip(label: widget.controller.activeChild.name, icon: Icons.child_care),
            _StatusChip(label: 'Λάθη για hero: $_tries / $_maxTriesForHero', icon: Icons.auto_awesome),
            _StatusChip(label: 'Σωστές: ${stats.correctAnswers}', icon: Icons.check_circle),
            _StatusChip(label: 'Λάθος: ${stats.wrongAnswers}', icon: Icons.close),
            _StatusChip(label: _isListening ? 'Ακούω…' : 'Voice standby', icon: Icons.record_voice_over),
          ],
        ),
      ),
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
                  _buildStatusCard(),
                  const SizedBox(height: 10),
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
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _answerController,
                    builder: (context, value, child) {
                      return TextField(
                        controller: _answerController,
                        focusNode: _answerFocusNode,
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: isTablet ? 30 : 24, fontWeight: FontWeight.w700),
                        decoration: InputDecoration(
                          hintText: '\u0393\u03c1\u03ac\u03c8\u03b5 \u03c4\u03b7\u03bd \u03b1\u03c0\u03ac\u03bd\u03c4\u03b7\u03c3\u03b7',
                          suffixIcon: value.text.isEmpty
                              ? null
                              : IconButton(
                                  tooltip: 'Clear',
                                  onPressed: () {
                                    _answerController.clear();
                                    _focusAnswerField();
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                        ),
                        onSubmitted: (_) => _checkTypedAnswer(),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: buttonHeight,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                            onPressed: _checkTypedAnswer,
                            icon: const Icon(Icons.check_circle),
                            label: const Text('Έλεγχος', style: TextStyle(fontSize: 18)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_correctStreak >= 5 || _bonusHero != null)
                    Card(
                      color: Colors.lightBlue.shade50,
                      margin: const EdgeInsets.only(top: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: HeroAvatar(hero: _bonusHero ?? widget.controller.randomHero(), size: 54),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _bonusHero == null
                                    ? 'Μπράβο! Συνέχισε έτσι ${widget.controller.activeChild.name}!'
                                    : widget.controller.parseMessage('msgWin', hero: _bonusHero),
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
                      style: FilledButton.styleFrom(backgroundColor: Colors.orange.shade600),
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

// NEW
class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFD9E2FF)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: const Color(0xFF3454D1)),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
