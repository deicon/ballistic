import 'dart:math';

import 'package:ballistic/src/bmath/unit/distance.dart';
import 'package:ballistic/src/bmath/unit/velocity.dart';
import 'package:ballistic/src/bmath/unit/weight.dart';
import 'package:ballistic/src/drag.dart';

Distance zeroDistance = Distance(0.0, DistanceUnit.millimeter);

class Projectile {
  BallisticCoefficient ballisticCoefficient;
  Weight weight;
  bool hasDimensions;
  late Distance bulletDiameter;
  late Distance bulletLength;

  Projectile(this.ballisticCoefficient, this.weight,
      {this.hasDimensions = false,
      Distance? bulletDiameter,
      Distance? bulletLength}) {
    if (bulletDiameter == null) {
      this.bulletDiameter = zeroDistance;
    } else {
      this.bulletDiameter = bulletDiameter;
    }

    if (bulletLength == null) {
      this.bulletLength = zeroDistance;
    } else {
      this.bulletLength = bulletLength;
    }
  }

  factory Projectile.withDimensions(BallisticCoefficient ballisticCoefficient,
      Distance bulletDiameter, Distance bulletLength, Weight weight) {
    return Projectile(ballisticCoefficient, weight,
        hasDimensions: true,
        bulletDiameter: bulletDiameter,
        bulletLength: bulletLength);
  }

  factory Projectile.withoutDimensions(
      BallisticCoefficient ballisticCoefficient, Weight weight) {
    return Projectile(ballisticCoefficient, weight);
  }

  BallisticCoefficient getBallisticCoefficient() {
    return ballisticCoefficient;
  }

  Weight getBulletWeight() {
    return weight;
  }

  Distance getBulletDiameter() {
    return bulletDiameter;
  }

  Distance getBulletLength() {
    return bulletLength;
  }

  bool hasDimensionsSet() {
    return hasDimensions;
  }

  double getBallisticCoefficientValue() {
    if (ballisticCoefficient.valueType == bc) {
      return ballisticCoefficient.value;
    }
    return weight.into(WeightUnit.grain) /
        7000.0 /
        pow(bulletDiameter.into(DistanceUnit.inch), 2) /
        ballisticCoefficient.value;
  }
}

class Ammunition {
  Projectile projectile;
  Velocity muzzleVelocity;

  Ammunition(this.projectile, this.muzzleVelocity);

  factory Ammunition.create(Projectile bullet, Velocity muzzleVelocity) {
    return Ammunition(bullet, muzzleVelocity);
  }

  Projectile getBullet() {
    return projectile;
  }

  Velocity getMuzzleVelocity() {
    return muzzleVelocity;
  }
}
