import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:meditation/widgets/animated_gradient_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:meditation/models/session_controller.dart';

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  int _minutes = 3;
  bool _playing = false;
  bool _bgSound = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
          vsync: this,
          duration: const Duration(seconds: 12), // 4 in + 4 hold + 4 out
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _controller.repeat();
          }
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _playing = !_playing;
    });
    if (_playing) {
      _controller.forward(from: 0);
      context.read<SessionController>().startMinutes(_minutes);
    } else {
      _controller.stop();
      context.read<SessionController>().reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Breathing Session')),
      body: AnimatedGradientBackground(
        child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Duration'),
                DropdownButton<int>(
                  value: _minutes,
                  items: const [3, 5, 7, 10]
                      .map(
                        (m) =>
                            DropdownMenuItem(value: m, child: Text('$m min')),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _minutes = v ?? 3),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Background sound'),
                Switch(value: _bgSound, onChanged: (v) => setState(() => _bgSound = v)),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height / 2,
                      child: Lottie.asset(
                        'assets/animations/Meditation Mindfulness Animation.json',
                        controller: _controller,
                        onLoaded: (_) {},
                        repeat: false,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, _) {
                        final t =
                            _controller.value * 12; // seconds within cycle
                        String phase;
                        if (t < 4) {
                          phase = 'Inhale';
                        } else if (t < 8) {
                          phase = 'Hold';
                        } else {
                          phase = 'Exhale';
                        }
                        return Text(
                          phase,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _toggle,
                  icon: Icon(_playing ? Icons.pause : Icons.play_arrow),
                  label: Text(_playing ? 'Pause' : 'Start'),
                ),
              ],
            ),
          ],
        ),
        ),
      ),
    );
  }
}
