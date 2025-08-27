/// One Rep Max Calculator für Kraftprogression
/// Implementiert verschiedene wissenschaftlich anerkannte Formeln
class OneRepMaxCalculator {
  /// Epley Formula: Weight × (1 + 0.0333 × Reps)
  /// Sehr populär und genau für Wiederholungen 1-10
  static double calculateEpley(double weight, int reps) {
    if (reps <= 0) return 0.0;
    if (reps == 1) return weight;
    return weight * (1 + 0.0333 * reps);
  }

  /// Brzycki Formula: Weight × (36 / (37 - Reps))
  /// Sehr genau für niedrige Wiederholungszahlen (1-6)
  static double calculateBrzycki(double weight, int reps) {
    if (reps <= 0 || reps >= 37) return 0.0;
    if (reps == 1) return weight;
    return weight * (36 / (37 - reps));
  }

  /// Lander Formula: Weight × (100 / (101.3 - 2.67123 × Reps))
  /// Gut für mittlere Wiederholungszahlen (6-12)
  static double calculateLander(double weight, int reps) {
    if (reps <= 0) return 0.0;
    if (reps == 1) return weight;
    return weight * (100 / (101.3 - 2.67123 * reps));
  }

  /// Durchschnitt aller drei Formeln für beste Genauigkeit
  static double calculateAverage(double weight, int reps) {
    if (reps <= 0) return 0.0;
    if (reps == 1) return weight;

    final epley = calculateEpley(weight, reps);
    final brzycki = calculateBrzycki(weight, reps);
    final lander = calculateLander(weight, reps);

    return (epley + brzycki + lander) / 3;
  }

  /// Beste Formel je nach Wiederholungsbereich wählen
  static double calculateOptimal(double weight, int reps) {
    if (reps <= 0) return 0.0;
    if (reps == 1) return weight;

    // 2-6 Reps: Brzycki (genauer für niedrige Reps)
    if (reps <= 6) {
      return calculateBrzycki(weight, reps);
    }
    // 7-12 Reps: Lander (besser für mittlere Reps)
    else if (reps <= 12) {
      return calculateLander(weight, reps);
    }
    // 13+ Reps: Epley (konservativer für hohe Reps)
    else {
      return calculateEpley(weight, reps);
    }
  }

  /// Volumen-Berechnung: Gewicht × Sätze × Wiederholungen
  static double calculateVolume(double weight, int sets, int reps) {
    return weight * sets * reps;
  }

  /// Intensität in Prozent des 1RM
  static double calculateIntensity(double weight, double oneRepMax) {
    if (oneRepMax <= 0) return 0.0;
    return (weight / oneRepMax) * 100;
  }
}

/// Progression Data Point für Charts
class ProgressionDataPoint {
  final DateTime date;
  final double weight;
  final int reps;
  final double oneRepMax;
  final double volume;

  ProgressionDataPoint({
    required this.date,
    required this.weight,
    required this.reps,
    required this.oneRepMax,
    required this.volume,
  });
}

/// Kraft-Progression Analyzer
class StrengthProgressionAnalyzer {
  /// Berechnet Kraft-Progression aus historischen Daten
  static List<ProgressionDataPoint> analyzeProgression(
    List<double> allWeights,
    List<int> allReps,
    List<DateTime> workoutDates,
  ) {
    final progressionData = <ProgressionDataPoint>[];

    if (allWeights.length != allReps.length || allWeights.length != workoutDates.length) {
      return progressionData; // Daten sind inkonsistent
    }

    for (int i = 0; i < allWeights.length; i++) {
      final weight = allWeights[i];
      final reps = allReps[i];
      final date = workoutDates[i];

      if (weight > 0 && reps > 0) {
        final oneRepMax = OneRepMaxCalculator.calculateOptimal(weight, reps);
        final volume = OneRepMaxCalculator.calculateVolume(weight, 1, reps);

        progressionData.add(
          ProgressionDataPoint(date: date, weight: weight, reps: reps, oneRepMax: oneRepMax, volume: volume),
        );
      }
    }

    // Sortiere nach Datum
    progressionData.sort((a, b) => a.date.compareTo(b.date));
    return progressionData;
  }

  /// Berechnet Progression-Prozentsatz zwischen erstem und letztem Wert
  static double calculateProgressionPercentage(List<ProgressionDataPoint> data) {
    if (data.length < 2) return 0.0;

    final firstValue = data.first.oneRepMax;
    final lastValue = data.last.oneRepMax;

    if (firstValue <= 0) return 0.0;
    return ((lastValue - firstValue) / firstValue) * 100;
  }

  /// Findet den besten 1RM Wert
  static double getBest1RM(List<ProgressionDataPoint> data) {
    if (data.isEmpty) return 0.0;
    return data.map((d) => d.oneRepMax).reduce((a, b) => a > b ? a : b);
  }

  /// Findet das höchste Volumen
  static double getBestVolume(List<ProgressionDataPoint> data) {
    if (data.isEmpty) return 0.0;
    return data.map((d) => d.volume).reduce((a, b) => a > b ? a : b);
  }
}
