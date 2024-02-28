import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flappy_bird/game/assets.dart';
import 'package:flappy_bird/game/config.dart';
import 'package:flappy_bird/game/flappy_bird_game.dart';
import 'package:flappy_bird/game/pipe_pos.dart';
import 'package:flutter/widgets.dart';

class Pipe extends SpriteComponent with HasGameRef<FlappyBirdGame> {

  @override
  final double height;
  final PipePosition pipePosition;

  Pipe({required this.height, required this.pipePosition});

  @override
  Future<void> onLoad() async {
    sprite = Sprite(await Flame.images.load(Assets.pipe));
    anchor = Anchor.center;
    angle = pipePosition == PipePosition.bottom ? 0 : pi;
    size = Vector2(50, height);
    setYPosition();
    add(RectangleHitbox());
  }

  void setYPosition() {
    switch(pipePosition) {
      case PipePosition.up:
        position.y = 0;
        break;
      case PipePosition.bottom:
        if (anchor == Anchor.center) {
          position.y = game.size.y - size.y / 2 - Config.groundHeight;
        } else {
          debugPrint('Cannot set position on Pipe, not supported anchor: $anchor, stackTrace: ${StackTrace.current}');
        }
        break;
    }
  }
}