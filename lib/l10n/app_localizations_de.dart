// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Trainings App';

  @override
  String get exercises => 'Übungen';

  @override
  String get workouts => 'Trainings';

  @override
  String get emoms => 'EMOMs';

  @override
  String get history => 'Verlauf';

  @override
  String get calendar => 'Kalender';

  @override
  String get settings => 'Einstellungen';

  @override
  String get counter => 'Zähler';

  @override
  String get statistics => 'Statistiken';

  @override
  String get addExercise => 'Übung hinzufügen';

  @override
  String get addWorkout => 'Training hinzufügen';

  @override
  String get editExercise => 'Übung bearbeiten';

  @override
  String get editWorkout => 'Training bearbeiten';

  @override
  String get delete => 'Löschen';

  @override
  String get save => 'Speichern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get name => 'Name';

  @override
  String get description => 'Beschreibung';

  @override
  String sets(int count) {
    return '$count Sätze';
  }

  @override
  String reps(int count) {
    return '$count Wdh.';
  }

  @override
  String get weight => 'Gewicht (kg)';

  @override
  String get duration => 'Dauer';

  @override
  String get note => 'Notiz';

  @override
  String get date => 'Datum';

  @override
  String get time => 'Zeit';

  @override
  String get selectExercise => 'Übung auswählen';

  @override
  String get noExercises => 'Noch keine Übungen';

  @override
  String get noWorkouts => 'Noch keine Trainings';

  @override
  String get createYourFirstExercise => 'Erstellen Sie Ihre erste Übung um zu beginnen';

  @override
  String get createYourFirstWorkout => 'Erstellen Sie Ihr erstes Training um zu beginnen';

  @override
  String get exerciseName => 'Übungsname';

  @override
  String get exerciseDescriptionEn => 'Übungsbeschreibung (Englisch)';

  @override
  String get exerciseDescriptionDe => 'Übungsbeschreibung (Deutsch)';

  @override
  String get workoutName => 'Trainingsname';

  @override
  String get workoutDate => 'Trainingsdatum';

  @override
  String get addExerciseToWorkout => 'Übung zum Training hinzufügen';

  @override
  String get workoutDetails => 'Trainingsdetails';

  @override
  String get exerciseDetails => 'Übungsdetails';

  @override
  String get loading => 'Lädt...';

  @override
  String get error => 'Fehler';

  @override
  String get success => 'Erfolg';

  @override
  String get confirmDelete => 'Löschen bestätigen';

  @override
  String get deleteExerciseMessage => 'Sind Sie sicher, dass Sie diese Übung löschen möchten?';

  @override
  String get deleteWorkoutMessage => 'Sind Sie sicher, dass Sie dieses Training löschen möchten?';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get minutes => 'Minuten';

  @override
  String get seconds => 'Sekunden';

  @override
  String get kg => 'kg';

  @override
  String get lbs => 'lbs';

  @override
  String get weightUnit => 'Gewichtseinheit';

  @override
  String get weightUnitKg => 'Kilogramm (kg)';

  @override
  String get weightUnitLbs => 'Pound (lbs)';

  @override
  String get setsLabel => 'Sätze';

  @override
  String get repsLabel => 'Wiederholungen';

  @override
  String get durationLabel => 'Dauer';

  @override
  String get weightLabel => 'Gewicht';

  @override
  String get noteLabel => 'Notiz (optional)';

  @override
  String get today => 'Heute';

  @override
  String get yesterday => 'Gestern';

  @override
  String get tomorrow => 'Morgen';

  @override
  String get noWorkoutsOnDate => 'Keine Trainings an diesem Datum';

  @override
  String workoutsOnDate(Object date) {
    return 'Trainings am $date';
  }

  @override
  String totalWorkouts(int count) {
    return 'Trainings gesamt: $count';
  }

  @override
  String get recentWorkouts => 'Letzte Trainings';

  @override
  String get allWorkouts => 'Alle Trainings';

  @override
  String get filterByDate => 'Nach Datum filtern';

  @override
  String get clearFilter => 'Filter löschen';

  @override
  String get language => 'Sprache';

  @override
  String get english => 'Englisch';

  @override
  String get german => 'Deutsch';

  @override
  String get theme => 'Design';

  @override
  String get light => 'Hell';

  @override
  String get dark => 'Dunkel';

  @override
  String get system => 'System';

  @override
  String get about => 'Über';

  @override
  String get version => 'Version';

  @override
  String get help => 'Hilfe';

  @override
  String get howToUse => 'Verwendung';

  @override
  String get howToUseDescription => '1. Erstellen Sie Übungen mit Namen und Beschreibungen\n2. Erstellen Sie Trainings und fügen Sie Übungen hinzu\n3. Verfolgen Sie Ihren Fortschritt im Verlauf und Kalender';

  @override
  String get contact => 'Kontakt';

  @override
  String get privacyPolicy => 'Datenschutz';

  @override
  String get termsOfService => 'Nutzungsbedingungen';

  @override
  String get logout => 'Abmelden';

  @override
  String get login => 'Anmelden';

  @override
  String get register => 'Registrieren';

  @override
  String get email => 'E-Mail';

  @override
  String get password => 'Passwort';

  @override
  String get confirmPassword => 'Passwort bestätigen';

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String get dontHaveAccount => 'Noch kein Konto?';

  @override
  String get alreadyHaveAccount => 'Bereits ein Konto?';

  @override
  String get welcome => 'Willkommen bei der Trainings App';

  @override
  String get welcomeDescription => 'Verfolgen Sie Ihre Trainings und Übungen einfach';

  @override
  String get getStarted => 'Loslegen';

  @override
  String get retry => 'Wiederholen';

  @override
  String get quickAccess => 'Schnellzugriff';

  @override
  String get newWorkout => 'Neues Training';

  @override
  String get newExercise => 'Neue Übung';

  @override
  String get yourProgress => 'Deine Fortschritte';

  @override
  String get completedWorkouts => 'Absolvierte Trainings';

  @override
  String get availableExercises => 'Verfügbare Übungen';

  @override
  String get lastWorkout => 'Letztes Training';

  @override
  String get mostUsedExercises => 'Meist genutzte Übungen';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get createWorkout => 'Training erstellen';

  @override
  String get addExerciseSubtitle => 'Übung hinzufügen';

  @override
  String get fitnessCompanion => 'Dein Fitness-Begleiter';

  @override
  String get searchExercise => 'Übung suchen...';

  @override
  String get pleaseEnterExerciseName => 'Bitte geben Sie einen Übungs-Namen ein';

  @override
  String get editExerciseTitle => 'Übung bearbeiten';

  @override
  String get newExerciseTitle => 'Neue Übung';

  @override
  String get editWorkoutTitle => 'Training bearbeiten';

  @override
  String get newWorkoutTitle => 'Neues Training';

  @override
  String get workoutNameLabel => 'Trainingsname';

  @override
  String get editExerciseTooltip => 'Übung bearbeiten';

  @override
  String get deleteExerciseTooltip => 'Übung löschen';

  @override
  String selectedExercise(String name) {
    return 'Ausgewählt: $name';
  }

  @override
  String get selectExerciseError => 'Bitte wählen Sie eine Übung aus';

  @override
  String get autoCalculatedSets => 'Wird automatisch berechnet bei variablen Wdh.';

  @override
  String get repsPerSetLabel => 'Wiederholungen pro Satz (optional)';

  @override
  String get repsPerSetHint => 'z.B. 20, 15, 12, 8';

  @override
  String get repsPerSetHelper => 'Kommagetrennte Liste für verschiedene Wdh. pro Satz (Sätze werden automatisch berechnet)';

  @override
  String get invalidRepsFormat => 'Ungültiges Format. Verwende: 20, 15, 12, 8';

  @override
  String get selectExerciseFirst => 'Bitte wählen Sie eine Übung aus';

  @override
  String get editWorkoutTooltip => 'Training bearbeiten';

  @override
  String get deleteWorkoutTooltip => 'Training löschen';

  @override
  String get workoutOverview => 'Training Übersicht';

  @override
  String get totalReps => 'Gesamte Wdh.';

  @override
  String get totalSets => 'Gesamte Sätze';

  @override
  String get exercisesLabel => 'Übungen';

  @override
  String get repCounter => 'Wiederholungs-Zähler';

  @override
  String get countRepsUnlimited => 'Zähle deine Wiederholungen ohne Limit';

  @override
  String get chooseStepSize => 'Schrittgröße wählen:';

  @override
  String currentClickValue(int value) {
    return 'Aktuell: +$value pro Klick';
  }

  @override
  String undoAction(String action, int value) {
    return 'Rückgängig: $action (war $value)';
  }

  @override
  String get lastActions => 'Letzte Aktionen:';

  @override
  String historyEntry(String action, int value) {
    return '$action → war $value';
  }

  @override
  String get counterInstructions => 'Wähle deine Schrittgröße und tippe den grünen Button\nPerfekt für Sets: 1er für einzelne Reps, 10er/20er für ganze Sets';

  @override
  String get trainingStatistics => 'Deine Trainings-Statistiken';

  @override
  String get progressOverview => 'Übersicht über deine Fortschritte';

  @override
  String get generalOverview => 'Allgemeine Übersicht';

  @override
  String get avgRepsPerWorkout => 'Ø Wdh. / Training';

  @override
  String get exerciseRanking => 'Übungs-Ranking';

  @override
  String get noExercisesUsed => 'Noch keine Übungen verwendet';

  @override
  String get createWorkoutHint => 'Erstelle ein Training und füge Übungen hinzu!';

  @override
  String timesUsed(int count) {
    return '${count}x verwendet';
  }

  @override
  String get exportData => 'Daten exportieren';

  @override
  String get exportDataSubtitle => 'Exportieren Sie Ihre Trainingsdaten';

  @override
  String get dataStatistics => 'Datenstatistiken';

  @override
  String get dataStatisticsSubtitle => 'Zeige Übersicht Ihrer Daten';

  @override
  String get dataStorage => 'Datenspeicherung';

  @override
  String get dataStorageSubtitle => 'Alle Daten werden lokal auf Ihrem Gerät gespeichert';

  @override
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get exportDataDialog => 'Daten exportieren';

  @override
  String get chooseExportFormat => 'Wählen Sie das Exportformat:';

  @override
  String get jsonExport => 'JSON Export';

  @override
  String get csvExport => 'CSV Export';

  @override
  String get dataStatisticsDialog => 'Datenstatistiken';

  @override
  String totalExercises(int count) {
    return 'Übungen gesamt: $count';
  }

  @override
  String userExercises(int count) {
    return 'Eigene Übungen: $count';
  }

  @override
  String predefinedExercises(int count) {
    return 'Vordefinierte Übungen: $count';
  }

  @override
  String exercisesInWorkouts(int count) {
    return 'Übungen in Trainings: $count';
  }

  @override
  String asOf(String date) {
    return 'Stand: $date';
  }

  @override
  String get close => 'Schließen';

  @override
  String get appDescription => 'Eine lokale Trainings-App zur Verwaltung Ihrer Übungen und Trainings. Alle Daten werden sicher auf Ihrem Gerät gespeichert.';

  @override
  String get localStorage => 'Lokale Speicherung';

  @override
  String get storageFeatures => '• Alle Ihre Daten werden lokal auf Ihrem Gerät gespeichert\n• Keine Cloud-Synchronisation\n• Vollständige Kontrolle über Ihre Daten\n• Export-Funktionen für Backups verfügbar';

  @override
  String get advantages => 'Vorteile:';

  @override
  String get storageAdvantages => '• Datenschutz\n• Offline-Verfügbarkeit\n• Schnelle Performance\n• Keine Internetverbindung erforderlich';

  @override
  String get understood => 'Verstanden';

  @override
  String get jsonExportSuccess => 'JSON Export erfolgreich geteilt!';

  @override
  String get csvExportSuccess => 'CSV Export erfolgreich geteilt!';

  @override
  String jsonExportError(String error) {
    return 'Fehler beim JSON Export: $error';
  }

  @override
  String csvExportError(String error) {
    return 'Fehler beim CSV Export: $error';
  }

  @override
  String statisticsLoadError(String error) {
    return 'Fehler beim Laden der Statistiken: $error';
  }

  @override
  String get workoutCreatedSuccessfully => 'Training erfolgreich erstellt';

  @override
  String get workoutUpdatedSuccessfully => 'Training erfolgreich aktualisiert';

  @override
  String get errorOccurred => 'Ein Fehler ist aufgetreten';

  @override
  String get noExercisesInWorkout => 'Noch keine Übungen in diesem Training';

  @override
  String get addFirstExerciseToWorkout => 'Fügen Sie Ihre erste Übung hinzu um zu beginnen';

  @override
  String get savedEmomTrainings => 'Gespeicherte EMOM-Trainings';

  @override
  String get quickStart => 'Schnellstart';

  @override
  String get createEmom => 'EMOM erstellen';

  @override
  String get startEmom => 'EMOM Starten';

  @override
  String get editEmom => 'Bearbeiten';

  @override
  String get deleteEmom => 'Löschen';

  @override
  String get deleteEmomTitle => 'EMOM löschen';

  @override
  String deleteEmomConfirm(Object emomName) {
    return 'Möchten Sie \"$emomName\" wirklich löschen?';
  }

  @override
  String get emomQuickStart => 'EMOM Schnellstart';

  @override
  String get emomQuickStartDescription => 'Starten Sie sofort ein EMOM ohne Übungen zu definieren.';

  @override
  String get desiredTime => 'Gewünschte Zeit';

  @override
  String get intervalSeconds => 'Intervall (Sekunden)';

  @override
  String get start => 'Starten';

  @override
  String get noEmomsYet => 'Noch keine EMOMs';

  @override
  String get createFirstEmom => 'Erstellen Sie Ihr erstes EMOM um zu beginnen';
}
