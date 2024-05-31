//ignore_for_file: prefer_typing_uninitialized_variables

import 'package:ballistic/src/bmath/bmath.dart';
import 'package:test/test.dart';


void angularBackAndForth(double value, AngularUnit units, AngularUnit other) {
  var u;
  var e1, e2;
  var v;
  try {
    u = Angular(value, units).inUnits(other);
    e1 = null;
  } catch (e) {
    e1 = e;
  }
  if (e1 != null) {
    fail('Creation failed for $units');
  }
  try {
    v = u.into(units);
    e2 = null;
  } catch (e) {
    e2 = e;
  }
  if (!(e2 == null && (v - value).abs() < 1e-7 && (v - u.into(units)).abs() < 1e-7)) {
    fail('Read back failed for $units');
  }
}

void distanceBackAndForth(double value, DistanceUnit units, DistanceUnit other) {
  var u;
  var e1, e2;
  var v;
  try {
    u = Distance(value, units).inUnits(other);
    e1 = null;
  } catch (e) {
    e1 = e;
  }
  if (e1 != null) {
    fail('Creation failed for $units');
  }
  try {
    v = u.into(units);
    e2 = null;
  } catch (e) {
    e2 = e;
  }
  if (!(e2 == null && (v - value).abs() < 1e-7 && (v - u.into(units)).abs() < 1e-7)) {
    fail('Read back failed for $units');
  }
}

void energyBackAndForth(double value, EnergyUnit units, EnergyUnit other) {
  var u;
  var e1, e2;
  var v;
  try {
    u = Energy(value, units).inUnits(other);
    e1 = null;
  } catch (e) {
    e1 = e;
  }
  if (e1 != null) {
    fail('Creation failed for $units');
  }
  try {
    v = u.into(units);
    e2 = null;
  } catch (e) {
    e2 = e;
  }
  if (!(e2 == null && (v - value).abs() < 1e-7 && (v - u.into(units)).abs() < 1e-7)) {
    fail('Read back failed for $units');
  }
}

void pressureBackAndForth(double value, PressureUnit units, PressureUnit other) {
  var u;
  var e1, e2;
  var v;
  try {
    u = Pressure(value, units).inUnits(other);
    e1 = null;
  } catch (e) {
    e1 = e;
  }
  if (e1 != null) {
    fail('Creation failed for $units');
  }
  try {
    v = u.into(units);
    e2 = null;
  } catch (e) {
    e2 = e;
  }
  if (!(e2 == null && (v - value).abs() < 1e-7 && (v - u.into(units)).abs() < 1e-7)) {
    fail('Read back failed for $units');
  }
}

void temperatureBackAndForth(double value, TemperatureUnit units, TemperatureUnit other) {
  var u;
  var e1, e2;
  var v;
  try {
    u = Temperature(value, units).inUnits(other);
    e1 = null;
  } catch (e) {
    e1 = e;
  }
  if (e1 != null) {
    fail('Creation failed for $units');
  }
  try {
    v = u.into(units);
    e2 = null;
  } catch (e) {
    e2 = e;
  }
  if (!(e2 == null && (v - value).abs() < 1e-7 && (v - u.into(units)).abs() < 1e-7)) {
    fail('Read back failed for $units');
  }
}

void velocityBackAndForth(double value, VelocityUnit units, VelocityUnit other) {
  var u;
  var e1, e2;
  var v;
  try {
    u = Velocity(value, units).inUnits(other);

    e1 = null;
  } catch (e) {
    e1 = e;
  }
  if (e1 != null) {
    fail('Creation failed for $units');
  }
  try {
    v = u.into(units);
    e2 = null;
  } catch (e) {
    e2 = e;
  }
  if (!(e2 == null && (v - value).abs() < 1e-7 && (v - u.into(units)).abs() < 1e-7)) {
    fail('Read back failed for $units');
  }
}

void weightBackAndForth(double value, WeightUnit units, WeightUnit other) {
  var u;
  var e1, e2;
  var v;
  try {
    u = Weight(value, units).inUnits(other);
    e1 = null;
  } catch (e) {
    e1 = e;
  }
  if (e1 != null) {
    fail('Creation failed for $units');
  }
  try {
    v = u.into(units);
    e2 = null;
  } catch (e) {
    e2 = e;
  }
  if (!(e2 == null && (v - value).abs() < 1e-7 && (v - u.into(units)).abs() < 1e-7)) {
    fail('Read back failed for $units');
  }
}

void main() {
  test('Angular', () {
    angularBackAndForth(3, AngularUnit.degree, AngularUnit.radian);
    angularBackAndForth(4, AngularUnit.moa, AngularUnit.moa);
    angularBackAndForth(5, AngularUnit.mrad, AngularUnit.radian);
    angularBackAndForth(6, AngularUnit.mil, AngularUnit.degree);
    angularBackAndForth(7, AngularUnit.radian, AngularUnit.radian);
    angularBackAndForth(8, AngularUnit.thousand, AngularUnit.mil);
    angularBackAndForth(9, AngularUnit.cmPer100M, AngularUnit.radian);
    angularBackAndForth(10, AngularUnit.inchesPer100Yd, AngularUnit.radian);

    var u = Angular(1, AngularUnit.inchesPer100Yd);
    if ((0.954930 - u.into(AngularUnit.moa)).abs() > 1e-5) {
      fail('Conversion failed');
    }

    u = Angular(1, AngularUnit.inchesPer100Yd);
    u = u.inUnits(AngularUnit.cmPer100M) as Angular;
    if (u.toString() != '2.78cm/100m') {
      fail('To string failed: ${u.toString()}');
    }
  });

  test('Distance', () {
    distanceBackAndForth(1, DistanceUnit.centimeter, DistanceUnit.meter);
    distanceBackAndForth(2, DistanceUnit.foot, DistanceUnit.meter);
    distanceBackAndForth(3, DistanceUnit.inch, DistanceUnit.meter);
    distanceBackAndForth(4, DistanceUnit.kilometer, DistanceUnit.meter);
    distanceBackAndForth(5, DistanceUnit.line, DistanceUnit.meter);
    distanceBackAndForth(6, DistanceUnit.meter, DistanceUnit.meter);
    distanceBackAndForth(7, DistanceUnit.mile, DistanceUnit.meter);
    distanceBackAndForth(8, DistanceUnit.millimeter, DistanceUnit.meter);
    distanceBackAndForth(9, DistanceUnit.nauticalMile, DistanceUnit.meter);
    distanceBackAndForth(10, DistanceUnit.yard, DistanceUnit.meter);
  });

  test('Energy', () {
    energyBackAndForth(1, EnergyUnit.footPound, EnergyUnit.joule);
    energyBackAndForth(2, EnergyUnit.joule, EnergyUnit.footPound);
    energyBackAndForth(3, EnergyUnit.joule, EnergyUnit.joule);
  });

  test('Pressure', () {
    pressureBackAndForth(1, PressureUnit.bar, PressureUnit.psi);
    pressureBackAndForth(2, PressureUnit.hPa, PressureUnit.psi);
    pressureBackAndForth(3, PressureUnit.mmHg, PressureUnit.inHgg);
    pressureBackAndForth(4, PressureUnit.inHgg, PressureUnit.bar);
  });

  test('Temperature', () {
    temperatureBackAndForth(1, TemperatureUnit.celsius, TemperatureUnit.fahrenheit);
    temperatureBackAndForth(2, TemperatureUnit.fahrenheit, TemperatureUnit.celsius);
    temperatureBackAndForth(3, TemperatureUnit.kelvin, TemperatureUnit.fahrenheit);
    temperatureBackAndForth(4, TemperatureUnit.rankin, TemperatureUnit.kelvin);
  });

  test('Velocity', () {
    velocityBackAndForth(1, VelocityUnit.fps, VelocityUnit.mps);
    velocityBackAndForth(2, VelocityUnit.kmh, VelocityUnit.mph);
    velocityBackAndForth(3, VelocityUnit.kt, VelocityUnit.mph);
    velocityBackAndForth(4, VelocityUnit.mph, VelocityUnit.kt);
    velocityBackAndForth(5, VelocityUnit.mps, VelocityUnit.kmh);
  });

  test('Weight', () {
    weightBackAndForth(1, WeightUnit.grain, WeightUnit.gram);
    weightBackAndForth(2, WeightUnit.gram, WeightUnit.kilogram);
    weightBackAndForth(3, WeightUnit.kilogram, WeightUnit.newton);
    weightBackAndForth(4, WeightUnit.newton, WeightUnit.pound);
    weightBackAndForth(5, WeightUnit.ounce, WeightUnit.pound);
    weightBackAndForth(6, WeightUnit.pound, WeightUnit.pound);
  });
}