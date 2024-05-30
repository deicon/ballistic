import 'bmath/unit/unit.dart';

/// ShotParameters class keeps parameters of the shot to be calculated
class ShotParameters {
  final Angular sightAngle;
  final Angular shotAngle;
  final Angular cantAngle;
  final Distance maximumDistance;
  final Distance step;

  /// Constructor for ShotParameters
  ShotParameters({
    required this.sightAngle,
    required this.shotAngle,
    required this.cantAngle,
    required this.maximumDistance,
    required this.step,
  });

  /// Factory method to create parameters of the shot
  ///
  /// sightAngle - is the angle between scope centerline and the barrel centerline
  factory ShotParameters.createShotParameters(
      Angular sightAngle, Distance maxDistance, Distance step) {
    return ShotParameters(
      sightAngle: sightAngle,
      shotAngle: Angular(0, AngularUnit.radian),
      cantAngle: Angular(0, AngularUnit.radian),
      maximumDistance: maxDistance,
      step: step,
    );
  }

  /// Returns the angle of the sight
  Angular getSightAngle() {
    return sightAngle;
  }

  /// Returns the angle of the shot
  Angular getShotAngle() {
    return shotAngle;
  }

  /// Returns the cant angle (the angle between centers of scope and the barrel projection and zenith line)
  Angular getCantAngle() {
    return cantAngle;
  }

  /// Returns the maximum distance to be calculated
  Distance getMaximumDistance() {
    return maximumDistance;
  }

  /// Returns the step between calculation results
  Distance getStep() {
    return step;
  }

  /// Factory method to create the parameter of the shot aimed at the target which is not on the same level
  /// as the shooter
  ///
  /// sightAngle - is the angle between scope centerline and the barrel centerline
  ///
  /// shotAngle - is the angle between lines drawn from the shooter to the target and the horizon. The positive angle
  /// means that the target is higher and the negative angle means that the target is lower
  factory ShotParameters.createShotParameterUnlevel(
      Angular sightAngle,
      Distance maxDistance,
      Distance step,
      Angular shotAngle,
      Angular cantAngle) {
    return ShotParameters(
      sightAngle: sightAngle,
      shotAngle: shotAngle,
      cantAngle: cantAngle,
      maximumDistance: maxDistance,
      step: step,
    );
  }
}
