import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

class EmomAudioService {
  static final EmomAudioService _instance = EmomAudioService._internal();
  factory EmomAudioService() => _instance;
  EmomAudioService._internal();

  bool _isInitialized = false;
  final Map<String, AudioPlayer> _audioPlayers = {}; // SoundPool-ähnlich: ein Player pro Sound
  bool _useSystemSounds = false;
  DateTime _lastSoundTime = DateTime.now();

  // Optimierte Sound-Pfade für Android Emulator (WAV-Format bevorzugt für kurze Töne)
  static const String _soundPath = 'sounds/';
  static const Map<String, String> _soundFiles = {
    'start': '${_soundPath}start.wav', // 16-bit PCM WAV, 44.1 kHz, ~300ms
    'halfTime': '${_soundPath}halfTime.wav', // 16-bit PCM WAV, 44.1 kHz, ~250ms
    'tick': '${_soundPath}tick.wav', // 16-bit PCM WAV, 44.1 kHz, ~200ms
    'warning': '${_soundPath}warning.wav', // 16-bit PCM WAV, 44.1 kHz, ~250ms
    'urgent': '${_soundPath}urgent.wav', // 16-bit PCM WAV, 44.1 kHz, ~200ms
    'finish': '${_soundPath}finish.wav', // 16-bit PCM WAV, 44.1 kHz, ~300ms
    'go': '${_soundPath}go.wav', // 16-bit PCM WAV, 44.1 kHz, ~250ms
  };

  // Initialisierung - jeden Sound separat laden (SoundPool-Verhalten)
  Future<void> init() async {
    if (_isInitialized) return;

    print('🎵 Initialisiere Audio-Service...');

    // Erstelle für jeden Sound einen eigenen AudioPlayer
    for (String soundKey in _soundFiles.keys) {
      _audioPlayers[soundKey] = AudioPlayer();

      try {
        // Preload Sound (SoundPool-ähnlich)
        await _audioPlayers[soundKey]!.setSource(AssetSource(_soundFiles[soundKey]!));
        print('✅ Sound geladen: $soundKey');
      } catch (e) {
        print('❌ Fehler beim Laden von $soundKey: $e');
        _useSystemSounds = true;
      }
    }

    if (!_useSystemSounds) {
      print('🎵 Alle Audio-Dateien erfolgreich geladen');
    } else {
      print('🔊 Fallback zu Systemsounds aktiviert');
    }

    _isInitialized = true;
  }

  // Aufräumen
  void dispose() {
    for (AudioPlayer player in _audioPlayers.values) {
      player.dispose();
    }
    _audioPlayers.clear();
    _isInitialized = false;
  }

  // Private Hilfsfunktion zum Abspielen von Sounds mit Pause zwischen Sounds
  Future<void> _playSound(String soundKey, {SystemSoundType? fallback}) async {
    if (!_isInitialized) await init();

    // Kleine Pause zwischen Sounds einfügen (Emulator-Optimierung)
    final now = DateTime.now();
    final timeSinceLastSound = now.difference(_lastSoundTime).inMilliseconds;
    if (timeSinceLastSound < 50) {
      await Future.delayed(Duration(milliseconds: 50 - timeSinceLastSound));
    }
    _lastSoundTime = DateTime.now();

    if (!_useSystemSounds && _audioPlayers.containsKey(soundKey)) {
      try {
        final player = _audioPlayers[soundKey]!;

        // Stop current playback und restart (SoundPool-Verhalten)
        await player.stop();
        await Future.delayed(const Duration(milliseconds: 10)); // Kurze Pause
        await player.resume(); // Spiele von Beginn ab

        print('🔊 Spiele Sound: $soundKey');
        return;
      } catch (e) {
        print('❌ Fehler beim Abspielen von $soundKey: $e');
        _useSystemSounds = true; // Fallback aktivieren
      }
    }

    // Fallback: Verstärkte Systemsounds + Vibration
    print('🔊 Fallback Sound: $soundKey');
    if (fallback != null) {
      SystemSound.play(fallback);
    }
    HapticFeedback.heavyImpact(); // Verstärkte Vibration für Emulator
  }

  // STARTSOUND - Deutlich erkennbar
  Future<void> playStartSound() async {
    await _playSound('start', fallback: SystemSoundType.alert);

    // Doppelklick-Effekt für bessere Erkennbarkeit
    await Future.delayed(const Duration(milliseconds: 200));
    HapticFeedback.heavyImpact();
    if (_useSystemSounds) {
      SystemSound.play(SystemSoundType.alert);
    }
  }

  // HALBZEIT-SOUND
  Future<void> playHalfTimeSound() async {
    await _playSound('halfTime', fallback: SystemSoundType.click);

    // Doppelklick für bessere Erkennbarkeit
    await Future.delayed(const Duration(milliseconds: 150));
    HapticFeedback.mediumImpact();
    if (_useSystemSounds) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  // COUNTDOWN-TICK (6-10 Sekunden)
  Future<void> playTickSound() async {
    await _playSound('tick', fallback: SystemSoundType.click);
  }

  // WARNSOUND (4-5 Sekunden)
  Future<void> playWarningSound() async {
    await _playSound('warning', fallback: SystemSoundType.click);

    // Doppelklick für mehr Aufmerksamkeit
    await Future.delayed(const Duration(milliseconds: 100));
    HapticFeedback.mediumImpact();
    if (_useSystemSounds) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  // DRINGENDER SOUND (1-3 Sekunden)
  Future<void> playUrgentSound() async {
    await _playSound('urgent', fallback: SystemSoundType.alert);
  }

  // SCHLUSSSOUND (Ende der Runde)
  Future<void> playFinishSound() async {
    await _playSound('finish', fallback: SystemSoundType.alert);
  }

  // GO-Sound für Countdown-Ende
  Future<void> playGoSound() async {
    await Future.delayed(const Duration(milliseconds: 100));
    await _playSound('go', fallback: SystemSoundType.alert);

    await Future.delayed(const Duration(milliseconds: 150));
    HapticFeedback.heavyImpact();
    if (_useSystemSounds) {
      SystemSound.play(SystemSoundType.alert);
    }
  }

  // EMOM ABGESCHLOSSEN - Finale Fanfare
  Future<void> playCompletionFanfare() async {
    // 4 aufsteigende Finish-Sounds mit unterschiedlichen Timings
    await playFinishSound();
    await Future.delayed(const Duration(milliseconds: 300));

    await playFinishSound();
    await Future.delayed(const Duration(milliseconds: 300));

    await playFinishSound();
    await Future.delayed(const Duration(milliseconds: 600));

    // Finaler Doppelklick
    HapticFeedback.heavyImpact();
    if (_useSystemSounds) {
      SystemSound.play(SystemSoundType.alert);
    }
    await Future.delayed(const Duration(milliseconds: 200));
    HapticFeedback.heavyImpact();
    if (_useSystemSounds) {
      SystemSound.play(SystemSoundType.alert);
    }
  }

  // DEBUG: Test alle Sounds (für Emulator-Testing)
  Future<void> testAllSounds() async {
    print('🧪 Teste alle Sounds...');

    print('🧪 Test 1: Start');
    await playStartSound();
    await Future.delayed(const Duration(seconds: 1));

    print('🧪 Test 2: Tick');
    await playTickSound();
    await Future.delayed(const Duration(seconds: 1));

    print('🧪 Test 3: Warning');
    await playWarningSound();
    await Future.delayed(const Duration(seconds: 1));

    print('🧪 Test 4: Urgent');
    await playUrgentSound();
    await Future.delayed(const Duration(seconds: 1));

    print('🧪 Test 5: HalfTime');
    await playHalfTimeSound();
    await Future.delayed(const Duration(seconds: 1));

    print('🧪 Test 6: Finish');
    await playFinishSound();
    await Future.delayed(const Duration(seconds: 1));

    print('🧪 Test 7: Go');
    await playGoSound();

    print('🧪 Sound-Test abgeschlossen!');
  }

  // Audio-Status für Debugging
  Map<String, dynamic> getAudioStatus() {
    return {
      'initialized': _isInitialized,
      'useSystemSounds': _useSystemSounds,
      'loadedSounds': _audioPlayers.keys.toList(),
      'totalPlayers': _audioPlayers.length,
    };
  }
}
