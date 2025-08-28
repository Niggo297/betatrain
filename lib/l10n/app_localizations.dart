import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('de'), Locale('en')];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Training App'**
  String get appTitle;

  /// No description provided for @exercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get exercises;

  /// No description provided for @workouts.
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get workouts;

  /// No description provided for @emoms.
  ///
  /// In en, this message translates to:
  /// **'EMOMs'**
  String get emoms;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @counter.
  ///
  /// In en, this message translates to:
  /// **'Counter'**
  String get counter;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @addExercise.
  ///
  /// In en, this message translates to:
  /// **'Add Exercise'**
  String get addExercise;

  /// No description provided for @addWorkout.
  ///
  /// In en, this message translates to:
  /// **'Add Workout'**
  String get addWorkout;

  /// No description provided for @editExercise.
  ///
  /// In en, this message translates to:
  /// **'Edit Exercise'**
  String get editExercise;

  /// No description provided for @editWorkout.
  ///
  /// In en, this message translates to:
  /// **'Edit Workout'**
  String get editWorkout;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @sets.
  ///
  /// In en, this message translates to:
  /// **'{count} sets'**
  String sets(int count);

  /// No description provided for @reps.
  ///
  /// In en, this message translates to:
  /// **'{count} reps'**
  String reps(int count);

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weight;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @selectExercise.
  ///
  /// In en, this message translates to:
  /// **'Select Exercise'**
  String get selectExercise;

  /// No description provided for @noExercises.
  ///
  /// In en, this message translates to:
  /// **'No exercises yet'**
  String get noExercises;

  /// No description provided for @noWorkouts.
  ///
  /// In en, this message translates to:
  /// **'No workouts yet'**
  String get noWorkouts;

  /// No description provided for @createYourFirstExercise.
  ///
  /// In en, this message translates to:
  /// **'Create your first exercise to get started'**
  String get createYourFirstExercise;

  /// No description provided for @createYourFirstWorkout.
  ///
  /// In en, this message translates to:
  /// **'Create your first workout to get started'**
  String get createYourFirstWorkout;

  /// No description provided for @exerciseName.
  ///
  /// In en, this message translates to:
  /// **'Exercise name'**
  String get exerciseName;

  /// No description provided for @exerciseDescriptionEn.
  ///
  /// In en, this message translates to:
  /// **'Exercise Description (English)'**
  String get exerciseDescriptionEn;

  /// No description provided for @exerciseDescriptionDe.
  ///
  /// In en, this message translates to:
  /// **'Exercise Description (German)'**
  String get exerciseDescriptionDe;

  /// No description provided for @workoutName.
  ///
  /// In en, this message translates to:
  /// **'Workout Name'**
  String get workoutName;

  /// No description provided for @workoutDate.
  ///
  /// In en, this message translates to:
  /// **'Workout Date'**
  String get workoutDate;

  /// No description provided for @addExerciseToWorkout.
  ///
  /// In en, this message translates to:
  /// **'Add Exercise to Workout'**
  String get addExerciseToWorkout;

  /// No description provided for @workoutDetails.
  ///
  /// In en, this message translates to:
  /// **'Workout Details'**
  String get workoutDetails;

  /// No description provided for @exerciseDetails.
  ///
  /// In en, this message translates to:
  /// **'Exercise Details'**
  String get exerciseDetails;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// No description provided for @deleteExerciseMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this exercise?'**
  String get deleteExerciseMessage;

  /// No description provided for @deleteWorkoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this workout?'**
  String get deleteWorkoutMessage;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get seconds;

  /// No description provided for @kg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get kg;

  /// No description provided for @lbs.
  ///
  /// In en, this message translates to:
  /// **'lbs'**
  String get lbs;

  /// No description provided for @weightUnit.
  ///
  /// In en, this message translates to:
  /// **'Weight Unit'**
  String get weightUnit;

  /// No description provided for @weightUnitKg.
  ///
  /// In en, this message translates to:
  /// **'Kilogram (kg)'**
  String get weightUnitKg;

  /// No description provided for @weightUnitLbs.
  ///
  /// In en, this message translates to:
  /// **'Pound (lbs)'**
  String get weightUnitLbs;

  /// No description provided for @setsLabel.
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get setsLabel;

  /// No description provided for @repsLabel.
  ///
  /// In en, this message translates to:
  /// **'Repetitions'**
  String get repsLabel;

  /// No description provided for @durationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get durationLabel;

  /// No description provided for @weightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weightLabel;

  /// No description provided for @noteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get noteLabel;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @noWorkoutsOnDate.
  ///
  /// In en, this message translates to:
  /// **'No workouts on this date'**
  String get noWorkoutsOnDate;

  /// No description provided for @workoutsOnDate.
  ///
  /// In en, this message translates to:
  /// **'Workouts on {date}'**
  String workoutsOnDate(Object date);

  /// No description provided for @totalWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Total workouts: {count}'**
  String totalWorkouts(int count);

  /// No description provided for @recentWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Recent Workouts'**
  String get recentWorkouts;

  /// No description provided for @allWorkouts.
  ///
  /// In en, this message translates to:
  /// **'All Workouts'**
  String get allWorkouts;

  /// No description provided for @filterByDate.
  ///
  /// In en, this message translates to:
  /// **'Filter by Date'**
  String get filterByDate;

  /// No description provided for @clearFilter.
  ///
  /// In en, this message translates to:
  /// **'Clear Filter'**
  String get clearFilter;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @german.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get german;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @howToUse.
  ///
  /// In en, this message translates to:
  /// **'How to Use'**
  String get howToUse;

  /// No description provided for @howToUseDescription.
  ///
  /// In en, this message translates to:
  /// **'1. Create exercises with names and descriptions\n2. Create workouts and add exercises to them\n3. Track your progress in the history and calendar'**
  String get howToUseDescription;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Training App'**
  String get welcome;

  /// No description provided for @welcomeDescription.
  ///
  /// In en, this message translates to:
  /// **'Track your workouts and exercises with ease'**
  String get welcomeDescription;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @quickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get quickAccess;

  /// No description provided for @newWorkout.
  ///
  /// In en, this message translates to:
  /// **'New Workout'**
  String get newWorkout;

  /// No description provided for @newExercise.
  ///
  /// In en, this message translates to:
  /// **'New Exercise'**
  String get newExercise;

  /// No description provided for @yourProgress.
  ///
  /// In en, this message translates to:
  /// **'Your Progress'**
  String get yourProgress;

  /// No description provided for @completedWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Completed Workouts'**
  String get completedWorkouts;

  /// No description provided for @availableExercises.
  ///
  /// In en, this message translates to:
  /// **'Available Exercises'**
  String get availableExercises;

  /// No description provided for @lastWorkout.
  ///
  /// In en, this message translates to:
  /// **'Last Workout'**
  String get lastWorkout;

  /// No description provided for @mostUsedExercises.
  ///
  /// In en, this message translates to:
  /// **'Most Used Exercises'**
  String get mostUsedExercises;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @createWorkout.
  ///
  /// In en, this message translates to:
  /// **'Create workout'**
  String get createWorkout;

  /// No description provided for @addExerciseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add exercise'**
  String get addExerciseSubtitle;

  /// No description provided for @fitnessCompanion.
  ///
  /// In en, this message translates to:
  /// **'Your Fitness Companion'**
  String get fitnessCompanion;

  /// No description provided for @searchExercise.
  ///
  /// In en, this message translates to:
  /// **'Search exercise...'**
  String get searchExercise;

  /// No description provided for @pleaseEnterExerciseName.
  ///
  /// In en, this message translates to:
  /// **'Please enter an exercise name'**
  String get pleaseEnterExerciseName;

  /// No description provided for @editExerciseTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Exercise'**
  String get editExerciseTitle;

  /// No description provided for @newExerciseTitle.
  ///
  /// In en, this message translates to:
  /// **'New Exercise'**
  String get newExerciseTitle;

  /// No description provided for @editWorkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Workout'**
  String get editWorkoutTitle;

  /// No description provided for @newWorkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'New Workout'**
  String get newWorkoutTitle;

  /// No description provided for @workoutNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Workout name'**
  String get workoutNameLabel;

  /// No description provided for @editExerciseTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit exercise'**
  String get editExerciseTooltip;

  /// No description provided for @deleteExerciseTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete exercise'**
  String get deleteExerciseTooltip;

  /// No description provided for @selectedExercise.
  ///
  /// In en, this message translates to:
  /// **'Selected: {name}'**
  String selectedExercise(String name);

  /// No description provided for @selectExerciseError.
  ///
  /// In en, this message translates to:
  /// **'Please select an exercise'**
  String get selectExerciseError;

  /// No description provided for @autoCalculatedSets.
  ///
  /// In en, this message translates to:
  /// **'Automatically calculated for variable reps'**
  String get autoCalculatedSets;

  /// No description provided for @repsPerSetLabel.
  ///
  /// In en, this message translates to:
  /// **'Repetitions per set (optional)'**
  String get repsPerSetLabel;

  /// No description provided for @repsPerSetHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 20, 15, 12, 8'**
  String get repsPerSetHint;

  /// No description provided for @repsPerSetHelper.
  ///
  /// In en, this message translates to:
  /// **'Comma-separated list for different reps per set (sets will be calculated automatically)'**
  String get repsPerSetHelper;

  /// No description provided for @invalidRepsFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid format. Use: 20, 15, 12, 8'**
  String get invalidRepsFormat;

  /// No description provided for @selectExerciseFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select an exercise first'**
  String get selectExerciseFirst;

  /// No description provided for @editWorkoutTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit workout'**
  String get editWorkoutTooltip;

  /// No description provided for @deleteWorkoutTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete workout'**
  String get deleteWorkoutTooltip;

  /// No description provided for @workoutOverview.
  ///
  /// In en, this message translates to:
  /// **'Workout Overview'**
  String get workoutOverview;

  /// No description provided for @totalReps.
  ///
  /// In en, this message translates to:
  /// **'Total Reps'**
  String get totalReps;

  /// No description provided for @totalSets.
  ///
  /// In en, this message translates to:
  /// **'Total Sets'**
  String get totalSets;

  /// No description provided for @exercisesLabel.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get exercisesLabel;

  /// No description provided for @repCounter.
  ///
  /// In en, this message translates to:
  /// **'Rep Counter'**
  String get repCounter;

  /// No description provided for @countRepsUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Count your repetitions without limit'**
  String get countRepsUnlimited;

  /// No description provided for @chooseStepSize.
  ///
  /// In en, this message translates to:
  /// **'Choose step size:'**
  String get chooseStepSize;

  /// No description provided for @currentClickValue.
  ///
  /// In en, this message translates to:
  /// **'Current: +{value} per click'**
  String currentClickValue(int value);

  /// No description provided for @undoAction.
  ///
  /// In en, this message translates to:
  /// **'Undo: {action} (was {value})'**
  String undoAction(String action, int value);

  /// No description provided for @lastActions.
  ///
  /// In en, this message translates to:
  /// **'Recent actions:'**
  String get lastActions;

  /// No description provided for @historyEntry.
  ///
  /// In en, this message translates to:
  /// **'{action} → was {value}'**
  String historyEntry(String action, int value);

  /// No description provided for @counterInstructions.
  ///
  /// In en, this message translates to:
  /// **'Choose your step size and tap the green button\nPerfect for sets: 1s for single reps, 10s/20s for whole sets'**
  String get counterInstructions;

  /// No description provided for @trainingStatistics.
  ///
  /// In en, this message translates to:
  /// **'Your Training Statistics'**
  String get trainingStatistics;

  /// No description provided for @progressOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview of your progress'**
  String get progressOverview;

  /// No description provided for @generalOverview.
  ///
  /// In en, this message translates to:
  /// **'General Overview'**
  String get generalOverview;

  /// No description provided for @avgRepsPerWorkout.
  ///
  /// In en, this message translates to:
  /// **'Avg Reps / Workout'**
  String get avgRepsPerWorkout;

  /// No description provided for @exerciseRanking.
  ///
  /// In en, this message translates to:
  /// **'Exercise Ranking'**
  String get exerciseRanking;

  /// No description provided for @noExercisesUsed.
  ///
  /// In en, this message translates to:
  /// **'No exercises used yet'**
  String get noExercisesUsed;

  /// No description provided for @createWorkoutHint.
  ///
  /// In en, this message translates to:
  /// **'Create a workout and add exercises!'**
  String get createWorkoutHint;

  /// No description provided for @timesUsed.
  ///
  /// In en, this message translates to:
  /// **'{count}x used'**
  String timesUsed(int count);

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// No description provided for @exportDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Export your training data'**
  String get exportDataSubtitle;

  /// No description provided for @importData.
  ///
  /// In en, this message translates to:
  /// **'Import Data'**
  String get importData;

  /// No description provided for @importDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Restore training data from file'**
  String get importDataSubtitle;

  /// No description provided for @noWorkoutHistoryYet.
  ///
  /// In en, this message translates to:
  /// **'No workout history yet'**
  String get noWorkoutHistoryYet;

  /// No description provided for @createdOn.
  ///
  /// In en, this message translates to:
  /// **'Created: {date}'**
  String createdOn(String date);

  /// No description provided for @totalDuration.
  ///
  /// In en, this message translates to:
  /// **'Total Duration'**
  String get totalDuration;

  /// No description provided for @getMonthName.
  ///
  /// In en, this message translates to:
  /// **'getMonthName'**
  String getMonthName(int month);

  /// No description provided for @dataStatistics.
  ///
  /// In en, this message translates to:
  /// **'Data Statistics'**
  String get dataStatistics;

  /// No description provided for @dataStatisticsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show overview of your data'**
  String get dataStatisticsSubtitle;

  /// No description provided for @dataStorage.
  ///
  /// In en, this message translates to:
  /// **'Data Storage'**
  String get dataStorage;

  /// No description provided for @dataStorageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'All data is stored locally on your device'**
  String get dataStorageSubtitle;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @exportDataDialog.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportDataDialog;

  /// No description provided for @chooseExportFormat.
  ///
  /// In en, this message translates to:
  /// **'Choose export format:'**
  String get chooseExportFormat;

  /// No description provided for @jsonExport.
  ///
  /// In en, this message translates to:
  /// **'JSON Export'**
  String get jsonExport;

  /// No description provided for @csvExport.
  ///
  /// In en, this message translates to:
  /// **'CSV Export'**
  String get csvExport;

  /// No description provided for @dataStatisticsDialog.
  ///
  /// In en, this message translates to:
  /// **'Data Statistics'**
  String get dataStatisticsDialog;

  /// No description provided for @totalExercises.
  ///
  /// In en, this message translates to:
  /// **'Total exercises: {count}'**
  String totalExercises(int count);

  /// No description provided for @userExercises.
  ///
  /// In en, this message translates to:
  /// **'User exercises: {count}'**
  String userExercises(int count);

  /// No description provided for @predefinedExercises.
  ///
  /// In en, this message translates to:
  /// **'Predefined exercises: {count}'**
  String predefinedExercises(int count);

  /// No description provided for @exercisesInWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Exercises in workouts: {count}'**
  String exercisesInWorkouts(int count);

  /// No description provided for @asOf.
  ///
  /// In en, this message translates to:
  /// **'As of: {date}'**
  String asOf(String date);

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'A local training app for managing your exercises and workouts. All data is stored securely on your device.'**
  String get appDescription;

  /// No description provided for @localStorage.
  ///
  /// In en, this message translates to:
  /// **'Local Storage'**
  String get localStorage;

  /// No description provided for @storageFeatures.
  ///
  /// In en, this message translates to:
  /// **'• All your data is stored locally on your device\n• No cloud synchronization\n• Full control over your data\n• Export functions available for backups'**
  String get storageFeatures;

  /// No description provided for @advantages.
  ///
  /// In en, this message translates to:
  /// **'Advantages:'**
  String get advantages;

  /// No description provided for @storageAdvantages.
  ///
  /// In en, this message translates to:
  /// **'• Privacy protection\n• Offline availability\n• Fast performance\n• No internet connection required'**
  String get storageAdvantages;

  /// No description provided for @understood.
  ///
  /// In en, this message translates to:
  /// **'Understood'**
  String get understood;

  /// No description provided for @jsonExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'JSON export successfully shared!'**
  String get jsonExportSuccess;

  /// No description provided for @csvExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'CSV export successfully shared!'**
  String get csvExportSuccess;

  /// No description provided for @jsonExportError.
  ///
  /// In en, this message translates to:
  /// **'Error during JSON export: {error}'**
  String jsonExportError(String error);

  /// No description provided for @csvExportError.
  ///
  /// In en, this message translates to:
  /// **'Error during CSV export: {error}'**
  String csvExportError(String error);

  /// No description provided for @statisticsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Error loading statistics: {error}'**
  String statisticsLoadError(String error);

  /// No description provided for @workoutCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Workout created successfully'**
  String get workoutCreatedSuccessfully;

  /// No description provided for @workoutUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Workout updated successfully'**
  String get workoutUpdatedSuccessfully;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @noExercisesInWorkout.
  ///
  /// In en, this message translates to:
  /// **'No exercises in this workout yet'**
  String get noExercisesInWorkout;

  /// No description provided for @addFirstExerciseToWorkout.
  ///
  /// In en, this message translates to:
  /// **'Add your first exercise to get started'**
  String get addFirstExerciseToWorkout;

  /// No description provided for @savedEmomTrainings.
  ///
  /// In en, this message translates to:
  /// **'Saved EMOM Trainings'**
  String get savedEmomTrainings;

  /// No description provided for @quickStart.
  ///
  /// In en, this message translates to:
  /// **'Quick Start'**
  String get quickStart;

  /// No description provided for @createEmom.
  ///
  /// In en, this message translates to:
  /// **'Create EMOM'**
  String get createEmom;

  /// No description provided for @startEmom.
  ///
  /// In en, this message translates to:
  /// **'Start EMOM'**
  String get startEmom;

  /// No description provided for @editEmom.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editEmom;

  /// No description provided for @deleteEmom.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteEmom;

  /// No description provided for @deleteEmomTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete EMOM'**
  String get deleteEmomTitle;

  /// No description provided for @deleteEmomConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to delete \"{emomName}\"?'**
  String deleteEmomConfirm(Object emomName);

  /// No description provided for @emomQuickStart.
  ///
  /// In en, this message translates to:
  /// **'EMOM Quick Start'**
  String get emomQuickStart;

  /// No description provided for @emomQuickStartDescription.
  ///
  /// In en, this message translates to:
  /// **'Start an EMOM immediately without defining exercises.'**
  String get emomQuickStartDescription;

  /// No description provided for @desiredTime.
  ///
  /// In en, this message translates to:
  /// **'Desired Time'**
  String get desiredTime;

  /// No description provided for @intervalSeconds.
  ///
  /// In en, this message translates to:
  /// **'Interval (Seconds)'**
  String get intervalSeconds;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @noEmomsYet.
  ///
  /// In en, this message translates to:
  /// **'No EMOMs yet'**
  String get noEmomsYet;

  /// No description provided for @createFirstEmom.
  ///
  /// In en, this message translates to:
  /// **'Create your first EMOM to get started'**
  String get createFirstEmom;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
