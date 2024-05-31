
import 'package:ballistic/ballistic.dart';
import 'package:test/test.dart';

void main() {
  test('Velocity Conversion', () {
    var v = Velocity(100, VelocityUnit.kmh);
    var p = v.inUnits(VelocityUnit.mps);
    assert(p.value == 27.77777777777778);
  });

  test('TestZero1', () {
    var bc = createBallisticCoefficient(0.365, DragTableId.g1);
    var projectile = Projectile(bc, Weight(69, WeightUnit.grain));

    var ammo = Ammunition(projectile, Velocity(2600, VelocityUnit.fps));

    var zero = ZeroInfo.createZeroInfo(
        Distance(100, DistanceUnit.yard));
    var weapon = Weapon.createWeapon(
        Distance(3.2, DistanceUnit.inch), zero);
    var atmosphere = Atmosphere.createDefaultAtmosphere();
    var calc = TrajectoryCalculator(
        maximumCalculatorStepSize: Distance(
            1, DistanceUnit.foot));

    var sightAngle = calc.sightAngle(ammo, weapon, atmosphere);
    if ((sightAngle.into(AngularUnit.radian) - 0.001651).abs() > 1e-6) {
      fail('TestZero1 failed ${sightAngle.inUnits(AngularUnit.radian)}');
    }
  });

  test('TestZero2', () {
    var bc = createBallisticCoefficient(0.223, DragTableId.g7);
    var projectile = Projectile(bc, Weight(168, WeightUnit.grain));
    var ammo = Ammunition(projectile, Velocity(2750, VelocityUnit.fps));
    var zero = ZeroInfo.createZeroInfo(Distance(100, DistanceUnit.yard));
    var weapon = Weapon.createWeapon(Distance(2, DistanceUnit.inch), zero);
    var atmosphere = Atmosphere.createDefaultAtmosphere();
    var calc = TrajectoryCalculator(
        maximumCalculatorStepSize: Distance(
            1, DistanceUnit.foot));

    var sightAngle = calc.sightAngle(ammo, weapon, atmosphere);
    if ((sightAngle.into(AngularUnit.radian) - 0.001228).abs() > 1e-6) {
      fail('TestZero2 failed ${sightAngle.inUnits(AngularUnit.radian)}');
    }
  });

  void assertEqual(double a, double b, double accuracy, String name) {
    if ((a - b).abs() > accuracy) {
      fail('Assertion $name failed ($a/$b)');
    }
  }

  void validateOneImperial(TrajectoryData data, double distance,
      double velocity, double mach, double energy, double path, double hold,
      double windage, double windAdjustment, double time, double ogv,
      AngularUnit adjustmentUnit) {
    expect(distance,
        closeTo(data.travelledDistance().into(DistanceUnit.yard), 0.001),
        reason: 'Distance');
    expect(velocity, closeTo(data.velocity.into(VelocityUnit.fps), 5),
        reason: 'Velocity');
    expect(mach, closeTo(data.machVelocity(), 0.005), reason: 'Mach');
    expect(energy, closeTo(data.energy.into(EnergyUnit.footPound), 5),
        reason: 'Energy');
    expect(time, closeTo(data.time.time, 0.06), reason: 'Time');
    expect(ogv, closeTo(data.optimalGameWeight.into(WeightUnit.pound), 1),
        reason: 'OGV');

    if (distance >= 800) {
      expect(
          path, closeTo(data.drop.into(DistanceUnit.inch), 4), reason: 'Drop');
    } else if (distance >= 500) {
      expect(
          path, closeTo(data.drop.into(DistanceUnit.inch), 1), reason: 'Drop');
    } else {
      expect(path, closeTo(data.drop.into(DistanceUnit.inch), 0.5),
          reason: 'Drop');
    }

    if (distance > 1) {
      expect(hold, closeTo(data.dropAdjustment.into(adjustmentUnit), 0.5),
          reason: 'Hold');
    }

    if (distance >= 800) {
      expect(windage, closeTo(data.windage.into(DistanceUnit.inch), 1.5),
          reason: 'Windage');
    } else if (distance >= 500) {
      expect(windage, closeTo(data.windage.into(DistanceUnit.inch), 1),
          reason: 'Windage');
    } else {
      expect(windage, closeTo(data.windage.into(DistanceUnit.inch), 0.5),
          reason: 'Windage');
    }

    if (distance > 1) {
      expect(windAdjustment,
          closeTo(data.windageAdjustment.into(adjustmentUnit), 0.5),
          reason: 'WAdj');
    }
  }

  test('TestPathG1', () {
    var bc = createBallisticCoefficient(0.223, DragTableId.g1);
    var projectile = Projectile(bc, Weight(168, WeightUnit.grain));
    var ammo = Ammunition(projectile, Velocity(2750, VelocityUnit.fps));
    var zero = ZeroInfo.createZeroInfo(Distance(100, DistanceUnit.yard));
    var weapon = Weapon.createWeapon(Distance(2, DistanceUnit.inch), zero);
    var atmosphere = Atmosphere.createDefaultAtmosphere();
    var shotInfo = ShotParameters.createShotParameters(
        Angular(0.001228, AngularUnit.radian),
        Distance(1000, DistanceUnit.yard),
        Distance(100, DistanceUnit.yard));
    var wind = createOnlyWindInfo(Velocity(5, VelocityUnit.mph),
        Angular(-45, AngularUnit.degree));

    var calc = TrajectoryCalculator(
        maximumCalculatorStepSize: Distance(
            1, DistanceUnit.foot));
    var data = calc.trajectory(ammo, weapon, atmosphere, shotInfo, wind);

    assertEqual(data.length.toDouble(), 11, 0.1, 'Length');

    validateOneImperial(
        data[0],
        0,
        2750,
        2.463,
        2820.6,
        -2,
        0,
        0,
        0,
        0,
        880,
        AngularUnit.moa);
    validateOneImperial(
        data[1],
        100,
        2351.2,
        2.106,
        2061,
        0,
        0,
        -0.6,
        -0.6,
        0.118,
        550,
        AngularUnit.moa);
    validateOneImperial(
        data[5],
        500,
        1169.1,
        1.047,
        509.8,
        -87.9,
        -16.8,
        -19.5,
        -3.7,
        0.857,
        67,
        AngularUnit.moa);
    validateOneImperial(
        data[10],
        1000,
        776.4,
        0.695,
        224.9,
        -823.9,
        -78.7,
        -87.5,
        -8.4,
        2.495,
        20,
        AngularUnit.moa);
  });



  test('TestPathG7', () {
    var bc = createBallisticCoefficient(0.223, DragTableId.g7);
    var projectile = Projectile.withDimensions(bc, Distance(0.308, DistanceUnit.inch), Distance(1.282, DistanceUnit.inch), Weight(168, WeightUnit.grain));
    var ammo = Ammunition(projectile, Velocity(2750, VelocityUnit.fps));
    var zero = ZeroInfo.createZeroInfo(Distance(100, DistanceUnit.yard));
    var twist = TwistInfo(twistDirection: TwistDirection.right, riflingTwist: Distance(11.24, DistanceUnit.inch));
    var weapon = Weapon.createWeaponWithTwist(Distance(2, DistanceUnit.inch), zero, twist);
    var atmosphere = Atmosphere.createDefaultAtmosphere();
    var shotInfo = ShotParameters.createShotParameters(Angular(4.221, AngularUnit.moa), Distance(1000, DistanceUnit.yard), Distance(100, DistanceUnit.yard));
    var wind = createOnlyWindInfo(Velocity(5, VelocityUnit.mph), Angular(-45, AngularUnit.degree));

    var calc = TrajectoryCalculator(
        maximumCalculatorStepSize: Distance(
            1, DistanceUnit.foot));
    var data = calc.trajectory(ammo, weapon, atmosphere, shotInfo, wind);

    assertEqual(data.length.toDouble(), 11, 0.1, 'Length');

    validateOneImperial(data[0], 0, 2750, 2.463, 2820.6, -2, 0, 0, 0, 0, 880, AngularUnit.mil);
    validateOneImperial(data[1], 100, 2544.3, 2.279, 2416, 0, 0, -0.35, -0.09, 0.113, 698, AngularUnit.mil);
    validateOneImperial(data[5], 500, 1810.7, 1.622, 1226, -56.3, -3.18, -9.96, -0.55, 0.673, 252, AngularUnit.mil);
    validateOneImperial(data[10], 1000, 1081.3, 0.968, 442, -401.6, -11.32, -50.98, -1.44, 1.748, 55, AngularUnit.mil);
  });

  test('TestAmmunictionReturnBC', () {
    var bc = createBallisticCoefficient(0.223, DragTableId.g7);
    var projectile = Projectile(bc, Weight(69, WeightUnit.grain));
    assertEqual(bc.getValue(), 0.223, 0.0005, 'BC');
    assertEqual(projectile.getBallisticCoefficient().value, 0.223, 0.0005, 'BC Calculated');
  });

}

