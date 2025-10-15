import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meditation/widgets/animated_gradient_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:meditation/models/session_controller.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  final CountDownController _controller = CountDownController();
  int _minutes = 5;
  bool _isRunning = false;

  int get _secondsTotal => _minutes * 60;

  void _toggle() {
    setState(() {
      if (_isRunning) {
        _controller.pause();
        _isRunning = false;
      } else {
        _controller.resume();
        _isRunning = true;
      }
    });
  }

  void _start() {
    setState(() {
      _isRunning = true;
    });
    _controller.restart(duration: _secondsTotal);
    context.read<SessionController>().startMinutes(_minutes);
  }

  void _reset() {
    _controller.reset();
    setState(() {
      _isRunning = false;
    });
    context.read<SessionController>().reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Timer Session')),
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
                  items: const [3, 5, 10, 15]
                      .map((m) => DropdownMenuItem(value: m, child: Text('$m min')))
                      .toList(),
                  onChanged: _isRunning
                      ? null
                      : (v) => setState(() {
                            _minutes = v ?? 5;
                          }),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Center(
                child: CircularCountDownTimer(
                  duration: _secondsTotal,
                  controller: _controller,
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.width * 0.7,
                  ringColor: Colors.white,
                  fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                  strokeWidth: 12.0,
                  strokeCap: StrokeCap.round,
                  isReverse: true,
                  isReverseAnimation: true,
                  textStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  textFormat: CountdownTextFormat.MM_SS,
                  autoStart: false,
                  onComplete: () async {
                    setState(() {
                      _isRunning = false;
                    });
                    HapticFeedback.mediumImpact();
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _start,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start'),
                ),
                ElevatedButton.icon(
                  onPressed: _toggle,
                  icon: Icon(_isRunning ? Icons.pause : Icons.play_circle),
                  label: Text(_isRunning ? 'Pause' : 'Resume'),
                ),
                ElevatedButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.stop),
                  label: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
        ),
      ),
    );
  }
}


