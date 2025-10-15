import 'dart:async';
import 'package:flutter/foundation.dart';

class SessionController extends ChangeNotifier {
  Timer? _timer;
  int _totalSeconds = 0;
  int _remainingSeconds = 0;
  bool _isPaused = false;

  bool get isActive => _remainingSeconds > 0 && !_isPaused;
  bool get isPaused => _isPaused && _remainingSeconds > 0;
  int get totalSeconds => _totalSeconds;
  int get remainingSeconds => _remainingSeconds;
  double get progress => _totalSeconds == 0 ? 0 : 1 - (_remainingSeconds / _totalSeconds);

  void startMinutes(int minutes) {
    startSeconds(minutes * 60);
  }

  void startSeconds(int seconds) {
    _totalSeconds = seconds;
    _remainingSeconds = seconds;
    _isPaused = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
    notifyListeners();
  }

  void _onTick(Timer timer) {
    if (_isPaused) return;
    if (_remainingSeconds <= 1) {
      _remainingSeconds = 0;
      _stopInternal();
      notifyListeners();
      return;
    }
    _remainingSeconds -= 1;
    notifyListeners();
  }

  void pause() {
    if (_remainingSeconds == 0) return;
    _isPaused = true;
    notifyListeners();
  }

  void resume() {
    if (_remainingSeconds == 0) return;
    _isPaused = false;
    notifyListeners();
  }

  void reset() {
    _stopInternal();
    _totalSeconds = 0;
    _remainingSeconds = 0;
    _isPaused = false;
    notifyListeners();
  }

  void _stopInternal() {
    _timer?.cancel();
    _timer = null;
  }
}


