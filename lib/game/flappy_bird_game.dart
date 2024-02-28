import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/timer.dart';
import 'package:flappy_bird/components/background.dart';
import 'package:flappy_bird/components/bird.dart';
import 'package:flappy_bird/components/ground.dart';
import 'package:flappy_bird/components/pipe_group.dart';
import 'package:flappy_bird/game/config.dart';

class FlappyBirdGame extends FlameGame with TapDetector, HasCollisionDetection {
  late final Bird bird;
  late final Timer timer = Timer(Config.pipeGeneratingInterval, repeat: true);
  late final TextComponent score;

  @override
  Future<void> onLoad() async {
    await add(Background());
    await add(Ground());
    await add(bird = Bird());
    await add(score = buildScore());
    timer.onTick = () async => await add(PipeGroup());
  }

  @override
  void update(double dt) {
    super.update(dt);
    timer.update(dt);
    score.text = 'Score: ${bird.score}';
  }

  @override
  void onTap() {
    bird.fly();
    super.onTap();
  }

  TextComponent buildScore() {
    return TextComponent(
      text: 'Score: ${bird.score}',
      position: Vector2(size.x / 2, size.y / 2* 0.2),
      anchor: Anchor.center,
      priority: 1
    );
  }
}
