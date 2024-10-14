import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

class ToiletTimerState extends ChangeNotifier {
  static const int _timerDuration = 300; // 5 minutes in seconds
  int _secondsRemaining = _timerDuration;

  Timer? _timer;
  bool _isRunning = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  int get secondsRemaining => _secondsRemaining;
  int get timerDuration => _timerDuration;
  bool get isRunning => _isRunning;

  void startTimer() {
    if (!_isRunning) {
      _isRunning = true;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
          notifyListeners();
        } else {
          _timer?.cancel();
          _playAlarm();
        }
      });
      notifyListeners();
    }
  }

  void resetTimer() {
    _timer?.cancel();
    _secondsRemaining = _timerDuration;
    _isRunning = false;
    notifyListeners();
  }

  void _playAlarm() async {
    await _audioPlayer.play(AssetSource('alarm.mp3'));
  }

  void stopAlarm() {
    _audioPlayer.stop();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}
