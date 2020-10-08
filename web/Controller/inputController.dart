import 'dart:html';
import '../Model/character.dart';
import '../Model/vector.dart';

/**
 * @author Ginter
 * Controller zur Steuerung des Character
 */
class InputController {
  bool _mobile = false;
  num _beta = 0;
  num _gamma = 0;
  num _firstBeta;
  num _firstGamma;
  Vector _mousePos;
  Character _character;
  bool _following = false;
  DeviceOrientationEvent event;

  set following(bool following) => _following = following;
  InputController(this._character) {
    //prueft, ob Gyrosensordaten vorliegen
    window.onDeviceOrientation.listen((ev) {
      event = ev;
      if (ev.beta == null || ev.gamma == null) {
        _mobile = false;
      } else {
        _mobile = true;
        if (_firstBeta == null && _firstGamma == null) {
          _firstBeta = ev.beta;
          _firstGamma = ev.gamma;
        }
        _beta = ev.beta - _firstBeta;
        _gamma = ev.gamma - _firstGamma;
      }
    });
    //auslesen der Mausdaten auf dem Bildschirm
    if (!_mobile) {
      window.onMouseMove.listen((e) {
        var levelPos = Vector(
            querySelector('#gameField').getBoundingClientRect().left,
            querySelector('#gameField').getBoundingClientRect().top);
        _mousePos = Vector(e.client.x, e.client.y);
      });
    }
  }
//Berechnung der Bewegung
  void receiveInput() {
    var direction = Vector();
    if (_mobile) {
      direction.x = _gamma;
      direction.y = _beta;
      direction /= 2;
    } else {
      if (_mousePos != null) {
        var char = querySelector('#character');
        if (char != null) {
          var charPos = Vector(char.getBoundingClientRect().left,
                  char.getBoundingClientRect().top) +
              Vector(_character.radius, _character.radius);
          if ((_mousePos - charPos).magnitude < _character.radius) {
            _following = true;
          }
          if (_following) {
            var dis = _mousePos - charPos;
            direction = dis * 0.2;
          }
        }
      }
    }
    _character.move(direction);
  }
//Anpassung des Haltewinkels des Mobiltelefons 
  void calibrate() {
    _firstBeta = event.beta;
    _firstGamma = event.gamma;
  }
}
