
import 'package:ballistic/src/projectile.dart';

import 'atmosphere.dart';
import 'bmath/unit/unit.dart';

/// ZeroInfo structure keeps the information about zeroing of the weapon
class ZeroInfo {
  final bool hasAmmunition;
  final Ammunition? ammunition;
  final Distance zeroDistance;
  final bool hasAtmosphere;
  final Atmosphere? zeroAtmosphere;

  ZeroInfo({
    required this.hasAmmunition,
    this.ammunition,
    required this.zeroDistance,
    required this.hasAtmosphere,
    this.zeroAtmosphere,
  });

  /// Creates zero information using distance only
  factory ZeroInfo.createZeroInfo(Distance distance) {
    return ZeroInfo(
      hasAmmunition: false,
      hasAtmosphere: false,
      zeroDistance: distance,
    );
  }

  /// Creates zero information using distance and conditions
  factory ZeroInfo.createZeroInfoWithAtmosphere(Distance distance, Atmosphere atmosphere) {
    return ZeroInfo(
      hasAmmunition: false,
      zeroDistance: distance,
      hasAtmosphere: true,
      zeroAtmosphere: atmosphere,
    );
  }

  /// Creates zero information using distance and other ammunition
  factory ZeroInfo.createZeroInfoWithAnotherAmmo(Distance distance, Ammunition ammo) {
    return ZeroInfo(
      hasAmmunition: true,
      ammunition: ammo,
      zeroDistance: distance,
      hasAtmosphere: false,
    );
  }

  /// Creates zero information using distance, other conditions and other ammunition
  factory ZeroInfo.createZeroInfoWithAnotherAmmoAndAtmosphere(Distance distance, Ammunition ammo, Atmosphere atmosphere) {
    return ZeroInfo(
      hasAmmunition: true,
      ammunition: ammo,
      zeroDistance: distance,
      hasAtmosphere: true,
      zeroAtmosphere: atmosphere,
    );
  }
}

enum TwistDirection {
  left,
  right,
}


/// TwistInfo contains the rifling twist information
///
/// The rifling twist is used to calculate spin drift only
class TwistInfo {
  final TwistDirection twistDirection;
  final Distance riflingTwist;

  TwistInfo({
    required this.twistDirection,
    required this.riflingTwist,
  });

  /// Creates twist information
  ///
  /// Direction must be either TwistRight or TwistLeft constant
  factory TwistInfo.createTwist(TwistDirection direction, Distance twist) {
    return TwistInfo(
      twistDirection: direction,
      riflingTwist: twist,
    );
  }

  /// Returns the twist direction (see TwistRight and TwistLeft)
  TwistDirection direction() => twistDirection;

  /// Returns the twist step (the distance inside the barrel at which the projectile makes one turn)
  Distance twist() => riflingTwist;
}

/// Weapon struct contains the weapon description
class Weapon {
  final Distance sightHeight;
  final ZeroInfo zeroInfo;
  final bool hasTwistInfo;
  final TwistInfo? twist;
  Angular clickValue;

  Weapon({
    required this.sightHeight,
    required this.zeroInfo,
    required this.hasTwistInfo,
    this.twist,
    required this.clickValue,
  });


  /// Creates the weapon definition with no twist info
  ///
  /// If no twist info is set, spin drift won't be calculated
  factory Weapon.createWeapon(Distance sightHeight, ZeroInfo zeroInfo) {
    return Weapon(
      sightHeight: sightHeight,
      zeroInfo: zeroInfo,
      hasTwistInfo: false,
      clickValue: Angular.zero(),
    );
  }

  /// Creates weapon description with twist info
  ///
  /// If twist info AND bullet dimensions are set, spin drift will be calculated
  factory Weapon.createWeaponWithTwist(Distance sightHeight, ZeroInfo zeroInfo, TwistInfo twist) {
    return Weapon(
      sightHeight: sightHeight,
      zeroInfo: zeroInfo,
      hasTwistInfo: true,
      twist: twist,
      clickValue: Angular.zero(),
    );
  }
}
