import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class Character extends SpriteAnimationComponent {
  static Future<Character> load() async {
    final gifFrames = await Future.wait([
      Sprite.load('baseru1.png'),
      Sprite.load('baseru2.png'),
      Sprite.load('baseru3.png'),
      Sprite.load('baseru4.png'),
      Sprite.load('baseru5.png'),
      Sprite.load('baseru6.png'),
    ]);

    final animation = SpriteAnimation.spriteList(
      gifFrames,
      stepTime: 0.1,
    );

    return Character()
      ..animation = animation
      ..size = Vector2(100, 100)
      ..position = Vector2(100, 100)
      ..flipHorizontally();
  }
}