import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../game/dino_game.dart';

class MainMenu extends StatelessWidget {
  final DinoGame game;

  const MainMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Dino Run',
              style: TextStyle(
                fontSize: 48,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Bắt đầu game
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => GameWidget(game: game),
                  ),
                );
              },
              child: const Text('Bắt đầu'),
            ),
          ],
        ),
      ),
    );
  }
}