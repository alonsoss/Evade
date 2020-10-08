import 'vector.dart';
/**
 * @author Ginter
 * abstrakte Klasse für Spieleobjekte für die einfachere Handhabung
 */
abstract class GameObject {
  Vector _pos;

  Vector get pos => _pos;
  GameObject();

  void update() {}
}
