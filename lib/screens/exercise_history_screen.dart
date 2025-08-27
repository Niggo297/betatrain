import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workout_provider.dart';
import '../providers/weight_unit_provider.dart';
import '../models/exercise.dart';
import '../models/workout.dart';
import '../models/workout_exercise.dart';

class ExerciseHistoryScreen extends StatefulWidget {
  final Exercise exercise;
  final String locale;

  const ExerciseHistoryScreen({super.key, required this.exercise, required this.locale});

  @override
  State<ExerciseHistoryScreen> createState() => _ExerciseHistoryScreenState();
}

class _ExerciseHistoryScreenState extends State<ExerciseHistoryScreen> {
  DateTimeRange? _selectedDateRange;
  String _selectedFilter = 'all'; // 'all', 'week', 'month', '3months', 'year', 'custom'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: Text('${widget.exercise.getName(widget.locale)} - History', style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Filter Button
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () => _showFilterDialog(context)),
        ],
      ),
      body: Consumer<WorkoutProvider>(
        builder: (context, workoutProvider, child) {
          final allHistoryData = workoutProvider.getExerciseHistory(widget.exercise.id);
          final filteredHistoryData = _filterHistoryData(allHistoryData);

          if (filteredHistoryData.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, color: Colors.grey[600], size: 64),
                  const SizedBox(height: 16),
                  Text(
                    widget.locale == 'de'
                        ? 'Keine Trainingshistorie für den gewählten Zeitraum'
                        : 'No training history for the selected period',
                    style: TextStyle(color: Colors.grey[400], fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredHistoryData.length,
            itemBuilder: (context, index) {
              final historyEntry = filteredHistoryData[index];
              return _buildHistoryCard(context, historyEntry);
            },
          );
        },
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, Map<String, dynamic> historyEntry) {
    final workout = historyEntry['workout'] as Workout;
    final workoutExercise = historyEntry['workoutExercise'] as WorkoutExercise;
    final date = workout.date; // Verwende das geplante Trainingsdatum, nicht das Erstellungsdatum

    // Formatiere das Datum
    final formattedDate =
        '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';

    return Card(
      color: Colors.grey[800],
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Datum und Workout-Name
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.blue[300], size: 18),
                const SizedBox(width: 8),
                Text(
                  formattedDate,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (workout.name.isNotEmpty) ...[
                  Text(workout.name, style: TextStyle(color: Colors.grey[400], fontSize: 14)),
                ],
              ],
            ),

            const SizedBox(height: 12),

            // Trainingsdetails
            _buildExerciseDetails(context, workoutExercise),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseDetails(BuildContext context, WorkoutExercise workoutExercise) {
    final weightProvider = context.read<WeightUnitProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Wiederholungen - detaillierte Anzeige
        if (workoutExercise.totalReps > 0) ...[
          _buildDetailRow(
            Icons.repeat,
            widget.locale == 'de' ? 'Wiederholungen:' : 'Repetitions:',
            _formatRepsDisplay(workoutExercise),
            Colors.green[300]!,
          ),
        ],

        // Gewicht
        if (workoutExercise.weight != null && workoutExercise.weight! > 0) ...[
          _buildDetailRow(
            Icons.fitness_center,
            widget.locale == 'de' ? 'Gewicht:' : 'Weight:',
            weightProvider.formatWeight(weightProvider.convertFromInternalWeight(workoutExercise.weight!)),
            Colors.amber[300]!,
          ),
        ],

        // Zeit
        if (workoutExercise.durationSeconds != null && workoutExercise.durationSeconds! > 0) ...[
          _buildDetailRow(
            Icons.timer,
            widget.locale == 'de' ? 'Zeit:' : 'Time:',
            _formatDuration(workoutExercise.durationSeconds!, workoutExercise.sets),
            Colors.cyan[300]!,
          ),
        ],

        // Notizen
        if (workoutExercise.note != null && workoutExercise.note!.isNotEmpty) ...[
          const SizedBox(height: 8),
          _buildDetailRow(
            Icons.note,
            widget.locale == 'de' ? 'Notizen:' : 'Notes:',
            workoutExercise.note!,
            Colors.grey[400]!,
          ),
        ],
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: Colors.grey[300], fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(int durationSeconds, int? sets) {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    final formattedTime = '${minutes}:${seconds.toString().padLeft(2, '0')}';

    if (sets != null && sets > 1) {
      final totalSeconds = durationSeconds * sets;
      final totalMinutes = totalSeconds ~/ 60;
      final totalSecondsRemainder = totalSeconds % 60;
      final totalFormattedTime = '${totalMinutes}:${totalSecondsRemainder.toString().padLeft(2, '0')}';

      return '$formattedTime × $sets ${widget.locale == 'de' ? 'Sätze' : 'sets'} = $totalFormattedTime ${widget.locale == 'de' ? 'gesamt' : 'total'}';
    }

    return formattedTime;
  }

  String _formatRepsDisplay(WorkoutExercise workoutExercise) {
    final totalReps = workoutExercise.totalReps;
    final sets = workoutExercise.sets;
    final reps = workoutExercise.reps;

    if (sets != null && sets > 1 && reps != null && reps > 0) {
      // Zeige Sätze × Wiederholungen + Gesamtanzahl
      return '$sets ${widget.locale == 'de' ? 'Sätze' : 'sets'} × $reps ${widget.locale == 'de' ? 'Wdh' : 'reps'} = $totalReps ${widget.locale == 'de' ? 'Wdh gesamt' : 'total reps'}';
    } else if (totalReps > 0) {
      // Zeige nur Gesamtanzahl wenn keine detaillierten Satz-Informationen vorhanden
      return '$totalReps ${widget.locale == 'de' ? 'Wdh gesamt' : 'total reps'}';
    }

    return '0 ${widget.locale == 'de' ? 'Wdh' : 'reps'}';
  }

  List<Map<String, dynamic>> _filterHistoryData(List<Map<String, dynamic>> historyData) {
    if (_selectedFilter == 'all') {
      return historyData;
    }

    final now = DateTime.now();
    DateTime startDate;

    switch (_selectedFilter) {
      case 'week':
        startDate = now.subtract(const Duration(days: 7));
        break;
      case 'month':
        startDate = DateTime(now.year, now.month - 1, now.day);
        break;
      case '3months':
        startDate = DateTime(now.year, now.month - 3, now.day);
        break;
      case 'year':
        startDate = DateTime(now.year - 1, now.month, now.day);
        break;
      case 'custom':
        if (_selectedDateRange == null) return historyData;
        return historyData.where((entry) {
          final workout = entry['workout'] as Workout;
          final date = workout.date;
          return date.isAfter(_selectedDateRange!.start.subtract(const Duration(days: 1))) &&
              date.isBefore(_selectedDateRange!.end.add(const Duration(days: 1)));
        }).toList();
      default:
        return historyData;
    }

    return historyData.where((entry) {
      final workout = entry['workout'] as Workout;
      return workout.date.isAfter(startDate);
    }).toList();
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800],
          title: Text(
            widget.locale == 'de' ? 'Zeitraum filtern' : 'Filter by Period',
            style: const TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFilterOption('all', widget.locale == 'de' ? 'Alle anzeigen' : 'Show All'),
              _buildFilterOption('week', widget.locale == 'de' ? 'Letzte Woche' : 'Last Week'),
              _buildFilterOption('month', widget.locale == 'de' ? 'Letzter Monat' : 'Last Month'),
              _buildFilterOption('3months', widget.locale == 'de' ? 'Letzte 3 Monate' : 'Last 3 Months'),
              _buildFilterOption('year', widget.locale == 'de' ? 'Letztes Jahr' : 'Last Year'),
              _buildFilterOption('custom', widget.locale == 'de' ? 'Benutzerdefiniert' : 'Custom Range'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                widget.locale == 'de' ? 'Abbrechen' : 'Cancel',
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterOption(String value, String label) {
    return RadioListTile<String>(
      title: Text(label, style: const TextStyle(color: Colors.white)),
      value: value,
      groupValue: _selectedFilter,
      activeColor: Colors.blue,
      onChanged: (String? newValue) async {
        if (newValue == 'custom') {
          Navigator.of(context).pop();
          final DateTimeRange? picked = await showDateRangePicker(
            context: context,
            firstDate: DateTime(2020),
            lastDate: DateTime.now(),
            initialDateRange: _selectedDateRange,
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.dark(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    surface: Color(0xFF424242),
                    onSurface: Colors.white,
                  ),
                ),
                child: child!,
              );
            },
          );
          if (picked != null) {
            setState(() {
              _selectedDateRange = picked;
              _selectedFilter = 'custom';
            });
          }
        } else {
          Navigator.of(context).pop();
          setState(() {
            _selectedFilter = newValue!;
            _selectedDateRange = null;
          });
        }
      },
    );
  }
}
