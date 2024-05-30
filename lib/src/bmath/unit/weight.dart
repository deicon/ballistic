import 'package:jbmcalc/src/bmath/bmath.dart';
import 'package:jbmcalc/src/bmath/unit/value_with_unit.dart';

enum WeightUnit implements BaseUnit{
  grain,
  gram,
  kilogram,
  newton,
  pound,
  ounce;

  @override
  double toDefault(double value) {
    switch (this) {
      case WeightUnit.grain:
        return value;
      case WeightUnit.gram:
        return value / 15.4323584;
      case WeightUnit.kilogram:
        return value / 15432.3584;
      case WeightUnit.newton:
        return value / 151339.73750336;
      case WeightUnit.pound:
        return value * 0.000142857143;
      case WeightUnit.ounce:
        return value / 437.5;
      default:
        throw ArgumentError('Weight: unit $this is not supported');
    }
  }

  @override
  double fromDefault(double value, BaseUnit units) {
    switch (units) {
      case WeightUnit.grain:
        return value;
      case WeightUnit.gram:
        return value * 15.4323584;
      case WeightUnit.kilogram:
        return value * 15432.3584;
      case WeightUnit.newton:
        return value * 151339.73750336;
      case WeightUnit.pound:
        return value / 0.000142857143;
      case WeightUnit.ounce:
        return value * 437.5;
      default:
        throw ArgumentError('Weight: unit $units is not supported');
    }
  }
}

/// Represents a weight value with a specific unit.
class Weight extends ValueWithUnit< WeightUnit> {
  Weight(super.value, super.unit);

  @override
  String toString() {
    final convertedValue = value;
    final unitName = getUnitName(unit);
    final accuracy = getUnitAccuracy(unit);
    return convertedValue.toStringAsFixed(accuracy) + unitName;
  }

  /// Returns the unit name for the given unit.
  static String getUnitName(WeightUnit units) {
    switch (units) {
      case WeightUnit.grain:
        return 'gr';
      case WeightUnit.gram:
        return 'g';
      case WeightUnit.kilogram:
        return 'kg';
      case WeightUnit.newton:
        return 'N';
      case WeightUnit.pound:
        return 'lb';
      case WeightUnit.ounce:
        return 'oz';
      default:
        return '?';
    }
  }

  /// Returns the accuracy (number of decimal places) for the given unit.
  static int getUnitAccuracy(WeightUnit units) {
    switch (units) {
      case WeightUnit.grain:
        return 0;
      case WeightUnit.gram:
        return 1;
      case WeightUnit.kilogram:
        return 3;
      case WeightUnit.newton:
        return 3;
      case WeightUnit.pound:
        return 3;
      case WeightUnit.ounce:
        return 1;
      default:
        return 6;
    }
  }

  @override
  ValueWithUnit< WeightUnit> inUnits(WeightUnit units) {
    return Weight(into(units), units);
  }

  @override
  String unitName() {
   return unit.name;
  }

}
