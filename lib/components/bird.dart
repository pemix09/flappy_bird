import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flappy_bird/components/pipe_group.dart';
import 'package:flappy_bird/game/assets.dart';
import 'package:flappy_bird/game/bird_move.dart';
import 'package:flappy_bird/game/config.dart';
import 'package:flappy_bird/game/flappy_bird_game.dart';
import 'package:flappy_bird/screens/game_over_screen.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

class Bird extends SpriteGroupComponent<BirdMovement>
    with HasGameRef<FlappyBirdGame>, CollisionCallbacks {
  int score = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final birdUpFlapSprite = await game.loadSprite(Assets.birdUpFlap);
    final birdMidFlapSprite = await game.loadSprite(Assets.birdMidFlap);
    final birdDownFlapSprite = await game.loadSprite(Assets.birdDownFlap);

    size = Vector2(50, 40);
    position = Vector2(50, game.size.y / 2 - size.y / 2);
    current = BirdMovement.middle;
    sprites = {
      BirdMovement.up: birdUpFlapSprite,
      BirdMovement.middle: birdMidFlapSprite,
      BirdMovement.down: birdDownFlapSprite,
    };
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += Config.birdVelocity * dt;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    game.pauseEngine();
    game.overlays.add(GameOverScreen.id);
    game.removeAll(game.children.whereType<PipeGroup>());
  }

  void fly() {
    add(
      MoveByEffect(
        Vector2(0, -Config.gravity),
        EffectController(duration: 0.3, curve: Curves.decelerate),
        onComplete: () => current = BirdMovement.down,
      ),
    );
    current = BirdMovement.up;
  }

  void reset() {
    position = Vector2(50, game.size.y / 2 - size.y /2);
    score = 0;
  }
}
