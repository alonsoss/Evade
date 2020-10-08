import 'dart:math' show acos, sqrt;

/**
 * @author Ginter
 * Vector zur Vereinfachung der Point Klasse und dem Hinzufügen weiterer arithmetischer MEthoden für die Kollisionsberechnung
 */
class Vector {
  num x, y;

  Vector([this.x = 0, this.y = 0]);

//gibt die entfernung zwischen zwei Punkten an
  num distanceTo(Vector other) {
    return sqrt(squaredDistanceTo(other));
  }

  num squaredDistanceTo(Vector other) {
    var dx = other.x - x;
    var dy = other.y - y;
    return dx * dx + dy * dy;
  }

// gibt die laenge eines vektors aus
  num get magnitude => distanceTo(Vector(0, 0));

  Vector get normal => this / magnitude;

  static num angleBetweenVectors(Vector a, Vector b) {
    return acos((a.skalar(b)) / (a.magnitude * b.magnitude));
  }

//multiplikation
  Vector operator *(num factor) {
    return Vector((x * factor), (y * factor));
  }

//division
  Vector operator /(num factor) {
    return Vector((x / factor), (y / factor));
  }

//addition
  Vector operator +(Vector other) {
    return Vector(x + other.x, y + other.y);
  }

//subtraktion
  Vector operator -(Vector other) {
    return Vector(x - other.x, y - other.y);
  }

// prueft auf gleichheit
  @override
  bool operator ==(dynamic other) =>
      other is Vector && x == other.x && y == other.y;

//wandelt in einen String um
  @override
  String toString() {
    return 'Vector($x, $y)';
  }

//berechnet das Skalarprodukt
  num skalar(Vector other) {
    return x * other.x + y * other.y;
  }

//berechnet den nächsten Punkt zwischen einem Vector und der Linie zwischen Vector a und b
  Vector closestPoint(Vector a, Vector b) {
    num d, t;
    d = a.squaredDistanceTo(b);

    if (d == 0) {
      return a;
    }
    t = ((x - a.x) * (b.x - a.x) + (y - a.y) * (b.y - a.y)) / d;

    if (t <= 0) {
      return a;
    } else if (t >= 1) {
      return b;
    } else {
      var vec = Vector(a.x + t * (b.x - a.x), a.y + t * (b.y - a.y));
      return vec;
    }
  }
}
