import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum WeightUnit { kg, lbs }

class WeightUnitProvider with ChangeNotifier {
  WeightUnit _weightUnit = WeightUnit.kg;
  bool _isFirstTime = true;
  bool _isLoaded = false;

  WeightUnit get weightUnit => _weightUnit;
  bool get isFirstTime => _isFirstTime && _isLoaded;
  bool get isLoaded => _isLoaded;

  String get weightUnitString => _weightUnit == WeightUnit.kg ? 'kg' : 'lbs';

  String get weightUnitDisplayName {
    switch (_weightUnit) {
      case WeightUnit.kg:
        return 'Kilogramm (kg)';
      case WeightUnit.lbs:
        return 'Pound (lbs)';
    }
  }

  WeightUnitProvider() {
    _loadWeightUnit();
  }

  Future<void> _loadWeightUnit() async {
    final prefs = await SharedPreferences.getInstance();
    final unitString = prefs.getString('weight_unit');

    if (unitString == null) {
      _isFirstTime = true;
      _weightUnit = WeightUnit.kg; // Default
    } else {
      _isFirstTime = false;
      _weightUnit = unitString == 'lbs' ? WeightUnit.lbs : WeightUnit.kg;
    }
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> setWeightUnit(WeightUnit unit) async {
    if (_weightUnit != unit) {
      _weightUnit = unit;
      _isFirstTime = false; // Markiere als nicht mehr erstes Mal
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'weight_unit',
        unit == WeightUnit.kg ? 'kg' : 'lbs',
      );
      notifyListeners();
    }
  }

  // Reset für Testing - macht den Dialog beim nächsten Start wieder sichtbar
  Future<void> resetToFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('weight_unit');
    _isFirstTime = true;
    _isLoaded = true; // Damit der Check funktioniert
    _weightUnit = WeightUnit.kg;
    notifyListeners();
  }

  // Konvertierung von kg zu lbs und umgekehrt
  double convertWeight(double weight, {bool toLbs = false}) {
    if (toLbs) {
      return weight * 2.20462; // kg zu lbs
    } else {
      return weight / 2.20462; // lbs zu kg
    }
  }

  // Zeigt das Gewicht in der gewählten Einheit an
  String formatWeight(double weight) {
    if (_weightUnit == WeightUnit.lbs) {
      final weightInLbs = convertWeight(weight, toLbs: true);
      return '${weightInLbs.toStringAsFixed(1)} lbs';
    } else {
      return '${weight.toStringAsFixed(1)} kg';
    }
  }

  // Für Eingabefelder: konvertiert von der Anzeige-Einheit zurück zu kg (interne Speicherung)
  double convertToInternalWeight(double displayWeight) {
    if (_weightUnit == WeightUnit.lbs) {
      return convertWeight(displayWeight, toLbs: false); // lbs zu kg
    } else {
      return displayWeight; // schon in kg
    }
  }

  // Für Eingabefelder: konvertiert von der internen kg-Speicherung zur Anzeige-Einheit
  double convertFromInternalWeight(double internalWeight) {
    if (_weightUnit == WeightUnit.lbs) {
      return convertWeight(internalWeight, toLbs: true); // kg zu lbs
    } else {
      return internalWeight; // schon in kg
    }
  }
}
