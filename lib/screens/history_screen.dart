import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/workout_provider.dart';
import '../models/workout.dart';
import 'workout_details_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WorkoutProvider>().loadWorkouts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Consumer<WorkoutProvider>(
        builder: (context, workoutProvider, child) {
          if (workoutProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (workoutProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
                  const SizedBox(height: 16),
                  Text(
                    workoutProvider.error!,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: () => workoutProvider.loadWorkouts(), child: const Text('Wiederholen')),
                ],
              ),
            );
          }

          if (workoutProvider.workouts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noWorkoutHistoryYet,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Complete your first workout to see it here',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[300]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => workoutProvider.loadWorkouts(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: workoutProvider.workouts.length,
              itemBuilder: (context, index) {
                final workout = workoutProvider.workouts[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  color: Colors.grey[800],
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Icon(Icons.sports_gymnastics, color: Colors.white),
                    ),
                    title: Text(workout.name, style: const TextStyle(color: Colors.white)),
                    subtitle: Text(_formatDate(workout.date), style: TextStyle(color: Colors.grey[300])),
                    trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
                    onTap: () {
                      // Show workout details
                      _showWorkoutDetails(context, workout);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  void _showWorkoutDetails(BuildContext context, Workout workout) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutDetailsScreen(workout: workout)));
  }
}
