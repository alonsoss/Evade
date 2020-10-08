import '../Model/rectangularObject.dart';
import '../Model/savePoint.dart';
import 'levelView.dart';
import 'rectangularView.dart';
/**
 * @author Ginter
 *View für die Savepoint Klasse
 */
class SavePointView extends RectangularView {
  SavePointView(RectangularObject model, LevelView parent)
      : super(model, parent);

  @override
  void render() {
    super.render();
//zeigt je nach Status des Savepoint ihn anders an
    div.className = (model as SavePoint).last
        ? 'savePoint finish'
        : (model as SavePoint).active
            ? 'savePoint active'
            : 'savePoint inactive';
  }
}
