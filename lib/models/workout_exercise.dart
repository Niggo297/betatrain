class WorkoutExercise {
  final String id;
  final String workoutId;
  final String exerciseId;
  final String? userId;
  final int? sets;
  final int? reps;
  final double? weight;
  final int? durationSeconds;
  final String? note;

  WorkoutExercise({
    required this.id,
    required this.workoutId,
    required this.exerciseId,
    this.userId,
    this.sets,
    this.reps,
    this.weight,
    this.durationSeconds,
    this.note,
  });

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) {
    return WorkoutExercise(
      id: json['id'],
      workoutId: json['workout_id'],
      exerciseId: json['exercise_id'],
      userId: json['user_id'],
      sets: json['sets'],
      reps: json['reps'],
      weight: json['weight']?.toDouble(),
      durationSeconds: json['duration_seconds'],
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workout_id': workoutId,
      'exercise_id': exerciseId,
      'user_id': userId,
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'duration_seconds': durationSeconds,
      'note': note,
    };
  }

  WorkoutExercise copyWith({
    String? id,
    String? workoutId,
    String? exerciseId,
    String? userId,
    int? sets,
    int? reps,
    double? weight,
    int? durationSeconds,
    String? note,
  }) {
    return WorkoutExercise(
      id: id ?? this.id,
      workoutId: workoutId ?? this.workoutId,
      exerciseId: exerciseId ?? this.exerciseId,
      userId: userId ?? this.userId,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      note: note ?? this.note,
    );
  }

  bool get hasReps => reps != null && reps! > 0;
  bool get hasDuration => durationSeconds != null && durationSeconds! > 0;
  bool get hasWeight => weight != null && weight! > 0;
  bool get hasSets => sets != null && sets! > 0;

  // Berechnet die Gesamtwiederholungen basierend auf reps * sets oder variable Reps aus Notiz
  int get totalReps {
    // Prüfe zuerst, ob variable Wiederholungen in der Notiz gespeichert sind
    if (note != null && note!.contains('Wiederholungen:')) {
      try {
        final lines = note!.split('\n');
        final repsLine = lines.firstWhere((line) => line.startsWith('Wiederholungen:'), orElse: () => '');

        if (repsLine.isNotEmpty) {
          final repsText = repsLine.substring('Wiederholungen:'.length).trim();
          final repsList = repsText.split(',');

          int totalVariableReps = 0;
          for (final repsStr in repsList) {
            final cleanReps = repsStr.trim();
            if (cleanReps.isNotEmpty) {
              final repsValue = int.tryParse(cleanReps);
              if (repsValue != null) {
                totalVariableReps += repsValue;
              }
            }
          }

          if (totalVariableReps > 0) {
            return totalVariableReps;
          }
        }
      } catch (e) {
        // Fallback zu Standard-Berechnung bei Parsing-Fehlern
      }
    }

    // Standard-Berechnung: reps * sets
    final currentReps = reps ?? 0;

    // NEUE LOGIK: Wenn Gewicht vorhanden aber keine Wiederholungen, dann 1 pro Satz annehmen
    if (currentReps == 0 && (weight != null && weight! > 0)) {
      return 1 * (sets ?? 1);
    }

    return currentReps * (sets ?? 1);
  }

  // Gibt die besten Wiederholungen pro Satz zurück (für Statistiken)
  int get bestRepsPerSet {
    // Prüfe zuerst, ob variable Wiederholungen in der Notiz gespeichert sind
    if (note != null && note!.contains('Wiederholungen:')) {
      try {
        final lines = note!.split('\n');
        final repsLine = lines.firstWhere((line) => line.startsWith('Wiederholungen:'), orElse: () => '');

        if (repsLine.isNotEmpty) {
          final repsText = repsLine.substring('Wiederholungen:'.length).trim();
          final repsList = repsText.split(',');

          int maxReps = 0;
          for (final repsStr in repsList) {
            final cleanReps = repsStr.trim();
            if (cleanReps.isNotEmpty) {
              final repsValue = int.tryParse(cleanReps);
              if (repsValue != null && repsValue > maxReps) {
                maxReps = repsValue;
              }
            }
          }

          if (maxReps > 0) {
            return maxReps;
          }
        }
      } catch (e) {
        // Fallback zu Standard-Berechnung bei Parsing-Fehlern
      }
    }

    // Standard-Berechnung: reps pro Satz (nicht multipliziert mit sets)
    final currentReps = reps ?? 0;

    // NEUE LOGIK: Wenn Gewicht vorhanden aber keine Wiederholungen, dann 1 annehmen
    if (currentReps == 0 && (weight != null && weight! > 0)) {
      return 1;
    }

    return currentReps;
  }

  String getDisplayText(String languageCode) {
    List<String> parts = [];

    if (hasSets) {
      parts.add('$sets ${languageCode == 'de' ? 'Sätze' : 'sets'}');
    }

    // Prüfe zuerst, ob variable Wiederholungen in der Notiz gespeichert sind
    bool hasVariableReps = false;
    if (note != null && note!.contains('Wiederholungen:')) {
      try {
        final lines = note!.split('\n');
        final repsLine = lines.firstWhere((line) => line.startsWith('Wiederholungen:'), orElse: () => '');

        if (repsLine.isNotEmpty) {
          final repsText = repsLine.substring('Wiederholungen:'.length).trim();
          parts.add('$repsText ${languageCode == 'de' ? 'Wdh.' : 'reps'}');
          hasVariableReps = true;
        }
      } catch (e) {
        // Fallback zu Standard-Anzeige bei Parsing-Fehlern
      }
    }

    // Nur normale Wiederholungen anzeigen, wenn keine variablen vorhanden sind
    if (!hasVariableReps && hasReps) {
      parts.add('$reps ${languageCode == 'de' ? 'Wiederholungen' : 'reps'}');
    }

    if (hasDuration) {
      final minutes = durationSeconds! ~/ 60;
      final seconds = durationSeconds! % 60;
      if (minutes > 0) {
        parts.add('$minutes:${seconds.toString().padLeft(2, '0')} ${languageCode == 'de' ? 'Min' : 'min'}');
      } else {
        parts.add('${seconds}s');
      }
    }

    if (hasWeight) {
      parts.add('${weight}kg'); // TODO: This will be updated via the UI layer
    }

    return parts.join(' • ');
  }
}
