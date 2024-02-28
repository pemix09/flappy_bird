import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flappy_bird/components/pipe.dart';
import 'package:flappy_bird/game/config.dart';
import 'package:flappy_bird/game/flappy_bird_game.dart';
import 'package:flappy_bird/game/pipe_pos.dart';
import 'package:flutter/rendering.dart';

class PipeGroup extends PositionComponent with HasGameRef<FlappyBirdGame> {
  final _random = Random();

  @override
  Future<void> onLoad() async {
    position.x = game.size.x;
    final playableY = game.size.y - Config.groundHeight;
    final spacingBetweenPipes = 100 + _random.nextDouble() * (playableY / 4);
    final centerY = spacingBetweenPipes + _random.nextDouble() * (playableY - spacingBetweenPipes);

    add(Pipe(height: centerY - spacingBetweenPipes / 2, pipePosition: PipePosition.up));
    add(Pipe(height: playableY - (centerY + spacingBetweenPipes / 2), pipePosition: PipePosition.bottom));
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= Config.gameSpeed * dt;

    if (position.x < 0 && !game.camera.canSee(this)) {
      removeFromParent();
      game.bird.score++;
    }
  }
}