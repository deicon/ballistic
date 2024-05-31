
import 'package:ballistic/ballistic.dart';

enum DistanceUnit implements BaseUnit {
  inch,
  yard,
  mile,
  nauticalMile,
  millimeter,
  centimeter,
  meter,
  kilometer,
  line,
  foot;

  @override
  double toDefault(double value) {
    switch (this) {
      case DistanceUnit.inch:
        return value;
      case DistanceUnit.foot:
        return value * 12;
      case DistanceUnit.yard:
        return value * 36;
      case DistanceUnit.mile:
        return value * 63360;
      case DistanceUnit.nauticalMile:
        return value * 72913.3858;
      case DistanceUnit.line:
        return value / 10;
      case DistanceUnit.millimeter:
        return value / 25.4;
      case DistanceUnit.centimeter:
        return value / 2.54;
      case DistanceUnit.meter:
        return value / 25.4 * 1000;
      case DistanceUnit.kilometer:
        return value / 25.4 * 1000000;
      default:
        throw Exception('Distance: unit $this is not supported');
    }
  }

  @override
  double fromDefault(double value, BaseUnit units) {
      switch (units) {
        case DistanceUnit.inch:
          return value;
        case DistanceUnit.foot:
          return value / 12;
        case DistanceUnit.yard:
          return value / 36;
        case DistanceUnit.mile:
          return value / 63360;
        case DistanceUnit.nauticalMile:
          return value / 72913.3858;
        case DistanceUnit.line:
          return value * 10;
        case DistanceUnit.millimeter:
          return value * 25.4;
        case DistanceUnit.centimeter:
          return value * 2.54;
        case DistanceUnit.meter:
          return value * 25.4 / 1000;
        case DistanceUnit.kilometer:
          return value * 25.4 / 1000000;
        default:
          throw Exception('Distance: unit $units is not supported');
    }
  }

}

/// The Distance structure keeps the distance value.
class Distance extends ValueWithUnit<DistanceUnit> {
  Distance(super.value, super.unit);

  Distance.zero() : super(0.0, DistanceUnit.meter);

  @override
  String toString() {
    try {
      final defaultValue = unit.fromDefault(value, unit);
      final accuracy = getAccuracy();
      return '${defaultValue.toStringAsFixed(accuracy)}${unitName()}';
    } catch (_) {
      return 'Distance: unit $unit is not supported';
    }
  }

  /// Returns the unit name for the given units.
  static String getUnitName(DistanceUnit units) {
    switch (units) {
      case DistanceUnit.inch:
        return "inch";
      case DistanceUnit.foot:
        return "ft";
      case DistanceUnit.yard:
        return "yd";
      case DistanceUnit.mile:
        return "mi";
      case DistanceUnit.nauticalMile:
        return "nm";
      case DistanceUnit.line:
        return "ln";
      case DistanceUnit.millimeter:
        return "mm";
      case DistanceUnit.centimeter:
        return "cm";
      case DistanceUnit.meter:
        return "m";
      case DistanceUnit.kilometer:
        return "km";
      default:
        return "?";
    }
  }

  /// Returns the accuracy for the given units.
  int getAccuracy() {
    switch (unit) {
      case DistanceUnit.inch:
        return 1;
      case DistanceUnit.foot:
        return 2;
      case DistanceUnit.yard:
        return 3;
      case DistanceUnit.mile:
        return 3;
      case DistanceUnit.nauticalMile:
        return 3;
      case DistanceUnit.line:
        return 1;
      case DistanceUnit.millimeter:
        return 0;
      case DistanceUnit.centimeter:
        return 1;
      case DistanceUnit.meter:
        return 2;
      case DistanceUnit.kilometer:
        return 3;
      default:
        return 6;
    }
  }

  @override
  ValueWithUnit<DistanceUnit> inUnits(DistanceUnit units) {
    return Distance(into(units), units);
  }

  @override
  String unitName() {
    return unit.name;
  }


}
