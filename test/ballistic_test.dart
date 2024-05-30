import 'package:jbmcalc/src/bmath/unit/unit.dart';
import 'package:jbmcalc/src/drag.dart';
import 'package:jbmcalc/src/projectile.dart';
import 'package:jbmcalc/src/atmosphere.dart';
import 'package:jbmcalc/src/trajectory_calculator.dart';
import 'package:jbmcalc/src/weapon.dart';
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
}
//
//   void validateOneImperial(TrajectoryData data, double distance, double velocity, double mach, double energy, double path, double hold, double windage, double windAdjustment, double time, double ogv, AngularUnit adjustmentUnit) {
//     assertEqual(distance, data.travelledDistance().inUnit(DistanceUnit()), 0.001, 'Distance');
//     assertEqual(velocity, data.velocity().(VelocityUnit()), 5, 'Velocity');
//     assertEqual(mach, data.machVelocity(), 0.005, 'Mach');
//     assertEqual(energy, data.energy().inUnit(EnergyUnit()), 5, 'Energy');
//     assertEqual(time, data.time(), 0.06, 'Time');
//     assertEqual(ogv, data.optimalGameWeight().inUnit(WeightUnit()), 1, 'OGV');
//
//     if (distance >= 800) {
//       assertEqual(path, data.drop().inUnit(DistanceUnit()), 4, 'Drop');
//     } else if (distance >= 500) {
//       assertEqual(path, data.drop().inUnit(DistanceUnit()), 1, 'Drop');
//     } else {
//       assertEqual(path, data.drop().inUnit(DistanceUnit()), 0.5, 'Drop');
//     }
//
//     if (distance > 1) {
//       assertEqual(hold, data.dropAdjustment().inUnit(adjustmentUnit), 0.5, 'Hold');
//     }
//
//     if (distance >= 800) {
//       assertEqual(windage, data.windage().inUnit(DistanceUnit()), 1.5, 'Windage');
//     } else if (distance >= 500) {
//       assertEqual(windage, data.windage().inUnit(DistanceUnit()), 1, 'Windage');
//     } else {
//       assertEqual(windage, data.windage().inUnit(DistanceUnit()), 0.5, 'Windage');
//     }
//
//     if (distance > 1) {
//       assertEqual(windAdjustment, data.windageAdjustment().inUnit(adjustmentUnit), 0.5, 'WAdj');
//     }
//   }
//
//   test('TestPathG1', () {
//     var bc = ExternalBallistics.createBallisticCoefficient(0.223, DragTableId.G1);
//     var projectile = ExternalBallistics.createProjectile(bc, Weight.mustCreateWeight(168, WeightUnit()));
//     var ammo = ExternalBallistics.createAmmunition(projectile, Velocity.mustCreateVelocity(2750, VelocityUnit()));
//     var zero = ExternalBallistics.createZeroInfo(Distance.mustCreateDistance(100, DistanceUnit()));
//     var weapon = ExternalBallistics.createWeapon(Distance.mustCreateDistance(2, DistanceUnit()), zero);
//     var atmosphere = ExternalBallistics.createDefaultAtmosphere();
//     var shotInfo = ShotParameters(Angular.mustCreateAngular(0.001228, AngularUnit()), Distance.mustCreateDistance(1000, DistanceUnit()), Distance.mustCreateDistance(100, DistanceUnit()));
//     var wind = WindInfo(Velocity.mustCreateVelocity(5, VelocityUnit()), Angular.mustCreateAngular(-45, AngularUnit()));
//
//     var calc = ExternalBallistics.createTrajectoryCalculator();
//     var data = calc.trajectory(ammo, weapon, atmosphere, shotInfo, wind);
//
//     assertEqual(data.length.toDouble(), 11, 0.1, 'Length');
//
//     validateOneImperial(data[0], 0, 2750, 2.463, 2820.6, -2, 0, 0, 0, 0, 880, AngularUnit());
//     validateOneImperial(data[1], 100, 2351.2, 2.106, 2061, 0, 0, -0.6, -0.6, 0.118, 550, AngularUnit());
//     validateOneImperial(data[5], 500, 1169.1, 1.047, 509.8, -87.9, -16.8, -19.5, -3.7, 0.857, 67, AngularUnit());
//     validateOneImperial(data[10], 1000, 776.4, 0.695, 224.9, -823.9, -78.7, -87.5, -8.4, 2.495, 20, AngularUnit());
//   });
//
//   test('TestPathG7', () {
//     var bc = ExternalBallistics.createBallisticCoefficient(0.223, DragTableId.G7);
//     var projectile = ExternalBallistics.createProjectile(bc, Weight.mustCreateWeight(168, WeightUnit()));
//     var ammo = ExternalBallistics.createAmmunition(projectile, Velocity.mustCreateVelocity(2750, VelocityUnit()));
//     var zero = ExternalBallistics.createZeroInfo(Distance.mustCreateDistance(100, DistanceUnit()));
//     var weapon = ExternalBallistics.createWeapon(Distance.mustCreateDistance(2, DistanceUnit()), zero);
//     var atmosphere = ExternalBallistics.createDefaultAtmosphere();
//     var shotInfo = ShotParameters(Angular.mustCreateAngular(4.221, AngularUnit()), Distance.mustCreateDistance(1000, DistanceUnit()), Distance.mustCreateDistance(100, DistanceUnit()));
//     var wind = WindInfo(Velocity.mustCreateVelocity(5, VelocityUnit()), Angular.mustCreateAngular(-45, AngularUnit()));
//
//     var calc = ExternalBallistics.createTrajectoryCalculator();
//     var data = calc.trajectory(ammo, weapon, atmosphere, shotInfo, wind);
//
//     assertEqual(data.length.toDouble(), 11, 0.1, 'Length');
//
//     validateOneImperial(data[0], 0, 2750, 2.463, 2820.6, -2, 0, 0, 0, 0, 880, AngularUnit());
//     validateOneImperial(data[1], 100, 2544.3, 2.279, 2416, 0, 0, -0.35, -0.09, 0.113, 698, AngularUnit());
//     validateOneImperial(data[5], 500, 1810.7, 1.622, 1226, -56.3, -3.18, -9.96, -0.55, 0.673, 252, AngularUnit());
//     validateOneImperial(data[10], 1000, 1081.3, 0.968, 442, -401.6, -11.32, -50.98, -1.44, 1.748, 55, AngularUnit());
//   });
//
//   test('TestAmmunictionReturnBC', () {
//     var bc = ExternalBallistics.createBallisticCoefficient(0.223, DragTableId.G7);
//     var projectile = ExternalBallistics.createProjectile(bc, Weight.mustCreateWeight(69, WeightUnit()));
//     assertEqual(bc.getValue(), 0.223, 0.0005, 'BC');
//     assertEqual(projectile.getBallisticCoefficient(), 0.223, 0.0005, 'BC Calculated');
//   });
//
//   test('TestAmmunictionReturnFF', () {
//     var bc = ExternalBallistics.createBallisticCoefficient(1.184, DragTableId.G7);
//     var projectile = ExternalBallistics.createProjectile(bc, Weight.mustCreateWeight(40, WeightUnit()));
//     assertEqual(bc.getValue(), 1.184, 0.0005, 'ff');
//     assertEqual(projectile.getBallisticCoefficient(), 0.116, 0.0005, 'BC Calculated');
//   });
//
//   var customTable = [
//     DataPoint(0.119, 0),
//     DataPoint(0.119, 0.7),
//     DataPoint(0.12, 0.85),
//     DataPoint(0.122, 0.87),
//     DataPoint(0.126, 0.9),
//     DataPoint(0.148, 0.93),
//     DataPoint(0.182, 0.95),
//   ];
//
//   var customCurve = calculateCurve(customTable);
//
//   double customDragFunction(double mach) {
//     return calculateByCurve(customTable, customCurve, mach);
//   }
//
//   void validateOneMetric(TrajectoryData data, double distance, double drop, double velocity, double time) {
//     assertEqual(distance, data.travelledDistance().inUnit(DistanceUnit()), 0.1, 'Distance');
//     var vac = Angular.mustCreateAngular(0.3, AngularUnit()).inUnit(AngularUnit()) * distance / 100;
//     assertEqual(drop, data.drop().inUnit(DistanceUnit()), vac, 'Drop');
//     assertEqual(velocity, data.velocity().inUnit(VelocityUnit()), 5, 'Velocity');
//     assertEqual(time, data.time(), 0.05, 'Time');
//   }
//
//   test('TestCustomCurve', () {
//     var bc = ExternalBallistics.createBallisticCoefficient(1, DragTableId.G7);
//     var projectile = ExternalBallistics.createProjectile(bc, Weight.mustCreateWeight(13585, WeightUnit()));
//     var ammo = ExternalBallistics.createAmmunition(projectile, Velocity.mustCreateVelocity(555, VelocityUnit()));
//     var zero = ExternalBallistics.createZeroInfo(Distance.mustCreateDistance(100, DistanceUnit()));
//     var weapon = ExternalBallistics.createWeapon(Distance.mustCreateDistance(40, DistanceUnit()), zero);
//     var atmosphere = ExternalBallistics.createDefaultAtmosphere();
//
//     var calc = ExternalBallistics.createTrajectoryCalculator();
//     var sightAngle = calc.sightAngle(ammo, weapon, atmosphere);
//     var shotInfo = ShotParameters(sightAngle, Distance.mustCreateDistance(1500, DistanceUnit()), Distance.mustCreateDistance(100, DistanceUnit()));
//     var data = calc.trajectory(ammo, weapon, atmosphere, shotInfo, null);
//     validateOneMetric(data[1], 100, 0, 550, 0.182);
//     validateOneMetric(data[2], 200, -28.4, 544, 0.364);
//     validateOneMetric(data[15], 1500, -3627.8, 486, 2.892);
//   });
// }
//
// List<double> calculateCurve(List<DataPoint> customTable) {
//   // Implement the curve calculation logic
//   return [];
// }
//
// double calculateByCurve(List<DataPoint> customTable, List<double> customCurve, double mach) {
//   // Implement the curve calculation logic
//   return 0.0;
// }
