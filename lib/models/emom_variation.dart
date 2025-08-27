// Beispiel: Neue EMOM Variationen
import '../models/emom.dart';

enum EmomType {
  standard, // Normale EMOMs
  ladder, // 1-2-3-4-5... Reps jede Minute
  deathBy, // Steigerung bis zum Versagen
  amrap, // As Many Reps As Possible
  restBased, // Variable Pausen
  random, // Zufällige Übungsauswahl
}

class EmomVariation {
  final EmomType type;
  final String name;
  final String description;
  final Map<String, dynamic> parameters;

  EmomVariation({required this.type, required this.name, required this.description, required this.parameters});

  // Beispiele für verschiedene EMOM-Typen:

  static EmomVariation createLadderEmom() {
    return EmomVariation(
      type: EmomType.ladder,
      name: "Ladder EMOM",
      description: "Reps steigen jede Minute: 1-2-3-4-5...",
      parameters: {'startReps': 1, 'increment': 1, 'maxReps': 10},
    );
  }

  static EmomVariation createDeathByEmom() {
    return EmomVariation(
      type: EmomType.deathBy,
      name: "Death By EMOM",
      description: "Jede Minute +1 Rep bis zum Versagen",
      parameters: {'startReps': 1, 'increment': 1, 'maxMinutes': 20},
    );
  }

  static EmomVariation createAmrapEmom() {
    return EmomVariation(
      type: EmomType.amrap,
      name: "AMRAP EMOM",
      description: "Übung fertigmachen, dann AMRAP in verbleibender Zeit",
      parameters: {'requiredReps': 5, 'amrapExercise': 'Air Squats'},
    );
  }

  static EmomVariation createRandomEmom() {
    return EmomVariation(
      type: EmomType.random,
      name: "Surprise EMOM",
      description: "App wählt zufällige Übungen aus Ihrem Pool",
      parameters: {
        'exercisePool': ['Push-ups', 'Burpees', 'Squats', 'Mountain Climbers'],
        'surpriseLevel': 'medium', // low, medium, high
      },
    );
  }

  // Logik für Timer-Anpassungen basierend auf EMOM-Typ
  int calculateRepsForRound(int round, int baseReps) {
    switch (type) {
      case EmomType.ladder:
        return parameters['startReps'] + (round - 1) * parameters['increment'];
      case EmomType.deathBy:
        return parameters['startReps'] + (round - 1) * parameters['increment'];
      case EmomType.amrap:
        return parameters['requiredReps'];
      default:
        return baseReps;
    }
  }

  String getInstructionForRound(int round) {
    switch (type) {
      case EmomType.ladder:
        final reps = calculateRepsForRound(round, 0);
        return "Runde $round: $reps Wiederholungen";
      case EmomType.deathBy:
        final reps = calculateRepsForRound(round, 0);
        return "Minute $round: $reps Reps - Überleben!";
      case EmomType.amrap:
        return "Erst ${parameters['requiredReps']} Reps, dann AMRAP!";
      case EmomType.random:
        return "Überraschung! Neue Übung wird ausgewählt...";
      default:
        return "Standard EMOM - Runde $round";
    }
  }
}
