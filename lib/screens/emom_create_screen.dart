import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/emom_provider.dart';
import '../providers/exercise_provider.dart';
import '../models/emom.dart';
import '../models/exercise.dart';
import '../l10n/app_localizations.dart';

class EmomCreateScreen extends StatefulWidget {
  final Emom? emom; // Für Bearbeitung

  const EmomCreateScreen({super.key, this.emom});

  @override
  State<EmomCreateScreen> createState() => _EmomCreateScreenState();
}

class _EmomCreateScreenState extends State<EmomCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _minutesController = TextEditingController();

  int _selectedInterval = 60; // Standard: 60 Sekunden
  final List<int> _intervalOptions = [45, 60, 90];
  List<EmomExercise> _selectedExercises = [];

  bool get _isEditing => widget.emom != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _nameController.text = widget.emom!.name;
      _minutesController.text = widget.emom!.totalMinutes.toString();
      _selectedInterval = widget.emom!.intervalSeconds;
      _selectedExercises = List.from(widget.emom!.exercises);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _minutesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing
              ? (locale == 'de' ? 'EMOM bearbeiten' : 'Edit EMOM')
              : (locale == 'de' ? 'EMOM erstellen' : 'Create EMOM'),
        ),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _saveEmom,
            child: Text(
              l10n.save,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildNameSection(l10n),
            const SizedBox(height: 24),
            _buildTimeSection(l10n),
            const SizedBox(height: 24),
            _buildIntervalSection(l10n),
            const SizedBox(height: 24),
            _buildExercisesSection(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildNameSection(AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('EMOM Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(hintText: 'z.B. Push-Pull Training', border: const OutlineInputBorder()),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Name ist erforderlich';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSection(AppLocalizations l10n) {
    final locale = Localizations.localeOf(context).languageCode;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              locale == 'de' ? 'Gesamtzeit' : 'Total Time',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _minutesController,
              decoration: InputDecoration(
                hintText: locale == 'de' ? 'z.B. 20' : 'e.g. 20',
                border: const OutlineInputBorder(),
                suffixText: locale == 'de' ? 'Minuten' : 'Minutes',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return locale == 'de' ? 'Gesamtzeit ist erforderlich' : 'Total time is required';
                }
                final minutes = int.tryParse(value);
                if (minutes == null || minutes < 1) {
                  return 'Bitte geben Sie eine gültige Zeit ein';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntervalSection(AppLocalizations l10n) {
    final locale = Localizations.localeOf(context).languageCode;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              locale == 'de' ? 'Intervall' : 'Interval',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              locale == 'de' ? 'Wählen Sie ein Intervall' : 'Choose an interval',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _intervalOptions.map((interval) {
                return ChoiceChip(
                  label: Text('${interval}s'),
                  selected: _selectedInterval == interval,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedInterval = interval;
                      });
                    }
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExercisesSection(AppLocalizations l10n) {
    final locale = Localizations.localeOf(context).languageCode;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(l10n.exercises, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                OutlinedButton.icon(
                  onPressed: () => _showAddExerciseDialog(context),
                  icon: const Icon(Icons.add),
                  label: Text(l10n.addExercise),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_selectedExercises.isEmpty) ...[
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(Icons.fitness_center, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 8),
                    Text(
                      locale == 'de' ? 'Noch keine Übungen hinzugefügt' : 'No exercises added yet',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      locale == 'de' ? 'Fügen Sie Ihre erste Übung hinzu' : 'Add your first exercise',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Column(
                children: [
                  Text(
                    '${_selectedExercises.length} ${l10n.exercises}',
                    style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8),
                  ..._selectedExercises.map((exercise) => _buildExerciseCard(exercise, l10n)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard(EmomExercise exercise, AppLocalizations l10n) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(exercise.exerciseName),
        subtitle: Text(exercise.displayText),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            setState(() {
              _selectedExercises.remove(exercise);
            });
          },
        ),
      ),
    );
  }

  void _showAddExerciseDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    showDialog(
      context: context,
      builder: (context) => _AddExerciseDialog(
        locale: locale,
        l10n: l10n,
        onExerciseAdded: (exercise) {
          setState(() {
            _selectedExercises.add(exercise);
          });
        },
      ),
    );
  }

  void _saveEmom() async {
    final locale = Localizations.localeOf(context).languageCode;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedExercises.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(locale == 'de' ? 'Fehler' : 'Error'),
          content: Text(
            locale == 'de' ? 'Bitte fügen Sie mindestens eine Übung hinzu' : 'Please add at least one exercise',
          ),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
        ),
      );
      return;
    }

    final emom = Emom(
      id: _isEditing ? widget.emom!.id : '',
      name: _nameController.text,
      totalMinutes: int.parse(_minutesController.text),
      intervalSeconds: _selectedInterval,
      exercises: _selectedExercises,
      isQuickStart: false,
    );

    try {
      final emomProvider = context.read<EmomProvider>();
      if (_isEditing) {
        await emomProvider.updateEmom(emom);
      } else {
        await emomProvider.addEmom(emom);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fehler: $e')));
      }
    }
  }
}

class _AddExerciseDialog extends StatefulWidget {
  final String locale;
  final AppLocalizations l10n;
  final Function(EmomExercise) onExerciseAdded;

  const _AddExerciseDialog({required this.locale, required this.l10n, required this.onExerciseAdded});

  @override
  State<_AddExerciseDialog> createState() => _AddExerciseDialogState();
}

class _AddExerciseDialogState extends State<_AddExerciseDialog> {
  Exercise? _selectedExercise;
  bool _isTimeBased = false; // false = Wiederholungen, true = Zeit
  final _repsController = TextEditingController();
  final _durationController = TextEditingController();
  bool _canAdd = false; // Zustand für Button-Aktivierung

  @override
  void initState() {
    super.initState();
    // Listener hinzufügen, um Button-Status zu aktualisieren
    _repsController.addListener(_updateCanAdd);
    _durationController.addListener(_updateCanAdd);
  }

  @override
  void dispose() {
    _repsController.removeListener(_updateCanAdd);
    _durationController.removeListener(_updateCanAdd);
    _repsController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _updateCanAdd() {
    setState(() {
      _canAdd = _canAddExercise();
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    return AlertDialog(
      title: Text(locale == 'de' ? 'Übung hinzufügen' : 'Add Exercise'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Übungsauswahl
            Container(
              height: 200,
              child: Consumer<ExerciseProvider>(
                builder: (context, exerciseProvider, child) {
                  return ListView.builder(
                    itemCount: exerciseProvider.exercises.length,
                    itemBuilder: (context, index) {
                      final exercise = exerciseProvider.exercises[index];
                      return ListTile(
                        title: Text(exercise.getName(widget.locale)),
                        selected: _selectedExercise?.id == exercise.id,
                        onTap: () {
                          setState(() {
                            _selectedExercise = exercise;
                            _updateCanAdd(); // Button-Status aktualisieren
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Typ auswählen
            Text(locale == 'de' ? 'Typ auswählen:' : 'Choose type:', style: TextStyle(fontWeight: FontWeight.bold)),
            RadioListTile<bool>(
              title: Text(locale == 'de' ? 'Wiederholungen' : 'Repetitions'),
              subtitle: Text(locale == 'de' ? 'z.B. 10x Liegestütze' : 'e.g. 10x Push-ups'),
              value: false,
              groupValue: _isTimeBased,
              onChanged: (value) {
                setState(() {
                  _isTimeBased = value!;
                  _updateCanAdd(); // Button-Status aktualisieren
                });
              },
            ),
            RadioListTile<bool>(
              title: Text(locale == 'de' ? 'Zeit' : 'Time'),
              subtitle: Text(locale == 'de' ? 'z.B. 30s Plank' : 'e.g. 30s Plank'),
              value: true,
              groupValue: _isTimeBased,
              onChanged: (value) {
                setState(() {
                  _isTimeBased = value!;
                  _updateCanAdd(); // Button-Status aktualisieren
                });
              },
            ),

            const SizedBox(height: 16),

            // Input basierend auf Typ
            if (!_isTimeBased) ...[
              TextField(
                controller: _repsController,
                decoration: InputDecoration(
                  labelText: locale == 'de' ? 'Wiederholungen' : 'Repetitions',
                  hintText: '10',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ] else ...[
              TextField(
                controller: _durationController,
                decoration: InputDecoration(
                  labelText: locale == 'de' ? 'Dauer (Sekunden)' : 'Duration (Seconds)',
                  hintText: '30',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(widget.l10n.cancel)),
        ElevatedButton(
          onPressed: _canAdd ? _addExercise : null,
          child: Text(locale == 'de' ? 'Zu EMOM hinzufügen' : 'Add to EMOM'),
        ),
      ],
    );
  }

  bool _canAddExercise() {
    if (_selectedExercise == null) return false;
    if (_isTimeBased) {
      return _durationController.text.isNotEmpty;
    } else {
      return _repsController.text.isNotEmpty;
    }
  }

  void _addExercise() {
    if (!_canAddExercise()) return;

    final exercise = EmomExercise(
      exerciseId: _selectedExercise!.id,
      exerciseName: _selectedExercise!.getName(widget.locale),
      isTimeBased: _isTimeBased,
      repetitions: _isTimeBased ? 0 : int.parse(_repsController.text),
      durationSeconds: _isTimeBased ? int.parse(_durationController.text) : 0,
    );

    widget.onExerciseAdded(exercise);
    Navigator.pop(context);
  }
}
