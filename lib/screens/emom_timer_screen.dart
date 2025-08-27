import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../models/emom.dart';
import '../models/workout.dart';
import '../providers/workout_provider.dart';
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

  // Für Training-Erstellung bei regulären EMOMs
  Map<String, int> _completedExercises = {};

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

    // Initialisiere Exercise-Counter für reguläre EMOMs
    if (!widget.emom.isQuickStart) {
      for (var exercise in widget.emom.exercises) {
        _completedExercises[exercise.exerciseId] = 0;
      }
    }
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
    setState(() {
      _isCountdownActive = true;
      _countdownValue = 5;
    });

    _pulseController.repeat(reverse: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Countdown-Sound wird intensiver je näher wir zu 0 kommen
      if (_countdownValue <= 2) {
        _audioService.playUrgentSound();
      } else {
        _audioService.playTickSound();
      }

      if (_countdownValue > 1) {
        setState(() {
          _countdownValue--;
        });
      } else {
        timer.cancel();
        _pulseController.stop();
        // START-Sound für EMOM-Beginn
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

    // STARTSOUND - Deutlich erkennbar mit doppeltem Klick
    _audioService.playStartSound();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          _secondsRemaining--;
        });

        _playTimerSounds();

        if (_secondsRemaining <= 0) {
          _nextRound();
        }
      }
    });
  }

  void _playTimerSounds() {
    final halfTime = widget.emom.intervalSeconds ~/ 2;

    if (_secondsRemaining == halfTime) {
      // HALBZEIT-SOUND
      _audioService.playHalfTimeSound();
      Future.delayed(const Duration(milliseconds: 100), () {
        SystemSound.play(SystemSoundType.click);
      });
    } else if (_secondsRemaining <= 10 && _secondsRemaining > 0) {
      // COUNTDOWN AB 10 SEKUNDEN - wird immer intensiver
      if (_secondsRemaining <= 3) {
        // Letzte 3 Sekunden - sehr intensiv
        _audioService.playUrgentSound();
      } else if (_secondsRemaining <= 5) {
        // 4-5 Sekunden - intensiver
        _audioService.playWarningSound();
      } else {
        // 6-10 Sekunden - leichtere Signale
        _audioService.playTickSound();
      }
    }
  }

  void _nextRound() {
    if (_currentRound >= widget.emom.totalRounds) {
      _finishEmom();
      return;
    }

    // FINISH-SOUND für abgeschlossene Runde
    _audioService.playFinishSound();

    // Bei regulären EMOMs: Übung als abgeschlossen markieren
    if (!widget.emom.isQuickStart) {
      final currentExercise = widget.emom.getExerciseForRound(_currentRound - 1);
      if (currentExercise != null) {
        _completedExercises[currentExercise.exerciseId] =
            (_completedExercises[currentExercise.exerciseId] ?? 0) + currentExercise.repetitions;
      }
    }

    // Kurze Pause damit Finish-Sound hörbar ist
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _currentRound++;
        _secondsRemaining = widget.emom.intervalSeconds;
      });

      // START-SOUND für neue Runde (ohne Pause!)
      _audioService.playStartSound();
    });
  }

  void _finishEmom() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });

    // EMOM ABGESCHLOSSEN - Finale Fanfare
    _audioService.playCompletionFanfare();

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
              _buildExerciseListSection(),
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
                        _countdownValue > 0 ? _countdownValue.toString() : 'GO!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: _countdownValue > 0 ? 80 : 60,
                          fontWeight: FontWeight.bold,
                        ),
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

  Widget _buildExerciseListSection() {
    if (widget.emom.isQuickStart) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.green.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(Icons.flash_on, color: Colors.green, size: 48),
            const SizedBox(height: 8),
            Text(
              'SCHNELLSTART MODUS',
              style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Freies Training - Machen Sie was Sie wollen!',
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
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
            'GEPLANTE ÜBUNGEN',
            style: TextStyle(color: Colors.grey[400], fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 16),
          ...widget.emom.exercises.map((exercise) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Text(
                        '${exercise.repetitions}',
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      exercise.exerciseName,
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildControlButtons() {
    if (!_isRunning) {
      return Center(
        child: ElevatedButton.icon(
          onPressed: _startCountdown,
          icon: const Icon(Icons.play_arrow),
          label: const Text('START'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
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
                  if (!widget.emom.isQuickStart) ...[
                    Text('${widget.emom.exercises.length} Übungen'),
                    const SizedBox(height: 8),
                    ..._buildExerciseSummary(),
                  ],
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Dialog schließen
              Navigator.pop(context); // Timer-Screen schließen
            },
            child: const Text('Fertig'),
          ),
          ElevatedButton(
            onPressed: () => _showAddToTrainingDialog(context),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
            child: const Text('Zu Training hinzufügen'),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildExerciseSummary() {
    return _completedExercises.entries.map((entry) {
      final exerciseName = widget.emom.exercises.firstWhere((ex) => ex.exerciseId == entry.key).exerciseName;
      return Text('$exerciseName: ${entry.value}x gesamt', style: const TextStyle(fontSize: 12, color: Colors.grey));
    }).toList();
  }

  Future<void> _showAddToTrainingDialog(BuildContext context) async {
    final workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    final workouts = workoutProvider.workouts;

    if (workouts.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Keine Trainings verfügbar. Erstelle erst ein Training.')));
      return;
    }

    // Sortiere Trainings chronologisch (neueste zuerst)
    final sortedWorkouts = List<Workout>.from(workouts)..sort((a, b) => b.date.compareTo(a.date));

    final selectedWorkout = await showDialog<Workout>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Training auswählen'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: sortedWorkouts.length,
            itemBuilder: (context, index) {
              final workout = sortedWorkouts[index];
              final exerciseCount = workoutProvider.getWorkoutExercises(workout.id).length;
              return ListTile(
                title: Text(workout.name),
                subtitle: Text('$exerciseCount Übungen'),
                onTap: () => Navigator.of(context).pop(workout),
              );
            },
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Abbrechen'))],
      ),
    );

    if (selectedWorkout != null) {
      await _addEmomToWorkout(selectedWorkout);
    }
  }

  Future<void> _addEmomToWorkout(Workout workout) async {
    final workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);

    // Berechne die Gesamtwiederholungen für jede Übung
    final Map<String, int> totalReps = {};

    for (final entry in _completedExercises.entries) {
      final exerciseId = entry.key;
      final rounds = entry.value;

      // Finde die EMOM-Übung
      final emomExercise = widget.emom.exercises.firstWhere((ex) => ex.exerciseId == exerciseId);

      // Berechne Gesamtwiederholungen je nach Typ
      int total;
      if (emomExercise.isTimeBased == true) {
        // Bei zeitbasierten Übungen: Anzahl Runden × Dauer in Sekunden
        total = rounds * emomExercise.durationSeconds;
      } else {
        // Bei wiederholungsbasierten Übungen: Anzahl Runden × Wiederholungen
        total = rounds * emomExercise.repetitions;
      }

      totalReps[exerciseId] = total;
    }

    // Füge die berechneten Übungen zum Training hinzu
    for (final entry in totalReps.entries) {
      final exerciseId = entry.key;

      // Finde die ursprüngliche Übung und absolvierte Runden
      final emomExercise = widget.emom.exercises.firstWhere((ex) => ex.exerciseId == exerciseId);
      final completedRounds = _completedExercises[exerciseId] ?? 0;

      // Bei EMOMs ist jede Minute/Runde ein Satz
      // Wiederholungen pro Satz = ursprüngliche Wiederholungen oder Dauer
      final repsPerSet = emomExercise.isTimeBased ? null : emomExercise.repetitions;
      final durationPerSet = emomExercise.isTimeBased ? emomExercise.durationSeconds : null;

      // Füge die Übung zum Training hinzu
      await workoutProvider.addExerciseToWorkout(
        workoutId: workout.id,
        exerciseId: exerciseId,
        reps: repsPerSet,
        durationSeconds: durationPerSet,
        sets: completedRounds, // Jede Runde = ein Satz
        note: 'EMOM: ${widget.emom.name}',
      );
    }

    // Zeige Erfolgsbestätigung
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('EMOM erfolgreich zu "${workout.name}" hinzugefügt!'), backgroundColor: Colors.green),
      );

      // Schließe beide Dialoge
      Navigator.of(context).pop(); // Completion Dialog
      Navigator.of(context).pop(); // Timer Screen
    }
  }
}
