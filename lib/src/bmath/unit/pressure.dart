import 'unit.dart';

enum PressureUnit implements BaseUnit {
  mmHg,
  inHgg,
  bar,
  hPa,
  psi;

  @override
  double toDefault(double value) {
    switch (this) {
      case PressureUnit.mmHg:
        return value;
      case PressureUnit.inHgg:
        return value * 25.4;
      case PressureUnit.bar:
        return value * 750.061683;
      case PressureUnit.hPa:
        return value * 750.061683 / 1000;
      case PressureUnit.psi:
        return value * 51.714924102396;
      default:
        throw Exception("Pressure: unit $this is not supported");
    }
  }

  @override
  double fromDefault(double value, BaseUnit units) {
    switch (units) {
      case PressureUnit.mmHg:
        return value;
      case PressureUnit.inHgg:
        return value / 25.4;
      case PressureUnit.bar:
        return value / 750.061683;
      case PressureUnit.hPa:
        return value / 750.061683 * 1000;
      case PressureUnit.psi:
        return value / 51.714924102396;
      default:
        throw Exception("Pressure: unit $units is not supported");
    }
  }
}

// Pressure structure keeps information about atmospheric pressure
class Pressure extends ValueWithUnit<PressureUnit> {
  Pressure(super.value, super.unit);

  @override
  String toString() {
    try {
      final x = unit.fromDefault(value, unit);
      String unitName;
      int accuracy;
      switch (unit) {
        case PressureUnit.mmHg:
          unitName = "mmHg";
          accuracy = 0;
          break;
        case PressureUnit.inHgg:
          unitName = "inHg";
          accuracy = 2;
          break;
        case PressureUnit.bar:
          unitName = "bar";
          accuracy = 2;
          break;
        case PressureUnit.hPa:
          unitName = "hPa";
          accuracy = 4;
          break;
        case PressureUnit.psi:
          unitName = "psi";
          accuracy = 4;
          break;
        default:
          unitName = "?";
          accuracy = 6;
          break;
      }
      final format = "${x.toStringAsFixed(accuracy)}$unitName";
      return format;
    } catch (e) {
      return "defaultUnitsError";
    }
  }

  @override
  ValueWithUnit<PressureUnit> inUnits(PressureUnit units) {
    return Pressure(into(units), units);
  }

  @override
  String unitName() {
    return unit.name;
  }
}
