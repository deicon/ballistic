import 'dart:math';

import 'package:ballistic/src/bmath/bmath.dart';

enum AngularUnit implements BaseUnit {
  radian,
  degree,
  moa,
  mil,
  mrad,
  thousand,
  inchesPer100Yd,
  cmPer100M;

  @override
  double toDefault(double value) {
    switch (this) {
      case AngularUnit.radian:
        return value;
      case AngularUnit.degree:
        return value / 180 * pi;
      case AngularUnit.moa:
        return value / 180 * pi / 60;
      case AngularUnit.mil:
        return value / 3200 * pi;
      case AngularUnit.mrad:
        return value / 1000;
      case AngularUnit.thousand:
        return value / 3000 * pi;
      case AngularUnit.inchesPer100Yd:
        return atan(value / 3600);
      case AngularUnit.cmPer100M:
        return atan(value / 10000);
      default:
        throw ArgumentError("Angular: unit $this is not supported");
    }
  }

  @override
  double fromDefault(double value, BaseUnit units) {
    switch (units) {
      case AngularUnit.radian:
        return value;
      case AngularUnit.degree:
        return value * 180 / pi;
      case AngularUnit.moa:
        return value * 180 / pi * 60;
      case AngularUnit.mil:
        return value * 3200 / pi;
      case AngularUnit.mrad:
        return value * 1000;
      case AngularUnit.thousand:
        return value * 3000 / pi;
      case AngularUnit.inchesPer100Yd:
        return tan(value) * 3600;
      case AngularUnit.cmPer100M:
        return tan(value) * 10000;
      default:
        throw ArgumentError("Angular: unit $this is not supported");
    }
  }
}

const String defaultUnitsError = "error: default units aren't correct";

// Angular structure keeps information about angular units
class Angular extends ValueWithUnit<AngularUnit> {
  Angular(super.value, super.unit, {super.convert});

  Angular.zero() : super(0, AngularUnit.radian);

  factory Angular.create(double value, AngularUnit unit) {
    return Angular(Angular.zero().convertToDefault(value), unit);
  }

  /// Prints the value in its default units.
  ///
  /// The default unit is the unit used in the CreateAngular function
  /// or in Convert method.
  @override
  String toString() {
    double x = unit.fromDefault(value, unit);

    String unitName;
    int accuracy;
    switch (unit) {
      case AngularUnit.radian:
        unitName = "rad";
        accuracy = 6;
        break;
      case AngularUnit.degree:
        unitName = "°";
        accuracy = 4;
        break;
      case AngularUnit.moa:
        unitName = "moa";
        accuracy = 2;
        break;
      case AngularUnit.mil:
        unitName = "mil";
        accuracy = 2;
        break;
      case AngularUnit.mrad:
        unitName = "mrad";
        accuracy = 2;
        break;
      case AngularUnit.thousand:
        unitName = "ths";
        accuracy = 2;
        break;
      case AngularUnit.inchesPer100Yd:
        unitName = "in/100yd";
        accuracy = 2;
        break;
      case AngularUnit.cmPer100M:
        unitName = "cm/100m";
        accuracy = 2;
        break;
      default:
        unitName = "?";
        accuracy = 6;
    }
    return "${x.toStringAsFixed(accuracy)}$unitName";
  }

  @override
  double convertToDefault(double value) {
    switch (unit) {
      case AngularUnit.radian:
        return value;
      case AngularUnit.degree:
        return value / 180 * pi;
      case AngularUnit.moa:
        return value / 180 * pi / 60;
      case AngularUnit.mil:
        return value / 3200 * pi;
      case AngularUnit.mrad:
        return value / 1000;
      case AngularUnit.thousand:
        return value / 3000 * pi;
      case AngularUnit.inchesPer100Yd:
        return atan(value / 3600);
      case AngularUnit.cmPer100M:
        return atan(value / 10000);
      default:
        throw ArgumentError("Angular: unit $unit is not supported");
    }
  }

  @override
  String unitName() {
    // TODO: implement unitName
    throw UnimplementedError();
  }

  @override
  ValueWithUnit<AngularUnit> inUnits(AngularUnit units) {
    return Angular(into(units), units);
  }
}
