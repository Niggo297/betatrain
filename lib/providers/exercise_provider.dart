import 'package:flutter/foundation.dart';
import '../models/exercise.dart';
import '../services/local_service.dart';

class ExerciseProvider with ChangeNotifier {
  final LocalService _localService = LocalService();
  List<Exercise> _userExercises = [];
  List<Exercise> _predefinedExercises = [];
  bool _isLoading = false;
  String? _error;
  bool _showPredefined = true;
  String _searchTerm = '';

  List<Exercise> get exercises {
    if (_searchTerm.isNotEmpty) {
      final allExercises = [..._predefinedExercises, ..._userExercises];
      return allExercises
          .where((exercise) => _matchesSearch(exercise))
          .toList();
    }
    return _showPredefined
        ? [..._predefinedExercises, ..._userExercises]
        : _userExercises;
  }

  List<Exercise> get userExercises {
    if (_searchTerm.isNotEmpty) {
      return _userExercises
          .where((exercise) => _matchesSearch(exercise))
          .toList();
    }
    return _userExercises;
  }

  List<Exercise> get predefinedExercises {
    if (_searchTerm.isNotEmpty) {
      return _predefinedExercises
          .where((exercise) => _matchesSearch(exercise))
          .toList();
    }
    return _predefinedExercises;
  }

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get showPredefined => _showPredefined;
  String get searchTerm => _searchTerm;

  bool _matchesSearch(Exercise exercise) {
    if (_searchTerm.isEmpty) return true;

    final searchLower = _searchTerm.toLowerCase();
    return exercise.nameEn.toLowerCase().contains(searchLower) ||
        exercise.nameDe.toLowerCase().contains(searchLower) ||
        exercise.descriptionEn.toLowerCase().contains(searchLower) ||
        exercise.descriptionDe.toLowerCase().contains(searchLower);
  }

  Future<void> loadExercises() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Load all exercises from local database
      final allExercises = await _localService.getExercises();

      // Separate predefined and user exercises
      _predefinedExercises = [];
      _userExercises = [];

      for (final exercise in allExercises) {
        final isPredefined = await _localService.isPredefinedExercise(
          exercise.id,
        );
        if (isPredefined) {
          _predefinedExercises.add(exercise);
        } else {
          _userExercises.add(exercise);
        }
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchExercises(String searchTerm) async {
    _searchTerm = searchTerm;
    notifyListeners();
  }

  void clearSearch() {
    _searchTerm = '';
    notifyListeners();
  }

  void togglePredefinedExercises() {
    _showPredefined = !_showPredefined;
    notifyListeners();
  }

  void setPredefinedVisibility(bool show) {
    _showPredefined = show;
    notifyListeners();
  }

  Future<void> createExercise({
    required String nameEn,
    required String nameDe,
    required String descriptionEn,
    required String descriptionDe,
  }) async {
    try {
      final exercise = await _localService.createExercise(
        nameEn: nameEn,
        nameDe: nameDe,
        descriptionEn: descriptionEn,
        descriptionDe: descriptionDe,
      );
      _userExercises.insert(0, exercise);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateExercise(Exercise exercise) async {
    try {
      await _localService.updateExercise(exercise);

      // Check if it's a predefined or user exercise and update accordingly
      final isPredefined = await _localService.isPredefinedExercise(
        exercise.id,
      );
      if (isPredefined) {
        final index = _predefinedExercises.indexWhere(
          (e) => e.id == exercise.id,
        );
        if (index != -1) {
          _predefinedExercises[index] = exercise;
        }
      } else {
        final index = _userExercises.indexWhere((e) => e.id == exercise.id);
        if (index != -1) {
          _userExercises[index] = exercise;
        }
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteExercise(String id) async {
    try {
      // Only allow deleting user exercises, not predefined ones
      final isPredefined = await _localService.isPredefinedExercise(id);
      if (isPredefined) {
        throw Exception('Cannot delete predefined exercises');
      }

      await _localService.deleteExercise(id);
      _userExercises.removeWhere((e) => e.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Exercise? getExerciseById(String id) {
    try {
      // First check predefined exercises
      final predefined = _predefinedExercises.firstWhere((e) => e.id == id);
      return predefined;
    } catch (e) {
      // Then check user exercises
      try {
        return _userExercises.firstWhere((e) => e.id == id);
      } catch (e) {
        return null;
      }
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
