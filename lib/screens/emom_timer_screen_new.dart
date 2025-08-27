import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../models/emom.dart';
import '../services/emom_audio_service.dart';

class EmomTimerScreen extends StatefulWidget {
  final Emom emom;

  const EmomTimerScreen({super.key, required this.emom});

  @override
  State<EmomTimerScreen> createState() => _EmomTimerScreenState();
}

class _EmomTimerScreenState extends State<EmomTimerScreen> with TickerProviderStateMixin {
  Timer? _timer;
  int _currentRound = 0;
  int _secondsRemaining = 0;
  bool _isRunning = false;
  bool _isPaused = false;

  // Countdown-Variablen
  bool _isCountdownActive = false;
  int _countdownValue = 5;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Audio Service
  final EmomAudioService _audioService = EmomAudioService();

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.emom.intervalSeconds;

    // Audio Service initialisieren
    _audioService.init();

    _pulseController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    // Verhindere, dass der Bildschirm ausgeht
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _audioService.dispose(); // Audio Service aufräumen
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  void _startCountdown() {
    print('🚀 Starting countdown!');

    setState(() {
      _isCountdownActive = true;
      _countdownValue = 5;
    });

    _pulseController.repeat(reverse: true);
    _audioService.playStartSound(); // Startsound für Countdown-Beginn

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      print('⏰ Countdown: $_countdownValue');

      // Verschiedene Sounds je nach Countdown-Phase
      if (_countdownValue <= 2) {
        _audioService.playUrgentSound(); // Dringend für letzte Sekunden
      } else if (_countdownValue <= 3) {
        _audioService.playWarningSound(); // Warnung
      } else {
        _audioService.playTickSound(); // Normal
      }

      if (_countdownValue > 1) {
        setState(() {
          _countdownValue--;
        });
      } else {
        print('🏁 Countdown finished, starting EMOM!');
        timer.cancel();
        _pulseController.stop();
        // GO-Sound für den Start
        _audioService.playStartSound();
        _startEmom();
      }
    });
  }

  void _startEmom() {
    setState(() {
      _isCountdownActive = false;
      _isRunning = true;
      _isPaused = false;
      _currentRound = 1;
      _secondsRemaining = widget.emom.intervalSeconds;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          _secondsRemaining--;
        });

        // Sound-Signale
        if (_secondsRemaining == widget.emom.intervalSeconds ~/ 2) {
          _playHalfwayBeep(); // Halbzeit-Signal
        } else if (_secondsRemaining <= 5 && _secondsRemaining > 0) {
          _playBeep(); // Letzte 5 Sekunden
        }

        if (_secondsRemaining <= 0) {
          _nextRound();
        }
      }
    });
  }

  void _nextRound() {
    if (_currentRound >= widget.emom.totalRounds) {
      _finishEmom();
      return;
    }

    // FINISH-SOUND für abgeschlossene Runde
    _audioService.playFinishSound();

    // Kurze Pause damit Finish-Sound hörbar ist
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _currentRound++;
        _secondsRemaining = widget.emom.intervalSeconds;
      });

      // START-SOUND für neue Runde
      _audioService.playStartSound();
    });
  }

  void _finishEmom() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });

    _playFinishBeep(); // Finish-Signal
    _showCompletionDialog();
  }

  void _pauseResume() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _stopEmom() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isPaused = false;
      _currentRound = 0;
      _secondsRemaining = widget.emom.intervalSeconds;
    });
  }

  // Sound-Funktionen mit echtem Audio-Service
  void _playBeep() {
    _audioService.playTickSound();
  }

  void _playHalfwayBeep() {
    _audioService.playHalfTimeSound();
  }

  void _playRoundEndBeep() {
    _audioService.playFinishSound();
  }

  void _playFinishBeep() {
    _audioService.playCompletionFanfare();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Color _getTimerColor() {
    if (_secondsRemaining <= 5) {
      return Colors.red;
    } else if (_secondsRemaining <= widget.emom.intervalSeconds ~/ 2) {
      return Colors.orange;
    }
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    if (_isCountdownActive) {
      return _buildCountdownScreen();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(widget.emom.name),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            if (_isRunning) {
              _showExitDialog();
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildProgressSection(),
              const SizedBox(height: 40),
              _buildTimerSection(),
              const SizedBox(height: 40),
              _buildCurrentExerciseSection(),
              const Spacer(),
              _buildControlButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountdownScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'BEREIT?',
              style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange,
                      boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.5), blurRadius: 20, spreadRadius: 5)],
                    ),
                    child: Center(
                      child: Text(
                        _countdownValue.toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 80, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            Text(
              widget.emom.name,
              style: TextStyle(color: Colors.grey[400], fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
    final progress = _currentRound / widget.emom.totalRounds;

    return Column(
      children: [
        Text(
          'Runde $_currentRound von ${widget.emom.totalRounds}',
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 16),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[800],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
          minHeight: 8,
        ),
        const SizedBox(height: 8),
        Text('${(progress * 100).toInt()}% abgeschlossen', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
      ],
    );
  }

  Widget _buildTimerSection() {
    return Column(
      children: [
        Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _getTimerColor().withOpacity(0.1),
            border: Border.all(color: _getTimerColor(), width: 8),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _formatTime(_secondsRemaining),
                  style: TextStyle(
                    color: _getTimerColor(),
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
                Text('verbleibend', style: TextStyle(color: Colors.grey[400], fontSize: 16)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentExerciseSection() {
    final currentExercise = widget.emom.getExerciseForRound(_currentRound - 1);

    if (currentExercise == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            'AKTUELLE ÜBUNG',
            style: TextStyle(color: Colors.grey[400], fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 8),
          Text(
            currentExercise.exerciseName,
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(20)),
            child: Text(
              '${currentExercise.repetitions} Wiederholungen',
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (!_isRunning) ...[
          ElevatedButton.icon(
            onPressed: () {
              print('🎯 START button pressed!');
              _startCountdown();
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('START'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ] else ...[
          ElevatedButton.icon(
            onPressed: _pauseResume,
            icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
            label: Text(_isPaused ? 'WEITER' : 'PAUSE'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _stopEmom,
            icon: const Icon(Icons.stop),
            label: const Text('STOP'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
        ],
      ],
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('EMOM beenden?'),
        content: const Text('Möchten Sie das laufende EMOM wirklich beenden?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Weiter trainieren')),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Dialog schließen
              Navigator.pop(context); // Timer-Screen schließen
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Beenden'),
          ),
        ],
      ),
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.celebration, color: Colors.orange),
            const SizedBox(width: 8),
            const Text('EMOM abgeschlossen!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Glückwunsch! Sie haben "${widget.emom.name}" erfolgreich abgeschlossen.'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  Text('${widget.emom.totalRounds} Runden'),
                  Text('${widget.emom.totalMinutes} Minuten'),
                  Text('${widget.emom.exercises.length} Übungen'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Dialog schließen
              Navigator.pop(context); // Timer-Screen schließen
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
            child: const Text('Fertig'),
          ),
        ],
      ),
    );
  }
}
