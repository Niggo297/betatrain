// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Training App';

  @override
  String get exercises => 'Exercises';

  @override
  String get workouts => 'Workouts';

  @override
  String get emoms => 'EMOMs';

  @override
  String get history => 'History';

  @override
  String get calendar => 'Calendar';

  @override
  String get settings => 'Settings';

  @override
  String get counter => 'Counter';

  @override
  String get statistics => 'Statistics';

  @override
  String get addExercise => 'Add Exercise';

  @override
  String get addWorkout => 'Add Workout';

  @override
  String get editExercise => 'Edit Exercise';

  @override
  String get editWorkout => 'Edit Workout';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get name => 'Name';

  @override
  String get description => 'Description';

  @override
  String sets(int count) {
    return '$count sets';
  }

  @override
  String reps(int count) {
    return '$count reps';
  }

  @override
  String get weight => 'Weight (kg)';

  @override
  String get duration => 'Duration';

  @override
  String get note => 'Note';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get selectExercise => 'Select Exercise';

  @override
  String get noExercises => 'No exercises yet';

  @override
  String get noWorkouts => 'No workouts yet';

  @override
  String get createYourFirstExercise => 'Create your first exercise to get started';

  @override
  String get createYourFirstWorkout => 'Create your first workout to get started';

  @override
  String get exerciseName => 'Exercise name';

  @override
  String get exerciseDescriptionEn => 'Exercise Description (English)';

  @override
  String get exerciseDescriptionDe => 'Exercise Description (German)';

  @override
  String get workoutName => 'Workout Name';

  @override
  String get workoutDate => 'Workout Date';

  @override
  String get addExerciseToWorkout => 'Add Exercise to Workout';

  @override
  String get workoutDetails => 'Workout Details';

  @override
  String get exerciseDetails => 'Exercise Details';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get deleteExerciseMessage => 'Are you sure you want to delete this exercise?';

  @override
  String get deleteWorkoutMessage => 'Are you sure you want to delete this workout?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get minutes => 'Minutes';

  @override
  String get seconds => 'seconds';

  @override
  String get kg => 'kg';

  @override
  String get lbs => 'lbs';

  @override
  String get weightUnit => 'Weight Unit';

  @override
  String get weightUnitKg => 'Kilogram (kg)';

  @override
  String get weightUnitLbs => 'Pound (lbs)';

  @override
  String get setsLabel => 'Sets';

  @override
  String get repsLabel => 'Repetitions';

  @override
  String get durationLabel => 'Duration';

  @override
  String get weightLabel => 'Weight';

  @override
  String get noteLabel => 'Note (optional)';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get noWorkoutsOnDate => 'No workouts on this date';

  @override
  String workoutsOnDate(Object date) {
    return 'Workouts on $date';
  }

  @override
  String totalWorkouts(int count) {
    return 'Total workouts: $count';
  }

  @override
  String get recentWorkouts => 'Recent Workouts';

  @override
  String get allWorkouts => 'All Workouts';

  @override
  String get filterByDate => 'Filter by Date';

  @override
  String get clearFilter => 'Clear Filter';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get german => 'German';

  @override
  String get theme => 'Theme';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get help => 'Help';

  @override
  String get howToUse => 'How to Use';

  @override
  String get howToUseDescription => '1. Create exercises with names and descriptions\n2. Create workouts and add exercises to them\n3. Track your progress in the history and calendar';

  @override
  String get contact => 'Contact';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get logout => 'Logout';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get welcome => 'Welcome to Training App';

  @override
  String get welcomeDescription => 'Track your workouts and exercises with ease';

  @override
  String get getStarted => 'Get Started';

  @override
  String get retry => 'Retry';

  @override
  String get quickAccess => 'Quick Access';

  @override
  String get newWorkout => 'New Workout';

  @override
  String get newExercise => 'New Exercise';

  @override
  String get yourProgress => 'Your Progress';

  @override
  String get completedWorkouts => 'Completed Workouts';

  @override
  String get availableExercises => 'Available Exercises';

  @override
  String get lastWorkout => 'Last Workout';

  @override
  String get mostUsedExercises => 'Most Used Exercises';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get createWorkout => 'Create workout';

  @override
  String get addExerciseSubtitle => 'Add exercise';

  @override
  String get fitnessCompanion => 'Your Fitness Companion';

  @override
  String get searchExercise => 'Search exercise...';

  @override
  String get pleaseEnterExerciseName => 'Please enter an exercise name';

  @override
  String get editExerciseTitle => 'Edit Exercise';

  @override
  String get newExerciseTitle => 'New Exercise';

  @override
  String get editWorkoutTitle => 'Edit Workout';

  @override
  String get newWorkoutTitle => 'New Workout';

  @override
  String get workoutNameLabel => 'Workout name';

  @override
  String get editExerciseTooltip => 'Edit exercise';

  @override
  String get deleteExerciseTooltip => 'Delete exercise';

  @override
  String selectedExercise(String name) {
    return 'Selected: $name';
  }

  @override
  String get selectExerciseError => 'Please select an exercise';

  @override
  String get autoCalculatedSets => 'Automatically calculated for variable reps';

  @override
  String get repsPerSetLabel => 'Repetitions per set (optional)';

  @override
  String get repsPerSetHint => 'e.g. 20, 15, 12, 8';

  @override
  String get repsPerSetHelper => 'Comma-separated list for different reps per set (sets will be calculated automatically)';

  @override
  String get invalidRepsFormat => 'Invalid format. Use: 20, 15, 12, 8';

  @override
  String get selectExerciseFirst => 'Please select an exercise first';

  @override
  String get editWorkoutTooltip => 'Edit workout';

  @override
  String get deleteWorkoutTooltip => 'Delete workout';

  @override
  String get workoutOverview => 'Workout Overview';

  @override
  String get totalReps => 'Total Reps';

  @override
  String get totalSets => 'Total Sets';

  @override
  String get exercisesLabel => 'Exercises';

  @override
  String get repCounter => 'Rep Counter';

  @override
  String get countRepsUnlimited => 'Count your repetitions without limit';

  @override
  String get chooseStepSize => 'Choose step size:';

  @override
  String currentClickValue(int value) {
    return 'Current: +$value per click';
  }

  @override
  String undoAction(String action, int value) {
    return 'Undo: $action (was $value)';
  }

  @override
  String get lastActions => 'Recent actions:';

  @override
  String historyEntry(String action, int value) {
    return '$action → was $value';
  }

  @override
  String get counterInstructions => 'Choose your step size and tap the green button\nPerfect for sets: 1s for single reps, 10s/20s for whole sets';

  @override
  String get trainingStatistics => 'Your Training Statistics';

  @override
  String get progressOverview => 'Overview of your progress';

  @override
  String get generalOverview => 'General Overview';

  @override
  String get avgRepsPerWorkout => 'Avg Reps / Workout';

  @override
  String get exerciseRanking => 'Exercise Ranking';

  @override
  String get noExercisesUsed => 'No exercises used yet';

  @override
  String get createWorkoutHint => 'Create a workout and add exercises!';

  @override
  String timesUsed(int count) {
    return '${count}x used';
  }

  @override
  String get exportData => 'Export Data';

  @override
  String get exportDataSubtitle => 'Export your training data';

  @override
  String get dataStatistics => 'Data Statistics';

  @override
  String get dataStatisticsSubtitle => 'Show overview of your data';

  @override
  String get dataStorage => 'Data Storage';

  @override
  String get dataStorageSubtitle => 'All data is stored locally on your device';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get exportDataDialog => 'Export Data';

  @override
  String get chooseExportFormat => 'Choose export format:';

  @override
  String get jsonExport => 'JSON Export';

  @override
  String get csvExport => 'CSV Export';

  @override
  String get dataStatisticsDialog => 'Data Statistics';

  @override
  String totalExercises(int count) {
    return 'Total exercises: $count';
  }

  @override
  String userExercises(int count) {
    return 'User exercises: $count';
  }

  @override
  String predefinedExercises(int count) {
    return 'Predefined exercises: $count';
  }

  @override
  String exercisesInWorkouts(int count) {
    return 'Exercises in workouts: $count';
  }

  @override
  String asOf(String date) {
    return 'As of: $date';
  }

  @override
  String get close => 'Close';

  @override
  String get appDescription => 'A local training app for managing your exercises and workouts. All data is stored securely on your device.';

  @override
  String get localStorage => 'Local Storage';

  @override
  String get storageFeatures => '• All your data is stored locally on your device\n• No cloud synchronization\n• Full control over your data\n• Export functions available for backups';

  @override
  String get advantages => 'Advantages:';

  @override
  String get storageAdvantages => '• Privacy protection\n• Offline availability\n• Fast performance\n• No internet connection required';

  @override
  String get understood => 'Understood';

  @override
  String get jsonExportSuccess => 'JSON export successfully shared!';

  @override
  String get csvExportSuccess => 'CSV export successfully shared!';

  @override
  String jsonExportError(String error) {
    return 'Error during JSON export: $error';
  }

  @override
  String csvExportError(String error) {
    return 'Error during CSV export: $error';
  }

  @override
  String statisticsLoadError(String error) {
    return 'Error loading statistics: $error';
  }

  @override
  String get workoutCreatedSuccessfully => 'Workout created successfully';

  @override
  String get workoutUpdatedSuccessfully => 'Workout updated successfully';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get noExercisesInWorkout => 'No exercises in this workout yet';

  @override
  String get addFirstExerciseToWorkout => 'Add your first exercise to get started';

  @override
  String get savedEmomTrainings => 'Saved EMOM Trainings';

  @override
  String get quickStart => 'Quick Start';

  @override
  String get createEmom => 'Create EMOM';

  @override
  String get startEmom => 'Start EMOM';

  @override
  String get editEmom => 'Edit';

  @override
  String get deleteEmom => 'Delete';

  @override
  String get deleteEmomTitle => 'Delete EMOM';

  @override
  String deleteEmomConfirm(Object emomName) {
    return 'Do you really want to delete \"$emomName\"?';
  }

  @override
  String get emomQuickStart => 'EMOM Quick Start';

  @override
  String get emomQuickStartDescription => 'Start an EMOM immediately without defining exercises.';

  @override
  String get desiredTime => 'Desired Time';

  @override
  String get intervalSeconds => 'Interval (Seconds)';

  @override
  String get start => 'Start';

  @override
  String get noEmomsYet => 'No EMOMs yet';

  @override
  String get createFirstEmom => 'Create your first EMOM to get started';
}
