import '../models/exercise.dart';
import '../models/workout.dart';
import '../models/workout_exercise.dart';
import 'database_helper.dart';

class LocalService {
  static final LocalService _instance = LocalService._internal();
  factory LocalService() => _instance;
  LocalService._internal();

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Exercise operations
  Future<List<Exercise>> getExercises() async {
    try {
      return await _databaseHelper.getExercises();
    } catch (e) {
      throw Exception('Failed to fetch exercises: $e');
    }
  }

  Future<List<Exercise>> searchExercises(String searchTerm) async {
    try {
      if (searchTerm.trim().isEmpty) {
        return await _databaseHelper.getExercises();
      }
      return await _databaseHelper.searchExercises(searchTerm.trim());
    } catch (e) {
      throw Exception('Failed to search exercises: $e');
    }
  }

  Future<List<Exercise>> getUserExercises() async {
    try {
      return await _databaseHelper.getUserExercises();
    } catch (e) {
      throw Exception('Failed to fetch user exercises: $e');
    }
  }

  Future<List<Exercise>> getPredefinedExercises() async {
    try {
      return await _databaseHelper.getPredefinedExercises();
    } catch (e) {
      throw Exception('Failed to fetch predefined exercises: $e');
    }
  }

  Future<Exercise> createExercise({
    required String nameEn,
    required String nameDe,
    required String descriptionEn,
    required String descriptionDe,
  }) async {
    try {
      return await _databaseHelper.createExercise(
        nameEn: nameEn,
        nameDe: nameDe,
        descriptionEn: descriptionEn,
        descriptionDe: descriptionDe,
      );
    } catch (e) {
      throw Exception('Failed to create exercise: $e');
    }
  }

  Future<void> updateExercise(Exercise exercise) async {
    try {
      await _databaseHelper.updateExercise(exercise);
    } catch (e) {
      throw Exception('Failed to update exercise: $e');
    }
  }

  Future<void> deleteExercise(String id) async {
    try {
      await _databaseHelper.deleteExercise(id);
    } catch (e) {
      throw Exception('Failed to delete exercise: $e');
    }
  }

  Future<Exercise?> getExerciseById(String id) async {
    try {
      return await _databaseHelper.getExerciseById(id);
    } catch (e) {
      throw Exception('Failed to fetch exercise: $e');
    }
  }

  Future<bool> isPredefinedExercise(String id) async {
    try {
      return await _databaseHelper.isPredefinedExercise(id);
    } catch (e) {
      return false;
    }
  }

  // Workout operations
  Future<List<Workout>> getWorkouts() async {
    try {
      return await _databaseHelper.getWorkouts();
    } catch (e) {
      throw Exception('Failed to fetch workouts: $e');
    }
  }

  Future<Workout> createWorkout({
    required String name,
    required DateTime date,
  }) async {
    try {
      return await _databaseHelper.createWorkout(name: name, date: date);
    } catch (e) {
      throw Exception('Failed to create workout: $e');
    }
  }

  Future<void> updateWorkout(Workout workout) async {
    try {
      await _databaseHelper.updateWorkout(workout);
    } catch (e) {
      throw Exception('Failed to update workout: $e');
    }
  }

  Future<void> deleteWorkout(String id) async {
    try {
      await _databaseHelper.deleteWorkout(id);
    } catch (e) {
      throw Exception('Failed to delete workout: $e');
    }
  }

  // WorkoutExercise operations
  Future<List<WorkoutExercise>> getWorkoutExercises(String workoutId) async {
    try {
      return await _databaseHelper.getWorkoutExercises(workoutId);
    } catch (e) {
      throw Exception('Failed to fetch workout exercises: $e');
    }
  }

  Future<WorkoutExercise> createWorkoutExercise({
    required String workoutId,
    required String exerciseId,
    int? sets,
    int? reps,
    double? weight,
    int? durationSeconds,
    String? note,
  }) async {
    try {
      return await _databaseHelper.createWorkoutExercise(
        workoutId: workoutId,
        exerciseId: exerciseId,
        sets: sets,
        reps: reps,
        weight: weight,
        durationSeconds: durationSeconds,
        note: note,
      );
    } catch (e) {
      throw Exception('Failed to create workout exercise: $e');
    }
  }

  Future<void> updateWorkoutExercise(WorkoutExercise workoutExercise) async {
    try {
      await _databaseHelper.updateWorkoutExercise(workoutExercise);
    } catch (e) {
      throw Exception('Failed to update workout exercise: $e');
    }
  }

  Future<void> deleteWorkoutExercise(String id) async {
    try {
      await _databaseHelper.deleteWorkoutExercise(id);
    } catch (e) {
      throw Exception('Failed to delete workout exercise: $e');
    }
  }

  // Get workout with exercises (for compatibility)
  Future<Map<String, dynamic>> getWorkoutWithExercises(String workoutId) async {
    try {
      final exercises = await _databaseHelper.getWorkoutExercises(workoutId);
      return {
        'workout': null,
        'exercises': exercises.map((e) => e.toJson()).toList(),
      };
    } catch (e) {
      throw Exception('Failed to fetch workout exercises: $e');
    }
  }
}
