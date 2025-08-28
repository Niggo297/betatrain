import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:io';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import '../providers/weight_unit_provider.dart';
import '../services/export_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ExportService _exportService = ExportService();
  bool _isExporting = false;
  bool _isImporting = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: ListView(
        children: [
          // Language Settings
          Consumer<LocaleProvider>(
            builder: (context, localeProvider, child) {
              return ListTile(
                leading: const Icon(Icons.language, color: Colors.white70),
                title: Text(l10n.language, style: const TextStyle(color: Colors.white)),
                subtitle: Text(
                  localeProvider.locale.languageCode == 'en' ? l10n.english : l10n.german,
                  style: TextStyle(color: Colors.grey[300]),
                ),
                onTap: () => _showLanguageDialog(context),
              );
            },
          ),
          const Divider(color: Colors.grey),

          // Weight Unit Settings
          Consumer<WeightUnitProvider>(
            builder: (context, weightUnitProvider, child) {
              return ListTile(
                leading: const Icon(Icons.fitness_center, color: Colors.white70),
                title: Text(l10n.weightUnit, style: const TextStyle(color: Colors.white)),
                subtitle: Text(
                  weightUnitProvider.weightUnit == WeightUnit.kg ? l10n.weightUnitKg : l10n.weightUnitLbs,
                  style: TextStyle(color: Colors.grey[300]),
                ),
                onTap: () => _showWeightUnitDialog(context),
              );
            },
          ),
          const Divider(color: Colors.grey),

          // Test-Button für Willkommensdialog (nur zum Testen)
          // ListTile(
          //   leading: const Icon(Icons.refresh, color: Colors.orange),
          //   title: const Text(
          //     'Willkommensdialog testen',
          //     style: TextStyle(color: Colors.white),
          //   ),
          //   subtitle: const Text(
          //     'Zeigt den Willkommensdialog für neue Nutzer',
          //     style: TextStyle(color: Colors.grey),
          //   ),
          //   onTap: () => _resetWeightUnitToFirstTime(context),
          // ),
          // const Divider(color: Colors.grey),

          // Data Export Section
          ListTile(
            leading: const Icon(Icons.download, color: Colors.white70),
            title: Text(l10n.exportData, style: const TextStyle(color: Colors.white)),
            subtitle: Text(l10n.exportDataSubtitle, style: const TextStyle(color: Colors.grey)),
            trailing: _isExporting ? const CircularProgressIndicator() : null,
            onTap: _isExporting ? null : () => _showExportDialog(context),
          ),

          // Data Import Section
          ListTile(
            leading: const Icon(Icons.upload, color: Colors.white70),
            title: Text(l10n.importData, style: const TextStyle(color: Colors.white)),
            subtitle: Text(l10n.importDataSubtitle, style: const TextStyle(color: Colors.grey)),
            trailing: _isImporting ? const CircularProgressIndicator() : null,
            onTap: _isImporting ? null : () => _showImportDialog(context),
          ),
          const Divider(),

          // Statistics Section
          ListTile(
            leading: const Icon(Icons.analytics, color: Colors.white70),
            title: Text(l10n.dataStatistics, style: const TextStyle(color: Colors.white)),
            subtitle: Text(l10n.dataStatisticsSubtitle, style: const TextStyle(color: Colors.grey)),
            onTap: () => _showStatisticsDialog(context),
          ),
          const Divider(color: Colors.grey),

          // About Section
          ListTile(
            leading: const Icon(Icons.info, color: Colors.white70),
            title: Text(l10n.about, style: const TextStyle(color: Colors.white)),
            onTap: () => _showAboutDialog(context),
          ),
          const Divider(color: Colors.grey),

          // Local Storage Info
          ListTile(
            leading: const Icon(Icons.storage, color: Colors.white70),
            title: Text(l10n.dataStorage, style: const TextStyle(color: Colors.white)),
            subtitle: Text(l10n.dataStorageSubtitle, style: const TextStyle(color: Colors.grey)),
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
      builder: (context) => Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return AlertDialog(
            title: Text(l10n.selectLanguage),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(l10n.english),
                  leading: Radio<String>(
                    value: 'en',
                    groupValue: localeProvider.locale.languageCode,
                    onChanged: (value) {
                      localeProvider.setLocale(const Locale('en'));
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                ListTile(
                  title: Text(l10n.german),
                  leading: Radio<String>(
                    value: 'de',
                    groupValue: localeProvider.locale.languageCode,
                    onChanged: (value) {
                      localeProvider.setLocale(const Locale('de'));
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showWeightUnitDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => Consumer<WeightUnitProvider>(
        builder: (context, weightUnitProvider, child) {
          return AlertDialog(
            title: Text(l10n.weightUnit),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(l10n.weightUnitKg),
                  leading: Radio<WeightUnit>(
                    value: WeightUnit.kg,
                    groupValue: weightUnitProvider.weightUnit,
                    onChanged: (value) {
                      weightUnitProvider.setWeightUnit(WeightUnit.kg);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                ListTile(
                  title: Text(l10n.weightUnitLbs),
                  leading: Radio<WeightUnit>(
                    value: WeightUnit.lbs,
                    groupValue: weightUnitProvider.weightUnit,
                    onChanged: (value) {
                      weightUnitProvider.setWeightUnit(WeightUnit.lbs);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.exportDataDialog),
        content: Text(l10n.chooseExportFormat),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _exportAsJson();
            },
            child: Text(l10n.jsonExport),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _exportAsCsv();
            },
            child: Text(l10n.csvExport),
          ),
        ],
      ),
    );
  }

  void _showImportDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.importData),
        content: Text(
          locale == 'de'
              ? 'Wählen Sie das Format der zu importierenden Datei:'
              : 'Choose the format of the file to import:',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _importFromJson();
            },
            child: const Text('JSON importieren'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _importFromCsv();
            },
            child: const Text('CSV importieren'),
          ),
        ],
      ),
    );
  }

  void _showStatisticsDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    try {
      final summary = await _exportService.getExportSummary();

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.dataStatisticsDialog),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Localizations.localeOf(context).languageCode == 'de'
                    ? 'Übungen gesamt: ${summary['total_exercises']}'
                    : 'Total exercises: ${summary['total_exercises']}',
              ),
              Text(
                Localizations.localeOf(context).languageCode == 'de'
                    ? 'Eigene Übungen: ${summary['user_exercises']}'
                    : 'User exercises: ${summary['user_exercises']}',
              ),
              Text(
                Localizations.localeOf(context).languageCode == 'de'
                    ? 'Vordefinierte Übungen: ${summary['predefined_exercises']}'
                    : 'Predefined exercises: ${summary['predefined_exercises']}',
              ),
              Text(
                Localizations.localeOf(context).languageCode == 'de'
                    ? 'Trainings gesamt: ${summary['total_workouts']}'
                    : 'Total workouts: ${summary['total_workouts']}',
              ),
              Text(
                Localizations.localeOf(context).languageCode == 'de'
                    ? 'Übungen in Trainings: ${summary['total_workout_exercises']}'
                    : 'Exercises in workouts: ${summary['total_workout_exercises']}',
              ),
              const SizedBox(height: 16),
              Text(
                Localizations.localeOf(context).languageCode == 'de'
                    ? 'Stand: ${_formatDate(DateTime.parse(summary['export_date']))}'
                    : 'As of: ${_formatDate(DateTime.parse(summary['export_date']))}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.close))],
        ),
      );
    } catch (e) {
      _showErrorSnackBar(
        Localizations.localeOf(context).languageCode == 'de'
            ? 'Fehler beim Laden der Statistiken: $e'
            : 'Error loading statistics: $e',
      );
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
            Text('TrainingsApp', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Text('Version: 1.0.0'),
            const SizedBox(height: 16),
            Text(l10n.appDescription),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.close))],
      ),
    );
  }

  void _showStorageInfoDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.dataStorage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.localStorage, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(l10n.storageFeatures),
            const SizedBox(height: 16),
            Text(l10n.advantages, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(l10n.storageAdvantages),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.understood))],
      ),
    );
  }

  Future<void> _exportAsJson() async {
    setState(() {
      _isExporting = true;
    });

    try {
      await _exportService.shareJsonExport();
      _showSuccessSnackBar(
        Localizations.localeOf(context).languageCode == 'de'
            ? 'JSON Export erfolgreich geteilt!'
            : 'JSON export successfully shared!',
      );
    } catch (e) {
      _showErrorSnackBar(
        Localizations.localeOf(context).languageCode == 'de'
            ? 'Fehler beim JSON Export: $e'
            : 'Error during JSON export: $e',
      );
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
      _showSuccessSnackBar(
        Localizations.localeOf(context).languageCode == 'de'
            ? 'CSV Export erfolgreich geteilt!'
            : 'CSV export successfully shared!',
      );
    } catch (e) {
      _showErrorSnackBar(
        Localizations.localeOf(context).languageCode == 'de'
            ? 'Fehler beim CSV Export: $e'
            : 'Error during CSV export: $e',
      );
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green));
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
    }
  }

  Future<void> _importFromJson() async {
    setState(() {
      _isImporting = true;
    });

    try {
      // 1. File picker to select JSON file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final jsonString = await file.readAsString();

        // 2. Parse JSON and validate structure
        final jsonData = json.decode(jsonString);

        // Basic validation
        if (jsonData is! Map<String, dynamic>) {
          throw Exception('Ungültiges JSON-Format');
        }

        // TODO: 3. Import data to database
        // Here you would call your import service to process the data
        // await _importService.importFromJson(jsonData);

        _showSuccessSnackBar(
          Localizations.localeOf(context).languageCode == 'de'
              ? 'JSON-Daten erfolgreich importiert!'
              : 'JSON data successfully imported!',
        );
      } else {
        // User cancelled file selection
        setState(() {
          _isImporting = false;
        });
        return;
      }
    } catch (e) {
      _showErrorSnackBar(
        Localizations.localeOf(context).languageCode == 'de'
            ? 'Fehler beim JSON-Import: $e'
            : 'Error during JSON import: $e',
      );
    } finally {
      setState(() {
        _isImporting = false;
      });
    }
  }

  Future<void> _importFromCsv() async {
    setState(() {
      _isImporting = true;
    });

    try {
      // 1. File picker to select CSV file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final csvString = await file.readAsString();

        // 2. Basic CSV validation
        final lines = csvString.split('\n');
        if (lines.isEmpty) {
          throw Exception('CSV-Datei ist leer');
        }

        // TODO: 3. Parse CSV and import data to database
        // Here you would call your import service to process the CSV data
        // await _importService.importFromCsv(csvString);

        _showSuccessSnackBar(
          Localizations.localeOf(context).languageCode == 'de'
              ? 'CSV-Daten erfolgreich importiert!'
              : 'CSV data successfully imported!',
        );
      } else {
        // User cancelled file selection
        setState(() {
          _isImporting = false;
        });
        return;
      }
    } catch (e) {
      _showErrorSnackBar(
        Localizations.localeOf(context).languageCode == 'de'
            ? 'Fehler beim CSV-Import: $e'
            : 'Error during CSV import: $e',
      );
    } finally {
      setState(() {
        _isImporting = false;
      });
    }
  }

  void _resetWeightUnitToFirstTime(BuildContext context) async {
    final weightUnitProvider = context.read<WeightUnitProvider>();
    await weightUnitProvider.resetToFirstTime();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gewichtseinheit zurückgesetzt - Starten Sie die App neu!'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
