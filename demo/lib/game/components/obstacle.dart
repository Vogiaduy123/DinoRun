import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class Obstacle extends SpriteComponent {
  static Future<Obstacle> load(Vector2 screenSize) async {
    final sprite = await Sprite.load('obstacle.png');
    return Obstacle()
      ..sprite = sprite
      ..size = Vector2(50, 50)
      ..position = Vector2(screenSize.x, screenSize.y - 50);
  }
}