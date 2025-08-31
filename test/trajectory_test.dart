import 'package:test/test.dart';
import 'package:ballistic/ballistic.dart';

main() {
  // using https://www.hornady.com/4dof set to BC Calculator as reference

  group('Trajectory', () {
    test("G1 M193", () {
      checkHornadyTable(
        createHornadyTable(
          dragFunction: DragTableId.g1,
          ballisticCoefficient: 0.243,
          bulletWeightGrains: 55,
          muzzleVelocityFps: 3240,
          barrelTwistInchRev: 7,
          boreDiameterInch: 0.217,
          sightHeightInch: 1.5,
          zeroRangeYard: 100,
          windSpeedMph: 10,
          windAngleDegrees: 90,
          altitudeFeet: 0,
          pressureInHg: 29.92,
          temperatureF: 59,
          humidityPct: 50,
          shootingAngleDegrees: 0,
          maxRangeYards: 500,
          intervalYards: 100,
        ),
        [
          (0, -1.5, 0),
          (100, 0, -1.1),
          (200, -2.9, -4.9),
          (300, -11.5, -11.8),
          (400, -28.1, -22.6),
          (500, -55.6, -38.3),
        ],
      );
    });
  });
}

List<TrajectoryData> createHornadyTable({
  required DragTableId dragFunction,
  required double ballisticCoefficient,
  required double bulletWeightGrains,
  required double muzzleVelocityFps,
  required double barrelTwistInchRev,
  required double boreDiameterInch,
  required double sightHeightInch,
  required double zeroRangeYard,
  required double windSpeedMph,
  required double windAngleDegrees,
  required double altitudeFeet,
  required double pressureInHg,
  required double temperatureF,
  required double humidityPct,
  required double shootingAngleDegrees,
  required double maxRangeYards,
  required double intervalYards,
}) {
  assert(humidityPct >= 0 && humidityPct <= 100);

  final bc = createBallisticCoefficient(ballisticCoefficient, dragFunction);
  final bullet = Projectile.withoutDimensions(
      bc, Weight(bulletWeightGrains, WeightUnit.grain));
  final ammo = Ammunition.create(
    bullet,
    Velocity(muzzleVelocityFps, VelocityUnit.fps),
  );

  final atmosphere = Atmosphere.createAtmosphere(
    Distance(altitudeFeet, DistanceUnit.foot),
    Pressure(pressureInHg, PressureUnit.inHgg),
    Temperature(temperatureF, TemperatureUnit.fahrenheit),
    humidityPct,
  );

  final weapon = Weapon.createWeaponWithTwist(
    Distance(sightHeightInch, DistanceUnit.inch),
    ZeroInfo.createZeroInfo(Distance(zeroRangeYard, DistanceUnit.yard)),
    TwistInfo.createTwist(
      TwistDirection.right,
      Distance(barrelTwistInchRev, DistanceUnit.inch),
    ),
  );

  final calculator = TrajectoryCalculator.create();
  final sightAngle = calculator.sightAngle(ammo, weapon, atmosphere);

  final shotParams = ShotParameters.createShotParameters(
    sightAngle,
    Distance(maxRangeYards, DistanceUnit.yard),
    Distance(intervalYards, DistanceUnit.yard),
  );

  final windList = createOnlyWindInfo(
    Velocity(windSpeedMph, VelocityUnit.mph),
    Angular(-windAngleDegrees, AngularUnit.degree),
  );

  return calculator.trajectory(
    ammo,
    weapon,
    atmosphere,
    shotParams,
    windList,
  );
}

void checkHornadyTable(List<TrajectoryData> trajectory,
    List<(double yards, double drop, double drift)> table) {
  expect(trajectory.length, table.length);
  for (final (i, d) in trajectory.indexed) {
    final data = d;
    final (rangeYards, dropInches, driftInches) = table[i];
    final targetRange = Distance(rangeYards, DistanceUnit.yard);
    final targetDrop = Distance(dropInches, DistanceUnit.inch);
    final targetDrift = Distance(driftInches, DistanceUnit.inch);
    expect(data.travelDistance.value, closeTo(targetRange.value, 36));
    expect(data.drop.value, closeTo(targetDrop.value, 0.1));
    expect(data.windage.value, closeTo(targetDrift.value, 0.1));
  }
}
