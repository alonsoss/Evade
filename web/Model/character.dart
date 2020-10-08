import '../Controller/inputController.dart';
import 'circularObject.dart';
import 'vector.dart';

/*@author Ginter 
Steuerbarer Character 
*/
class Character extends CircularObject {
  InputController _controller;
  //@author Essenwanger Hinzufügen von Leben
  num lives = 3;

  InputController get inputController => _controller;

  Character(Vector pos, num radius) : super(pos, radius) {
    _controller = InputController(this);
  }

  Character.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    _controller = InputController(this);
  }
  
//Veränderung der Geschwindigkeit & Richtung
  void move(Vector direction) {
    vel = direction;
  }

  @override
  void update() {
    _controller.receiveInput();
    super.update();
  }

  // stzt den Charakter in die Mitte des Speicherpunktes
  void respawn(Vector spawnPoint) {
    pos = Vector(spawnPoint.x - radius, spawnPoint.y - radius);
    _controller.following = false;
  }
}
