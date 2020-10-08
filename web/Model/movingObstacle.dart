import 'circularObject.dart';
import 'vector.dart';
/**
 * @author Ginter
 * Berechnet den Pfad und die Geschwindigkeit von bewegenden Hindernissen
 */
class MovingObstacle extends CircularObject {
  num _maxVel;
  num _targetIndex = 0;

  List<Vector> _points = [];

  MovingObstacle(Vector pos, num radius, this._points) : super(pos, radius);

  MovingObstacle.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    for (var point in json['points']) {
      _points.add(Vector(point[0], point[1]));
    }
    _maxVel = json['maxVel'] ?? 3;
    calculateVelocity();
  }

  @override
  void update() {
    move();
    super.update();
  }

// Realisiert die Bewegung von Zielpunkt zu Zielpunkt
  void move() {
    if ((_points[_targetIndex] - pos).magnitude <= _maxVel) {
      pos = _points[_targetIndex];
      calculateTarget();
    } else {
      pos += vel;
    }
  }

//Berechnet die Geschwindigkeit, sodass es die maximale Geschwindigkeit nicht überschreitet
  void calculateVelocity() {
    var toGo = _points[_targetIndex] - pos;
    toGo = (toGo / toGo.magnitude) * _maxVel;
    vel = toGo;
  }

//Berechnet den nächsten Zielpunkt
  void calculateTarget() {
    _targetIndex = (_targetIndex + 1) % _points.length;

    calculateVelocity();
  }
}
