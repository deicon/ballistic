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
