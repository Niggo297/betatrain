import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weight_unit_provider.dart';

class WeightDisplay {
  static String formatWeight(BuildContext context, double weight) {
    final weightUnitProvider = context.read<WeightUnitProvider>();
    return weightUnitProvider.formatWeight(weight);
  }

  static String getWeightUnit(BuildContext context) {
    final weightUnitProvider = context.read<WeightUnitProvider>();
    return weightUnitProvider.weightUnitString;
  }
}
