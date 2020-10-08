import '../Model/character.dart';
import 'circularView.dart';
import 'levelView.dart';
/**
 * author Ginter
 * View für die Character Klasse
 */
class CharacterView extends CircularView {
  // haengt div an den body an
  CharacterView(Character model, LevelView parent) : super(model, parent) {
    parent.gameField.append(div);
  }

  /// Override to render the character
  @override
  void render() {
    super.render(); //positioniert einen kreis
    div..id = 'character';
  }
}
