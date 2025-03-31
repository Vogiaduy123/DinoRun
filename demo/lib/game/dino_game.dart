import 'package:flame/components.dart';
import 'my_flame_game.dart';
import 'components/character.dart';
import 'components/obstacle.dart';
import 'components/parallax_background.dart';

class DinoGame extends MyFlameGame {
  late Character character;
  late Obstacle obstacle;
  bool isJumping = false;
  bool isFalling = false;
  double jumpSpeed = 300;
  double groundLevel = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Tải nền parallax
    final parallaxBackground = await ParallaxBackground.load();
    add(parallaxBackground);

    // Tải nhân vật Dino
    character = await Character.load();
    add(character);

    // Tải chướng ngại vật
    obstacle = await Obstacle.load(size);
    add(obstacle);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Logic nhảy
    if (isJumping) {
      character.y -= jumpSpeed * dt;
      if (character.y <= groundLevel - 100) {
        isJumping = false;
        isFalling = true;
      }
    } else if (isFalling) {
      character.y += jumpSpeed * dt;
      if (character.y >= groundLevel) {
        character.y = groundLevel;
        isFalling = false;
      }
    }

    // Di chuyển chướng ngại vật
    obstacle.x -= 100 * dt;
    if (obstacle.x < -obstacle.width) {
      obstacle.x = size.x;
    }

    // Kiểm tra va chạm
    if (character.toRect().overlaps(obstacle.toRect())) {
      gameOver();
    }
  }

  void onTap() {
    if (!isJumping && !isFalling) {
      isJumping = true;
    }
  }

  void gameOver() {
    // Xử lý game over
  }

  void startGame() {
    // Đặt lại trạng thái game
    isJumping = false;
    isFalling = false;
    character.position = Vector2(100, 100);
    obstacle.position = Vector2(size.x, size.y - 50);
  }
}