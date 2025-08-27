import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/exercise.dart';
import '../l10n/app_localizations.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final String locale;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isPredefined;

  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.locale,
    this.onEdit,
    this.onDelete,
    this.isPredefined = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final canEdit = onEdit != null; // Alle Übungen können bearbeitet werden
    final canDelete = onDelete != null; // Alle Übungen können gelöscht werden

    return Slidable(
      enabled: canEdit || canDelete,
      endActionPane: (canEdit || canDelete)
          ? ActionPane(
              motion: const ScrollMotion(),
              children: [
                if (canEdit)
                  SlidableAction(
                    onPressed: (_) => onEdit!(),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: 'Edit',
                  ),
                if (canDelete)
                  SlidableAction(
                    onPressed: (_) => onDelete!(),
                    backgroundColor: Theme.of(context).colorScheme.error,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
              ],
            )
          : null,
      child: Card(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[800],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.fitness_center,
                color: Theme.of(context).colorScheme.secondary,
                size: 24,
              ),
            ),
            title: Text(
              exercise.getName(locale),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (canEdit)
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit, color: Colors.blue, size: 24),
                    tooltip: l10n.editExerciseTooltip,
                  ),
                if (canDelete)
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
  }
}
