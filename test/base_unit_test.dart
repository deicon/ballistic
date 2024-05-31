import 'package:ballistic/src/bmath/bmath.dart';
import 'package:test/test.dart';

import 'package:test/scaffolding.dart';

enum DemoUnit implements BaseUnit{
  meter,
  centimeter;

  @override
  double toDefault(double value) {
    switch (this) {
      case DemoUnit.meter:
        return value;
      case DemoUnit.centimeter:
        return value / 100;
      default:
        throw ArgumentError('Laengenmass: unit $this is not supported');
    }
  }

  @override
  double fromDefault(double value, BaseUnit units) {
    switch (units) {
      case DemoUnit.meter:
        return value;
      case DemoUnit.centimeter:
        return value * 100;
      default:
        throw ArgumentError('Laengenmass: unit $units is not supported');
    }
  }
}

class Laengenmass extends ValueWithUnit<DemoUnit> {

  Laengenmass(super.value, super.unit);

  Laengenmass.inUnits(Laengenmass other, DemoUnit units)
      : super(other.into(units), units);


  @override
  into(DemoUnit units) {
    return valueFromDefault(convertToDefault(value), units);
  }

    @override
  String unitName() {
    return unit.name;
  }

  @override
  ValueWithUnit< DemoUnit> inUnits(DemoUnit units) {
    return Laengenmass.inUnits(this, units);
  }

}


main() {
  group('Laengenmass tests der Default Measurement Implementierung', () {
    test('1 Meter in Cm und zurück', () {
      var a = Laengenmass(1.0, DemoUnit.meter);
      var bincm = Laengenmass.inUnits(a, DemoUnit.centimeter);
      print(a);
      print(bincm);
    });
  });
}