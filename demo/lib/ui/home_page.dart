import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../game/dino_game.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  final DinoGame game;

  const MyHomePage({super.key, required this.title, required this.game});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue,
      ),
      body: GameWidget(
        game: widget.game,
      ),
    );
  }
}
