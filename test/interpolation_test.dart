import 'package:ballistic/src/bmath/unit/unit.dart';
import 'package:ballistic/src/trajectory_data.dart';
import 'package:test/test.dart';

main() {
  test('pairwise', () {
    final pairwise = TrajectoryDataInterpolation.pairwise;
    expect(pairwise([1, 2, 3]), [(1, 2), (2, 3)]);
  });

  test('lerp', () {
    final lerp = TrajectoryDataInterpolation.lerp;

    // simple sweep
    expect(() => lerp(0, 1, 0, 1, -1), throwsRangeError);
    expect(lerp(0, 1, 0, 1, 0), 0);
    expect(lerp(0, 1, 0, 1, 0.5), 0.5);
    expect(lerp(0, 1, 0, 1, 1), 1);
    expect(() => lerp(0, 1, 0, 1, 2), throwsRangeError);

    // complexish
    expect(lerp(0, 50, 0, 200, 100), 25);
  });

  group('TrajectoryData interpolation', () {
    final data = [
      TrajectoryData(
        drop: Distance(0, DistanceUnit.inch),
        dropAdjustment: Angular(0, AngularUnit.moa),
        energy: Energy(100, EnergyUnit.footPound),
        mach: 0,
        optimalGameWeight: Weight(100, WeightUnit.pound),
        time: Timespan(0),
        travelDistance: Distance(0, DistanceUnit.yard),
        velocity: Velocity(500, VelocityUnit.fps),
        windage: Distance(0, DistanceUnit.inch),
        windageAdjustment: Angular(0, AngularUnit.moa),
      ),
      TrajectoryData(
        drop: Distance(1, DistanceUnit.inch),
        dropAdjustment: Angular(1, AngularUnit.moa),
        energy: Energy(80, EnergyUnit.footPound),
        mach: 1,
        optimalGameWeight: Weight(80, WeightUnit.pound),
        time: Timespan(1),
        travelDistance: Distance(100, DistanceUnit.yard),
        velocity: Velocity(400, VelocityUnit.fps),
        windage: Distance(1, DistanceUnit.inch),
        windageAdjustment: Angular(1, AngularUnit.moa),
      ),
      TrajectoryData(
        drop: Distance(2, DistanceUnit.inch),
        dropAdjustment: Angular(2, AngularUnit.moa),
        energy: Energy(60, EnergyUnit.footPound),
        mach: 2,
        optimalGameWeight: Weight(60, WeightUnit.pound),
        time: Timespan(2),
        travelDistance: Distance(200, DistanceUnit.yard),
        velocity: Velocity(300, VelocityUnit.fps),
        windage: Distance(2, DistanceUnit.inch),
        windageAdjustment: Angular(2, AngularUnit.moa),
      ),
    ];

    test('in bounds, all fields', () {
      final x = data.interpolate(Distance(50, DistanceUnit.yard));
      expect(x.drop.unitValue, 0.5);
      expect(x.dropAdjustment.unitValue, 0.5);
      expect(x.energy.unitValue, 90);
      expect(x.mach, 0.5);
      expect(x.optimalGameWeight.unitValue, closeTo(90, .001));
      expect(x.time.time, 0.5);
      expect(x.travelDistance.unitValue, 50);
      expect(x.velocity.unitValue, closeTo(450, .001));
      expect(x.windage.unitValue, 0.5);
      expect(x.windageAdjustment.unitValue, 0.5);
    });

    test('out of bounds', () {
      expect(() => data.interpolate(Distance(5000, DistanceUnit.yard)),
          throwsRangeError);
      expect(() => data.interpolate(Distance(50, DistanceUnit.kilometer)),
          throwsRangeError);
    });

    test('unit sweep', () {
      fn(DistanceUnit d) => data.interpolate(Distance(50, d)).drop.unitValue;
      expect(fn(DistanceUnit.centimeter), closeTo(0.0055, 0.001));
      expect(fn(DistanceUnit.inch), closeTo(0.0138, 0.001));
      expect(fn(DistanceUnit.yard), closeTo(0.5, 0.001));
      expect(fn(DistanceUnit.meter), closeTo(0.547, 0.001));
    });
  });
}
