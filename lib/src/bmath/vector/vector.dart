//Package vector provides simple operations on 3d vector
//required for 3DF trajectory calculation

//Vector struct keeps data about a 3D vector
import 'dart:core';
import 'dart:math';

class Vector {
  final double X; //X-coordinate
  final double Y; //Y-coordinate
  final double Z;

  Vector(this.X, this.Y, this.Z); //Z-coordinate

  @override
  String toString() {
    return '[X=$X,Y=$Y,Z=$Z';
  }

  Vector.create(this.X, this.Y, this.Z);

  Vector.copy(Vector v)
      : X = v.X,
        Y = v.Y,
        Z = v.Z;

//MultiplyByVector returns a product of two vectors
//
//The product of two vectors is a sum of products of each coordinate
  double multiplyByVector(Vector b) {
    return X * b.X + Y * b.Y + Z * b.Z;
  }

  Vector copy() {
    return Vector.create(X, Y, Z);
  }

//Magnitude retruns a magnitude of the vector
//
//The magnitude of the vector is the length of a line that starts in point (0,0,0)
//and ends in the point set by the vector coordinates
  double magnitude() {
    return sqrt(X * X + Y * Y + Z * Z);
  }

//MultiplyByConst multiplies the vector by the constant
  Vector multiplyByConst(double a) {
    return Vector.create(a * X, a * Y, a * Z);
  }

//Add adds two vectors
  Vector add(Vector b) {
    return Vector.create(X + b.X, Y + b.Y, Z + b.Z);
  }

//Subtract subtracts one vector from another
  Vector subtract(Vector b) {
    return Vector.create(X - b.X, Y - b.Y, Z - b.Z);
  }

//Cross returns a cross product of two vectors
  Vector cross(Vector b) {
    return Vector.create(
        Y * b.Z - Z * b.Y, Z * b.X - X * b.Z, X * b.Y - Y * b.X);
  }

//Negate returns a vector which is simmetrical to this vector vs (0,0,0) point
  Vector negate() {
    return Vector.create(-X, -Y, -Z);
  }

//Normalize returns a vector of magnitude one which is collinear to this vector
  Vector normalize() {
    var magn = magnitude();

    if (magn.abs() < 1e-10) {
      return Vector.copy(this);
    }
    return multiplyByConst(1.0 / magn);
  }
}