import 'gameObject.dart';
import 'vector.dart';

/**
 * @author Ginter
 * Erstellt ein rundes bewegliches Objekt, das zur Erweiterbarkeit dient
 */
class CircularObject implements GameObject {
  Vector _pos;
  num _radius;
  Vector _vel = Vector();

  CircularObject(this._pos, this._radius);

  Vector get pos => _pos;
  num get radius => _radius;
  Vector get vel => _vel;
  set vel(Vector v) => _vel = v;
  set pos(Vector pos) => _pos = pos;

  //erstellt ein Objekt aus einer json Datei
  CircularObject.fromJson(Map<String, dynamic> json) {
    if (json['pos'] == null) {
      _pos = Vector();
    } else {
      _pos = Vector(json['pos'][0], json['pos'][1]);
    }
    _radius = json['radius'];
  }
  //erstellt eine map fuer die Umwandlung zur json
  Map<String, dynamic> toJson() {
    final data = {};
    data['pos'] = [_pos.x, _pos.y];
    data['radius'] = _radius;

    return data;
  }

  @override
  void update() {
    _pos += _vel;
  }
}
