// Beispiel: Erweiterte Audio-Coaching Features
import 'package:flutter/services.dart';

class EmomCoachingService {
  // Voice-Over für Übungsansagen (Placeholder - würde echte TTS Library benötigen)
  Future<void> announceExercise(String exerciseName, int reps) async {
    // Placeholder für Text-to-Speech Implementierung
    // In einer echten App würde man hier flutter_tts oder ähnliches verwenden
    print("TTS: Nächste Übung: $exerciseName, $reps Wiederholungen");

    // Optional: Haptic Feedback als Alternative
    await HapticFeedback.mediumImpact();
  }

  // Motivations-Nachrichten basierend auf Fortschritt
  String getMotivationalMessage(int currentRound, int totalRounds, double completionRate) {
    if (completionRate > 0.9) return "Perfekte Ausführung! Weiter so!";
    if (currentRound > totalRounds * 0.8) return "Fast geschafft! Durchhalten!";
    return "Du schaffst das! Bleib fokussiert!";
  }

  // Adaptive Pausenempfehlungen
  Duration recommendRestTime(int heartRate, int targetHeartRate) {
    if (heartRate > targetHeartRate * 1.2) {
      return const Duration(seconds: 15); // Längere Pause
    }
    return const Duration(seconds: 5); // Standard Pause
  }

  // Coaching-Tipps basierend auf EMOM-Phase
  String getCoachingTip(int roundsCompleted, double averageTime) {
    if (averageTime < 30) {
      return "Perfekte Zeit! Du kannst das Tempo halten.";
    } else if (averageTime > 50) {
      return "Nimm dir Zeit für saubere Ausführung. Qualität vor Geschwindigkeit!";
    }
    return "Guter Rhythmus! Konzentriere dich auf die Atmung.";
  }

  // EMOM-spezifische Ermutigung
  String getEmomSpecificEncouragement(int currentMinute, int totalMinutes) {
    final progress = currentMinute / totalMinutes;

    if (progress < 0.25) {
      return "🔥 Starker Start! Halte den Fokus!";
    } else if (progress < 0.5) {
      return "💪 Halbzeit! Du bist auf dem richtigen Weg!";
    } else if (progress < 0.75) {
      return "🚀 Endspurt! Gib alles was du hast!";
    } else {
      return "🏆 Fast geschafft! Jede Minute zählt!";
    }
  }
}
