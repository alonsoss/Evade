import 'dart:html';
import 'dart:js';

import '../Controller/gameController.dart';
import 'gameView.dart';

class MenuView {
  // Attributes
  GameController controller;
  Element endBox;
  GameView parent;

  final gameField = querySelector('#gameField');
  final menu = querySelector('#menu');
  final qr = querySelector('#qr');
  final buttons = querySelector('#buttons');
  final menuBtn = querySelector('#menuBtn');

  var lvl1Btn = ButtonElement()
    ..text = 'Level 1'
    ..className = 'button';
  var lvl2Btn = ButtonElement()
    ..text = 'Level 2'
    ..className = 'button';
  var lvl3Btn = ButtonElement()
    ..text = 'Level 3'
    ..className = 'button';
  var lvl4Btn = ButtonElement()
    ..text = 'Level 4'
    ..className = 'button';
  var lvl5Btn = ButtonElement()
    ..text = 'Level 5'
    ..className = 'button';
  var lvl6Btn = ButtonElement()
    ..text = 'Level 6'
    ..className = 'button';
  var lvl7Btn = ButtonElement()
    ..text = 'Level 7'
    ..className = 'button';
  var lvl8Btn = ButtonElement()
    ..text = 'Level 8'
    ..className = 'button';
  var lvl9Btn = ButtonElement()
    ..text = 'Level 9'
    ..className = 'button';
  var lvl10Btn = ButtonElement()
    ..text = 'Level 10'
    ..className = 'button';
  var lvlBtn = ButtonElement()
    ..text = 'Levels anzeigen'
    ..className = 'button';
  var bckBtn = ButtonElement()
    ..text = 'Zurück'
    ..className = 'button';
  var btnQR = ButtonElement()
    ..text = 'QR Code anzeigen'
    ..className = 'button';
  var btnHighScore = ButtonElement()
    ..text = 'HighScore anzeigen'
    ..className = 'button';
  var btnCredits = ButtonElement()
    ..text = 'Credits'
    ..className = 'button';
  var image_QR = ImageElement()
    ..src = 'qrcode.png'
    ..width = 250
    ..height = 250;
  var btnHighScore1 = ButtonElement()
    ..text = 'Level 1: '
    ..className = 'button';
  var btnHighScore2 = ButtonElement()
    ..text = 'Level 2: '
    ..className = 'button';
  var btnHighScore3 = ButtonElement()
    ..text = 'Level 3: '
    ..className = 'button';
  var btnHighScore4 = ButtonElement()
    ..text = 'Level 4: '
    ..className = 'button';
  var btnHighScore5 = ButtonElement()
    ..text = 'Level 5: '
    ..className = 'button';
  var resetHSBtn = ButtonElement()
    ..text = 'Alle Zurücksetzen: '
    ..className = 'buttonReset';

  MenuView(this.controller, this.parent) {
    showMenu();

    resetHSBtn.addEventListener('click', (e) {
      controller.clearStorage();
      buttons.children.clear();
      showHighScoreMenu();
    });

    lvl1Btn.addEventListener('click', (e) {
      requestGyroloadLevel();
      controller.loadLevel('level1');
    });
    lvl2Btn.addEventListener('click', (e) {
      requestGyroloadLevel();
      controller.loadLevel('level2');
    });
    lvl3Btn.addEventListener('click', (e) {
      requestGyroloadLevel();
      controller.loadLevel('level3');
    });
    lvl4Btn.addEventListener('click', (e) {
      requestGyroloadLevel();
      controller.loadLevel('level4');
    });
    lvl5Btn.addEventListener('click', (e) {
      requestGyroloadLevel();
      controller.loadLevel('level5');
    });
    lvl6Btn.addEventListener('click', (e) {
      requestGyroloadLevel();
      controller.loadLevel('level6');
    });

    lvl7Btn.addEventListener('click', (e) {
      requestGyroloadLevel();
      controller.loadLevel('level7');
    });

    lvl8Btn.addEventListener('click', (e) {
      requestGyroloadLevel();
      controller.loadLevel('level8');
    });

    lvl9Btn.addEventListener('click', (e) {
      requestGyroloadLevel();
      controller.loadLevel('level9');
    });

    lvl10Btn.addEventListener('click', (e) {
      requestGyroloadLevel();
      controller.loadLevel('level10');
    });
    // Show QR code
    btnQR.addEventListener('click', (e) {
      showQR();
    });
    lvlBtn.addEventListener('click', (e) {
      buttons.children.clear();
      showLevelsMenu();
    });
    bckBtn.addEventListener('click', (e) {
      buttons.children.clear();
      qr.children.clear();
      showMenu();
    });
    btnHighScore.addEventListener('click', (e) {
      buttons.children.clear();
      showHighScoreMenu();
    });
    btnCredits.addEventListener('click', (e) {
      showCredits();
    });
  }

  void requestGyroloadLevel() {
    context.callMethod('requestiOSGyro');
    gameField.children.clear();
    buttons.children.clear();
    parent.game.classes.add('level-boundry');
  }

  void showHighScoreMenu() {
    updateScore();
    buttons.append(btnHighScore1);
    buttons.append(BRElement());
    buttons.append(btnHighScore2);
    buttons.append(BRElement());
    buttons.append(btnHighScore3);
    buttons.append(BRElement());
    buttons.append(btnHighScore4);
    buttons.append(BRElement());
    buttons.append(btnHighScore5);
    buttons.append(BRElement());
    buttons.append(BRElement());
    buttons.append(bckBtn);
    buttons.append(BRElement());
    buttons.append(resetHSBtn);
  }

  void showQR() {
    buttons.children.clear();
    buttons.append(bckBtn);
    buttons.append(BRElement());
    buttons.append(BRElement());
    qr.append(image_QR);
  }

  void showMenu() {
    controller.exitFullscreen();
    buttons.append(lvlBtn);
    buttons.append(BRElement());
    buttons.append(btnHighScore);
    buttons.append(BRElement());
    buttons.append(btnQR);
    buttons.append(BRElement());
    buttons.append(btnCredits);
  }

  void showCredits() {
    buttons.children.clear();
    var title = HeadingElement.h3()..text = 'Dieses Spiel wurde Entwickelt von:';
    var name1 = HeadingElement.h3()..text = 'Alonso Essenwanger';
    var name2 = HeadingElement.h3()..text = 'Viktoria Ginter';
    title.style.color = 'white';
    name1.style.color = 'white';
    name2.style.color = 'white';

    buttons.append(title);
    buttons.append(BRElement());
    buttons.append(name1);
    buttons.append(BRElement());
    buttons.append(name2);
    buttons.append(BRElement());
    buttons.append(bckBtn);
  }

  void showLevelsMenu() {
    var levels = DivElement()..id = 'level-buttons';
    levels.append(lvl1Btn);
    levels.append(lvl2Btn);
    levels.append(lvl3Btn);
    levels.append(lvl4Btn);
    levels.append(lvl5Btn);
    levels.append(lvl6Btn);
    levels.append(lvl7Btn);
    levels.append(lvl8Btn);
    levels.append(lvl9Btn);
    levels.append(lvl10Btn);

    buttons.append(levels);
    buttons.append(bckBtn);
  }

  void closeAll() {
    qr.children.clear();
    gameField.children.clear();
    parent.game.classes.remove('level-boundry');
    buttons.children.clear();
  }

  /// Method to show the end box depending on which method called it
  void _showEndBox(String titleText, String starsScoreString, int inSeconds,
      String currentLevel, int status) {
    gameField.style.opacity = '0.2';
    endBox = DivElement()..id = 'endBox';
    var title = HeadingElement.h3()..text = titleText;
    var scoreText = HeadingElement.h1()..text = starsScoreString;
    var closeBtn = ButtonElement()
      ..type = 'button'
      ..text = 'Zurück zum Menü';
    var nextBtn = ButtonElement()
      ..type = 'button'
      ..text = 'Level ${int.parse(currentLevel) + 1}';
    var retryBtn = ButtonElement()
      ..type = 'button'
      ..text = 'Nochmal versuchen';
    var zeit = HeadingElement.h5()..text = 'Benötigte Zeit: ${inSeconds} s';
    closeBtn.addEventListener('click', (e) => closeEndBox());
    nextBtn.addEventListener(
        'click', (e) => loadLevel(int.parse(currentLevel) + 1));
    retryBtn.addEventListener('click', (e) => loadLevel(currentLevel));
    endBox.append(title);
    endBox.append(scoreText);
    endBox.append(zeit);
    endBox.append(closeBtn);
    if (status == 1) {
      if (num.parse(currentLevel) < 10) {
        endBox.append(nextBtn);
      }
    } else {
      endBox.append(retryBtn);
    }
    menu.append(endBox);
  }

  /// Method to load the level from the controller
  void loadLevel(level) {
    gameField.style.opacity = '1';
    endBox.remove();
    closeAll();
    gameField.children.clear();
    parent.game.classes.add('level-boundry');
    controller.loadLevel('level${level}');
  }

  /// Method to show level completed box
  void showLevelCompletedBox(
      String starsScoreString, int inSeconds, currentLevel) {
    _showEndBox('Level ${currentLevel} Completed!', starsScoreString, inSeconds,
        currentLevel, 1);
  }

  /// Method to show the game over box
  void showGameOverBox(String starsScoreString, int inSeconds, currentLevel) {
    _showEndBox('Game Over!', starsScoreString, inSeconds, currentLevel, 0);
  }

  /// Method to close the end box
  void closeEndBox() {
    gameField.style.opacity = '1';
    endBox.remove();
    closeAll();
    showMenu();
  }

  /// Method to update the score at the HighScore Menu
  void updateScore() {
    if (window.localStorage.containsKey('Level1')) {
      btnHighScore1.text =
          'Level 1: ' + window.localStorage['Level1'].toString();
    } else {
      btnHighScore1.text = 'Level 1: ';
    }
    if (window.localStorage.containsKey('Level2')) {
      btnHighScore2.text =
          'Level 2: ' + window.localStorage['Level2'].toString();
    } else {
      btnHighScore2.text = 'Level 2: ';
    }
    if (window.localStorage.containsKey('Level3')) {
      btnHighScore3.text =
          'Level 3: ' + window.localStorage['Level3'].toString();
    } else {
      btnHighScore3.text = 'Level 3: ';
    }
    if (window.localStorage.containsKey('Level4')) {
      btnHighScore4.text =
          'Level 4: ' + window.localStorage['Level4'].toString();
    } else {
      btnHighScore4.text = 'Level 4: ';
    }
    if (window.localStorage.containsKey('Level5')) {
      btnHighScore5.text =
          'Level 5: ' + window.localStorage['Level5'].toString();
    } else {
      btnHighScore5.text = 'Level 5: ';
    }
  }
}
