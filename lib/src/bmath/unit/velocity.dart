// VelocityUnit is an enum representing different velocity units
import 'unit.dart';

enum VelocityUnit implements BaseUnit {
  mps,
  kmh,
  fps,
  mph,
  kt;

  @override
  double toDefault(double value) {
    switch (this) {
      case VelocityUnit.mps:
        return value;
      case VelocityUnit.kmh:
        return value / 3.6;
      case VelocityUnit.fps:
        return value / 3.2808399;
      case VelocityUnit.mph:
        return value / 2.23693629;
      case VelocityUnit.kt:
        return value / 1.94384449;
      default:
        throw Exception("Velocity: unit $this is not supported");
    }
  }

  @override
  double fromDefault(double value, BaseUnit units) {
    switch (units) {
      case VelocityUnit.mps:
        return value;
      case VelocityUnit.kmh:
        return value * 3.6;
      case VelocityUnit.fps:
        return value * 3.2808399;
      case VelocityUnit.mph:
        return value * 2.23693629;
      case VelocityUnit.kt:
        return value * 1.94384449;
      default:
        throw Exception("Velocity: unit $units is not supported");
    }
  }
}

// Velocity class represents a velocity value with units
class Velocity extends ValueWithUnit<VelocityUnit> {
  Velocity(super.value, super.unit);

  Velocity.inUnits(Velocity other, VelocityUnit unit)
      : super(other.into(unit), unit);

  @override
  String toString() {
    try {
      double x = unit.fromDefault(value, unit);
      String unitName;
      int accuracy;
      switch (unit) {
        case VelocityUnit.mps:
          unitName = "m/s";
          accuracy = 0;
          break;
        case VelocityUnit.kmh:
          unitName = "km/h";
          accuracy = 1;
          break;
        case VelocityUnit.fps:
          unitName = "ft/s";
          accuracy = 1;
          break;
        case VelocityUnit.mph:
          unitName = "mph";
          accuracy = 1;
          break;
        case VelocityUnit.kt:
          unitName = "kt";
          accuracy = 1;
          break;
        default:
          unitName = "?";
          accuracy = 6;
      }
      return "${x.toStringAsFixed(accuracy)}$unitName";
    } catch (e) {
      return "Error: Unit conversion failed";
    }
  }

  @override
  String unitName() {
    return unit.name;
  }

  @override
  ValueWithUnit<VelocityUnit> inUnits(VelocityUnit units) {
    return Velocity(into(units), units);
  }
}
