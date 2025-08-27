import 'dart:async';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/exercise.dart';
import '../models/workout.dart';
import '../models/workout_exercise.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      // Initialize sqflite for desktop platforms
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        // Initialize FFI
        sqfliteFfiInit();
        // Change the default factory
        databaseFactory = databaseFactoryFfi;
      }

      // Get the application documents directory path
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final path = join(documentsDirectory.path, 'trainingsapp.db');

      print('Initializing database at: $path');

      // Open/create the database
      final database = await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
        onOpen: (db) async {
          print('Database opened successfully');
          // Enable foreign key constraints
          await db.execute('PRAGMA foreign_keys = ON');
        },
      );

      return database;
    } catch (e) {
      print('Error initializing database: $e');

      // Fallback: try with in-memory database if file system fails
      print('Attempting fallback to in-memory database...');
      return await openDatabase(
        inMemoryDatabasePath,
        version: 1,
        onCreate: _onCreate,
      );
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create exercises table
    await db.execute('''
      CREATE TABLE exercises (
        id TEXT PRIMARY KEY,
        name_en TEXT NOT NULL,
        name_de TEXT NOT NULL,
        description_en TEXT,
        description_de TEXT,
        created_at TEXT NOT NULL,
        is_predefined INTEGER DEFAULT 0
      )
    ''');

    // Create workouts table
    await db.execute('''
      CREATE TABLE workouts (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        date TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // Create workout_exercises table
    await db.execute('''
      CREATE TABLE workout_exercises (
        id TEXT PRIMARY KEY,
        workout_id TEXT NOT NULL,
        exercise_id TEXT NOT NULL,
        sets INTEGER,
        reps INTEGER,
        weight REAL,
        duration_seconds INTEGER,
        note TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (workout_id) REFERENCES workouts (id) ON DELETE CASCADE,
        FOREIGN KEY (exercise_id) REFERENCES exercises (id) ON DELETE CASCADE
      )
    ''');

    // Insert predefined exercises
    await _insertPredefinedExercises(db);
  }

  Future<void> _insertPredefinedExercises(Database db) async {
    final predefinedExercises = [
      {'id': 'pred_pullups', 'name_en': 'Pull-ups', 'name_de': 'Klimmzüge'},
      {'id': 'pred_pushups', 'name_en': 'Push-ups', 'name_de': 'Liegestütz'},
      {
        'id': 'pred_bench_press',
        'name_en': 'Bench Press',
        'name_de': 'Bankdrücken',
      },
      {'id': 'pred_rowing', 'name_en': 'Rowing', 'name_de': 'Rudern'},
      {
        'id': 'pred_bicep_curls',
        'name_en': 'Bicep Curls',
        'name_de': 'Bizeps-Curls',
      },
      {'id': 'pred_squats', 'name_en': 'Squats', 'name_de': 'Kniebeugen'},
      {'id': 'pred_deadlifts', 'name_en': 'Deadlifts', 'name_de': 'Kreuzheben'},
      {
        'id': 'pred_shoulder_press',
        'name_en': 'Shoulder Press',
        'name_de': 'Schulterdrücken',
      },
      {
        'id': 'pred_tricep_dips',
        'name_en': 'Tricep Dips',
        'name_de': 'Trizeps-Dips',
      },
      {'id': 'pred_lunges', 'name_en': 'Lunges', 'name_de': 'Ausfallschritte'},
      {'id': 'pred_plank', 'name_en': 'Plank', 'name_de': 'Plank'},
      {'id': 'pred_burpees', 'name_en': 'Burpees', 'name_de': 'Burpees'},
    ];

    for (final exercise in predefinedExercises) {
      await db.insert('exercises', {
        'id': exercise['id'],
        'name_en': exercise['name_en'],
        'name_de': exercise['name_de'],
        'description_en': '',
        'description_de': '',
        'created_at': DateTime.now().toIso8601String(),
        'is_predefined': 1,
      });
    }
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // Exercise operations
  Future<List<Exercise>> getExercises() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('exercises');

    return List.generate(maps.length, (i) {
      return Exercise(
        id: maps[i]['id'],
        userId: 'local_user',
        nameEn: maps[i]['name_en'],
        nameDe: maps[i]['name_de'],
        descriptionEn: maps[i]['description_en'] ?? '',
        descriptionDe: maps[i]['description_de'] ?? '',
        createdAt: DateTime.parse(maps[i]['created_at']),
      );
    });
  }

  Future<List<Exercise>> searchExercises(String searchTerm) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'exercises',
      where:
          'name_en LIKE ? OR name_de LIKE ? OR description_en LIKE ? OR description_de LIKE ?',
      whereArgs: [
        '%$searchTerm%',
        '%$searchTerm%',
        '%$searchTerm%',
        '%$searchTerm%',
      ],
    );

    return List.generate(maps.length, (i) {
      return Exercise(
        id: maps[i]['id'],
        userId: 'local_user',
        nameEn: maps[i]['name_en'],
        nameDe: maps[i]['name_de'],
        descriptionEn: maps[i]['description_en'] ?? '',
        descriptionDe: maps[i]['description_de'] ?? '',
        createdAt: DateTime.parse(maps[i]['created_at']),
      );
    });
  }

  Future<Exercise?> getExerciseById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'exercises',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    return Exercise(
      id: maps[0]['id'],
      userId: 'local_user',
      nameEn: maps[0]['name_en'],
      nameDe: maps[0]['name_de'],
      descriptionEn: maps[0]['description_en'] ?? '',
      descriptionDe: maps[0]['description_de'] ?? '',
      createdAt: DateTime.parse(maps[0]['created_at']),
    );
  }

  Future<List<Exercise>> getUserExercises() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'exercises',
      where: 'is_predefined = ?',
      whereArgs: [0],
    );

    return List.generate(maps.length, (i) {
      return Exercise(
        id: maps[i]['id'],
        userId: 'local_user',
        nameEn: maps[i]['name_en'],
        nameDe: maps[i]['name_de'],
        descriptionEn: maps[i]['description_en'] ?? '',
        descriptionDe: maps[i]['description_de'] ?? '',
        createdAt: DateTime.parse(maps[i]['created_at']),
      );
    });
  }

  Future<List<Exercise>> getPredefinedExercises() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'exercises',
      where: 'is_predefined = ?',
      whereArgs: [1],
    );

    return List.generate(maps.length, (i) {
      return Exercise(
        id: maps[i]['id'],
        userId: 'local_user',
        nameEn: maps[i]['name_en'],
        nameDe: maps[i]['name_de'],
        descriptionEn: maps[i]['description_en'] ?? '',
        descriptionDe: maps[i]['description_de'] ?? '',
        createdAt: DateTime.parse(maps[i]['created_at']),
      );
    });
  }

  Future<bool> isPredefinedExercise(String exerciseId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'exercises',
      where: 'id = ? AND is_predefined = ?',
      whereArgs: [exerciseId, 1],
    );
    return maps.isNotEmpty;
  }

  Future<Exercise> createExercise({
    required String nameEn,
    required String nameDe,
    required String descriptionEn,
    required String descriptionDe,
  }) async {
    final db = await database;
    final id = _generateId();
    final now = DateTime.now();

    await db.insert('exercises', {
      'id': id,
      'name_en': nameEn,
      'name_de': nameDe,
      'description_en': descriptionEn,
      'description_de': descriptionDe,
      'created_at': now.toIso8601String(),
      'is_predefined': 0,
    });

    return Exercise(
      id: id,
      userId: 'local_user',
      nameEn: nameEn,
      nameDe: nameDe,
      descriptionEn: descriptionEn,
      descriptionDe: descriptionDe,
      createdAt: now,
    );
  }

  Future<void> updateExercise(Exercise exercise) async {
    final db = await database;
    await db.update(
      'exercises',
      {
        'name_en': exercise.nameEn,
        'name_de': exercise.nameDe,
        'description_en': exercise.descriptionEn,
        'description_de': exercise.descriptionDe,
      },
      where: 'id = ?',
      whereArgs: [exercise.id],
    );
  }

  Future<void> deleteExercise(String id) async {
    final db = await database;
    await db.delete('exercises', where: 'id = ?', whereArgs: [id]);
  }

  // Workout operations
  Future<List<Workout>> getWorkouts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'workouts',
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) {
      return Workout(
        id: maps[i]['id'],
        userId: 'local_user',
        name: maps[i]['name'],
        date: DateTime.parse(maps[i]['date']),
        createdAt: DateTime.parse(maps[i]['created_at']),
      );
    });
  }

  Future<Workout> createWorkout({
    required String name,
    required DateTime date,
  }) async {
    final db = await database;
    final id = _generateId();
    final now = DateTime.now();

    await db.insert('workouts', {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'created_at': now.toIso8601String(),
    });

    return Workout(
      id: id,
      userId: 'local_user',
      name: name,
      date: date,
      createdAt: now,
    );
  }

  Future<void> updateWorkout(Workout workout) async {
    final db = await database;
    await db.update(
      'workouts',
      {'name': workout.name, 'date': workout.date.toIso8601String()},
      where: 'id = ?',
      whereArgs: [workout.id],
    );
  }

  Future<void> deleteWorkout(String id) async {
    final db = await database;
    await db.delete('workouts', where: 'id = ?', whereArgs: [id]);
  }

  // WorkoutExercise operations
  Future<List<WorkoutExercise>> getWorkoutExercises(String workoutId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'workout_exercises',
      where: 'workout_id = ?',
      whereArgs: [workoutId],
      orderBy: 'created_at ASC',
    );

    return List.generate(maps.length, (i) {
      return WorkoutExercise(
        id: maps[i]['id'],
        workoutId: maps[i]['workout_id'],
        exerciseId: maps[i]['exercise_id'],
        sets: maps[i]['sets'],
        reps: maps[i]['reps'],
        weight: maps[i]['weight']?.toDouble(),
        durationSeconds: maps[i]['duration_seconds'],
        note: maps[i]['note'],
      );
    });
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
    final db = await database;
    final id = _generateId();
    final now = DateTime.now();

    await db.insert('workout_exercises', {
      'id': id,
      'workout_id': workoutId,
      'exercise_id': exerciseId,
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'duration_seconds': durationSeconds,
      'note': note,
      'created_at': now.toIso8601String(),
    });

    return WorkoutExercise(
      id: id,
      workoutId: workoutId,
      exerciseId: exerciseId,
      sets: sets,
      reps: reps,
      weight: weight,
      durationSeconds: durationSeconds,
      note: note,
    );
  }

  Future<void> updateWorkoutExercise(WorkoutExercise workoutExercise) async {
    final db = await database;
    await db.update(
      'workout_exercises',
      {
        'sets': workoutExercise.sets,
        'reps': workoutExercise.reps,
        'weight': workoutExercise.weight,
        'duration_seconds': workoutExercise.durationSeconds,
        'note': workoutExercise.note,
      },
      where: 'id = ?',
      whereArgs: [workoutExercise.id],
    );
  }

  Future<void> deleteWorkoutExercise(String id) async {
    final db = await database;
    await db.delete('workout_exercises', where: 'id = ?', whereArgs: [id]);
  }
}
