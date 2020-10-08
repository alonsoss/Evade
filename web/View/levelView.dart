import 'dart:html';
import '../Controller/gameController.dart';
import '../Model/camera.dart';

class LevelView {
  // Attributes
  final _gameField = querySelector('#gameField');
  final DivElement _div = DivElement();
  final DivElement _life = DivElement();
  final List<GameObjectView> _children = [];
  HtmlElement parent;
  final GameController _controller;
  Camera _cam;
  DivElement _pauseMenu;
  Camera get cam => _cam;
  DivElement get pauseMenu=> _pauseMenu;

  get gameField => _gameField;

  // Constructor
  LevelView(this.parent, this._controller) {
    showPauseButton();
    _life.className ='life overlay';
    _gameField.append(_life);
  }

  // Fuegt children Kinder hinzu
  void addChild(GameObjectView child) {
    _children.add(child);
  }
//@author Ginter Button für das Pausenmenü
  void showPauseButton() {
    var button = ButtonElement()
      ..addEventListener('click', (event) => _controller.pause())
      ..text = 'II'
      ..className = 'pauseButton overlay';
    _gameField.append(button);
  }

//@author Ginter Pausenmenü
  void showPauseMenu() {
    _pauseMenu = DivElement()..className = 'overlay pauseMenu';
    var quitButton = ButtonElement()
      ..addEventListener('click', (event) => _controller.quitLevel())
      ..text = 'Zurück zum Menü';
    var sensorButton = ButtonElement()
      ..addEventListener('click', (event) => _controller.recalibrate())
      ..text = 'Gyrosensor kalibrieren';
    var continueButton = ButtonElement()
      ..addEventListener('click', (event) => _controller.pause())
      ..text = 'Zurück zum Spiel';

    _pauseMenu.append(continueButton);
    _pauseMenu.append(sensorButton);
    _pauseMenu.append(quitButton);
    _gameField.append(_pauseMenu);
  }

  // Lives showed on the left side in the level
  void showLives(num lives){
    _life.children.clear();
    for(var i = 0; i<lives;i++){
      var heart = DivElement()..
      className = 'heart';
      _life.append(heart);
    }
  }

  // Adds the camera to the level
  void addCamera(Camera cam) {
    _cam = cam;
  }

  void render() {
    // laesst alle kinder die rendermethode ausfuehren
    _children.forEach((child) => child.render());
  }

  void setWidth(int width) => parent.style.width = width.toString() + 'px';
  void setHeight(int height) => parent.style.height = height.toString() + 'px';
}

//Abstrakte Klasse für Spieleobjekte
abstract class GameObjectView {
  DivElement div = DivElement();
  LevelView parent;

  GameObjectView(this.parent);

  void render() {}
}
