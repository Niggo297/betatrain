import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/weight_unit_provider.dart';
import '../providers/locale_provider.dart';
import 'dashboard_screen.dart';
import 'exercises_screen.dart';
import 'workouts_screen.dart';
import 'emoms_screen.dart';
import 'history_screen.dart';
import 'calendar_screen.dart';
import 'counter_screen.dart';
import 'statistics_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget? _currentScreen;
  String? _currentTitle;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _currentScreen = DashboardScreen(onNavigate: _navigateToScreen);
        _currentTitle = l10n.dashboard;
      });

      // Warte auf Provider und prüfe dann Gewichtseinheit
      _checkFirstTimeWeightUnit();
    });
  }

  void _checkFirstTimeWeightUnit() {
    final weightUnitProvider = context.read<WeightUnitProvider>();

    // Höre auf Änderungen des Providers
    void checkAndShow() {
      if (weightUnitProvider.isLoaded && weightUnitProvider.isFirstTime && mounted) {
        // Zeige Onboarding nach kurzer Verzögerung
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _showWeightUnitOnboarding();
          }
        });
      }
    }

    // Falls schon geladen, sofort prüfen
    if (weightUnitProvider.isLoaded) {
      checkAndShow();
    } else {
      // Sonst auf Änderung warten
      weightUnitProvider.addListener(checkAndShow);
      // Listener nach erstem Check entfernen
      Future.delayed(const Duration(seconds: 2), () {
        weightUnitProvider.removeListener(checkAndShow);
      });
    }
  }

  void _showWeightUnitOnboarding() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          final locale = localeProvider.locale.languageCode;

          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.grey[800]!, Colors.grey[900]!],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Sprach-Umschalter
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 40),
                      Text(
                        locale == 'de' ? 'Sprache' : 'Language',
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                      Row(
                        children: [
                          _buildLanguageButton('DE', locale == 'de', () {
                            context.read<LocaleProvider>().setLocale(const Locale('de'));
                          }),
                          const SizedBox(width: 8),
                          _buildLanguageButton('EN', locale == 'en', () {
                            context.read<LocaleProvider>().setLocale(const Locale('en'));
                          }),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Willkommens-Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(Icons.fitness_center, color: Colors.orange, size: 48),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    locale == 'de' ? 'Willkommen bei TrainingApp!' : 'Welcome to TrainingApp!',
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  Text(
                    locale == 'de'
                        ? 'Lassen Sie uns Ihre bevorzugte Gewichtseinheit einrichten'
                        : 'Let\'s set up your preferred weight unit',
                    style: TextStyle(color: Colors.grey[300], fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Gewichtseinheit-Optionen
                  Text(
                    locale == 'de' ? 'Gewichtseinheit wählen:' : 'Choose weight unit:',
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: _buildWeightUnitButton(
                          'kg',
                          locale == 'de' ? 'Kilogramm' : 'Kilograms',
                          Icons.fitness_center,
                          Colors.blue,
                          () {
                            context.read<WeightUnitProvider>().setWeightUnit(WeightUnit.kg);
                            Navigator.of(context).pop();
                            _showWelcomeComplete(locale == 'de');
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildWeightUnitButton(
                          'lbs',
                          locale == 'de' ? 'Pfund' : 'Pounds',
                          Icons.scale,
                          Colors.green,
                          () {
                            context.read<WeightUnitProvider>().setWeightUnit(WeightUnit.lbs);
                            Navigator.of(context).pop();
                            _showWelcomeComplete(locale == 'de');
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Text(
                    locale == 'de'
                        ? 'Sie können dies jederzeit in den Einstellungen ändern'
                        : 'You can change this anytime in settings',
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLanguageButton(String text, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? Colors.orange : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isActive ? Colors.orange : Colors.grey[600]!, width: 1),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey[400],
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildWeightUnitButton(String unit, String name, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 2),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(30)),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              unit,
              style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              name,
              style: TextStyle(color: Colors.grey[300], fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showWelcomeComplete(bool isGerman) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isGerman
              ? '🎉 Willkommen! Ihre Einstellungen wurden gespeichert.'
              : '🎉 Welcome! Your settings have been saved.',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          _currentTitle ?? l10n.dashboard,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey[900],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Moderner Gradient Header
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue[700]!, Colors.purple[600]!, Colors.indigo[700]!],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.fitness_center, size: 36, color: Colors.white),
                  ),
                  // const SizedBox(height: 16),
                  Text(
                    'TrainLog',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(offset: Offset(0, 2), blurRadius: 4, color: Colors.black26)],
                    ),
                  ),
                  Text(
                    l10n.fitnessCompanion,
                    style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 16, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
            // Navigation Items mit einheitlicher Farbpalette
            _buildDrawerItem(
              icon: Icons.dashboard,
              title: l10n.dashboard,
              color: Colors.blue[400]!,
              onTap: () => _navigateToScreen(DashboardScreen(onNavigate: _navigateToScreen), l10n.dashboard),
            ),
            _buildDrawerItem(
              icon: Icons.fitness_center,
              title: l10n.exercises,
              color: Colors.blue[500]!,
              onTap: () => _navigateToScreen(const ExercisesScreen(), l10n.exercises),
            ),
            _buildDrawerItem(
              icon: Icons.sports_gymnastics,
              title: l10n.workouts,
              color: Colors.blue[600]!,
              onTap: () => _navigateToScreen(const WorkoutsScreen(), l10n.workouts),
            ),
            _buildDrawerItem(
              icon: Icons.timer,
              title: 'EMOMs',
              color: Colors.indigo[400]!,
              onTap: () => _navigateToScreen(const EmomsScreen(), 'EMOMs'),
            ),
            _buildDrawerItem(
              icon: Icons.history,
              title: l10n.history,
              color: Colors.indigo[500]!,
              onTap: () => _navigateToScreen(const HistoryScreen(), l10n.history),
            ),
            _buildDrawerItem(
              icon: Icons.calendar_month,
              title: l10n.calendar,
              color: Colors.indigo[600]!,
              onTap: () => _navigateToScreen(const CalendarScreen(), l10n.calendar),
            ),
            _buildDrawerItem(
              icon: Icons.add_circle,
              title: l10n.counter,
              color: Colors.purple[400]!,
              onTap: () => _navigateToScreen(const CounterScreen(), l10n.counter),
            ),
            _buildDrawerItem(
              icon: Icons.analytics,
              title: l10n.statistics,
              color: Colors.purple[500]!,
              onTap: () => _navigateToScreen(const StatisticsScreen(), l10n.statistics),
            ),
            // Stylische Divider
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.transparent, Colors.grey[600]!, Colors.transparent]),
              ),
            ),
            _buildDrawerItem(
              icon: Icons.settings,
              title: l10n.settings,
              color: Colors.grey[400]!,
              onTap: () => _navigateToScreen(const SettingsScreen(), l10n.settings),
            ),
          ],
        ),
      ),
      body: _currentScreen ?? const CircularProgressIndicator(),
    );
  }

  Widget _buildDrawerItem({required IconData icon, required String title, required VoidCallback onTap, Color? color}) {
    final isSelected = _currentTitle == title;
    final itemColor = color ?? Colors.white70;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isSelected ? itemColor.withOpacity(0.15) : Colors.transparent,
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? itemColor.withOpacity(0.2) : itemColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: isSelected ? itemColor : itemColor.withOpacity(0.8), size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? itemColor : Colors.white.withOpacity(0.9),
            fontSize: 16,
          ),
        ),
        onTap: onTap,
        hoverColor: itemColor.withOpacity(0.1),
        splashColor: itemColor.withOpacity(0.2),
      ),
    );
  }

  void _navigateToScreen(Widget screen, String title) {
    Navigator.of(context).pop(); // Close drawer
    setState(() {
      _currentScreen = screen;
      _currentTitle = title;
    });
  }
}
