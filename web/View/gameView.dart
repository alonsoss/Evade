import 'dart:html';

import '../Controller/gameController.dart';
import 'levelView.dart';
import 'menuView.dart';

/// Class that represents the game view
class GameView {
  // Attributes
  final game = querySelector('#game');
  MenuView _menuView;
  LevelView _levelView;
  GameController controller;

  int scene = 1;

  // Constructor
  GameView(this.controller) {
    _menuView = MenuView(controller, this);
  }

  // Getter to get the menuview
  MenuView get menuView => _menuView;

  // Method to show the level complete box
  void showLevelCompleteBox(String starsScoreString, int inSeconds, currentLevel) {
    _menuView.showLevelCompletedBox(starsScoreString, inSeconds, currentLevel);
  }

  // Method to show the game over box
  void showGameOverBox(String starsScoreString, int inSeconds, currentLevel) {
    _menuView.showGameOverBox(starsScoreString, inSeconds, currentLevel);
  }
}
