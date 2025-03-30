import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class Ground extends SpriteComponent with HasGameRef {
  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('ground.png');
    size = Vector2(800, 100);
    position = Vector2(0, 300);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Di chuyển mặt đất sang trái
    position.x -= 5;

    // Reset vị trí khi mặt đất chạy hết
    if (position.x <= -800) {
      position.x = 0;
    }
  }
}
