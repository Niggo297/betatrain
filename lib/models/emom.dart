class EmomExercise {
  final String exerciseId;
  final String exerciseName;
  final int repetitions;
  final int durationSeconds;
  final bool isTimeBased; // true = Dauer, false = Wiederholungen

  EmomExercise({
    required this.exerciseId,
    required this.exerciseName,
    this.repetitions = 0,
    this.durationSeconds = 0,
    required this.isTimeBased,
  });

  String get displayText {
    // Sichere Null-Prüfung für isTimeBased
    if (isTimeBased == true) {
      return '${durationSeconds}s';
    } else {
      return '${repetitions}x';
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'exerciseId': exerciseId,
      'exerciseName': exerciseName,
      'repetitions': repetitions,
      'durationSeconds': durationSeconds,
      'isTimeBased': isTimeBased,
    };
  }

  factory EmomExercise.fromMap(Map<String, dynamic> map) {
    // Für Rückwärtskompatibilität: wenn isTimeBased nicht existiert, ist es false
    final isTimeBased = map['isTimeBased'] is bool ? map['isTimeBased'] : false;

    return EmomExercise(
      exerciseId: map['exerciseId'] ?? '',
      exerciseName: map['exerciseName'] ?? '',
      repetitions: map['repetitions'] ?? 0,
      durationSeconds: map['durationSeconds'] ?? 0,
      isTimeBased: isTimeBased,
    );
  }
}

class Emom {
  final String id;
  final String name;
  final int totalMinutes;
  final int intervalSeconds; // 45, 60, oder 90 Sekunden
  final List<EmomExercise> exercises;
  final DateTime? createdAt;
  final bool isQuickStart; // Neu für Schnellstart

  Emom({
    required this.id,
    required this.name,
    required this.totalMinutes,
    required this.intervalSeconds,
    required this.exercises,
    this.createdAt,
    this.isQuickStart = false, // Standard: false
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'totalMinutes': totalMinutes,
      'intervalSeconds': intervalSeconds,
      'exercises': exercises.map((e) => e.toMap()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'isQuickStart': isQuickStart,
    };
  }

  factory Emom.fromMap(Map<String, dynamic> map) {
    return Emom(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      totalMinutes: map['totalMinutes'] ?? 0,
      intervalSeconds: map['intervalSeconds'] ?? 60,
      exercises:
          (map['exercises'] as List<dynamic>?)
              ?.map((e) => EmomExercise.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : null,
      isQuickStart: map['isQuickStart'] ?? false,
    );
  }

  // Berechnet die Gesamtanzahl der Runden
  int get totalRounds => (totalMinutes * 60) ~/ intervalSeconds;

  // Berechnet welche Übung in einer bestimmten Runde dran ist
  EmomExercise? getExerciseForRound(int round) {
    if (exercises.isEmpty) return null;
    return exercises[round % exercises.length];
  }
}
