import 'package:ballistic/src/bmath/vector/vector.dart';
import 'package:test/test.dart';

void main() {
  test('VectorCreation', () {
    Vector v, c;

    v = Vector.create(1, 2, 3);
    expect(v.X, equals(1));
    expect(v.Y, equals(2));
    expect(v.Z, equals(3));

    c = v.copy();
    expect(c.X, equals(1));
    expect(c.Y, equals(2));
    expect(c.Z, equals(3));
  });

  test('Unary', () {
    Vector v1, v2;

    v1 = Vector.create(1, 2, 3);
    expect((v1.magnitude() - 3.74165738677).abs() < 1e-7, isTrue);

    v2 = v1.negate();
    expect(v2.X, equals(-1));
    expect(v2.Y, equals(-2));
    expect(v2.Z, equals(-3));

    v2 = v1.normalize();
    expect(v2.X <= 1, isTrue);
    expect(v2.Y <= 1, isTrue);
    expect(v2.Z <= 1, isTrue);

    v1 = Vector.create(0, 0, 0);
    v2 = v1.normalize();
    expect(v2.X, equals(0));
    expect(v2.Y, equals(0));
    expect(v2.Z, equals(0));
  });

  test('Binary', () {
    Vector v1, v2;

    v1 = Vector.create(1, 2, 3);
    v2 = v1.add(v1.copy());
    expect(v2.X, equals(2));
    expect(v2.Y, equals(4));
    expect(v2.Z, equals(6));

    v2 = v1.subtract(v2);
    expect(v2.X, equals(-1));
    expect(v2.Y, equals(-2));
    expect(v2.Z, equals(-3));

    expect(v1.multiplyByVector(v1.copy()), equals(1 + 4 + 9));

    v2 = v1.multiplyByConst(3);
    expect(v2.X, equals(3));
    expect(v2.Y, equals(6));
    expect(v2.Z, equals(9));
  });
}
