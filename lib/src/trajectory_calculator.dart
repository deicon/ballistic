import 'dart:math';

import 'package:ballistic/src/atmosphere.dart';
import 'package:ballistic/src/projectile.dart';
import 'package:ballistic/src/shot_parameters.dart';
import 'package:ballistic/src/trajectory_data.dart';
import 'package:ballistic/src/weapon.dart';
import 'package:ballistic/src/wind.dart';

import 'bmath/bmath.dart';

class TrajectoryCalculator {
  Distance maximumCalculatorStepSize;

  TrajectoryCalculator({required this.maximumCalculatorStepSize});

  Distance getMaximumCalculatorStepSize() {
    return maximumCalculatorStepSize;
  }

  void setMaximumCalculatorStepSize(Distance x) {
    maximumCalculatorStepSize = x;
  }

  double getCalculationStep(double step) {
    step = step /
        2; // do it twice for increased accuracy of velocity calculation and 10 times per step
    var maximumStep = maximumCalculatorStepSize.into(DistanceUnit.foot);

    if (step > maximumStep) {
      var stepOrder = (log(step) / ln10).floor();
      var maximumOrder = (log(maximumStep) / ln10).floor();

      step = step / pow(10, stepOrder - maximumOrder + 1);
    }
    return step;
  }

  static TrajectoryCalculator create() {
    return TrajectoryCalculator(
      maximumCalculatorStepSize: Distance(1, DistanceUnit.foot),
    );
  }

  //SightAngle calculates the sight angle for a rifle with scope height specified and zeroed using the ammo specified at
//the range specified and under the conditions (atmosphere) specified.
//
//The calculated value is to be used as sightAngle parameter of the ShotParameters structure
  Angular sightAngle(
      Ammunition ammunition, Weapon weapon, Atmosphere atmosphere) {
    var calculationStep = getCalculationStep(
        Distance(10, weapon.zeroInfo.zeroDistance.unit)
            .into(DistanceUnit.foot));

    Vector deltaRangeVector, rangeVector, velocityVector, gravityVector;
    double muzzleVelocity, velocity, barrelAzimuth, barrelElevation;
    double densityFactor, mach, drag, zeroFindingError;
    double time, deltaTime;
    double maximumRange;

    mach = atmosphere.mach.into(VelocityUnit.fps);
    densityFactor = atmosphere.getDensityFactor();
    muzzleVelocity = ammunition.muzzleVelocity.into(VelocityUnit.fps);
    barrelAzimuth = 0.0;
    barrelElevation = 0.0;

    zeroFindingError = cZeroFindingAccuracy * 2;
    var iterationsCount = 0;
    var bullet = ammunition.projectile;
    var ballisticFactor = 1 / bullet.getBallisticCoefficient().value;

    gravityVector = Vector.create(0, cGravityConstant, 0);
    while (zeroFindingError > cZeroFindingAccuracy &&
        iterationsCount < cMaxIterations) {
      velocity = muzzleVelocity;
      time = 0.0;

      // x - distance towards target,
      // y - drop and
      // z - windage
      rangeVector =
          Vector.create(0.0, -weapon.sightHeight.into(DistanceUnit.foot), 0);
      velocityVector = Vector.create(cos(barrelElevation) * cos(barrelAzimuth),
              sin(barrelElevation), cos(barrelElevation) * sin(barrelAzimuth))
          .multiplyByConst(velocity);
      var zeroDistance = weapon.zeroInfo.zeroDistance.into(DistanceUnit.foot);
      maximumRange = zeroDistance + calculationStep;

      while (rangeVector.X <= maximumRange) {
        if (velocity < cMinimumVelocity || rangeVector.Y < cMaximumDrop) {
          break;
        }

        deltaTime = calculationStep / velocityVector.X;
        velocity = velocityVector.magnitude();
        drag = ballisticFactor *
            densityFactor *
            velocity *
            bullet.ballisticCoefficient.getDrag(velocity / mach);
        velocityVector = velocityVector.subtract(
            (velocityVector.multiplyByConst(drag).subtract(gravityVector))
                .multiplyByConst(deltaTime));
        deltaRangeVector = Vector.create(calculationStep,
            velocityVector.Y * deltaTime, velocityVector.Z * deltaTime);
        rangeVector = rangeVector.add(deltaRangeVector);
        velocity = velocityVector.magnitude();
        time = time + deltaRangeVector.magnitude() / velocity;

        if ((rangeVector.X - zeroDistance).abs() < 0.5 * calculationStep) {
          zeroFindingError = rangeVector.Y.abs();
          barrelElevation = barrelElevation - rangeVector.Y / rangeVector.X;
          break;
        }
      }
      iterationsCount++;
    }
    return Angular(barrelElevation, AngularUnit.radian);
  }

  List<TrajectoryData> trajectory(Ammunition ammunition, Weapon weapon,
      Atmosphere atmosphere, ShotParameters shotInfo, List<WindInfo> windInfo) {
    var rangeTo = shotInfo.maximumDistance.into(DistanceUnit.foot);
    var step = shotInfo.step.into(DistanceUnit.foot);

    var calculationStep = getCalculationStep(step);

    Vector deltaRangeVector,
        rangeVector,
        velocityAdjusted,
        velocityVector,
        windVector,
        gravityVector;
    double muzzleVelocity, velocity, barrelAzimuth, barrelElevation;
    double densityFactor, mach, drag;
    double time, deltaTime;
    double maximumRange, nextRangeDistance;
    var bulletWeight =
        ammunition.projectile.getBulletWeight().into(WeightUnit.grain);
    var stabilityCoefficient = 1.0;
    var calculateDrift = false;

    if (weapon.hasTwistInfo && ammunition.projectile.hasDimensions) {
      stabilityCoefficient =
          calculateStabilityCoefficient(ammunition, weapon, atmosphere);
      calculateDrift = true;
    }

    var rangesLength = (rangeTo / step).floor() + 1;
    var ranges = List<TrajectoryData>.filled(rangesLength, TrajectoryData(
      time: Timespan(0),
      travelDistance: Distance(0, DistanceUnit.foot),
      drop: Distance(0, DistanceUnit.foot),
      dropAdjustment: Angular(0, AngularUnit.radian),
      windage: Distance(0, DistanceUnit.foot),
      windageAdjustment: Angular(0, AngularUnit.radian),
      velocity: Velocity(0, VelocityUnit.fps),
      mach: 0,
      energy: Energy(0, EnergyUnit.footPound),
      optimalGameWeight: Weight(0, WeightUnit.pound),
    ), growable: true);

    barrelAzimuth = 0.0;
    barrelElevation = shotInfo.sightAngle.into(AngularUnit.radian);
    barrelElevation =
        barrelElevation + shotInfo.shotAngle.into(AngularUnit.radian);
    var alt0 = atmosphere.altitude.into(DistanceUnit.foot);
    var currentWind = 0;
    var nextWindRange = 1e7;

    if (windInfo.isEmpty) {
      windVector = Vector.create(0, 0, 0);
    } else {
      if (windInfo.length > 1) {
        nextWindRange = windInfo[0].untilDistance.into(DistanceUnit.foot);
      }
      windVector = windToVector(shotInfo, windInfo[0]);
    }

    muzzleVelocity = ammunition.muzzleVelocity.into(VelocityUnit.fps);
    gravityVector = Vector.create(0, cGravityConstant, 0);
    velocity = muzzleVelocity;
    time = 0.0;

    // x - distance towards target,
    // y - drop and
    // z - windage
    rangeVector =
        Vector.create(0.0, -weapon.sightHeight.into(DistanceUnit.foot), 0);
    velocityVector = Vector.create(cos(barrelElevation) * cos(barrelAzimuth),
            sin(barrelElevation), cos(barrelElevation) * sin(barrelAzimuth))
        .multiplyByConst(velocity);

    var currentItem = 0;
    maximumRange = rangeTo;
    nextRangeDistance = 0;

    var twistCoefficient = 0.0;

    if (calculateDrift) {
      if (weapon.hasTwistInfo &&
          weapon.twist!.twistDirection == TwistDirection.left) {
        twistCoefficient = 1;
      } else {
        twistCoefficient = -1;
      }
    }

    var bullet = ammunition.projectile;
    var ballisticFactor = 1 / bullet.getBallisticCoefficient().value;

    // run all the way down the range
    while (rangeVector.X <= maximumRange + calculationStep) {
      if (velocity < cMinimumVelocity || rangeVector.Y < cMaximumDrop) {
        break;
      }

      var result =
          atmosphere.getDensityFactorAndMachForAltitude(alt0 + rangeVector.Y);
      densityFactor = result[0];
      mach = result[1];

      if (rangeVector.X >= nextWindRange) {
        currentWind++;
        windVector = windToVector(shotInfo, windInfo[currentWind]);

        if (currentWind == windInfo.length - 1) {
          nextWindRange = 1e7;
        } else {
          nextWindRange =
              windInfo[currentWind].untilDistance.into(DistanceUnit.foot);
        }
      }

      if (rangeVector.X >= nextRangeDistance) {
        var windage = rangeVector.Z;
        if (calculateDrift) {
          windage += (1.25 *
                  (stabilityCoefficient + 1.2) *
                  pow(time, 1.83) *
                  twistCoefficient) /
              12.0;
        }

        var dropAdjustment = getCorrection(rangeVector.X, rangeVector.Y);
        var windageAdjustment = getCorrection(rangeVector.X, windage);

        ranges[currentItem] = TrajectoryData(
          time: Timespan(time),
          travelDistance:
              Distance(rangeVector.X, DistanceUnit.foot),
          drop: Distance( rangeVector.Y, DistanceUnit.foot),
          dropAdjustment:
              Angular( dropAdjustment, AngularUnit.radian),
          windage: Distance(windage, DistanceUnit.foot),
          windageAdjustment: Angular(
              windageAdjustment, AngularUnit.radian),
          velocity: Velocity(velocity, VelocityUnit.fps),
          mach: velocity / mach,
          energy: Energy(
              calculateEnergy(bulletWeight, velocity), EnergyUnit.footPound),
          optimalGameWeight:
              Weight(calculateOgv(bulletWeight, velocity), WeightUnit.pound),
        );
        nextRangeDistance += step;
        currentItem++;
        if (currentItem == ranges.length) {
          break;
        }
      }

      deltaTime = calculationStep / velocityVector.X;
      velocityAdjusted = velocityVector.subtract(windVector);

      velocity = velocityAdjusted.magnitude();
      drag = ballisticFactor *
          densityFactor *
          velocity *
          bullet.ballisticCoefficient.getDrag(velocity / mach);
      velocityVector = velocityVector.subtract(
          (velocityAdjusted.multiplyByConst(drag).subtract(gravityVector))
              .multiplyByConst(deltaTime));

      deltaRangeVector = Vector(calculationStep, velocityVector.Y * deltaTime,
          velocityVector.Z * deltaTime);
      rangeVector = rangeVector.add(deltaRangeVector);
      velocity = velocityVector.magnitude();
      time = time + deltaRangeVector.magnitude() / velocity;
    }
    return ranges;
  }

  double calculateStabilityCoefficient(
      Ammunition ammunitionInfo, Weapon rifleInfo, Atmosphere atmosphere) {
    var weight =
        ammunitionInfo.projectile.getBulletWeight().into(WeightUnit.grain);
    var diameter =
        ammunitionInfo.projectile.bulletDiameter.into(DistanceUnit.inch);
    var twist = rifleInfo.hasTwistInfo
        ? rifleInfo.twist!.riflingTwist.into(DistanceUnit.inch) / diameter
        : 0.0;
    var length =
        ammunitionInfo.projectile.bulletLength.into(DistanceUnit.inch) /
            diameter;
    var sd = 30 *
        weight /
        (pow(twist, 2) * pow(diameter, 3) * length * (1 + pow(length, 2)));
    var fv = pow(
        ammunitionInfo.muzzleVelocity.into(VelocityUnit.fps) / 2800, 1.0 / 3.0);

    var ft = atmosphere.temperature.into(TemperatureUnit.fahrenheit);
    var pt = atmosphere.pressure.into(PressureUnit.inHgg);
    var ftp = ((ft + 460) / (59 + 460)) * (29.92 / pt);

    return sd * fv * ftp;
  }

  Vector windToVector(ShotParameters shot, WindInfo wind) {
    var sightCosine = cos(shot.sightAngle.into(AngularUnit.radian));
    var sightSine = sin(shot.sightAngle.into(AngularUnit.radian));
    var cantCosine = cos(shot.cantAngle.into(AngularUnit.radian));
    var cantSine = sin(shot.cantAngle.into(AngularUnit.radian));
    var rangeVelocity = wind.velocity.into(VelocityUnit.fps) *
        cos(wind.direction.into(AngularUnit.radian));
    var crossComponent = wind.velocity.into(VelocityUnit.fps) *
        sin(wind.direction.into(AngularUnit.radian));
    var rangeFactor = -rangeVelocity * sightSine;
    return Vector(
        rangeVelocity * sightCosine,
        rangeFactor * cantCosine + crossComponent * cantSine,
        crossComponent * cantCosine - rangeFactor * cantSine);
  }

  double getCorrection(double distance, double offset) {
    return atan(offset / distance);
  }

  double calculateEnergy(double bulletWeight, double velocity) {
    return bulletWeight * pow(velocity, 2) / 450400;
  }

  double calculateOgv(double bulletWeight, double velocity) {
    return pow(bulletWeight, 2) * pow(velocity, 3) * 1.5e-12;
  }
}

// Constants
const double cZeroFindingAccuracy = 0.000005;
const double cMinimumVelocity = 50.0;
const double cMaximumDrop = -15000;
const int cMaxIterations = 10;
const double cGravityConstant = -32.17405;
