import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/exercise.dart';
import '../providers/exercise_provider.dart';
import '../providers/workout_provider.dart';
import '../providers/weight_unit_provider.dart';
import 'exercise_history_screen.dart';

class PremiumStatisticsScreen extends StatefulWidget {
  const PremiumStatisticsScreen({super.key});

  @override
  State<PremiumStatisticsScreen> createState() => _PremiumStatisticsScreenState();
}

class _PremiumStatisticsScreenState extends State<PremiumStatisticsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: Text(locale == 'de' ? 'Statistiken' : 'Statistics', style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Suchfeld
          Padding(padding: const EdgeInsets.all(20), child: _buildSearchField(context, locale)),

          // Alle Übungen mit kombinierter Statistik
          Expanded(child: _buildAllExercisesTab(context, locale)),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context, String locale) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(10)),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: locale == 'de' ? 'Übungen suchen...' : 'Search exercises...',
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value.toLowerCase();
          });
        },
      ),
    );
  }

  Widget _buildAllExercisesTab(BuildContext context, String locale) {
    return Consumer2<WorkoutProvider, ExerciseProvider>(
      builder: (context, workoutProvider, exerciseProvider, child) {
        final exerciseStats = workoutProvider.getMostUsedExercises();
        final Map<String, Map<String, dynamic>> allExercises = {};

        exerciseStats.forEach((exerciseId, stats) {
          final exercise = exerciseProvider.exercises.where((e) => e.id == exerciseId).firstOrNull;

          if (exercise != null && _exerciseMatchesSearch(exercise, locale)) {
            final usageCount = (stats['count'] as int?) ?? 0;

            if (usageCount >= 1) {
              allExercises[exerciseId] = {
                'exercise': exercise,
                'maxRepsWithWeight': (stats['maxRepsWithWeight'] as int?) ?? 0,
                'maxRepsBodyweight': (stats['maxRepsBodyweight'] as int?) ?? 0,
                'maxWeight': (stats['maxWeight'] as double?) ?? 0.0,
                'totalReps': (stats['totalReps'] as int?) ?? 0,
                'totalSets': (stats['totalSets'] as int?) ?? 0,
                'totalTime': (stats['totalTime'] as int?) ?? 0,
                'maxTime': (stats['maxTime'] as int?) ?? 0,
                'usageCount': usageCount,
                'allTotalReps': (stats['allTotalReps'] as List<int>?) ?? <int>[],
                'allTrainingReps': (stats['allTrainingReps'] as List<int>?) ?? <int>[],
                'allWeightedReps': (stats['allWeightedReps'] as List<int>?) ?? <int>[],
                'allBodyweightReps': (stats['allBodyweightReps'] as List<int>?) ?? <int>[],
                'allTimeVolumes': (stats['allTimeVolumes'] as List<int>?) ?? <int>[],
                'allSingleTimes': (stats['allSingleTimes'] as List<int>?) ?? <int>[],
                'timeSetsPairs': (stats['timeSetsPairs'] as List<Map<String, dynamic>>?) ?? <Map<String, dynamic>>[],
                'weightRepsPairs':
                    (stats['weightRepsPairs'] as List<Map<String, dynamic>>?) ?? <Map<String, dynamic>>[],
              };
            }
          }
        });

        // Sortiere nach Nutzungshäufigkeit
        final sortedExercises = allExercises.entries.toList()
          ..sort((a, b) => (b.value['usageCount'] as int).compareTo(a.value['usageCount'] as int));

        if (sortedExercises.isEmpty) {
          return Center(
            child: Text(
              locale == 'de' ? 'Keine Übungsdaten verfügbar' : 'No exercise data available',
              style: const TextStyle(color: Colors.white70, fontSize: 18),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: sortedExercises.length,
          itemBuilder: (context, index) {
            final entry = sortedExercises[index];
            final exercise = entry.value['exercise'] as Exercise;
            final data = entry.value;

            return _buildExerciseStatisticsCard(context, exercise, data, locale);
          },
        );
      },
    );
  }

  Widget _buildExerciseStatisticsCard(
    BuildContext context,
    Exercise exercise,
    Map<String, dynamic> data,
    String locale,
  ) {
    final maxRepsWithWeight = data['maxRepsWithWeight'] as int;
    final maxRepsBodyweight = data['maxRepsBodyweight'] as int;
    final maxWeight = data['maxWeight'] as double;
    final totalReps = data['totalReps'] as int;
    final totalTime = data['totalTime'] as int;
    final maxTime = data['maxTime'] as int;
    final usageCount = data['usageCount'] as int;

    // Bestimme den Haupttyp der Übung
    final weightThreshold = 5.0;
    final hasWeightData = maxWeight > weightThreshold;
    final hasBodyweightData = maxRepsBodyweight > 0;
    final isTimeBased = maxTime > 0;

    return Card(
      color: Colors.grey[800],
      margin: const EdgeInsets.only(bottom: 16),
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Übungsname und Icon
              Row(
                children: [
                  Icon(Icons.fitness_center, color: Colors.blue, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      exercise.getName(locale),
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Detaillierte Statistiken
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bester Satz (ohne Gewicht) - zeige wenn Bodyweight-Daten vorhanden
                  if (hasBodyweightData) ...[
                    _buildDetailedStatRow(
                      locale == 'de' ? 'Bester Satz (Körpergew. ):' : 'Best Set (bodyweight):',
                      '$maxRepsBodyweight ${locale == 'de' ? 'Wdh' : 'reps'}',
                      Colors.blue,
                      Icons.trending_up,
                    ),

                    const SizedBox(height: 10),
                  ],

                  // Höchstes Gewicht - zeige wenn Gewichtsdaten vorhanden
                  if (hasWeightData) ...[
                    _buildDetailedStatRow(
                      locale == 'de' ? 'Höchstes Gewicht:' : 'Highest Weight:',
                      '${context.read<WeightUnitProvider>().formatWeight(context.read<WeightUnitProvider>().convertFromInternalWeight(maxWeight)).replaceAll(' kg', '').replaceAll(' lbs', '')} ${context.read<WeightUnitProvider>().weightUnitString} × $maxRepsWithWeight ${locale == 'de' ? 'Wdh' : 'reps'}',
                      Colors.amber,
                      Icons.fitness_center,
                    ),

                    const SizedBox(height: 10),
                  ],

                  // Bestes Volumen - getrennt für gewichtete und Körpergewichtsübungen
                  if (hasWeightData) ...[
                    _buildDetailedStatRow(
                      locale == 'de' ? 'Bestes Volumen (Gewicht):' : 'Best Volume (Weighted):',
                      _formatBestWeightedVolume(data, locale),
                      Colors.purple[300]!,
                      Icons.bar_chart,
                    ),
                    const SizedBox(height: 10),
                  ],

                  if (hasBodyweightData) ...[
                    _buildDetailedStatRow(
                      locale == 'de' ? 'Bestes Volumen (Körpergew.):' : 'Best Volume (Bodyweight):',
                      _formatBestBodyweightVolume(data, locale),
                      Colors.deepPurple[300]!,
                      Icons.bar_chart_outlined,
                    ),
                    const SizedBox(height: 10),
                  ],

                  // Meiste Wiederholungen in einem Training - nur anzeigen wenn Daten vorhanden
                  if (_hasValidTrainingData(data)) ...[
                    _buildDetailedStatRow(
                      locale == 'de' ? 'Meiste Wdh. pro Training:' : 'Most Reps per Workout:',
                      _formatBestTraining(data, locale),
                      Colors.orange,
                      Icons.emoji_events,
                    ),

                    const SizedBox(height: 10),
                  ],

                  // Beste Zeit (nur bei zeitbasierten Übungen und > 0)
                  if (isTimeBased && maxTime > 0) ...[
                    _buildDetailedStatRow(
                      locale == 'de' ? 'Beste Zeit:' : 'Best Time:',
                      _formatBestTime(maxTime, locale),
                      Colors.cyan,
                      Icons.timer,
                    ),

                    const SizedBox(height: 10),
                  ],

                  // Bestes Zeit-Volumen (nur bei zeitbasierten Übungen)
                  if (isTimeBased && _hasValidTimeVolumeData(data)) ...[
                    _buildDetailedStatRow(
                      locale == 'de' ? 'Bestes Zeit-Volumen:' : 'Best Time Volume:',
                      _formatBestTimeVolume(data, locale),
                      Colors.teal,
                      Icons.hourglass_full,
                    ),

                    const SizedBox(height: 10),
                  ],

                  // Gesamt Wiederholungen - nur anzeigen wenn > 0
                  if (totalReps > 0) ...[
                    _buildDetailedStatRow(
                      locale == 'de' ? 'Gesamt Wdh:' : 'Total Reps:',
                      '$totalReps ${locale == 'de' ? 'Wdh' : 'reps'} (${usageCount}x ${locale == 'de' ? 'trainiert' : 'trained'})',
                      Colors.green,
                      Icons.repeat,
                    ),
                  ],

                  // Dauer insgesamt (nur bei zeitbasierten Übungen und > 0)
                  if (isTimeBased && totalTime > 0) ...[
                    _buildDetailedStatRow(
                      locale == 'de' ? 'Dauer insgesamt:' : 'Total Duration:',
                      _formatTotalTime(totalTime, locale),
                      Colors.indigo[300]!,
                      Icons.access_time,
                    ),
                  ],
                ],
              ),

              // History über Übung ansehen Button
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => _showExerciseHistory(context, exercise, locale),
                  icon: const Icon(Icons.timeline, size: 18),
                  label: Text(
                    locale == 'de' ? 'History über Übung ansehen' : 'View Exercise History',
                    style: const TextStyle(fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailedStatRow(String label, String value, Color color, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: Colors.grey[300], fontSize: 15),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool _exerciseMatchesSearch(Exercise exercise, String locale) {
    if (_searchQuery.isEmpty) return true;
    return exercise.getName(locale).toLowerCase().contains(_searchQuery);
  }

  // Hilfsmethoden für erweiterte Statistiken
  String _formatBestWeightedVolume(Map<String, dynamic> data, String locale) {
    final weightRepsPairs = data['weightRepsPairs'] as List<Map<String, dynamic>>;
    if (weightRepsPairs.isEmpty) return '0 ${locale == 'de' ? 'Wdh' : 'reps'}';

    // Finde das beste Volumen (höchste totalReps) mit dem dazugehörigen Gewicht
    var bestPair = weightRepsPairs.first;
    var bestVolume = bestPair['totalReps'] as int;

    for (final pair in weightRepsPairs) {
      final totalReps = pair['totalReps'] as int;
      if (totalReps > bestVolume) {
        bestVolume = totalReps;
        bestPair = pair;
      }
    }

    final weight = bestPair['weight'] as double;
    final weightProvider = context.read<WeightUnitProvider>();
    final formattedWeight = weightProvider.formatWeight(weightProvider.convertFromInternalWeight(weight));

    return '$bestVolume ${locale == 'de' ? 'Wdh' : 'reps'} × $formattedWeight';
  }

  String _formatBestBodyweightVolume(Map<String, dynamic> data, String locale) {
    final allBodyweightReps = data['allBodyweightReps'] as List<int>;
    if (allBodyweightReps.isEmpty) return '0 ${locale == 'de' ? 'Wdh' : 'reps'}';

    final bestVolume = allBodyweightReps.reduce((a, b) => a > b ? a : b);
    return '$bestVolume ${locale == 'de' ? 'Wdh' : 'reps'}';
  }

  bool _hasValidTrainingData(Map<String, dynamic> data) {
    final allTrainingReps = data['allTrainingReps'] as List<int>;
    return allTrainingReps.isNotEmpty && allTrainingReps.any((reps) => reps > 0);
  }

  bool _hasValidTimeVolumeData(Map<String, dynamic> data) {
    final allTimeVolumes = data['allTimeVolumes'] as List<int>;
    return allTimeVolumes.isNotEmpty && allTimeVolumes.any((time) => time > 0);
  }

  String _formatBestTimeVolume(Map<String, dynamic> data, String locale) {
    final timeSetsPairs = data['timeSetsPairs'] as List<Map<String, dynamic>>;
    if (timeSetsPairs.isEmpty) return '0:00';

    // Finde das beste Zeitvolumen (längste Gesamtzeit)
    var bestPair = timeSetsPairs.first;
    for (final pair in timeSetsPairs) {
      if ((pair['totalTime'] as int) > (bestPair['totalTime'] as int)) {
        bestPair = pair;
      }
    }

    final totalTime = bestPair['totalTime'] as int;
    final sets = bestPair['sets'] as int;
    final singleTime = bestPair['singleTime'] as int;

    final totalMinutes = totalTime ~/ 60;
    final totalSeconds = totalTime % 60;
    final singleMinutes = singleTime ~/ 60;
    final singleSecondsFormatted = singleTime % 60;

    final singleTimeStr = '${singleMinutes}:${singleSecondsFormatted.toString().padLeft(2, '0')}';
    final totalTimeStr = '${totalMinutes}:${totalSeconds.toString().padLeft(2, '0')}';

    if (locale == 'de') {
      return '$totalTimeStr ($singleTimeStr × ${sets} Sätze)';
    } else {
      return '$totalTimeStr ($singleTimeStr × $sets sets)';
    }
  }

  String _formatBestTraining(Map<String, dynamic> data, String locale) {
    final allTrainingReps = data['allTrainingReps'] as List<int>;
    if (allTrainingReps.isEmpty) return '0 ${locale == 'de' ? 'Wdh' : 'reps'}';

    final bestTrainingReps = allTrainingReps.reduce((a, b) => a > b ? a : b);
    final averageTrainingReps = allTrainingReps.reduce((a, b) => a + b) / allTrainingReps.length;
    final avgText = locale == 'de' ? 'Ø' : 'Avg';
    return '$bestTrainingReps ${locale == 'de' ? 'Wdh' : 'reps'} ($avgText: ${averageTrainingReps.round()})';
  }

  String _formatBestTime(int maxTimeSeconds, String locale) {
    if (maxTimeSeconds <= 0) return '0:00';

    final minutes = maxTimeSeconds ~/ 60;
    final seconds = maxTimeSeconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _formatTotalTime(int totalTimeSeconds, String locale) {
    if (totalTimeSeconds <= 0) return '0:00';

    final hours = totalTimeSeconds ~/ 3600;
    final minutes = (totalTimeSeconds % 3600) ~/ 60;
    final seconds = totalTimeSeconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '0:${seconds.toString().padLeft(2, '0')}';
    }
  }

  void _showExerciseHistory(BuildContext context, Exercise exercise, String locale) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseHistoryScreen(exercise: exercise, locale: locale),
      ),
    );
  }
}
