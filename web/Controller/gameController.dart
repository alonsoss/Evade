import 'dart:convert';
import 'dart:html';
import 'dart:js';
import '../Model/camera.dart';
import '../Model/character.dart';
import '../Model/circularObject.dart';
import '../Model/gameObject.dart';
import '../Model/level.dart';
import '../Model/rectangularObject.dart';
import '../Model/savePoint.dart';
import '../View/charcterView.dart';
import '../View/circularView.dart';
import '../View/gameView.dart';
import '../View/levelView.dart';
import '../View/rectangularView.dart';
import '../View/savePointView.dart';

class GameController {
  Level _model;
  LevelView _view;
  GameView _gameView;
  num _lastTimeStamp = 0;
  var _currentLevel;

  GameController() {
    _gameView = GameView(this);
  }

// laedt das Level aus einer json Datei und erstellt die zugehoerige View
  Future<void> loadLevel(String name) async {
    requestFullscreen();
    _currentLevel = name.substring(5);
    //print(_currentLevel);
    var json = await makeRequest('assets/$name.json');
    _view = LevelView(_gameView.game, this);
    _model = Level.fromJson(json, this);
    if (_model.width < window.innerWidth) {
      _view.setWidth(_model.width + 8);
    } else {
      _view.setWidth(window.innerWidth);
    }
    if (_model.height < window.innerHeight) {
      _view.setHeight(_model.height + 8);
    } else {
      _view.setHeight(window.innerHeight);
    }
    run();
  }

  /// Quelle: https://stackoverflow.com/questions/29714889/how-to-request-fullscreen-in-compiled-dart
  void requestFullscreen() {
    var elem = JsObject.fromBrowserObject(document.documentElement);

    if (elem.hasProperty('requestFullscreen')) {
      elem.callMethod('requestFullscreen');
    } else {
      var vendors = ['moz', 'webkit', 'ms', 'o'];
      for (var vendor in vendors) {
        var vendorFullscreen = '${vendor}RequestFullscreen';
        if (vendor == 'moz') {
          vendorFullscreen = '${vendor}RequestFullScreen';
        }
        if (elem.hasProperty(vendorFullscreen)) {
          elem.callMethod(vendorFullscreen);
          return;
        }
      }
    }
  }

  void exitFullscreen() {
    if (window.screenTop == null && window.screenY == null) {
      var doc = JsObject.fromBrowserObject(document);

      if (doc.hasProperty('exitFullscreen')) {
        doc.callMethod('exitFullscreen');
      } else if (doc.hasProperty('mozCancelFullScreen')) {
        doc.callMethod('mozCancelFullScreen');
      } else if (doc.hasProperty('webkitExitFullscreen')) {
        doc.callMethod('webkitExitFullscreen');
      } else if (doc.hasProperty('msExitFullscreen')) {
        doc.callMethod('msExitFullscreen');
      }
    }
  }

//ordnet die gameObjecte der entsprechenden View zu
  void registerView(GameObject object) {
    if (object is Character) {
      _view.addChild(CharacterView(object, _view));
    } else if (object is SavePoint) {
      _view.addChild(SavePointView(object, _view));
    } else if (object is RectangularObject) {
      _view.addChild(RectangularView(object, _view));
    } else if (object is CircularObject) {
      _view.addChild(CircularView(object, _view));
    }
  }

  void registerCamera(Camera cam) {
    _view.addCamera(cam);
  }

// decodet die json Datei
  Future<Map<String, dynamic>> makeRequest(String url) async {
    //print(window.location.href);

    //var response = await HttpRequest.getString(window.location.href+url);
    var response = await HttpRequest.getString(url);
    return jsonDecode(response);
  }

// update und render, wenn die instanz existiert
  void run() async {
    //Anpassung des Zykluses an Browser
    //true ersetzen
    while (_model.running) {
      final runTime = await window.animationFrame;
      final delta = runTime - _lastTimeStamp;
      if (delta > 30) {
        _lastTimeStamp = runTime;
        _model?.update();
        _view?.render();
      }
    }
  }

  void pause() {
    if (_model.running) {
      _model.running = false;
      _view.showPauseMenu();
    } else {
      _model.running = true;
      _view.pauseMenu.remove();
      run();
    }
  }

  void recountLives(num lives) {
    _view.showLives(lives);
  }

  void recalibrate() {
    _model.prot.inputController.calibrate();
  }

  void quitLevel() {
    _gameView.menuView.closeAll();
    _gameView.menuView.showMenu();
  }

  void endLevel(int type, int score, int inSeconds) {
    // Player reached the goal = 1
    // Player dies = 2
    String _starsScoreString;
    var _starsScore;
    _model.running = false;
    // print(score);

    if (score >= 400 && score <= 600) {
      _starsScore = 3;
    } else if (score < 400 && score >= 200) {
      _starsScore = 2;
    } else if (score < 200 && score >= 0) {
      _starsScore = 1;
    } else {
      _starsScore = 0;
    }
    if (type == 1) {
      if (_starsScore == 3) {
        _starsScoreString = '★ ★ ★';
      } else if (_starsScore == 2) {
        _starsScoreString = '★ ★ ☆';
      } else if (_starsScore == 1) {
        _starsScoreString = '★ ☆ ☆';
      } else {
        _starsScoreString = '☆ ☆ ☆';
      }

      if (window.localStorage.containsKey('Level' + _currentLevel)) {
        if (window.localStorage['Level' + _currentLevel]
                .compareTo(_starsScoreString) ==
            1) {
          window.localStorage['Level' + _currentLevel] = _starsScoreString;
        }
      } else {
        window.localStorage['Level' + _currentLevel] = _starsScoreString;
      }
      _gameView.showLevelCompleteBox(
          _starsScoreString, inSeconds, _currentLevel);
    } else if (type == 2) {
      _starsScoreString = '☆ ☆ ☆';
      _gameView.showGameOverBox(_starsScoreString, inSeconds, _currentLevel);
    }
  }

  void clearStorage() {
    window.localStorage.clear();
  }
}
