import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class DinoGame extends FlameGame with TapDetector {
  late DinoPlayer dino;
  late Ground ground;
  late Cactus cactus;
  late TextComponent scoreText;
  late TextComponent gameOverText;
  late TextComponent restartText;

  int score = 0;
  bool isGameOver = false;

  @override
  Future<void> onLoad() async {
    // Khởi tạo các components
    dino = DinoPlayer();
    ground = Ground();
    cactus = Cactus();

    // Thêm các components vào game
    add(ground);
    add(dino);
    add(cactus);

    // Khởi tạo text components
    scoreText = TextComponent(
      text: 'Điểm: 0',
      position: Vector2(10, 10),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 24,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    gameOverText = TextComponent(
      text: 'GAME OVER',
      position: Vector2(size.x / 2 - 100, size.y / 2 - 50),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 48,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    restartText = TextComponent(
      text: 'Nhấn để chơi lại',
      position: Vector2(size.x / 2 - 100, size.y / 2 + 50),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 24,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    add(scoreText);
  }

  @override
  void onTap() {
    if (isGameOver) {
      restart();
    } else {
      dino.jump();
    }
  }

  void updateScore() {
    score++;
    scoreText.text = 'Điểm: $score';
  }

  void gameOver() {
    isGameOver = true;
    add(gameOverText);
    add(restartText);
  }

  void restart() {
    isGameOver = false;
    score = 0;
    scoreText.text = 'Điểm: 0';
    remove(gameOverText);
    remove(restartText);
    cactus.reset();
  }
}
