import '../Model/circularObject.dart';
import '../Model/vector.dart';
import 'levelView.dart';

/// The CircularView class to create circulas objects
class CircularView extends GameObjectView {
  CircularObject _model;

//haengt div an den body an
  CircularView(this._model, LevelView parent) : super(parent) {
    parent.gameField.append(div);
  }

  Vector getRelativePos() {
    return _model.pos - parent.cam.pos;
  }

  /// Override to render the circular object
  @override
  void render() {
    var relPos = getRelativePos();
    //positioniert einen kreis
    div
      ..className = 'circle'
      ..style.top = relPos.y.toString() + 'px'
      ..style.left = relPos.x.toString() + 'px'
      ..style.width = (_model.radius * 2).toString() + 'px'
      ..style.height = (_model.radius * 2).toString() + 'px'
      ..style.borderRadius = '50%';
  }
}
