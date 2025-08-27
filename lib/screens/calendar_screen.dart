import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/workout_provider.dart';
import '../models/workout.dart';
import 'workout_details_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WorkoutProvider>().loadWorkouts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Consumer<WorkoutProvider>(
        builder: (context, workoutProvider, child) {
          if (workoutProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Simple calendar view
              Container(
                padding: const EdgeInsets.all(16),
                child: _buildCalendarView(workoutProvider),
              ),
              Divider(color: Colors.grey[600]),
              // Workouts for selected day
              Expanded(child: _buildWorkoutsForDay(workoutProvider)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCalendarView(WorkoutProvider workoutProvider) {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday;

    return Column(
      children: [
        // Month header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  _focusedDay = DateTime(
                    _focusedDay.year,
                    _focusedDay.month - 1,
                  );
                });
              },
              icon: const Icon(Icons.chevron_left, color: Colors.white),
            ),
            Text(
              '${_getMonthName(_focusedDay.month)} ${_focusedDay.year}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _focusedDay = DateTime(
                    _focusedDay.year,
                    _focusedDay.month + 1,
                  );
                });
              },
              icon: const Icon(Icons.chevron_right, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Weekday headers
        Row(
          children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
              .map(
                (day) => Expanded(
                  child: Text(
                    day,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        // Calendar grid
        ...List.generate((lastDayOfMonth.day + firstWeekday - 1) ~/ 7 + 1, (
          weekIndex,
        ) {
          return Row(
            children: List.generate(7, (dayIndex) {
              final dayNumber = weekIndex * 7 + dayIndex - firstWeekday + 1;
              final isCurrentMonth =
                  dayNumber > 0 && dayNumber <= lastDayOfMonth.day;
              final day = isCurrentMonth
                  ? DateTime(_focusedDay.year, _focusedDay.month, dayNumber)
                  : null;
              final isSelected =
                  day != null &&
                  _selectedDay != null &&
                  day.year == _selectedDay!.year &&
                  day.month == _selectedDay!.month &&
                  day.day == _selectedDay!.day;
              final isToday =
                  day != null &&
                  day.year == now.year &&
                  day.month == now.month &&
                  day.day == now.day;
              final hasWorkouts =
                  day != null &&
                  workoutProvider.getWorkoutsByDate(day).isNotEmpty;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (isCurrentMonth) {
                      setState(() {
                        _selectedDay = day;
                      });
                    }
                  },
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : isToday
                          ? Theme.of(context).colorScheme.primaryContainer
                          : hasWorkouts
                          ? Colors.blue.withOpacity(0.2)
                          : null,
                      borderRadius: BorderRadius.circular(8),
                      border: hasWorkouts && !isSelected
                          ? Border.all(
                              color: Colors.blue.withOpacity(0.6),
                              width: 2,
                            )
                          : null,
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            isCurrentMonth ? dayNumber.toString() : '',
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : isToday
                                  ? Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer
                                  : hasWorkouts
                                  ? Colors.white
                                  : Colors.white,
                              fontWeight: isToday || isSelected || hasWorkouts
                                  ? FontWeight.bold
                                  : null,
                            ),
                          ),
                        ),
                        if (hasWorkouts && !isSelected)
                          Positioned(
                            bottom: 4,
                            right: 4,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.blue[400],
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.fitness_center,
                                size: 8,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ],
    );
  }

  Widget _buildWorkoutsForDay(WorkoutProvider workoutProvider) {
    if (_selectedDay == null) {
      return Center(
        child: Text(
          'Select a day to view workouts',
          style: TextStyle(color: Colors.grey[300]),
        ),
      );
    }

    final workouts = workoutProvider.getWorkoutsByDate(_selectedDay!);

    if (workouts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No workouts on ${_formatDate(_selectedDay!)}',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey[300]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: workouts.length,
      itemBuilder: (context, index) {
        final workout = workouts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          color: Colors.grey[800],
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(Icons.sports_gymnastics, color: Colors.white),
            ),
            title: Text(
              workout.name,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              'Created: ${_formatDate(workout.createdAt)}',
              style: TextStyle(color: Colors.grey[300]),
            ),
            trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
            onTap: () {
              // Show workout details
              _showWorkoutDetails(context, workout);
            },
          ),
        );
      },
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  void _showWorkoutDetails(BuildContext context, Workout workout) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutDetailsScreen(workout: workout),
      ),
    );
  }
}
