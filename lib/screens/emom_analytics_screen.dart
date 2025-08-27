// Beispiel: EMOM Performance Analytics
import 'package:flutter/material.dart';

class EmomAnalyticsScreen extends StatelessWidget {
  const EmomAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📊 EMOM Analytics'), backgroundColor: Colors.orange),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildStatsCard('Diese Woche', {
            'Trainings': '5',
            'Gesamtzeit': '2h 15min',
            'Runden': '147',
            'Durchschnitt': '29.4 Runden/Training',
          }),

          _buildTrendCard('Fortschritt', [
            {'Woche': 'KW 1', 'Runden': 120},
            {'Woche': 'KW 2', 'Runden': 135},
            {'Woche': 'KW 3', 'Runden': 147},
          ]),

          _buildPersonalRecords(),
          _buildFavoriteEmoms(),
        ],
      ),
    );
  }

  Widget _buildStatsCard(String title, Map<String, String> stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...stats.entries.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(e.key),
                    Text(e.value, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendCard(String title, List<Map<String, dynamic>> data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(height: 120, child: const Center(child: Text('📈 Hier würde ein Fortschritts-Chart stehen'))),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalRecords() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('🏆 Persönliche Rekorde', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.timer, color: Colors.amber),
              title: const Text('Längste EMOM Session'),
              subtitle: const Text('45 Minuten - Burpee Challenge'),
              trailing: const Text('12.08.2025'),
            ),
            ListTile(
              leading: const Icon(Icons.fitness_center, color: Colors.green),
              title: const Text('Meiste Runden an einem Tag'),
              subtitle: const Text('67 Runden - Mixed EMOM'),
              trailing: const Text('18.08.2025'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteEmoms() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('⭐ Lieblings-EMOMs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('1. Burpee Madness - 23x absolviert'),
            const Text('2. Push-Pull Power - 18x absolviert'),
            const Text('3. Leg Day Hell - 15x absolviert'),
          ],
        ),
      ),
    );
  }
}
