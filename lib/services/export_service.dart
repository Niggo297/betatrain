import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/exercise.dart';
import '../models/workout_exercise.dart';
import 'local_service.dart';

class ExportService {
  static final ExportService _instance = ExportService._internal();
  factory ExportService() => _instance;
  ExportService._internal();

  final LocalService _localService = LocalService();

  // Export all data as JSON
  Future<String> exportAllDataAsJson() async {
    try {
      final exercises = await _localService.getExercises();
      final workouts = await _localService.getWorkouts();

      // Get all workout exercises for each workout
      final Map<String, List<WorkoutExercise>> workoutExercisesMap = {};
      for (final workout in workouts) {
        final workoutExercises = await _localService.getWorkoutExercises(
          workout.id,
        );
        workoutExercisesMap[workout.id] = workoutExercises;
      }

      final exportData = {
        'export_info': {
          'app_name': 'TrainingsApp',
          'export_date': DateTime.now().toIso8601String(),
          'version': '1.0.0',
        },
        'exercises': exercises.map((e) => e.toJson()).toList(),
        'workouts': workouts.map((w) => w.toJson()).toList(),
        'workout_exercises': workoutExercisesMap.map(
          (workoutId, exercises) =>
              MapEntry(workoutId, exercises.map((e) => e.toJson()).toList()),
        ),
      };

      return const JsonEncoder.withIndent('  ').convert(exportData);
    } catch (e) {
      throw Exception('Failed to export data: $e');
    }
  }

  // Export data as CSV format
  Future<String> exportWorkoutsAsCsv() async {
    try {
      final workouts = await _localService.getWorkouts();
      final exercises = await _localService.getExercises();

      // Create exercise lookup map
      final exerciseMap = <String, Exercise>{};
      for (final exercise in exercises) {
        exerciseMap[exercise.id] = exercise;
      }

      final csvLines = <String>[];

      // Header
      csvLines.add(
        'Workout Name,Workout Date,Exercise Name (DE),Exercise Name (EN),Sets,Reps,Weight (kg),Duration (seconds),Note',
      );

      for (final workout in workouts) {
        final workoutExercises = await _localService.getWorkoutExercises(
          workout.id,
        );

        for (final workoutExercise in workoutExercises) {
          final exercise = exerciseMap[workoutExercise.exerciseId];

          final line = [
            _escapeCsvField(workout.name),
            workout.date.toIso8601String().split('T')[0], // Date only
            _escapeCsvField(exercise?.nameDe ?? 'Unknown'),
            _escapeCsvField(exercise?.nameEn ?? 'Unknown'),
            workoutExercise.sets?.toString() ?? '',
            workoutExercise.reps?.toString() ?? '',
            workoutExercise.weight?.toString() ?? '',
            workoutExercise.durationSeconds?.toString() ?? '',
            _escapeCsvField(workoutExercise.note ?? ''),
          ].join(',');

          csvLines.add(line);
        }
      }

      return csvLines.join('\n');
    } catch (e) {
      throw Exception('Failed to export CSV: $e');
    }
  }

  String _escapeCsvField(String field) {
    if (field.contains(',') || field.contains('"') || field.contains('\n')) {
      return '"${field.replaceAll('"', '""')}"';
    }
    return field;
  }

  // Save and share JSON export
  Future<void> shareJsonExport() async {
    try {
      final jsonData = await exportAllDataAsJson();
      final directory = await getTemporaryDirectory();
      final file = File(
        '${directory.path}/trainingsapp_export_${_getDateString()}.json',
      );

      await file.writeAsString(jsonData);

      await Share.shareXFiles([XFile(file.path)]);
    } catch (e) {
      throw Exception('Failed to share JSON export: $e');
    }
  }

  // Save and share CSV export
  Future<void> shareCsvExport() async {
    try {
      final csvData = await exportWorkoutsAsCsv();
      final directory = await getTemporaryDirectory();
      final file = File(
        '${directory.path}/trainingsapp_workouts_${_getDateString()}.csv',
      );

      await file.writeAsString(csvData);

      await Share.shareXFiles([XFile(file.path)]);
    } catch (e) {
      throw Exception('Failed to share CSV export: $e');
    }
  }

  // Get statistics for export summary
  Future<Map<String, dynamic>> getExportSummary() async {
    try {
      final exercises = await _localService.getExercises();
      final userExercises = await _localService.getUserExercises();
      final workouts = await _localService.getWorkouts();

      int totalWorkoutExercises = 0;
      for (final workout in workouts) {
        final workoutExercises = await _localService.getWorkoutExercises(
          workout.id,
        );
        totalWorkoutExercises += workoutExercises.length;
      }

      return {
        'total_exercises': exercises.length,
        'user_exercises': userExercises.length,
        'predefined_exercises': exercises.length - userExercises.length,
        'total_workouts': workouts.length,
        'total_workout_exercises': totalWorkoutExercises,
        'export_date': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      throw Exception('Failed to get export summary: $e');
    }
  }

  String _getDateString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  // Import data from JSON (for future use)
  Future<void> importFromJson(String jsonData) async {
    try {
      // This would need more sophisticated logic for importing
      // including handling conflicts, user confirmation, etc.
      throw UnimplementedError(
        'Import functionality will be implemented in a future version',
      );
    } catch (e) {
      throw Exception('Failed to import data: $e');
    }
  }
}
