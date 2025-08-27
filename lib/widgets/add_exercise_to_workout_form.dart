import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/workout_provider.dart';
import '../providers/exercise_provider.dart';
import '../providers/weight_unit_provider.dart';
import '../models/workout_exercise.dart';

class AddExerciseToWorkoutForm extends StatefulWidget {
  final String workoutId;
  final WorkoutExercise? workoutExercise;

  const AddExerciseToWorkoutForm({
    super.key,
    required this.workoutId,
    this.workoutExercise,
  });

  @override
  State<AddExerciseToWorkoutForm> createState() =>
      _AddExerciseToWorkoutFormState();
}

class _AddExerciseToWorkoutFormState extends State<AddExerciseToWorkoutForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedExerciseId;
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  final _repsPerSetController = TextEditingController();
  final _weightController = TextEditingController();
  final _durationMinutesController = TextEditingController();
  final _durationSecondsController = TextEditingController();
  final _noteController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.workoutExercise != null) {
      _selectedExerciseId = widget.workoutExercise!.exerciseId;
      _setsController.text = widget.workoutExercise!.sets?.toString() ?? '';
      _repsController.text = widget.workoutExercise!.reps?.toString() ?? '';

      // Extrahiere repsPerSet aus den Notizen wenn vorhanden
      String note = widget.workoutExercise!.note ?? '';
      String regularNote = note;
      if (note.startsWith('Wiederholungen: ') ||
          note.startsWith('Repetitions: ')) {
        final lines = note.split('\n');
        final repsLine = lines.first
            .replaceFirst('Wiederholungen: ', '')
            .replaceFirst('Repetitions: ', '');
        _repsPerSetController.text = repsLine;
        regularNote = lines.skip(1).join('\n');
      }

      _weightController.text = widget.workoutExercise!.weight != null
          ? context
                .read<WeightUnitProvider>()
                .convertFromInternalWeight(widget.workoutExercise!.weight!)
                .toStringAsFixed(1)
          : '';
      if (widget.workoutExercise!.durationSeconds != null) {
        final minutes = widget.workoutExercise!.durationSeconds! ~/ 60;
        final seconds = widget.workoutExercise!.durationSeconds! % 60;
        _durationMinutesController.text = minutes.toString();
        _durationSecondsController.text = seconds.toString();
      }
      _noteController.text = regularNote;
    }

    // ExerciseProvider laden beim Start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExerciseProvider>().loadExercises();
    });
  }

  @override
  void dispose() {
    _setsController.dispose();
    _repsController.dispose();
    _repsPerSetController.dispose();
    _weightController.dispose();
    _durationMinutesController.dispose();
    _durationSecondsController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final isEditing = widget.workoutExercise != null;

    return AlertDialog(
      backgroundColor: Colors.grey[850],
      title: Text(
        isEditing ? l10n.editExercise : l10n.addExerciseToWorkout,
        style: const TextStyle(color: Colors.white),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.7,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Consumer<ExerciseProvider>(
                  builder: (context, exerciseProvider, child) {
                    final selectedExercise = _selectedExerciseId != null
                        ? exerciseProvider.exercises
                              .where((e) => e.id == _selectedExerciseId)
                              .firstOrNull
                        : null;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Label für Übungsauswahl
                        Text(
                          l10n.selectExercise,
                          style: Theme.of(
                            context,
                          ).textTheme.labelLarge?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 8),

                        // Suchfeld
                        TextField(
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: l10n.searchExercise,
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey[400],
                            ),
                            suffixIcon: exerciseProvider.searchTerm.isNotEmpty
                                ? IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      color: Colors.grey[400],
                                    ),
                                    onPressed: () =>
                                        exerciseProvider.clearSearch(),
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[600]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[600]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                            filled: true,
                            fillColor: Colors.grey[800],
                          ),
                          onChanged: (value) =>
                              exerciseProvider.searchExercises(value),
                        ),
                        const SizedBox(height: 8),

                        // Übungsliste
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[600]!),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey[800],
                          ),
                          child: ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: exerciseProvider.exercises.length,
                            itemBuilder: (context, index) {
                              final exercise =
                                  exerciseProvider.exercises[index];
                              final isSelected =
                                  exercise.id == _selectedExerciseId;

                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                color: Colors.grey[750],
                                child: ListTile(
                                  title: Text(
                                    exercise.getName(locale),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  subtitle:
                                      exercise.getDescription(locale).isNotEmpty
                                      ? Text(
                                          exercise.getDescription(locale),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.grey[300],
                                          ),
                                        )
                                      : null,
                                  selected: isSelected,
                                  selectedTileColor: Colors.blue.withOpacity(
                                    0.3,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _selectedExerciseId = exercise.id;
                                    });
                                  },
                                  trailing: isSelected
                                      ? const Icon(
                                          Icons.check_circle,
                                          color: Colors.blue,
                                        )
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),

                        // Anzeige der ausgewählten Übung
                        if (selectedExercise != null) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue, width: 1),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    locale == 'de'
                                        ? 'Ausgewählt: ${selectedExercise.getName(locale)}'
                                        : 'Selected: ${selectedExercise.getName(locale)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        // Validierung für ausgewählte Übung
                        if (_selectedExerciseId == null)
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              l10n.selectExerciseError,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _setsController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: l10n.setsLabel,
                          labelStyle: TextStyle(color: Colors.grey[400]),
                          helperText: l10n.autoCalculatedSets,
                          helperStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 11,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[600]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[600]!),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          filled: true,
                          fillColor: Colors.grey[800],
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _repsController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: l10n.repsLabel,
                          labelStyle: TextStyle(color: Colors.grey[400]),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[600]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[600]!),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          filled: true,
                          fillColor: Colors.grey[800],
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Detaillierte Wiederholungen pro Satz
                TextFormField(
                  controller: _repsPerSetController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: l10n.repsPerSetLabel,
                    hintText: l10n.repsPerSetHint,
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    labelStyle: TextStyle(color: Colors.grey[400]),
                    helperText: l10n.repsPerSetHelper,
                    helperStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[600]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[600]!),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    filled: true,
                    fillColor: Colors.grey[800],
                  ),
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    // Automatische Berechnung der Sätze basierend auf den Einträgen
                    if (value.trim().isNotEmpty) {
                      try {
                        final parts = value
                            .split(',')
                            .where((part) => part.trim().isNotEmpty)
                            .toList();
                        if (parts.isNotEmpty) {
                          _setsController.text = parts.length.toString();
                        }
                      } catch (e) {
                        // Ignoriere Fehler bei der Parsing
                      }
                    }
                  },
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      // Validiere das Format
                      try {
                        final parts = value.split(',');
                        for (final part in parts) {
                          int.parse(part.trim());
                        }
                      } catch (e) {
                        return l10n.invalidRepsFormat;
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _weightController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: l10n.weightLabel,
                          labelStyle: TextStyle(color: Colors.grey[400]),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[600]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[600]!),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          filled: true,
                          fillColor: Colors.grey[800],
                          suffixText: context
                              .watch<WeightUnitProvider>()
                              .weightUnitString,
                          suffixStyle: TextStyle(color: Colors.grey[400]),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _durationMinutesController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: l10n.durationLabel,
                          labelStyle: TextStyle(color: Colors.grey[400]),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[600]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[600]!),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          filled: true,
                          fillColor: Colors.grey[800],
                          suffixText: l10n.minutes,
                          suffixStyle: TextStyle(color: Colors.grey[400]),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _durationSecondsController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: '',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[600]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[600]!),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          filled: true,
                          fillColor: Colors.grey[800],
                          suffixText: l10n.seconds,
                          suffixStyle: TextStyle(color: Colors.grey[400]),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _noteController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: l10n.noteLabel,
                    labelStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[600]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[600]!),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    filled: true,
                    fillColor: Colors.grey[800],
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.cancel, style: TextStyle(color: Colors.grey[300])),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveExercise,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(l10n.save),
        ),
      ],
    );
  }

  Future<void> _saveExercise() async {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    if (!_formKey.currentState!.validate()) return;

    // Überprüfen, ob eine Übung ausgewählt wurde
    if (_selectedExerciseId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.selectExerciseFirst),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final workoutProvider = context.read<WorkoutProvider>();

      // Parse duration
      int? durationSeconds;
      if (_durationMinutesController.text.isNotEmpty ||
          _durationSecondsController.text.isNotEmpty) {
        final minutes = int.tryParse(_durationMinutesController.text) ?? 0;
        final seconds = int.tryParse(_durationSecondsController.text) ?? 0;
        durationSeconds = minutes * 60 + seconds;
      }

      if (widget.workoutExercise != null) {
        // Update existing workout exercise
        String finalNote = _noteController.text.trim();
        int? finalSets = int.tryParse(_setsController.text);

        // Wenn repsPerSet ausgefüllt ist, füge es zu den Notizen hinzu und berechne Sätze
        if (_repsPerSetController.text.trim().isNotEmpty) {
          final repsPerSetText = locale == 'de'
              ? 'Wiederholungen: ${_repsPerSetController.text.trim()}'
              : 'Repetitions: ${_repsPerSetController.text.trim()}';
          if (finalNote.isEmpty) {
            finalNote = repsPerSetText;
          } else {
            finalNote = '$repsPerSetText\n$finalNote';
          }

          // Automatische Berechnung der Sätze basierend auf den Komma-getrennten Werten
          try {
            final parts = _repsPerSetController.text
                .split(',')
                .where((part) => part.trim().isNotEmpty)
                .toList();
            if (parts.isNotEmpty) {
              finalSets = parts.length;
            }
          } catch (e) {
            // Fallback zu manuell eingegebenen Sätzen
          }
        }
        final updatedWorkoutExercise = widget.workoutExercise!.copyWith(
          sets: finalSets,
          reps: int.tryParse(_repsController.text),
          weight: _weightController.text.isNotEmpty
              ? context.read<WeightUnitProvider>().convertToInternalWeight(
                  double.parse(_weightController.text),
                )
              : null,
          durationSeconds: durationSeconds,
          note: finalNote.isEmpty ? null : finalNote,
        );
        await workoutProvider.updateWorkoutExercise(updatedWorkoutExercise);
      } else {
        // Add new exercise to workout
        String finalNote = _noteController.text.trim();
        int? finalSets = int.tryParse(_setsController.text);

        // Wenn repsPerSet ausgefüllt ist, füge es zu den Notizen hinzu und berechne Sätze
        if (_repsPerSetController.text.trim().isNotEmpty) {
          final repsPerSetText = locale == 'de'
              ? 'Wiederholungen: ${_repsPerSetController.text.trim()}'
              : 'Repetitions: ${_repsPerSetController.text.trim()}';
          if (finalNote.isEmpty) {
            finalNote = repsPerSetText;
          } else {
            finalNote = '$repsPerSetText\n$finalNote';
          }

          // Automatische Berechnung der Sätze basierend auf den Komma-getrennten Werten
          try {
            final parts = _repsPerSetController.text
                .split(',')
                .where((part) => part.trim().isNotEmpty)
                .toList();
            if (parts.isNotEmpty) {
              finalSets = parts.length;
            }
          } catch (e) {
            // Fallback zu manuell eingegebenen Sätzen
          }
        }

        await workoutProvider.addExerciseToWorkout(
          workoutId: widget.workoutId,
          exerciseId: _selectedExerciseId!,
          sets: finalSets,
          reps: int.tryParse(_repsController.text),
          weight: _weightController.text.isNotEmpty
              ? context.read<WeightUnitProvider>().convertToInternalWeight(
                  double.parse(_weightController.text),
                )
              : null,
          durationSeconds: durationSeconds,
          note: finalNote.isEmpty ? null : finalNote,
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
