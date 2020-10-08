import 'rectangularObject.dart';
import 'vector.dart';

/**
 * @author Ginter
 * Speicherpunkt zur Rückkehr des Charakters bei Berührung von bewegbaren Objekten
 */
class SavePoint extends RectangularObject {
  // active gibt an, ob der Character zu diesem Punkt zurückkehrt
  bool _active = false;
  bool _last = false;

  bool get active => _active;
  bool get last => _last;
  set last(bool last) => _last = last;
  set active(bool status) => _active = status;

  SavePoint(Vector pos, num width, num height) : super(pos, width, height);
  SavePoint.fromJson(Map<String, dynamic> json) : super.fromJson(json);

//Berechnet den Mittelpunkt des Speicherpunktes
  Vector getSpawnPoint() {
    return Vector(pos.x + width / 2, pos.y + height / 2);
  }
}
