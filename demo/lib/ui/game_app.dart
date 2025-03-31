import 'package:flutter/material.dart';
import '../game/dino_game.dart';
import 'main_menu.dart'; // Import MainMenu

class GameApp extends StatelessWidget {
  final DinoGame game;

  const GameApp({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dino Run',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainMenu(game: game), // Sử dụng MainMenu làm màn hình chính
    );
  }
}