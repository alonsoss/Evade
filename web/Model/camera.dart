import 'dart:html';
import 'character.dart';
import 'level.dart';
import 'vector.dart';

/*@author Ginter  
Camera verändert den angezeigten Bildausschnitt des Levels
*/
class Camera {
  final num _width = window.innerWidth;
  final num _height = window.innerHeight;
  Vector _pos;
  final Level _level;
  final Character _target;

  Camera(this._level, this._target) {
    _pos = Vector(0, 0);
  }

  Vector get pos => _pos;

  //Veränderung der Position, wenn das target über die Hälfte des Bildschirms geht und das Level gößer als der Bildschirm ist
  void update() {
    if (_level.height > _height) {
      _pos.y = _target.pos.y - _height / 2;
      if (_pos.y > _level.height + 8 - _height) {
        _pos.y = _level.height + 8 - _height;
      }
    }
    if (_target.pos.y < _height / 2) {
      _pos.y = 0;
    }

    if (_level.width > _width) {
      _pos.x = _target.pos.x - _width / 2;
      // @author Essenwanger Veränderung der Breite
      if (_pos.x > _level.width + 8 - _width) {
        _pos.x = _level.width + 8 - _width;
      }
    }
    if (_target.pos.x < _width / 2) {
      _pos.x = 0;
    }
  }
}
