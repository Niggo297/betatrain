import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/exercise_provider.dart';
import '../providers/workout_provider.dart';
import '../providers/locale_provider.dart';
import '../models/exercise.dart';
import '../models/workout.dart';
import 'workout_details_screen.dart';
import '../widgets/workout_form.dart';
import '../widgets/exercise_form.dart';

class DashboardScreen extends StatefulWidget {
  final Function(Widget, String)? onNavigate;

  const DashboardScreen({super.key, this.onNavigate});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDashboardData();
    });
  }

  Future<void> _loadDashboardData() async {
    final exerciseProvider = context.read<ExerciseProvider>();
    final workoutProvider = context.read<WorkoutProvider>();

    await exerciseProvider.loadExercises();
    await workoutProvider.loadWorkouts();

    // Lade alle WorkoutExercises für Statistiken
    for (final workout in workoutProvider.workouts) {
      await workoutProvider.loadWorkoutExercises(workout.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Begrüßung
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                locale == 'de'
                                    ? 'Willkommen zurück!'
                                    : 'Welcome back!',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                locale == 'de'
                                    ? 'Bereit für dein nächstes Training?'
                                    : 'Ready for your next workout?',
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                              ),
                            ],
                          ),
                        ),
                        // Sprach-Umschalter
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildLanguageButton('DE', 'de'),
                              _buildLanguageButton('EN', 'en'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Quick Actions
              _buildQuickActions(context, l10n),
              const SizedBox(height: 24),

              // Statistiken
              _buildStatsSection(context, l10n),
              const SizedBox(height: 24),

              // Letztes Training
              _buildLastWorkout(context, l10n, locale),
              const SizedBox(height: 24),

              // Beliebte Übungen
              _buildPopularExercises(context, l10n, locale),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.quickAccess,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            // Erst bei wirklich sehr schmalen Bildschirmen wrappen (< 260px)
            final shouldWrap = constraints.maxWidth < 260;

            if (!shouldWrap) {
              return Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      context,
                      icon: Icons.add_circle,
                      title: l10n.newWorkout,
                      subtitle: l10n.createWorkout,
                      color: Colors.blue,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => const WorkoutForm(),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionCard(
                      context,
                      icon: Icons.fitness_center,
                      title: l10n.newExercise,
                      subtitle: l10n.addExerciseSubtitle,
                      color: Colors.green,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => const ExerciseForm(),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 220),
                    child: _buildActionCard(
                      context,
                      icon: Icons.add_circle,
                      title: l10n.newWorkout,
                      subtitle: l10n.createWorkout,
                      color: Colors.blue,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => const WorkoutForm(),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 220),
                    child: _buildActionCard(
                      context,
                      icon: Icons.fitness_center,
                      title: l10n.newExercise,
                      subtitle: l10n.addExerciseSubtitle,
                      color: Colors.green,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => const ExerciseForm(),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Progressive Verkleinerung basierend auf verfügbarem Platz
        final width = constraints.maxWidth;

        // Sehr kompakt unter 140px, kompakt unter 180px, normal darüber
        final isVeryCompact = width < 140;
        final isCompact = width < 180;

        final iconSize = isVeryCompact ? 24.0 : (isCompact ? 30.0 : 36.0);
        final padding = isVeryCompact ? 12.0 : (isCompact ? 16.0 : 20.0);
        final iconPadding = isVeryCompact ? 8.0 : (isCompact ? 12.0 : 16.0);
        final spacing = isVeryCompact ? 8.0 : (isCompact ? 12.0 : 16.0);
        final titleSize = isVeryCompact ? 14.0 : (isCompact ? 16.0 : 18.0);
        final subtitleSize = isVeryCompact ? 12.0 : (isCompact ? 13.0 : 14.0);

        return Card(
          elevation: 2,
          shadowColor: color.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(padding),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[800],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(iconPadding),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, size: iconSize, color: color),
                  ),
                  SizedBox(height: spacing),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: titleSize,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[300],
                      fontSize: subtitleSize,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget _buildStatsSection(BuildContext context, AppLocalizations l10n) {
  return Consumer2<ExerciseProvider, WorkoutProvider>(
    builder: (context, exerciseProvider, workoutProvider, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.yourProgress,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              // Erst bei wirklich sehr schmalen Bildschirmen wrappen (< 260px)
              final shouldWrap = constraints.maxWidth < 260;

              if (!shouldWrap) {
                return Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        title: l10n.completedWorkouts,
                        value: workoutProvider.workouts.length.toString(),
                        icon: Icons.sports_gymnastics,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        title: l10n.availableExercises,
                        value: exerciseProvider.exercises.length.toString(),
                        icon: Icons.fitness_center,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 220),
                      child: _buildStatCard(
                        context,
                        title: l10n.completedWorkouts,
                        value: workoutProvider.workouts.length.toString(),
                        icon: Icons.sports_gymnastics,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 220),
                      child: _buildStatCard(
                        context,
                        title: l10n.availableExercises,
                        value: exerciseProvider.exercises.length.toString(),
                        icon: Icons.fitness_center,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      );
    },
  );
}

Widget _buildStatCard(
  BuildContext context, {
  required String title,
  required String value,
  required IconData icon,
  required Color color,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      // Progressive Verkleinerung basierend auf verfügbarem Platz
      final width = constraints.maxWidth;

      // Sehr kompakt unter 120px, kompakt unter 160px, normal darüber
      final isVeryCompact = width < 120;
      final isCompact = width < 160;

      final padding = isVeryCompact ? 12.0 : (isCompact ? 16.0 : 20.0);
      final iconSize = isVeryCompact ? 20.0 : (isCompact ? 24.0 : 28.0);
      final iconPadding = isVeryCompact ? 8.0 : (isCompact ? 12.0 : 14.0);
      final valueSize = isVeryCompact ? 20.0 : (isCompact ? 24.0 : 28.0);
      final titleSize = isVeryCompact ? 12.0 : (isCompact ? 14.0 : 16.0);
      final spacing = isVeryCompact ? 8.0 : (isCompact ? 10.0 : 12.0);

      return Card(
        elevation: 2,
        shadowColor: color.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[800],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(iconPadding),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: iconSize, color: color),
              ),
              SizedBox(height: spacing),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: valueSize,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[300],
                  fontWeight: FontWeight.w500,
                  fontSize: titleSize,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildLastWorkout(
  BuildContext context,
  AppLocalizations l10n,
  String locale,
) {
  return Consumer<WorkoutProvider>(
    builder: (context, workoutProvider, child) {
      final lastWorkout = workoutProvider.workouts.isNotEmpty
          ? workoutProvider.workouts.first
          : null;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.lastWorkout,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          if (lastWorkout == null)
            Card(
              color: Colors.grey[800],
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.sports_gymnastics_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Noch kein Training absolviert',
                        style: TextStyle(color: Colors.grey[300], fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Beginne mit deinem ersten Training!',
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            _buildWorkoutCard(context, lastWorkout),
        ],
      );
    },
  );
}

Widget _buildWorkoutCard(BuildContext context, Workout workout) {
  return Card(
    margin: const EdgeInsets.only(bottom: 8),
    elevation: 2,
    shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => WorkoutDetailsScreen(workout: workout),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[800],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.sports_gymnastics,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${workout.date.day}.${workout.date.month}.${workout.date.year}',
                    style: TextStyle(color: Colors.grey[300], fontSize: 14),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).colorScheme.primary,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildPopularExercises(
  BuildContext context,
  AppLocalizations l10n,
  String locale,
) {
  return Consumer2<ExerciseProvider, WorkoutProvider>(
    builder: (context, exerciseProvider, workoutProvider, child) {
      final mostUsedStats = workoutProvider.getMostUsedExercises();

      // Sortiere Übungen nach Häufigkeit der Nutzung
      final sortedExerciseIds = mostUsedStats.keys.toList()
        ..sort(
          (a, b) => (mostUsedStats[b]!['count'] as int).compareTo(
            mostUsedStats[a]!['count'] as int,
          ),
        );

      final topExercises = <Exercise>[];
      for (final exerciseId in sortedExerciseIds.take(4)) {
        final exercise = exerciseProvider.exercises
            .where((e) => e.id == exerciseId)
            .firstOrNull;
        if (exercise != null) {
          topExercises.add(exercise);
        }
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.mostUsedExercises,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          if (topExercises.isEmpty)
            Card(
              color: Colors.grey[800],
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.fitness_center_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Noch keine Übungen in Trainings verwendet',
                        style: TextStyle(color: Colors.grey[300], fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Erstelle ein Training und füge Übungen hinzu!',
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: topExercises.map((exercise) {
                final stats = mostUsedStats[exercise.id]!;
                return SizedBox(
                  width:
                      (MediaQuery.of(context).size.width - 56) /
                      2, // 56 = padding (16*2) + spacing (12*2) + gap (12)
                  height:
                      180, // Further increased height for better readability
                  child: _buildExerciseCardWithStats(
                    context,
                    exercise,
                    locale,
                    stats,
                  ),
                );
              }).toList(),
            ),
        ],
      );
    },
  );
}

Widget _buildExerciseCardWithStats(
  BuildContext context,
  Exercise exercise,
  String locale,
  Map<String, dynamic> stats,
) {
  return Card(
    elevation: 4,
    shadowColor: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: InkWell(
      onTap: () {
        // TODO: Navigate to exercise details or add to workout
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[800],
        ),
        child: Column(
          children: [
            // Icon Container - kompakter
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.fitness_center,
                size: 20,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 8),

            // Exercise Name - mehr Platz
            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  exercise.getName(locale),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            // Statistics - kompakter
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${stats['count']}x verwendet',
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildLanguageButton(String language, String code) {
  return Builder(
    builder: (context) {
      final isActive = Localizations.localeOf(context).languageCode == code;
      final localeProvider = Provider.of<LocaleProvider>(
        context,
        listen: false,
      );

      return GestureDetector(
        onTap: () {
          localeProvider.setLocale(Locale(code, ''));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Language changed to $language'),
              backgroundColor: Colors.grey[800],
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? Colors.blue : Colors.grey[800],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isActive ? Colors.blue : Colors.grey[600]!,
              width: 1,
            ),
          ),
          child: Text(
            language,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey[400],
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      );
    },
  );
}
