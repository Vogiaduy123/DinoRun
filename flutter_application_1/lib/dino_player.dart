import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class DinoPlayer extends SpriteComponent with HasGameRef {
  static const double gravity = 0.8;
  static const double jumpForce = -15.0;

  double velocityY = 0;
  bool isJumping = false;

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('dino.png');
    size = Vector2(50, 50);
    position = Vector2(50, 200);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Cập nhật vị trí theo trọng lực
    velocityY += gravity;
    position.y += velocityY;

    // Kiểm tra va chạm với mặt đất
    if (position.y > 200) {
      position.y = 200;
      velocityY = 0;
      isJumping = false;
    }
  }

  void jump() {
    if (!isJumping) {
      velocityY = jumpForce;
      isJumping = true;
    }
  }
}
