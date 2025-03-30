import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class Cactus extends SpriteComponent with HasGameRef {
  static const double speed = 5.0;

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('cactus.png');
    size = Vector2(30, 50);
    position = Vector2(800, 200);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Di chuyển xương rồng sang trái
    position.x -= speed;

    // Reset vị trí khi xương rồng chạy hết
    if (position.x <= -30) {
      position.x = 800;
      // Tăng điểm khi vượt qua xương rồng
      (gameRef as dynamic).updateScore();
    }
  }

  void reset() {
    position.x = 800;
  }
}
