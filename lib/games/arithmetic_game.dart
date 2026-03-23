// UPDATED
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../core/app_controller.dart';
import '../core/app_models.dart';
import '../widgets/hero_selector.dart';

/// Τύπος πράξης για το tab 4 ετών.
enum OperationMode { addition, subtraction, mixed }

/// Επίπεδο δυσκολίας για μικρότερα παιδιά.
enum KidLevel { low, normal }

/// Tab 2: Αριθμητική για παιδιά ~4 ετών.
class ArithmeticGame extends StatefulWidget {
  const ArithmeticGame({required this.controller, super.key});

  final AppController controller;

  @override
  State<ArithmeticGame> createState() => _ArithmeticGameState();
}

class _ArithmeticGameState extends State<ArithmeticGame> {
  final Random _random = Random();
  final TextEditingController _answerController = TextEditingController();
  final FocusNode _answerFocusNode = FocusNode();
  final stt.SpeechToText _speech = stt.SpeechToText();

  int _left = 0;
  int _right = 0;
  String _operator = '+';
  int _correctAnswer = 0;
  int _tries = 0;

  String _message = 'Μετράω και λέω/γράφω την απάντηση!';
  Color _messageColor = Colors.black87;

  OperationMode _mode = OperationMode.mixed;
  KidLevel _level = KidLevel.low;

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
    final max = _level == KidLevel.low ? 5 : 10;
    final useAddition = switch (_mode) {
      OperationMode.addition => true,
      OperationMode.subtraction => false,
      OperationMode.mixed => _random.nextBool(),
    };

    if (useAddition) {
      _operator = '+';
      if (_level == KidLevel.low) {
        _left = _random.nextInt(4) + 1;
        _right = _random.nextInt(5 - _left) + 1;
      } else {
        _left = _random.nextInt(max + 1);
        _right = _random.nextInt(max - _left + 1);
      }
      _correctAnswer = _left + _right;
    } else {
      _operator = '−';
      _left = _random.nextInt(max + 1);
      _right = _random.nextInt(_left + 1);
      _correctAnswer = _left - _right;
    }

    _answerController.clear();
    _message = 'Μετράω και λέω/γράφω την απάντηση!';
    _messageColor = Colors.black87;
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusAnswerField();
      _startAutoVoice();
    });
  }

  Future<void> _checkTypedAnswer() async {
    final answer = int.tryParse(_answerController.text.trim());
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

  String _stars(int count) => List.generate(count, (_) => '⭐').join(' ');

  Widget _buildStatusCard() {
    final stats = widget.controller.activeStats;
    return Card(
      color: const Color(0xFFFFF6E9),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: [
            _StatusChip(label: widget.controller.activeChild.name, icon: Icons.face_3_outlined),
            _StatusChip(label: 'Λάθη για hero: $_tries / $_maxTriesForHero', icon: Icons.auto_awesome),
            _StatusChip(label: 'Σωστές: ${stats.correctAnswers}', icon: Icons.check_circle),
            _StatusChip(label: 'Λάθος: ${stats.wrongAnswers}', icon: Icons.close),
            _StatusChip(label: _isListening ? 'Ακούω…' : 'Voice standby', icon: Icons.hearing),
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
        final questionFont = isTablet ? 46.0 : 34.0;
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
                            _operator == '+' ? '${_stars(_left)} + ${_stars(_right)}' : '${_stars(_left)} − ${_stars(_right)}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: isTablet ? 26 : 20),
                          ),
                        ],
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
                  const SizedBox(height: 10),
                  if (_correctStreak >= 5 || _bonusHero != null)
                    Card(
                      color: Colors.amber.shade50,
                      margin: const EdgeInsets.only(top: 10),
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
                                    ? 'Bonus! 5 σωστές συνεχόμενες ⭐'
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
                      style: FilledButton.styleFrom(backgroundColor: Colors.purple.shade400),
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
        border: Border.all(color: const Color(0xFFFFE1B6)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: const Color(0xFFB26A00)),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
