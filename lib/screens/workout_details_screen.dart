import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/workout_provider.dart';
import '../models/workout.dart';
import '../models/workout_exercise.dart';
import '../widgets/workout_exercise_card.dart';
import '../widgets/add_exercise_to_workout_form.dart';

class WorkoutDetailsScreen extends StatefulWidget {
  final Workout workout;

  const WorkoutDetailsScreen({super.key, required this.workout});

  @override
  State<WorkoutDetailsScreen> createState() => _WorkoutDetailsScreenState();
}

class _WorkoutDetailsScreenState extends State<WorkoutDetailsScreen> {
  bool _skipLoadingExercises = false;

  @override
  void initState() {
    super.initState();
    print('WorkoutDetailsScreen: initState for workout ${widget.workout.id}');

    // Add a small delay to see if the screen loads first
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('Screen loaded, now loading workout exercises...');
      if (!_skipLoadingExercises) {
        _loadExercisesSafely();
      }
    });
  }

  Future<void> _loadExercisesSafely() async {
    try {
      await context.read<WorkoutProvider>().loadWorkoutExercises(widget.workout.id);
    } catch (e) {
      print('Failed to load exercises safely: $e');
      // Continue anyway - don't let this crash the screen
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.workout.name, style: const TextStyle(color: Colors.white)),
            Text(
              _formatDate(widget.workout.date),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[300]),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => _showAddExerciseDialog(context),
            tooltip: l10n.addExerciseToWorkout,
          ),
        ],
      ),
      body: Consumer<WorkoutProvider>(
        builder: (context, workoutProvider, child) {
          // Show loading state
          if (workoutProvider.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  const Text('Loading exercises...', style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _skipLoadingExercises = true;
                      });
                      context.read<WorkoutProvider>().skipLoadingExercises(widget.workout.id);
                    },
                    child: const Text('Skip Loading & Continue'),
                  ),
                ],
              ),
            );
          }

          // Show error state
          if (workoutProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${workoutProvider.error}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      workoutProvider.clearError();
                      workoutProvider.loadWorkoutExercises(widget.workout.id);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final workoutExercises = workoutProvider.getWorkoutExercises(widget.workout.id);

          if (workoutExercises.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.fitness_center_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    Localizations.localeOf(context).languageCode == 'de'
                        ? 'Noch keine Übungen in diesem Training'
                        : 'No exercises in this workout yet',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    Localizations.localeOf(context).languageCode == 'de'
                        ? 'Fügen Sie Ihre erste Übung hinzu um zu beginnen'
                        : 'Add your first exercise to get started',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[300]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showAddExerciseDialog(context),
                    icon: const Icon(Icons.add),
                    label: Text(l10n.addExerciseToWorkout),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Workout Statistiken Card
              _buildWorkoutStatsCard(workoutExercises),
              // Übungsliste
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: workoutExercises.length,
                  itemBuilder: (context, index) {
                    final workoutExercise = workoutExercises[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: WorkoutExerciseCard(
                        workoutExercise: workoutExercise,
                        locale: locale,
                        onEdit: () => _showEditExerciseDialog(context, workoutExercise),
                        onDelete: () => _showDeleteExerciseDialog(context, workoutExercise),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddExerciseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddExerciseToWorkoutForm(workoutId: widget.workout.id),
    );
  }

  void _showEditExerciseDialog(BuildContext context, WorkoutExercise workoutExercise) {
    print('Opening edit dialog for workout exercise: ${workoutExercise.id}');
    showDialog(
      context: context,
      builder: (context) => AddExerciseToWorkoutForm(workoutId: widget.workout.id, workoutExercise: workoutExercise),
    );
  }

  void _showDeleteExerciseDialog(BuildContext context, WorkoutExercise workoutExercise) {
    print('Opening delete dialog for workout exercise: ${workoutExercise.id}');
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[800],
        title: Text(l10n.confirmDelete, style: const TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to remove this exercise from the workout?',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel, style: const TextStyle(color: Colors.blue)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<WorkoutProvider>().deleteWorkoutExercise(workoutExercise.id, widget.workout.id);
            },
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final workoutDate = DateTime(date.year, date.month, date.day);

    if (workoutDate == today) {
      return 'Heute';
    } else if (workoutDate == today.subtract(const Duration(days: 1))) {
      return 'Gestern';
    } else if (workoutDate == today.add(const Duration(days: 1))) {
      return 'Morgen';
    } else {
      return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
    }
  }

  Widget _buildWorkoutStatsCard(List<WorkoutExercise> workoutExercises) {
    final stats = _calculateWorkoutStats(workoutExercises);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
            Theme.of(context).colorScheme.primary.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.workoutOverview,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: Icons.fitness_center,
                  label: AppLocalizations.of(context)!.totalReps,
                  value: '${stats['totalReps'] ?? 0}',
                  showValue: (stats['totalReps'] ?? 0) > 0,
                ),
              ),
              if ((stats['totalReps'] ?? 0) > 0 && (stats['totalTime'] ?? 0) > 0) const SizedBox(width: 16),
              if ((stats['totalTime'] ?? 0) > 0)
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.timer,
                    label: AppLocalizations.of(context)!.totalDuration,
                    value: _formatTime(stats['totalTime'] ?? 0),
                    showValue: true,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: Icons.numbers,
                  label: AppLocalizations.of(context)!.exercisesLabel,
                  value: '${workoutExercises.length}',
                  showValue: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.layers,
                  label: AppLocalizations.of(context)!.totalSets,
                  value: '${stats['totalSets'] ?? 0}',
                  showValue: (stats['totalSets'] ?? 0) > 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required bool showValue,
  }) {
    if (!showValue) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.white.withOpacity(0.9)),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.white70),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }

  Map<String, int> _calculateWorkoutStats(List<WorkoutExercise> workoutExercises) {
    int totalReps = 0;
    int totalTime = 0;
    int totalSets = 0;

    for (final exercise in workoutExercises) {
      final sets = exercise.sets ?? 1;
      final durationSeconds = exercise.durationSeconds ?? 0;

      // Berechne Gesamtwiederholungen: verwende neue totalReps Methode
      totalReps += exercise.totalReps;

      // Berechne Gesamtzeit: durationSeconds * sets
      totalTime += durationSeconds * sets;

      // Zähle Sätze
      totalSets += sets;
    }

    return {'totalReps': totalReps, 'totalTime': totalTime, 'totalSets': totalSets};
  }

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${secs}s';
    } else {
      return '${secs}s';
    }
  }
}
