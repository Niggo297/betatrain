import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/export_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'en';
  String _selectedTheme = 'system';
  final ExportService _exportService = ExportService();
  bool _isExporting = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        children: [
          // Language Settings
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            subtitle: Text(
              _selectedLanguage == 'en' ? l10n.english : l10n.german,
            ),
            onTap: () => _showLanguageDialog(context),
          ),
          const Divider(),

          // Theme Settings
          ListTile(
            leading: const Icon(Icons.palette),
            title: Text(l10n.theme),
            subtitle: Text(_getThemeName(_selectedTheme)),
            onTap: () => _showThemeDialog(context),
          ),
          const Divider(),

          // Data Export Section
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Daten exportieren'),
            subtitle: const Text('Exportieren Sie Ihre Trainingsdaten'),
            trailing: _isExporting ? const CircularProgressIndicator() : null,
            onTap: _isExporting ? null : () => _showExportDialog(context),
          ),
          const Divider(),

          // Statistics Section
          ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text('Datenstatistiken'),
            subtitle: const Text('Zeige Übersicht Ihrer Daten'),
            onTap: () => _showStatisticsDialog(context),
          ),
          const Divider(),

          // About Section
          ListTile(
            leading: const Icon(Icons.info),
            title: Text(l10n.about),
            onTap: () => _showAboutDialog(context),
          ),
          const Divider(),

          // Local Storage Info
          ListTile(
            leading: const Icon(Icons.storage),
            title: const Text('Datenspeicherung'),
            subtitle: const Text(
              'Alle Daten werden lokal auf Ihrem Gerät gespeichert',
            ),
            onTap: () => _showStorageInfoDialog(context),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sprache auswählen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(l10n.english),
              leading: Radio<String>(
                value: 'en',
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ),
            ListTile(
              title: Text(l10n.german),
              leading: Radio<String>(
                value: 'de',
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Design auswählen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('System'),
              leading: Radio<String>(
                value: 'system',
                groupValue: _selectedTheme,
                onChanged: (value) {
                  setState(() {
                    _selectedTheme = value!;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ),
            ListTile(
              title: const Text('Hell'),
              leading: Radio<String>(
                value: 'light',
                groupValue: _selectedTheme,
                onChanged: (value) {
                  setState(() {
                    _selectedTheme = value!;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ),
            ListTile(
              title: const Text('Dunkel'),
              leading: Radio<String>(
                value: 'dark',
                groupValue: _selectedTheme,
                onChanged: (value) {
                  setState(() {
                    _selectedTheme = value!;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Daten exportieren'),
        content: const Text('Wählen Sie das Exportformat:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _exportAsJson();
            },
            child: const Text('JSON Export'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _exportAsCsv();
            },
            child: const Text('CSV Export'),
          ),
        ],
      ),
    );
  }

  void _showStatisticsDialog(BuildContext context) async {
    try {
      final summary = await _exportService.getExportSummary();

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Datenstatistiken'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Übungen gesamt: ${summary['total_exercises']}'),
              Text('Eigene Übungen: ${summary['user_exercises']}'),
              Text('Vordefinierte Übungen: ${summary['predefined_exercises']}'),
              Text('Trainings gesamt: ${summary['total_workouts']}'),
              Text(
                'Übungen in Trainings: ${summary['total_workout_exercises']}',
              ),
              const SizedBox(height: 16),
              Text(
                'Stand: ${_formatDate(DateTime.parse(summary['export_date']))}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Schließen'),
            ),
          ],
        ),
      );
    } catch (e) {
      _showErrorSnackBar('Fehler beim Laden der Statistiken: $e');
    }
  }

  void _showAboutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.about),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TrainingsApp',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text('Version: 1.0.0'),
            const SizedBox(height: 16),
            const Text(
              'Eine lokale Trainings-App zur Verwaltung Ihrer Übungen und Trainings. '
              'Alle Daten werden sicher auf Ihrem Gerät gespeichert.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Schließen'),
          ),
        ],
      ),
    );
  }

  void _showStorageInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Datenspeicherung'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lokale Speicherung',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '• Alle Ihre Daten werden lokal auf Ihrem Gerät gespeichert\n'
              '• Keine Cloud-Synchronisation\n'
              '• Vollständige Kontrolle über Ihre Daten\n'
              '• Export-Funktionen für Backups verfügbar',
            ),
            SizedBox(height: 16),
            Text('Vorteile:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(
              '• Datenschutz\n'
              '• Offline-Verfügbarkeit\n'
              '• Schnelle Performance\n'
              '• Keine Internetverbindung erforderlich',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Verstanden'),
          ),
        ],
      ),
    );
  }

  Future<void> _exportAsJson() async {
    setState(() {
      _isExporting = true;
    });

    try {
      await _exportService.shareJsonExport();
      _showSuccessSnackBar('JSON Export erfolgreich geteilt!');
    } catch (e) {
      _showErrorSnackBar('Fehler beim JSON Export: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }

  Future<void> _exportAsCsv() async {
    setState(() {
      _isExporting = true;
    });

    try {
      await _exportService.shareCsvExport();
      _showSuccessSnackBar('CSV Export erfolgreich geteilt!');
    } catch (e) {
      _showErrorSnackBar('Fehler beim CSV Export: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green),
      );
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _getThemeName(String theme) {
    switch (theme) {
      case 'light':
        return 'Hell';
      case 'dark':
        return 'Dunkel';
      case 'system':
      default:
        return 'System';
    }
  }
}
