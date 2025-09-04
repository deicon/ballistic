import 'bmath/bmath.dart';

/// Timespan keeps the amount of time spent
class Timespan {
  final double time;

  Timespan(this.time);

  /// TotalSeconds returns the total number of seconds
  double totalSeconds() {
    return time;
  }

  /// Seconds return the whole number of the seconds
  double seconds() {
    return (time % 60).floorToDouble();
  }

  /// Minutes return the whole number of minutes
  double minutes() {
    return ((time / 60) % 60).floorToDouble();
  }
}

/// TrajectoryData structure keeps information about one point of the trajectory.
class TrajectoryData {
  final Timespan time;
  final Distance travelDistance;
  final Velocity velocity;
  final double mach;
  final Distance drop;
  final Angular dropAdjustment;
  final Distance windage;
  final Angular windageAdjustment;
  final Energy energy;
  final Weight optimalGameWeight;

  TrajectoryData({
    required this.time,
    required this.travelDistance,
    required this.velocity,
    required this.mach,
    required this.drop,
    required this.dropAdjustment,
    required this.windage,
    required this.windageAdjustment,
    required this.energy,
    required this.optimalGameWeight,
  });

  /// Time return the amount of time spent since the shot moment
  Timespan getTime() {
    return time;
  }

  /// TravelledDistance returns the distance measured between the muzzle and the projection of the current bullet position to
  /// the line between the muzzle and the target
  Distance travelledDistance() {
    return travelDistance;
  }

  /// Velocity returns the current projectile velocity
  Velocity getVelocity() {
    return velocity;
  }

  /// MachVelocity returns the proportion between the current projectile velocity and the speed of the sound
  double machVelocity() {
    return mach;
  }

  /// Drop returns the shorted distance between the projectile and the shot line
  ///
  /// The positive value means the the projectile is above this line and the negative value means that the projectile
  /// is below this line
  Distance getDrop() {
    return drop;
  }

  /// Energy returns the kinetic energy of the projectile
  Energy getEnergy() {
    return energy;
  }
}

extension TrajectoryDataInterpolation on List<TrajectoryData> {
  TrajectoryData interpolate(Distance travelDistance) {
    for (final (a, b) in pairwise(this)) {
      final da = a.travelDistance.value;
      final db = b.travelDistance.value;
      final dt = travelDistance.value;
      final inRange = da <= dt && db >= dt;
      if (!inRange) continue;

      t(double a, double b) => lerp(a, b, da, db, dt);

      return TrajectoryData(
        time: Timespan(t(a.time.time, b.time.time)),
        travelDistance: Distance(
          t(a.travelDistance.value, b.travelDistance.value),
          a.travelDistance.unit,
          convert: false,
        ),
        velocity: Velocity(
          t(a.velocity.value, b.velocity.value),
          a.velocity.unit,
          convert: false,
        ),
        mach: t(a.mach, b.mach),
        drop: Distance(
          t(a.drop.value, b.drop.value),
          a.drop.unit,
          convert: false,
        ),
        dropAdjustment: Angular(
          t(a.dropAdjustment.value, b.dropAdjustment.value),
          a.dropAdjustment.unit,
          convert: false,
        ),
        windage: Distance(
          t(a.windage.value, b.windage.value),
          a.windage.unit,
          convert: false,
        ),
        windageAdjustment: Angular(
          t(a.windageAdjustment.value, b.windageAdjustment.value),
          a.windageAdjustment.unit,
          convert: false,
        ),
        energy: Energy(
          t(a.energy.value, b.energy.value),
          a.energy.unit,
          convert: false,
        ),
        optimalGameWeight: Weight(
          t(a.optimalGameWeight.value, b.optimalGameWeight.value),
          a.optimalGameWeight.unit,
          convert: false,
        ),
      );
    }

    throw RangeError('reference point is out of bounds');
  }

  // visible for testing
  static List<(T, T)> pairwise<T>(List<T> source) {
    return [
      for (var i = 0; i < source.length - 1; i++)
        (
          source[i],
          source[i + 1],
        )
    ];
  }

  // visible for testing
  static double lerp(double y1, double y2, double x1, double x2, double x) {
    if (x < x1) throw RangeError("x must be greater than x1");
    if (x > x2) throw RangeError("x must be less than x2");
    return y1 + (y2 - y1) / (x2 - x1) * (x - x1);
  }
}
