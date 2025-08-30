import 'package:ballistic/ballistic.dart';
import 'package:test/test.dart';

main() {
  group("Unit Conversion", () {
    test("Angular", () {
      testConversions(Angular(10, AngularUnit.degree), {
        AngularUnit.moa: 600,
        AngularUnit.mil: 177.8,
        AngularUnit.mrad: 174.5,
        AngularUnit.radian: 0.174533,
        AngularUnit.thousand: 166.7,
        AngularUnit.cmPer100M: 1763,
        AngularUnit.inchesPer100Yd: 635,
      });
    });

    test("Distance", () {
      testConversions(Distance(1000, DistanceUnit.centimeter), {
        DistanceUnit.foot: 32.8,
        DistanceUnit.inch: 393.7,
        DistanceUnit.kilometer: 0.010,
        DistanceUnit.line: 3937,
        DistanceUnit.meter: 10,
        DistanceUnit.mile: 0.00621,
        DistanceUnit.millimeter: 10000,
        DistanceUnit.nauticalMile: 0.00539,
        DistanceUnit.yard: 10.9,
      });
    });

    test("Energy", () {
      testConversions(Energy(10, EnergyUnit.footPound), {
        EnergyUnit.joule: 13.56,
      });
    });

    test("Pressure", () {
      testConversions(Pressure(1, PressureUnit.bar), {
        PressureUnit.hPa: 1000,
        PressureUnit.inHgg: 29.53,
        PressureUnit.mmHg: 750,
        PressureUnit.psi: 14.5,
      });
    });

    test("Temperature", () {
      testConversions(Temperature(30, TemperatureUnit.celsius), {
        TemperatureUnit.fahrenheit: 86,
        TemperatureUnit.kelvin: 303,
        TemperatureUnit.rankin: 546,
      });
    });

    test("Velocity", () {
      testConversions(Velocity(100, VelocityUnit.fps), {
        VelocityUnit.kmh: 109,
        VelocityUnit.kt: 59.2,
        VelocityUnit.mph: 68.2,
        VelocityUnit.mps: 30.5,
      });
    });

    test("Weight", () {
      testConversions(Weight(100, WeightUnit.grain), {
        WeightUnit.gram: 6.479,
        WeightUnit.kilogram: 0.0064,
        WeightUnit.newton: 0.00066,
        WeightUnit.ounce: 0.2285,
        WeightUnit.pound: 0.0142,
      });
    });
  });
}

void testConversions<T extends BaseUnit>(
    ValueWithUnit<T> initial, Map<T, num> conversions) {
  for (final MapEntry(key: unit, :value) in conversions.entries) {
    final x = initial.inUnits(unit);
    expect(x.unitValue, closeTo(value, value * 0.015));
    expect(x.unit, unit);
  }
}
