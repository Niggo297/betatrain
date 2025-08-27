import 'package:flutter/foundation.dart';
import '../models/workout.dart';
import '../models/workout_exercise.dart';
import '../services/local_service.dart';

class WorkoutProvider with ChangeNotifier {
  final LocalService _localService = LocalService();
  List<Workout> _workouts = [];
  Map<String, List<WorkoutExercise>> _workoutExercises = {};
  bool _isLoading = false;
  String? _error;

  List<Workout> get workouts => _workouts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<WorkoutExercise> getWorkoutExercises(String workoutId) {
    return _workoutExercises[workoutId] ?? [];
  }

  // Neue Methode: Hole Verlauf einer bestimmten Übung
  List<Map<String, dynamic>> getExerciseHistory(String exerciseId) {
    final historyData = <Map<String, dynamic>>[];

    // Iteriere durch alle Workouts chronologisch (neueste zuerst)
    final sortedWorkouts = List<Workout>.from(_workouts)
      ..sort((a, b) => b.date.compareTo(a.date)); // Sortiere nach geplantem Trainingsdatum

    for (final workout in sortedWorkouts) {
      final exercises = _workoutExercises[workout.id] ?? [];

      for (final exercise in exercises) {
        if (exercise.exerciseId == exerciseId) {
          historyData.add({'workout': workout, 'workoutExercise': exercise});
        }
      }
    }

    return historyData;
  }

  // Neue Methode: Berechne die meist genutzten Übungen mit Gesamtwiederholungen
  Map<String, Map<String, dynamic>> getMostUsedExercises() {
    final exerciseStats = <String, Map<String, dynamic>>{};

    // Iteriere durch alle Workouts um Datums-Zuordnung zu haben
    for (final workout in _workouts) {
      final exercises = _workoutExercises[workout.id] ?? [];

      for (final exercise in exercises) {
        final exerciseId = exercise.exerciseId;

        if (!exerciseStats.containsKey(exerciseId)) {
          exerciseStats[exerciseId] = {
            'count': 0,
            'totalReps': 0,
            'totalSets': 0,
            'totalTime': 0,
            'totalWeight': 0.0,
            'maxWeight': 0.0,
            'maxRepsWithWeight': 0, // Beste Wdh MIT Gewicht
            'maxRepsBodyweight': 0, // Beste Wdh ohne Gewicht
            'maxTime': 0,
            'allTotalReps': <int>[], // Für bestes Volumen (gesamt)
            'allTrainingReps': <int>[], // Für meiste Wdhl in einem Training
            'allWeightedReps': <int>[], // Nur Gewichts-Sätze
            'allBodyweightReps': <int>[], // Nur Bodyweight-Sätze
            'allTimeVolumes': <int>[], // Für bestes Zeit-Volumen (Zeit * Sätze)
            'allSingleTimes': <int>[], // Für beste Einzelzeit pro Satz
            'timeSetsPairs': <Map<String, dynamic>>[], // Zeit-Sätze Paare
            'weightRepsPairs': <Map<String, dynamic>>[], // Gewicht-Wiederholungen Paare
          };
        }

        exerciseStats[exerciseId]!['count'] = (exerciseStats[exerciseId]!['count'] as int) + 1;

        // Einfache Berechnung: Verwende totalReps
        final totalRepsForThisExercise = exercise.totalReps;
        final bestRepsForThisExercise = exercise.bestRepsPerSet;

        exerciseStats[exerciseId]!['totalReps'] =
            (exerciseStats[exerciseId]!['totalReps'] as int) + totalRepsForThisExercise;
        exerciseStats[exerciseId]!['totalSets'] =
            (exerciseStats[exerciseId]!['totalSets'] as int) + (exercise.sets ?? 1);

        // Speichere Daten für erweiterte Statistiken
        final allTotalReps = exerciseStats[exerciseId]!['allTotalReps'] as List<int>;
        allTotalReps.add(totalRepsForThisExercise);

        final allTrainingReps = exerciseStats[exerciseId]!['allTrainingReps'] as List<int>;
        allTrainingReps.add(totalRepsForThisExercise);

        // Berechne Gesamtzeit: Zeit * Sätze
        final sets = exercise.sets ?? 1;
        final durationSeconds = exercise.durationSeconds ?? 0;
        final totalTimeForThisExercise = durationSeconds * sets;

        exerciseStats[exerciseId]!['totalTime'] =
            (exerciseStats[exerciseId]!['totalTime'] as int) + totalTimeForThisExercise;

        // Zeit-Volumen für zeitbasierte Übungen
        if (durationSeconds > 0) {
          final allTimeVolumes = exerciseStats[exerciseId]!['allTimeVolumes'] as List<int>;
          allTimeVolumes.add(totalTimeForThisExercise); // Zeit * Sätze

          final allSingleTimes = exerciseStats[exerciseId]!['allSingleTimes'] as List<int>;
          allSingleTimes.add(durationSeconds); // Einzelzeit pro Satz

          // Speichere Zeit-Sätze Paar für korrekte Zuordnung
          final timeSetsPairs = exerciseStats[exerciseId]!['timeSetsPairs'] as List<Map<String, dynamic>>;
          timeSetsPairs.add({'singleTime': durationSeconds, 'sets': sets, 'totalTime': totalTimeForThisExercise});
        }

        // Gewichtsdaten verfolgen
        final weight = exercise.weight ?? 0.0;
        if (weight > 0) {
          exerciseStats[exerciseId]!['totalWeight'] = (exerciseStats[exerciseId]!['totalWeight'] as double) + weight;

          final currentMaxWeight = exerciseStats[exerciseId]!['maxWeight'] as double;
          if (weight > currentMaxWeight) {
            exerciseStats[exerciseId]!['maxWeight'] = weight;
          }

          // Speichere Gewichts-Wiederholungen getrennt
          final allWeightedReps = exerciseStats[exerciseId]!['allWeightedReps'] as List<int>;
          allWeightedReps.add(totalRepsForThisExercise);

          // Beste Wiederholungen MIT Gewicht
          final currentMaxRepsWithWeight = exerciseStats[exerciseId]!['maxRepsWithWeight'] as int;
          if (bestRepsForThisExercise > currentMaxRepsWithWeight) {
            exerciseStats[exerciseId]!['maxRepsWithWeight'] = bestRepsForThisExercise;
          }

          // Speichere Gewicht-Wiederholungen Paar für korrekte Zuordnung
          final weightRepsPairs = exerciseStats[exerciseId]!['weightRepsPairs'] as List<Map<String, dynamic>>;
          weightRepsPairs.add({
            'weight': weight,
            'reps': bestRepsForThisExercise,
            'totalReps': totalRepsForThisExercise,
          });
        } else {
          // Speichere Bodyweight-Wiederholungen getrennt
          final allBodyweightReps = exerciseStats[exerciseId]!['allBodyweightReps'] as List<int>;
          allBodyweightReps.add(totalRepsForThisExercise);

          // Beste Wiederholungen OHNE Gewicht
          final currentMaxRepsBodyweight = exerciseStats[exerciseId]!['maxRepsBodyweight'] as int;
          if (bestRepsForThisExercise > currentMaxRepsBodyweight) {
            exerciseStats[exerciseId]!['maxRepsBodyweight'] = bestRepsForThisExercise;
          }
        }

        // Maximale Zeit verfolgen (beste Einzelzeit pro Satz, nicht Gesamtzeit)
        final currentMaxTime = exerciseStats[exerciseId]!['maxTime'] as int;
        if (durationSeconds > currentMaxTime) {
          exerciseStats[exerciseId]!['maxTime'] = durationSeconds;
        }
      }
    }

    return exerciseStats;
  }

  Future<void> loadWorkouts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _workouts = await _localService.getWorkouts();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadWorkoutExercises(String workoutId) async {
    print('Loading workout exercises for workout: $workoutId');

    // Set loading state but don't clear exercises immediately
    notifyListeners();

    try {
      print('Calling getWorkoutExercises...');

      final exercises = await _localService.getWorkoutExercises(workoutId);
      print('Number of exercises found: ${exercises.length}');

      _workoutExercises[workoutId] = exercises;
      print('Successfully loaded workout exercises');

      _error = null; // Clear any previous errors
      notifyListeners();
    } catch (e) {
      print('Error loading workout exercises: $e');

      // Instead of showing error, just set empty list
      _workoutExercises[workoutId] = [];
      _error = null; // Don't show error to user for empty exercise list
      notifyListeners();
    }
  }

  Future<Workout> createWorkout({required String name, required DateTime date}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final workout = await _localService.createWorkout(name: name, date: date);
      _workouts.insert(0, workout);
      _workoutExercises[workout.id] = [];
      return workout;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateWorkout(Workout workout) async {
    try {
      await _localService.updateWorkout(workout);
      final index = _workouts.indexWhere((w) => w.id == workout.id);
      if (index != -1) {
        _workouts[index] = workout;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteWorkout(String id) async {
    try {
      await _localService.deleteWorkout(id);
      _workouts.removeWhere((w) => w.id == id);
      _workoutExercises.remove(id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> addExerciseToWorkout({
    required String workoutId,
    required String exerciseId,
    int? sets,
    int? reps,
    double? weight,
    int? durationSeconds,
    String? note,
  }) async {
    try {
      await _localService.createWorkoutExercise(
        workoutId: workoutId,
        exerciseId: exerciseId,
        sets: sets,
        reps: reps,
        weight: weight,
        durationSeconds: durationSeconds,
        note: note,
      );

      // Reload the workout exercises to get the full data
      await loadWorkoutExercises(workoutId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateWorkoutExercise(WorkoutExercise workoutExercise) async {
    try {
      await _localService.updateWorkoutExercise(workoutExercise);
      await loadWorkoutExercises(workoutExercise.workoutId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteWorkoutExercise(String id, String workoutId) async {
    print('Deleting workout exercise: $id from workout: $workoutId');
    try {
      await _localService.deleteWorkoutExercise(id);
      print('Workout exercise deleted successfully, reloading exercises...');
      await loadWorkoutExercises(workoutId);
    } catch (e) {
      print('Error deleting workout exercise: $e');
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Workout? getWorkoutById(String id) {
    try {
      return _workouts.firstWhere((w) => w.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Workout> getWorkoutsByDate(DateTime date) {
    return _workouts
        .where((w) => w.date.year == date.year && w.date.month == date.month && w.date.day == date.day)
        .toList();
  }

  void clearError() {
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  void skipLoadingExercises(String workoutId) {
    _workoutExercises[workoutId] = [];
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}
