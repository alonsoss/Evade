import 'dart:math';

import '../Controller/gameController.dart';
import 'camera.dart';
import 'character.dart';
import 'circularObject.dart';
import 'fiend.dart';
import 'gameObject.dart';
import 'movingObstacle.dart';
import 'rectangularObject.dart';
import 'savePoint.dart';
import 'vector.dart';

/*@author Ginter
Level beinhaltet den Levelaufbau und die Kollision der GameObjects */
class Level {
  num _width, _height;
  Character _character;
  List<GameObject> _gameObjects;
  List<Fiend> _fiends;
  final GameController _controller;
  SavePoint _activeSavePoint;
  List<SavePoint> _savePoints;
  Camera _cam;
  bool _running = true;
  //@author Essenwanger Attribute für den Score
  var _score = 0;
  final _timer = Stopwatch();

  bool get running => _running;
  num get width => _width;
  num get height => _height;
  Character get prot => _character;
  set running(bool r) => _running = r;

  Level(this._width, this._height, this._controller);

// erstellt ein level aus json und ordnet sie zur weiteren Verarbeitung zu
  Level.fromJson(Map<String, dynamic> json, this._controller) {
    _gameObjects = [];
    _savePoints = [];
    _fiends = [];
    _width = json['width'];
    _height = json['height'];

    for (var object in json['SavePoints']) {
      var model = SavePoint.fromJson(object);
      _savePoints.add(model);
      _controller.registerView(model);
    }
    _savePoints.last.last = true;
    for (var object in json['RectangularObjects']) {
      var model = RectangularObject.fromJson(object);
      _gameObjects.add(model);
      _controller.registerView(model);
    }
    for (var object in json['MovingObstacles']) {
      var model = MovingObstacle.fromJson(object);
      _gameObjects.add(model);
      _controller.registerView(model);
    }

    _activeSavePoint = _savePoints[0];
    _activeSavePoint.active = true;

    _character = Character.fromJson(json['Character']);
    _character.respawn(_activeSavePoint.getSpawnPoint());
    _controller.registerView(_character);
    _controller.recountLives(_character.lives);

    if (json['Fiends'] != null) {
      for (var object in json['Fiends']) {
        var model = Fiend.fromJson(object, _character);
        _gameObjects.add(model);
        _controller.registerView(model);
        _fiends.add(model);
      }
    }

    _cam = Camera(this, _character);
    _controller.registerCamera(_cam);
  }

  // map zur json erstellung
  Map<String, dynamic> toJson() {
    var rects = [];
    var circ = [];
    final data = {};
    data['width'] = _width;
    data['height'] = _height;

    for (var object in _gameObjects) {
      if (object is RectangularObject) {
        rects.add(object);
      } else if (object is CircularObject) {
        circ.add(object);
      }
    }

    data['RectangularObjects'] = rects;
    data['CircularObjects'] = circ;
    return data;
  }

  void update() {
    levelTime();
    _character.update();
    _gameObjects.forEach((e) => e.update());
    collision();
    collision();
    savePointCollision();
    _cam.update();
    if (_activeSavePoint == _savePoints.last) {
      //@author Essenwanger Berechnung des Punktestandes
      _score = ((60 - _timer.elapsed.inSeconds * 1.5) * 10) as int;
      _controller.endLevel(
          1, _score ~/ (4 - _character.lives), _timer.elapsed.inSeconds);
      _character.lives = 3;
    } else if (_character.lives == 0) {
      _controller.endLevel(2, _score, _timer.elapsed.inSeconds);
      _character.lives = 3;
    }
  }

  // Hält den Abstand zwischen einem Runden und Eckigen Objekt ein, unabhängig von deren Bewegungsrichtung
  void closestPointCollision(RectangularObject object, CircularObject circle) {
    var closestPoint;

    var circleCenter =
        Vector(circle.pos.x + circle.radius, circle.pos.y + circle.radius);

    var edges = object.edges;

    //Berechnet den nähersten Punkt zwischen CircularObject und Objekt
    for (var i = 0; i < edges.length; i++) {
      var edge = edges[i];

      var point = circleCenter.closestPoint(edge[0], edge[1]);
      if (point != null) {
        if (closestPoint == null ||
            (closestPoint.squaredDistanceTo(circleCenter) >
                point.squaredDistanceTo(circleCenter))) {
          closestPoint = point;
        }
      }
    }
    if (closestPoint != null) {
      var distance = circleCenter - closestPoint;
      var mag = distance.magnitude;
      if (mag < circle.radius) {
        var displacement = (distance / mag) * (circle.radius - mag + 0.1);
        circle.pos += displacement;
      }
    }
  }

  // Prüft auf Kollisionen zwischen den einzelnen Spielobjekten
  void collision() {
    var char = _character;

    var radius = _character.radius;

    if (char.pos.y < 0) {
      _character.pos.y = 0;
    } else if (char.pos.y + radius * 2 > _height) {
      _character.pos.y = _height - radius * 2;
    }
    if (char.pos.x < 0) {
      _character.pos.x = 0;
    } else if (char.pos.x + radius * 2 > _width) {
      _character.pos.x = _width - radius * 2;
    }

    var charCenter = Vector(char.pos.x + radius, char.pos.y + radius);
    for (var object in _gameObjects) {
      if (object is RectangularObject) {
        closestPointCollision(object, _character);
        rectangleCollision(object, _character);
        _fiends.forEach((element) {
          closestPointCollision(object, element);
          rectangleCollision(object, element);
        });
      } else if (object is CircularObject) {
        var center =
            Vector(object.pos.x + object.radius, object.pos.y + object.radius);
        var distance = (charCenter - center).magnitude;
        if ((object.radius + radius) > distance) {
          _character.respawn(_activeSavePoint.getSpawnPoint());
          _character.lives--;
          _fiends.forEach((element) => element.respawn());
          _controller.recountLives(_character.lives);
        }
      }
    }
  }

//Reagiert auf die Kollision des Characters mit den Speicherpunkten
  void savePointCollision() {
    var char = _character;

    var radius = _character.radius;

    var charCenter = Vector(char.pos.x + radius, char.pos.y + radius);

    for (var point in _savePoints) {
      if ((charCenter.y + radius) >= point.pos.y &&
          (charCenter.y - radius) <= (point.pos.y + point.height) &&
          (charCenter.x + radius) >= point.pos.x &&
          (charCenter.x - radius) <= (point.pos.x + point.width)) {
        _activeSavePoint.active = false;
        _activeSavePoint = point;
        _activeSavePoint.active = true;
      }
    }
  }

// Berechnet, ob es einen Schnittpunkt zwischen zwei Strecken gibt
  Vector getIntersection(Vector a1, Vector a2, Vector b1, Vector b2) {
    var x3 = a1.x;
    var y3 = a1.y;
    var x4 = a2.x;
    var y4 = a2.y;

    var x1 = b1.x;
    var y1 = b1.y;
    var x2 = b2.x;
    var y2 = b2.y;

    //Denominatorberechnung, bei 0 ein null zurueck, da Linien parallel oder uebereinstimmend
    var den = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
    if (den == 0) {
      return null;
    }
    //Bestimmung, ob die beiden Strecken sich einen Schnittpunkt teilen
    var t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / den;
    var u = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / den;
    if (t >= 0.0 && t <= 1.0 && u >= 0.0 && u <= 1.0) {
      //Berechnung des exakten Schnittpunkts
      var intersection = Vector(x1 + t * (x2 - x1), y1 + t * (y2 - y1));
      return intersection;
    }
    return null;
  }

//Berechnet mit welcher Geschwindigkeit und in welche Richtung der Charakter von Wänden abprallt
  Vector getResultingVel(Vector vel, Vector collidingEdge) {
    var alpha = Vector.angleBetweenVectors(vel, collidingEdge);

    var c = vel.magnitude;

    if (vel.normal.x < 0) {
      c *= -1;
    }

    var dir =
        Vector(collidingEdge.normal.x.abs(), collidingEdge.normal.y.abs());
    var result = dir * c * cos(alpha);

    if (result.x > 0 && vel.x < 0 || result.x < 0 && vel.x > 0) {
      result.x *= -1;
    }
    if (result.y > 0 && vel.y < 0 || result.y < 0 && vel.y > 0) {
      result.y *= -1;
    }

    if (result.magnitude.abs() < 0.001) {
      result *= 0;
    }

    return result;
  }

//Prüft auf Kollision mit den rectangularObjects abhängig von der Bewegungsrichtung des Circular Objects und hält den Abstand
  void rectangleCollision(RectangularObject object, CircularObject circle) {
    var char = circle;

    var radius = circle.radius;
    var circleCenter = Vector(char.pos.x + radius, char.pos.y + radius);
    var posOld = circleCenter - char.vel;
    var lines = List<List<Vector>>(4);
    var edges = object.edges;

    // Initialisierung von 4 Bewegungslinien, die im Abstand von 90° rundherum am Rand des Kreises ansetzen. Sie beschreiben den Weg der Bewegung des Kreises
    lines[0] = [posOld + Vector(0, -radius), circleCenter + Vector(0, -radius)];
    lines[1] = [posOld + Vector(0, radius), circleCenter + Vector(0, radius)];
    lines[2] = [posOld + Vector(radius, 0), circleCenter + Vector(radius, 0)];
    lines[3] = [posOld + Vector(-radius, 0), circleCenter + Vector(-radius, 0)];

    // Prüfen ob einer der Bewegungslinien mit einer Wand kollidiert, und Berechnung der Distanz zum nächsten Kollisionspunkt [shortestDistance]
    var shortestDistance;
    var collidedEdge;
    var closestIntersection;
    for (var i = 0; i < lines.length; i++) {
      var line = lines[i];
      for (var edge in edges) {
        var intersection = getIntersection(line[0], line[1], edge[0], edge[1]);
        if (intersection != null) {
          var distance = intersection - line[0];
          if (shortestDistance == null) {
            collidedEdge = edge;
            shortestDistance = distance;
            closestIntersection = intersection;
          } else if (shortestDistance.magnitude > distance.magnitude) {
            shortestDistance = distance;
            collidedEdge = edge;
            closestIntersection = intersection;
          }
        }
      }
    }
    // Wenn eine Kollision erkannt wurde, wird [circle] senkrecht zu der Kante des Rechtecks, 
    // mit dem [circle] collidiert ist, von dem Kollisionspunkt aus um den Radius abgestoßen
    if (shortestDistance != null) {
      var m = (collidedEdge[0].y - collidedEdge[1].y) /
          (collidedEdge[0].x - collidedEdge[1].x);

      // initialisierung der senkrechten Vektoren zur kollidiernten Kante
      var n1 = Vector(m, -1);
      var n2 = Vector(-m, 1);

      if ((m as num).isInfinite) {
        n1 = Vector(radius + .1, 0);
        n2 = Vector(-radius - .1, 0);
      } else {
        n1 = (n1 / n1.magnitude) * (radius + .1);
        n2 = (n2 / n2.magnitude) * (radius + .1);
      }

      circle.pos = closestIntersection - Vector(radius, radius);
      var n;
      if ((circle.vel + n1).magnitude < (circle.vel + n2).magnitude) {
        n = n1;
      } else {
        n = n2;
      }

      circle.pos += n;

      // Berechnung der resultierenden Geschwindigkeit von [circle] nach Aufprall
      var resVel =
          getResultingVel(circle.vel, collidedEdge[1] - collidedEdge[0]);
      circle.vel = resVel * 0.6;
      circle.pos += circle.vel;
    }
  }

  //@author Essenwanger Timer für den Score
  void levelTime() {
    _timer.start();
  }
}
