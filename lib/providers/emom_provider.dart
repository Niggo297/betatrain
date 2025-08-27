import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/emom.dart';

class EmomProvider with ChangeNotifier {
  List<Emom> _emoms = [];

  List<Emom> get emoms => _emoms;

  EmomProvider() {
    _loadEmoms();
  }

  Future<void> _loadEmoms() async {
    final prefs = await SharedPreferences.getInstance();
    final emomsJson = prefs.getStringList('emoms') ?? [];

    _emoms = emomsJson.map((json) {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return Emom.fromMap(map);
    }).toList();

    notifyListeners();
  }

  Future<void> _saveEmoms() async {
    final prefs = await SharedPreferences.getInstance();
    final emomsJson = _emoms.map((emom) => jsonEncode(emom.toMap())).toList();
    await prefs.setStringList('emoms', emomsJson);
  }

  Future<void> addEmom(Emom emom) async {
    _emoms.add(emom);
    await _saveEmoms();
    notifyListeners();
  }

  Future<void> updateEmom(Emom updatedEmom) async {
    final index = _emoms.indexWhere((emom) => emom.id == updatedEmom.id);
    if (index != -1) {
      _emoms[index] = updatedEmom;
      await _saveEmoms();
      notifyListeners();
    }
  }

  Future<void> deleteEmom(String emomId) async {
    _emoms.removeWhere((emom) => emom.id == emomId);
    await _saveEmoms();
    notifyListeners();
  }

  Emom? getEmomById(String id) {
    try {
      return _emoms.firstWhere((emom) => emom.id == id);
    } catch (e) {
      return null;
    }
  }
}
