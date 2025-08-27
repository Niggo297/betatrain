import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/workout_exercise.dart';
import '../providers/exercise_provider.dart';
import '../providers/weight_unit_provider.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';

class WorkoutExerciseCard extends StatelessWidget {
  final WorkoutExercise workoutExercise;
  final String locale;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const WorkoutExerciseCard({
    super.key,
    required this.workoutExercise,
    required this.locale,
    required this.onEdit,
    required this.onDelete,
  });

  String _getDisplayTextWithCorrectWeightUnit(BuildContext context) {
    final weightUnitProvider = context.watch<WeightUnitProvider>();

    List<String> parts = [];

    if (workoutExercise.hasSets) {
      parts.add('${workoutExercise.sets} ${locale == 'de' ? 'Sätze' : 'sets'}');
    }

    // Prüfe zuerst, ob variable Wiederholungen in der Notiz gespeichert sind
    bool hasVariableReps = false;
    if (workoutExercise.note != null &&
        workoutExercise.note!.contains('Wiederholungen:')) {
      try {
        final lines = workoutExercise.note!.split('\n');
        final repsLine = lines.firstWhere(
          (line) => line.startsWith('Wiederholungen:'),
          orElse: () => '',
        );

        if (repsLine.isNotEmpty) {
          final repsText = repsLine.substring('Wiederholungen:'.length).trim();
          parts.add('$repsText ${locale == 'de' ? 'Wdh.' : 'reps'}');
          hasVariableReps = true;
        }
      } catch (e) {
        // Fallback zu Standard-Anzeige bei Parsing-Fehlern
      }
    }

    // Nur normale Wiederholungen anzeigen, wenn keine variablen vorhanden sind
    if (!hasVariableReps && workoutExercise.hasReps) {
      parts.add(
        '${workoutExercise.reps} ${locale == 'de' ? 'Wiederholungen' : 'reps'}',
      );
    }

    if (workoutExercise.hasDuration) {
      final minutes = workoutExercise.durationSeconds! ~/ 60;
      final seconds = workoutExercise.durationSeconds! % 60;
      if (minutes > 0) {
        parts.add(
          '$minutes:${seconds.toString().padLeft(2, '0')} ${locale == 'de' ? 'Min' : 'min'}',
        );
      } else {
        parts.add('${seconds}s');
      }
    }

    if (workoutExercise.hasWeight) {
      final displayWeight = weightUnitProvider.convertFromInternalWeight(
        workoutExercise.weight!,
      );
      final unit = weightUnitProvider.weightUnitString;
      parts.add('${displayWeight.toStringAsFixed(1)}$unit');
    }

    return parts.join(' • ');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<ExerciseProvider>(
      builder: (context, exerciseProvider, child) {
        final exercise = exerciseProvider.getExerciseById(
          workoutExercise.exerciseId,
        );

        if (exercise == null) {
          return Card(
            color: Colors.grey[800],
            child: ListTile(
              leading: const Icon(Icons.error, color: Colors.red),
              title: const Text(
                'Exercise not found',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        return Slidable(
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (_) => onEdit(),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                icon: Icons.edit,
                label: 'Edit',
              ),
              SlidableAction(
                onPressed: (_) => onDelete(),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: Card(
            elevation: 2,
            shadowColor: Colors.black.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[750],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.fitness_center,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        exercise.getName(locale),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                      ),
                    ),
                    if (workoutExercise.note != null &&
                        workoutExercise.note!.isNotEmpty &&
                        !_isOnlyVariableRepsNote(workoutExercise.note!))
                      Icon(
                        Icons.sticky_note_2,
                        size: 16,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getDisplayTextWithCorrectWeightUnit(context),
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                    ),
                    // Zeige nur Notizen an, die nicht "Wiederholungen:" enthalten
                    if (workoutExercise.note != null &&
                        workoutExercise.note!.isNotEmpty &&
                        !_isOnlyVariableRepsNote(workoutExercise.note!)) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.note,
                            size: 16,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              _getCleanedNote(workoutExercise.note!),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 4),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.blue,
                        size: 24,
                      ),
                      tooltip: l10n.editExerciseTooltip,
                    ),
                    IconButton(
                      onPressed: onDelete,
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.error,
                        size: 24,
                      ),
                      tooltip: l10n.deleteExerciseTooltip,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Prüft, ob die Notiz nur variable Wiederholungen enthält
  bool _isOnlyVariableRepsNote(String note) {
    final lines = note
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();
    return lines.length == 1 && lines.first.startsWith('Wiederholungen:');
  }

  // Entfernt die "Wiederholungen:"-Zeile aus der Notiz
  String _getCleanedNote(String note) {
    final lines = note.split('\n');
    final cleanedLines = lines
        .where((line) => !line.startsWith('Wiederholungen:'))
        .toList();
    return cleanedLines.join('\n').trim();
  }
}
