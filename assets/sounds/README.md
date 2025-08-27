# EMOM Sound Assets

Platzieren Sie hier Ihre Sound-Dateien für die EMOM-Timer-Funktionalität.

## Benötigte Dateien:

### Für Android Emulator (optimale Kompatibilität):
- `start.wav` - Startsound (deutlich erkennbar, ~300ms)
- `halfTime.wav` - Halbzeit-Signal (~250ms)
- `tick.wav` - Countdown-Tick für 6-10 Sekunden (~200ms)
- `warning.wav` - Warnsound für 4-5 Sekunden (~250ms)
- `urgent.wav` - Dringender Sound für 1-3 Sekunden (~200ms)
- `finish.wav` - Schlusssound am Ende jeder Runde (~300ms)
- `go.wav` - GO-Sound nach Countdown (~250ms)

### Alternative Formate (Fallback):
- `.ogg` Dateien mit identischen Namen
- `.mp3` Dateien (weniger empfohlen für Emulator)

## Android Emulator - Optimale Einstellungen:

### Audio-Format Spezifikationen (Emulator-optimiert):
- **Format**: 16-bit PCM WAV (beste Emulator-Kompatibilität)
- **Samplingrate**: 44.1 kHz
- **Bit-Tiefe**: 16-bit
- **Kanäle**: Mono (ausreichend für Signaltöne)
- **Mindestlänge**: 200ms+ (längere Töne werden zuverlässiger abgespielt)
- **Dateigröße**: 10-50KB pro Datei

### Warum WAV für Android Emulator:
- ✅ Beste Emulator-Kompatibilität
- ✅ Keine Dekodierung nötig
- ✅ Geringste Latenz
- ✅ Zuverlässige Wiedergabe auch kurzer Sounds
- ✅ Funktioniert auch bei schwacher Emulator-Performance

### Emulator-Einstellungen prüfen:
1. **Extended Controls öffnen** (3-Punkte-Menü im Emulator)
2. **Audio-Sektion** auswählen
3. **"Microphone"** aktivieren
4. **"Play Audio"** aktivieren  
5. **Host Audio Input/Output** aktivieren
6. **Anderes Systemimage testen** falls Probleme bestehen (API 31+ empfohlen)

## Sound-Eigenschaften:

### `start.wav` - Startsound
- **Zweck**: Workout-Beginn signalisieren
- **Charakter**: Deutlich, motivierend, energiegeladen
- **Dauer**: 300ms (optimal für Emulator)
- **Beispiele**: Längerer Pfeifton, Gong, "Beep-Beep"

### `halfTime.wav` - Halbzeit
- **Zweck**: Mittelpunkt der Runde markieren
- **Charakter**: Neutral, kurz, erkennbar
- **Dauer**: 250ms (optimal für Emulator)
- **Beispiele**: Doppelklick, kurzer Gong

### `tick.wav` - Countdown-Tick
- **Zweck**: Countdown 10-6 Sekunden vor Rundenende
- **Charakter**: Neutral, rhythmisch
- **Dauer**: 200ms (mindestens für Emulator)
- **Beispiele**: Metronom-Tick, kurzer Klick

### `warning.wav` - Warnsound
- **Zweck**: 5-4 Sekunden vor Rundenende
- **Charakter**: Aufmerksamkeitserregend, aber nicht aufdringlich
- **Dauer**: 250ms (optimal für Emulator)
- **Beispiele**: Höherer Ton, Doppel-Beep

### `urgent.wav` - Dringend
- **Zweck**: 3-1 Sekunden vor Rundenende
- **Charakter**: Dringlich, schnell
- **Dauer**: 200ms (mindestens für Emulator)
- **Beispiele**: Schneller Beep, hoher Pfeifton

### `finish.wav` - Rundenende
- **Zweck**: Ende einer EMOM-Runde
- **Charakter**: Abschließend, erkennbar
- **Dauer**: 300ms (optimal für Emulator)
- **Beispiele**: Glocke, "Ding", Abschlusston

### `go.wav` - GO-Signal
- **Zweck**: Start nach Countdown
- **Charakter**: Motivierend, energisch
- **Dauer**: 250ms (optimal für Emulator)
- **Beispiele**: "GO!"-Sound, Startpfeife

## Empfohlene Sound-Quellen:

### Kostenlose Quellen:
- **Freesound.org** (CC-Lizenz, hochwertige Sounds)
- **Zapsplat.com** (nach kostenloser Registrierung)
- **BBC Sound Effects Library** (kostenlos für nicht-kommerzielle Nutzung)
- **Adobe Audition** (eingebaute Effekte)

### Kommerzielle Quellen:
- **Adobe Stock Audio**
- **AudioJungle**
- **Pond5**

## Audio-Bearbeitung:

### Empfohlene Tools:
- **Audacity** (kostenlos, alle Plattformen)
- **Adobe Audition** (professionell)
- **GarageBand** (macOS/iOS)
- **WavePad** (Windows)

### Bearbeitungsschritte:
1. **Normalisierung**: Audio auf -3dB normalisieren
2. **Fade-in/out**: Kurze Ein-/Ausblendungen (10-50ms)
3. **EQ**: Hochpass-Filter bei 80Hz für klarere Sounds
4. **Kompression**: Leichte Kompression für gleichmäßige Lautstärke
5. **Export**: OGG Vorbis, Qualität 6-8, 44.1kHz, 16-bit

## Fallback-Verhalten:

Wenn keine Audio-Dateien gefunden werden:
- ✅ Automatischer Fallback zu Systemsounds
- ✅ Haptisches Feedback (Vibration)
- ✅ Keine Fehlermeldungen
- ✅ Vollständige Funktionalität erhalten

## Installation:

1. Sound-Dateien in `assets/sounds/` ablegen
2. `flutter clean` ausführen
3. `flutter pub get` ausführen
4. App neu kompilieren

## Test im Android Emulator:

```bash
# Dependencies installieren
flutter pub get

# Audio-Dateien prüfen
flutter doctor

# Im Emulator testen
flutter run
```

Die App erkennt automatisch verfügbare Audio-Dateien und verwendet diese anstelle der Systemsounds.
