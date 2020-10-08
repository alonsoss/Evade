import '../Model/rectangularObject.dart';
import '../Model/vector.dart';
import 'levelView.dart';

class RectangularView extends GameObjectView {
  RectangularObject _model;

  RectangularObject get model => _model;

//haengt div an den body an
  RectangularView(this._model, LevelView parent) : super(parent) {
    parent.gameField.append(div);
  }

  Vector getRelativePos() {
    return _model.pos - parent.cam.pos;
  }

  @override
  void render() {
    var relPos = getRelativePos();
    div
      ..className = 'rectangle'
      ..style.top = relPos.y.toString() + 'px'
      ..style.left = relPos.x.toString() + 'px'
      ..style.width = _model.width.toString() + 'px'
      ..style.height = _model.height.toString() + 'px';
  }
}
