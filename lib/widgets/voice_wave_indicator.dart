import 'package:flutter/material.dart';

class VoiceWaveIndicator extends StatefulWidget {
  const VoiceWaveIndicator({
    required this.active,
    this.color = const Color(0xFF3454D1),
    super.key,
  });

  final bool active;
  final Color color;

  @override
  State<VoiceWaveIndicator> createState() => _VoiceWaveIndicatorState();
}

class _VoiceWaveIndicatorState extends State<VoiceWaveIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    if (widget.active) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant VoiceWaveIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active == oldWidget.active) return;

    if (widget.active) {
      _controller.repeat(reverse: true);
    } else {
      _controller
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18,
      height: 18,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = widget.active ? _controller.value : 0.0;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _WaveBar(
                height: _lerpHeight(5, 11, (t + 0.0) % 1),
                color: widget.color,
              ),
              _WaveBar(
                height: _lerpHeight(8, 15, (t + 0.2) % 1),
                color: widget.color,
              ),
              _WaveBar(
                height: _lerpHeight(6, 12, (t + 0.4) % 1),
                color: widget.color,
              ),
              _WaveBar(
                height: _lerpHeight(9, 16, (t + 0.6) % 1),
                color: widget.color,
              ),
            ],
          );
        },
      ),
    );
  }

  double _lerpHeight(double min, double max, double t) {
    final wave = Curves.easeInOut.transform((0.5 - (t - 0.5).abs()) * 2);
    return min + ((max - min) * wave);
  }
}

class _WaveBar extends StatelessWidget {
  const _WaveBar({required this.height, required this.color});

  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: 3,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}
