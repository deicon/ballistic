import 'dart:core';

import 'unit.dart';

enum TemperatureUnit implements BaseUnit {
  fahrenheit,
  celsius,
  kelvin,
  rankin;

  @override
  double toDefault(double value) {
    switch (this) {
      case TemperatureUnit.fahrenheit:
        return value;
      case TemperatureUnit.rankin:
        return value + 459.67;
      case TemperatureUnit.celsius:
        return value * 9 / 5 + 32;
      case TemperatureUnit.kelvin:
        return (value - 273.15) * 9 / 5 + 32;
      default:
        throw Exception('Temperature: unit $this is not supported');
    }
  }

  @override
  double fromDefault(double value, BaseUnit units) {
    switch (units) {
      case TemperatureUnit.fahrenheit:
        return value;
      case TemperatureUnit.rankin:
        return value - 459.67;
      case TemperatureUnit.celsius:
        return (value - 32) * 5 / 9;
      case TemperatureUnit.kelvin:
        return (value - 32) * 5 / 9 + 273.15;
      default:
        throw Exception('Temperature: unit $units is not supported');
    }
  }
}

/// Temperature class keeps information about the temperature
class Temperature extends ValueWithUnit<TemperatureUnit> {
  Temperature(super.value, super.unit);
  Temperature.inUnit(Temperature other, TemperatureUnit unit)
      : super(other.into(unit), unit);

  @override
  String toString() {
    try {
      double x = unit.fromDefault(value, unit);
      String unitName;
      int accuracy;
      switch (unit) {
        case TemperatureUnit.fahrenheit:
          unitName = '°F';
          accuracy = 1;
          break;
        case TemperatureUnit.rankin:
          unitName = '°R';
          accuracy = 1;
          break;
        case TemperatureUnit.celsius:
          unitName = '°C';
          accuracy = 1;
          break;
        case TemperatureUnit.kelvin:
          unitName = '°K';
          accuracy = 1;
          break;
        default:
          unitName = '?';
          accuracy = 6;
      }
      return '${x.toStringAsFixed(accuracy)}$unitName';
    } catch (e) {
      return 'Error converting temperature';
    }
  }

  @override
  String unitName() {
    return unit.name;
  }

  @override
  ValueWithUnit<TemperatureUnit> inUnits(TemperatureUnit units) {
    return Temperature(into(units), units);
  }
}

void main() async {
  // Example usage:
  try {
    var temp = Temperature(100, TemperatureUnit.celsius);
    print(temp.toString()); // 212.0°F
    print(Temperature.inUnit(temp, TemperatureUnit.kelvin)
        .toString()); // 373.15°K
    print(temp.inUnits(TemperatureUnit.rankin)); // 671.67
    print(temp.inUnits(TemperatureUnit.celsius)); // 671.67
  } catch (e) {
    print(e);
  }
}
