import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'providers/exercise_provider.dart';
import 'providers/workout_provider.dart';
import 'providers/emom_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/weight_unit_provider.dart';
import 'screens/main_screen.dart';
import 'services/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database early
  try {
    await DatabaseHelper().database;
    print('Database initialized successfully');
  } catch (e) {
    print('Error initializing database: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExerciseProvider()),
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
        ChangeNotifierProvider(create: (_) => EmomProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => WeightUnitProvider()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            title: 'Training App',
            debugShowCheckedModeBanner: false,

            // Localization
            locale: localeProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English
              Locale('de', ''), // German
            ],

            // Theme
            theme: ThemeData(
              colorScheme:
                  ColorScheme.fromSeed(
                    seedColor: Colors.blue,
                    brightness: Brightness.dark,
                  ).copyWith(
                    primary: Colors.blue[400]!,
                    secondary: Colors.green[400]!,
                    error: Colors.red[400]!,
                    surface: Colors.grey[800]!,
                    onSurface: Colors.white,
                    onPrimary: Colors.white,
                    onSecondary: Colors.white,
                    onError: Colors.white,
                  ),
              useMaterial3: true,
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue[400],
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              iconButtonTheme: IconButtonThemeData(
                style: IconButton.styleFrom(foregroundColor: Colors.white),
              ),
            ),
            darkTheme: ThemeData(
              colorScheme:
                  ColorScheme.fromSeed(
                    seedColor: Colors.blue,
                    brightness: Brightness.dark,
                  ).copyWith(
                    primary: Colors.blue[400]!,
                    secondary: Colors.green[400]!,
                    error: Colors.red[400]!,
                    surface: Colors.grey[800]!,
                    onSurface: Colors.white,
                    onPrimary: Colors.white,
                    onSecondary: Colors.white,
                    onError: Colors.white,
                  ),
              useMaterial3: true,
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue[400],
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              iconButtonTheme: IconButtonThemeData(
                style: IconButton.styleFrom(foregroundColor: Colors.white),
              ),
            ),
            themeMode: ThemeMode.dark,

            home: const MainScreen(),
          );
        },
      ),
    );
  }
}
