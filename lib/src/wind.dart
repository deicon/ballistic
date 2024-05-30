import 'bmath/bmath.dart';

/// WindInfo class keeps information about wind
class WindInfo {
  final Distance untilDistance;
  final Velocity velocity;
  /// Returns the wind direction.
  ///
  /// 0 degrees means wind blowing into the face
  /// 90 degrees means wind blowing from the left
  /// -90 or 270 degrees means wind blowing from the right
  /// 180 degrees means wind blowing from the back
  final Angular direction;

  WindInfo({
    required this.untilDistance,
    required this.velocity,
    required this.direction,
  });
}

/// CreateNoWind creates wind description with no wind
List<WindInfo> createNoWind() {
  return [WindInfo(
    untilDistance: Distance(0, DistanceUnit.kilometer),
    velocity: Velocity(0, VelocityUnit.mps),
    direction: Angular(0, AngularUnit.degree),
  )];
}

/// CreateOnlyWindInfo creates the wind information for the constant wind for the whole distance of the shot
List<WindInfo> createOnlyWindInfo(Velocity windVelocity, Angular direction) {
  return [WindInfo(
    untilDistance: Distance(9999, DistanceUnit.kilometer),
    velocity: windVelocity,
    direction: direction,
  )];
}

/// AddWindInfo creates description of one wind
WindInfo addWindInfo(Distance untilRange, Velocity windVelocity, Angular direction) {
  return WindInfo(
    untilDistance: untilRange,
    velocity: windVelocity,
    direction: direction,
  );
}

/// CreateWindInfo creates a wind descriptor from multiple winds
///
/// winds must be ordered from the closest to the muzzlepoint to the farest to the muzzlepoint
List<WindInfo> createWindInfo(List<WindInfo> winds) {
  return winds;
}
