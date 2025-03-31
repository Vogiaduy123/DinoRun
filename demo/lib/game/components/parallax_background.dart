import 'package:flame/components.dart';
import 'package:flame/parallax.dart';

class ParallaxBackground extends ParallaxComponent {
  static Future<ParallaxBackground> load() async {
    final parallax = await Parallax.load(
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

    return ParallaxBackground(parallax);
  }

  ParallaxBackground(Parallax parallax) : super(parallax: parallax);
}