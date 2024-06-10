import 'package:ballistic/src/bmath/unit/base_unit.dart';

// Measurements are represented as a value with a unit.
// Values are saved as default unit
abstract class ValueWithUnit<T extends BaseUnit> {
  final double value;
  final T unit;

  // creates value with unit, converting value into default unit
  ValueWithUnit(double value, this.unit, {bool convert = true}) : value = convert ? unit.toDefault(value) : value;

  // creates value with unit, assuming value is already in default unit
  const ValueWithUnit.createWithValueInDefaultUnit(this.value, this.unit);

  ValueWithUnit<T> inUnits(T units);

  double into(T units) {
    return unit.fromDefault(value, units);
  }

  // get scalar value K in default unit
  double convertToDefault(double value) {
    return unit.toDefault(value);
  }

  // convert value in K from its assumed default Unit to units
  double valueFromDefault(double value, T units) {
    return unit.fromDefault(value, units);
  }

  String unitName();

  @override
  String toString() {
    return '${valueFromDefault(value, unit)}$unitName()';
  }
}
