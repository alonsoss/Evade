import 'gameObject.dart';
import 'vector.dart';

/**
 * @author Ginter
 * RectangularObjects dienen als Wände im Level
 */
class RectangularObject implements GameObject {
  Vector _pos;
  num _width;
  num _height;

  RectangularObject(this._pos, this._width, this._height);

  //erstellung aus json Daten
  RectangularObject.fromJson(Map<String, dynamic> json) {
    _pos = Vector(json['pos'][0], json['pos'][1]);
    _width = json['width'];
    _height = json['height'];
  }
  // map zur json Erstellung
  Map<String, dynamic> toJson() {
    final data = {};
    data['pos'] = [_pos.x, _pos.y];
    data['width'] = _width;
    data['height'] = _height;
    return data;
  }

  @override
  void update() {}

  @override
  Vector get pos => _pos;
  num get width => _width;
  num get height => _height;
  //gibt die Kanten zurück
  List get edges {
    var edges = List<List<Vector>>(4);
    edges[0] = [_pos, _pos + Vector(_width, 0)];
    edges[1] = [_pos + Vector(_width, 0), _pos + Vector(_width, _height)];
    edges[2] = [_pos + Vector(_width, _height), _pos + Vector(0, _height)];
    edges[3] = [_pos + Vector(0, _height), _pos];
    return edges;
  }
}
