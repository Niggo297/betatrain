import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/emom_provider.dart';
import '../models/emom.dart';
import '../l10n/app_localizations.dart';
import 'emom_create_screen.dart';
import 'emom_timer_screen.dart';

class EmomsScreen extends StatelessWidget {
  const EmomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Consumer<EmomProvider>(
        builder: (context, emomProvider, child) {
          if (emomProvider.emoms.isEmpty) {
            return _buildEmptyState(context, l10n);
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.bookmark, color: Colors.grey[600], size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '${l10n.savedEmomTrainings} (${emomProvider.emoms.length})',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: emomProvider.emoms.length,
                  itemBuilder: (context, index) {
                    final emom = emomProvider.emoms[index];
                    return _buildEmomCard(context, emom, l10n);
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Schnellstart FAB
          FloatingActionButton.extended(
            onPressed: () => _showQuickStartDialog(context),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.flash_on),
            label: Text(l10n.quickStart),
            heroTag: "quickstart",
          ),
          const SizedBox(width: 16),
          // Normaler FAB
          FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const EmomCreateScreen()));
            },
            backgroundColor: Colors.orange,
            child: const Icon(Icons.add),
            heroTag: "create",
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Bunter Icon-Container
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.indigo[400]!, Colors.purple[400]!],
              ),
              borderRadius: BorderRadius.circular(50),
              boxShadow: [BoxShadow(color: Colors.indigo.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
            ),
            child: const Icon(Icons.timer, size: 48, color: Colors.white),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.noEmomsYet,
            style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.createFirstEmom,
            style: TextStyle(fontSize: 16, color: Colors.grey[400]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          // Verbesserter Button
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.indigo[500]!, Colors.purple[500]!]),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [BoxShadow(color: Colors.indigo.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6))],
            ),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const EmomCreateScreen()));
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text(
                l10n.createEmom,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmomCard(BuildContext context, Emom emom, AppLocalizations l10n) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(emom.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EmomCreateScreen(emom: emom)));
                    } else if (value == 'delete') {
                      _showDeleteDialog(context, emom);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(children: [Icon(Icons.edit, size: 20), SizedBox(width: 8), Text(l10n.editEmom)]),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text(l10n.deleteEmom, style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildInfoChip(Icons.timer, '${emom.totalMinutes} Min', Colors.blue),
                const SizedBox(width: 8),
                _buildInfoChip(Icons.repeat, '${emom.intervalSeconds}s', Colors.green),
                const SizedBox(width: 8),
                _buildInfoChip(Icons.fitness_center, '${emom.exercises.length} Übungen', Colors.orange),
              ],
            ),
            if (emom.exercises.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(l10n.exercises, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 4),
              ...emom.exercises.map(
                (exercise) => Padding(
                  padding: const EdgeInsets.only(left: 8, top: 2),
                  child: Text(
                    '• ${exercise.exerciseName} (${exercise.displayText})',
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EmomTimerScreen(emom: emom)));
                },
                icon: const Icon(Icons.play_arrow),
                label: Text(l10n.startEmom),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Emom emom) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteEmomTitle),
        content: Text(l10n.deleteEmomConfirm(emom.name)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
          TextButton(
            onPressed: () {
              context.read<EmomProvider>().deleteEmom(emom.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.deleteEmom),
          ),
        ],
      ),
    );
  }

  void _showQuickStartDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final timeController = TextEditingController(text: '10');
    int selectedInterval = 60;
    final List<int> intervalOptions = [45, 60, 90];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.flash_on, color: Colors.green),
              const SizedBox(width: 8),
              Text(l10n.emomQuickStart),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.emomQuickStartDescription, style: TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 20),

              // Zeit eingeben
              const Text('Gewünschte Zeit:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: timeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Minuten',
                  hintText: 'z.B. 10',
                  suffixText: 'min',
                ),
              ),
              const SizedBox(height: 16),

              // Intervall auswählen
              const Text('Intervall:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: intervalOptions.map((interval) {
                  final isSelected = interval == selectedInterval;
                  return ChoiceChip(
                    label: Text('${interval}s'),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          selectedInterval = interval;
                        });
                      }
                    },
                    selectedColor: Colors.green.withOpacity(0.3),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.green : null,
                      fontWeight: isSelected ? FontWeight.bold : null,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Abbrechen')),
            ElevatedButton.icon(
              onPressed: () {
                final minutes = int.tryParse(timeController.text) ?? 10;
                if (minutes > 0 && minutes <= 120) {
                  Navigator.pop(context);
                  _startQuickEmom(context, minutes, selectedInterval);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Bitte geben Sie eine Zeit zwischen 1 und 120 Minuten ein.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('Starten'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void _startQuickEmom(BuildContext context, int minutes, int intervalSeconds) {
    final quickEmom = Emom(
      id: 'quick_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Schnellstart EMOM',
      totalMinutes: minutes,
      intervalSeconds: intervalSeconds,
      exercises: [], // Keine Übungen für Schnellstart
      isQuickStart: true,
    );

    Navigator.push(context, MaterialPageRoute(builder: (context) => EmomTimerScreen(emom: quickEmom)));
  }
}
