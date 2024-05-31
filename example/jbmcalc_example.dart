
import 'package:ballistic/ballistic.dart';

void main() {
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

  for (var trajectoryData in data) {
    print("Bullet drops after ${trajectoryData.travelDistance.into(DistanceUnit.meter).toString()}");
    print(trajectoryData.drop.into(DistanceUnit.inch).toString());
  }
}
