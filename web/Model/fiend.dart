import 'character.dart';
import 'circularObject.dart';
import 'vector.dart';

/*
 * @author Ginter
 * Objekt fängt den Spieler ab bzw. verfolgt ihn
 */
class Fiend extends CircularObject {
  final Character _char;
  num _speed;
  Vector _respawnPoint;
  bool _hunting = false;

  Fiend(Vector pos, num radius, this._char) : super(pos, radius);
  Fiend.fromJson(Map<String, dynamic> json, this._char) : super.fromJson(json) {
    _speed = json['speed'] ?? 3;
    _respawnPoint = pos;
  }

//berechnet die Bewegungsrichtung abhängig der Position des Charakters
  void hunt() {
    var distance = _char.pos - pos;
    vel = (distance / distance.magnitude) * _speed;
  }

//setzt die Position auf die Startposition zurück
  void respawn() {
    pos = _respawnPoint;
    vel *= 0;
  }

  @override
  void update() {
    if (_hunting) {
      hunt();
    } else {
      // fängt erst an zu jagen wenn das Opfer in der Nähe ist
      var distance = _char.pos - pos;
      if (distance.magnitude < _char.radius * 8) {
        _hunting = true;
      }
    }

    super.update();
  }
}
