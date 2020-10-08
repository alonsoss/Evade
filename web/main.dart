import 'dart:js';

import 'Controller/gameController.dart';
import 'package:pwa/client.dart' as pwa;

void main() {
  var controller = GameController();
  pwa.Client();
  //wartet bis das Level geladen ist und fuehrt dann die methode aus
  // controller.loadLevel('level1').then((f) => controller.run());
}
