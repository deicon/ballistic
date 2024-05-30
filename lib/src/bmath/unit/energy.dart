// EnergyUnit.dart

import 'package:jbmcalc/src/bmath/unit/base_unit.dart';
import 'package:jbmcalc/src/bmath/unit/value_with_unit.dart';

enum EnergyUnit implements BaseUnit {
  footPound,
  joule;

  @override
  double toDefault(double value) {
    switch (this) {
      case EnergyUnit.footPound:
        return value;
      case EnergyUnit.joule:
        return value / 0.737562149277;
      default:
        throw ArgumentError('Energy: unit $this is not supported');
    }
  }

  @override
  double fromDefault(double value, BaseUnit units) {
    switch (units) {
      case EnergyUnit.footPound:
        return value;
      case EnergyUnit.joule:
        return value * 0.737562149277;
      default:
        throw ArgumentError('Energy: unit $units is not supported');
    }
  }
}

class Energy extends ValueWithUnit<EnergyUnit> {
  static const int energyFootPound = 30;
  static const int energyJoule = 31;

  Energy(super.value, super.unit);

  @override
  String toString() {
    try {
      String unitName;
      int accuracy;
      switch (value) {
        case energyFootPound:
          unitName = 'ft·lb';
          accuracy = 0;
          break;
        case energyJoule:
          unitName = 'J';
          accuracy = 0;
          break;
        default:
          unitName = '?';
          accuracy = 6;
      }
      String format = '${value.toStringAsFixed(accuracy)}$unitName';
      return format;
    } catch (e) {
      return 'Error: Unsupported unit';
    }
  }

  @override
  String unitName() {
    return unit.name;
  }

  @override
  ValueWithUnit<EnergyUnit> inUnits(EnergyUnit units) {
    return Energy(into(units), units);
  }
}
