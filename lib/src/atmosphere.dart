import 'dart:math';

import 'package:jbmcalc/src/bmath/unit/distance.dart';
import 'package:jbmcalc/src/bmath/unit/pressure.dart';
import 'package:jbmcalc/src/bmath/unit/temperatur.dart';
import 'package:jbmcalc/src/bmath/unit/velocity.dart';

const double cIcaoStandardTemperatureR = 518.67;
const double cIcaoFreezingPointTemperatureR = 459.67;
const double cTemperatureGradient = -3.56616e-03;
const double cIcaoStandardHumidity = 0.0;
const double cPressureExponent = -5.255876;
const double cSpeedOfSound = 49.0223;
const double cA0 = 1.24871;
const double cA1 = 0.0988438;
const double cA2 = 0.00152907;
const double cA3 = -3.07031e-06;
const double cA4 = 4.21329e-07;
const double cA5 = 3.342e-04;
const double cStandardTemperature = 59.0;
const double cStandardPressure = 29.92;
const double cStandardDensity = 0.076474;

Velocity zero = Velocity(0.0, VelocityUnit.fps);

class Atmosphere {
  Distance altitude;
  Pressure pressure;
  Temperature temperature;
  double humidity;
  double density;
  Velocity mach = Velocity(0.0, VelocityUnit.fps);
  double mach1;

  Atmosphere({
    required this.altitude,
    required this.pressure,
    required this.temperature,
    required this.humidity,
    this.density = 0.0,
    this.mach1 = 0.0,
    required this.mach,
  });

  factory Atmosphere.createDefaultAtmosphere() {
    var a = Atmosphere(
      altitude: Distance(0, DistanceUnit.foot),
      pressure:
          Pressure(cStandardPressure, PressureUnit.inHgg),
      temperature: Temperature(cStandardTemperature, TemperatureUnit.fahrenheit),
      humidity: 0.78,
      mach: zero
    );
    a.calculate();
    return a;
  }

  factory Atmosphere.createAtmosphere(Distance altitude, Pressure pressure,
      Temperature temperature, double humidity) {
    if (humidity < 0 || humidity > 100) {
      throw ArgumentError(
          'Atmosphere: humidity must be in 0..1 or 0..100 range');
    }

    if (humidity > 1) {
      humidity = humidity / 100;
    }

    var a = Atmosphere(
      altitude: altitude,
      pressure: pressure,
      temperature: temperature,
      humidity: humidity,
      mach: zero,
    );

    a.calculate();
    return a;
  }

  factory Atmosphere.createICAOAtmosphere(Distance altitude) {
    var temperature = Temperature(
      cIcaoStandardTemperatureR +
          altitude.into(DistanceUnit.foot) * cTemperatureGradient -
          cIcaoFreezingPointTemperatureR,
      TemperatureUnit.fahrenheit,
    );

    var pressure = Pressure(
      cStandardPressure *
          pow(
              cIcaoStandardTemperatureR /
                  (temperature.into(TemperatureUnit.fahrenheit) +
                      cIcaoFreezingPointTemperatureR),
              cPressureExponent),
      PressureUnit.inHgg,
    );

    var a = Atmosphere(
      altitude: altitude,
      temperature: temperature,
      pressure: pressure,
      humidity: cIcaoStandardHumidity,
      mach: zero,
    );

    a.calculate();
    return a;
  }

  Distance getAltitude() => altitude;

  Temperature getTemperature() => temperature;

  Pressure getPressure() => pressure;

  double getHumidity() => humidity;

  double getHumidityInPercents() => humidity * 100;

  @override
  String toString() {
    return 'Altitude: $altitude, Pressure: $pressure, Temperature: $temperature, Humidity: ${humidity * 100}%';
  }

  double getDensity() => density;

  double getDensityFactor() => density / cStandardDensity;

  Velocity getMach() => mach;

  void calculate0(double t, double p) {
    double hc, et, et0, density, mach;

    if (t > 0.0) {
      et0 = cA0 + t * (cA1 + t * (cA2 + t * (cA3 + t * cA4)));
      et = cA5 * humidity * et0;
      hc = (p - 0.3783 * et) / cStandardPressure;
    } else {
      hc = 1.0;
    }
    density = cStandardDensity *
        (cIcaoStandardTemperatureR / (t + cIcaoFreezingPointTemperatureR)) *
        hc;
    mach = sqrt(t + cIcaoFreezingPointTemperatureR) * cSpeedOfSound;
    density = density;
    mach1 = mach;
    this.mach = Velocity(mach, VelocityUnit.fps);
  }

  void calculate() {
    var t = temperature.into(TemperatureUnit.fahrenheit);
    var p = pressure.into(PressureUnit.inHgg);
    calculate0(t, p);
  }

  List<double> getDensityFactorAndMachForAltitude(double altitude) {
    double t, t0, p, ta, tb, orgAltitude, density = 0, mach = 0;

    orgAltitude = this.altitude.into(DistanceUnit.foot);

    if ((orgAltitude - altitude).abs() < 30) {
      density = this.density / cStandardDensity;
      mach = mach1;
      return [density, mach];
    }

    t0 = temperature.into(TemperatureUnit.fahrenheit);
    p = pressure.into(PressureUnit.inHgg);

    ta = cIcaoStandardTemperatureR +
        orgAltitude * cTemperatureGradient -
        cIcaoFreezingPointTemperatureR;
    tb = cIcaoStandardTemperatureR +
        altitude * cTemperatureGradient -
        cIcaoFreezingPointTemperatureR;
    t = t0 + ta - tb;
    p = p * pow(t0 / t, cPressureExponent);

    calculate0(t, p);

    return [density / cStandardDensity, mach];
  }
}
