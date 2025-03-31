import 'dart:math';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const double groundHeight = 32;
const double jumpSpeed = 1000; // Tốc độ nhảy
const double gravity = 1500;  // Trọng lực
const double dinoSpeed = 350; // Tốc độ di chuyển của Dino
const double coinSpeed = 350; // Tốc độ di chuyển của đồng tiền

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);

  final game = DinoGame();
  runApp(GameApp(game: game));
}

class GameApp extends StatelessWidget {
  final DinoGame game;

  GameApp({required this.game});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dino Run',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: GameWidget(game: game),
      ),
    );
  }
}

class DinoGame extends MyFlameGame with TapDetector {
  late SpriteAnimationComponent character;
  double ySpeed = 0;
  bool isJumping = false;
  late double initialY;

  final List<SpriteAnimationComponent> characters = [];
  late Timer _spawnTimer;
  late Timer _coinSpawnTimer;
  final Random _random = Random();

  bool gameOver = false;
  SpriteComponent? coin; // Có thể null
  int score = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final parallax = await loadParallaxComponent(
      [
        ParallaxImageData('parallax/plx-1.png'),
        ParallaxImageData('parallax/plx-2.png'),
        ParallaxImageData('parallax/plx-3.png'),
        ParallaxImageData('parallax/plx-4.png'),
        ParallaxImageData('parallax/plx-5.png'),
        ParallaxImageData('parallax/plx-6.png'),
      ],
      baseVelocity: Vector2(30, 0),
      velocityMultiplierDelta: Vector2(1.4, 0),
    );
    add(parallax);

    final dinoFrames = await Future.wait([
      images.load('baseru1.png'),
      images.load('baseru2.png'),
      images.load('baseru3.png'),
      images.load('baseru4.png'),
      images.load('baseru5.png'),
      images.load('baseru6.png'),
    ]);
    final dinoAnimation = SpriteAnimation.spriteList(
      dinoFrames.map((frame) => Sprite(frame)).toList(),
      stepTime: 0.1,
    );
    character = SpriteAnimationComponent(
      animation: dinoAnimation,
      size: Vector2(100, 100),
      position: Vector2(100, 550),
    );
    character.flipHorizontally();
    add(character);

    initialY = character.position.y;

    _scheduleNextCharacterSpawn();

    _coinSpawnTimer = Timer(2.0, onTick: _spawnCoin, repeat: true);
    _coinSpawnTimer.start();
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (!isJumping) {
      isJumping = true;
      ySpeed = -jumpSpeed;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameOver) return;

    for (final enemy in characters) {
      enemy.position.x -= dinoSpeed * dt;

      if (character.toRect().overlaps(enemy.toRect())) {
        gameOver = true;
        print("Game Over!");
        return;
      }
    }

    if (coin != null) {
      coin!.position.x -= coinSpeed * dt;

      if (coin!.position.x < -coin!.size.x) {
        coin!.removeFromParent();
        coin = null;
      }

      if (character.toRect().overlaps(coin!.toRect())) {
        score += 10;
        print("Score: $score");
        coin!.removeFromParent();
        coin = null;
      }
    }

    if (isJumping) {
      character.position.y += ySpeed * dt;
      ySpeed += gravity * dt;

      if (character.position.y >= initialY) {
        character.position.y = initialY;
        isJumping = false;
      }
    }

    _spawnTimer.update(dt);
    _coinSpawnTimer.update(dt);
  }

  void _spawnCharacter() async {
    if (gameOver) return;

    final types = ['dino', 'rino', 'bat'];
    final type = types[_random.nextInt(types.length)];

    final frames = await Future.wait(
      type == 'rino'
          ? [
        images.load('rino/rino1.png'),
        images.load('rino/rino2.png'),
        images.load('rino/rino3.png'),
        images.load('rino/rino4.png'),
      ]
          : type == 'bat'
          ? [
        images.load('bat/bat1.png'),
        images.load('bat/bat2.png'),
        images.load('bat/bat3.png'),
        images.load('bat/bat4.png'),
        images.load('bat/bat5.png'),
      ]
          : [
        images.load('pig/pig1.png'),
        images.load('pig/pig2.png'),
        images.load('pig/pig3.png'),
        images.load('pig/pig4.png'),
        images.load('pig/pig5.png'),
        images.load('pig/pig6.png'),
        images.load('pig/pig7.png'),
      ],
    );

    final animation = SpriteAnimation.spriteList(
      frames.map((frame) => Sprite(frame)).toList(),
      stepTime: 0.1,
    );

    final yPosition = type == 'bat'
        ? size.y - groundHeight - 200
        : size.y - groundHeight - 120;

    final enemy = SpriteAnimationComponent(
      animation: animation,
      size: Vector2(100, 100),
      position: Vector2(size.x, yPosition),
    );
    enemy.flipHorizontally();
    characters.add(enemy);
    add(enemy);

    _scheduleNextCharacterSpawn();
  }

  void _spawnCoin() async {
    final coinImage = await images.load('coin.png');
    coin = SpriteComponent()
      ..sprite = Sprite(coinImage)
      ..size = Vector2(50, 50) // Kích thước đồng tiền
      ..position = Vector2(
        size.x,                        // Vị trí ban đầu: ngoài màn hình bên phải
        size.y - groundHeight - 420,   // Đặt đồng tiền gần mặt đất
      );
    add(coin!);
  }

  void _scheduleNextCharacterSpawn() {
    final nextSpawnTime = 3 + _random.nextDouble() * 2;
    _spawnTimer = Timer(nextSpawnTime, onTick: _spawnCharacter);
    _spawnTimer.start();
  }
}

class MyFlameGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    super.onLoad();
  }
}
