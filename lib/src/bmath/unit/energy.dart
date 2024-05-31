// EnergyUnit.dart

import 'unit.dart';

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
  Energy(super.value, super.unit);

  @override
  String toString() {
    try {
      double value = unit.fromDefault(this.value, unit);
      String unitName;
      int accuracy;
      switch (unit) {
        case EnergyUnit.footPound:
          unitName = 'ft·lb';
          accuracy = 0;
          break;
        case EnergyUnit.joule:
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
