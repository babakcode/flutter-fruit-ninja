import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flutter_fruit_ninja/src/components/back_button.dart';
import 'package:flutter_fruit_ninja/src/components/pause_button.dart';
import 'package:flutter_fruit_ninja/src/components/rectangle_test.dart';
import 'package:flutter_fruit_ninja/src/config/app_config.dart';
import 'package:flutter_fruit_ninja/src/game.dart';

import '../components/fruit_component.dart';

class GamePage extends Component
    with DragCallbacks, HasGameReference<MainRouterGame> {
  final Random random = Random();
  late List<double> fruitsTime;
  late double time, countDown;
  TextComponent? _countdownTextComponent,
    _mistakeTextComponent,
    _scoreTextComponent
  ;
  bool _countdownFinished = false;
  late int mistakeCount, score;

  @override
  void onMount() {
    super.onMount();

    fruitsTime = [];
    countDown = 3;
    mistakeCount = 0;
    score = 0;
    time = 0;
    _countdownFinished = false;

    double initTime = 0;
    for (int i = 0; i < 40; i++) {
      if (i != 0) {
        initTime = fruitsTime.last;
      }
      final millySecondTime = random.nextInt(100) / 100;
      final componentTime = random.nextInt(1) + millySecondTime + initTime;
      fruitsTime.add(componentTime);
    }

    addAll([
      BackButton(onPressed: () {
        removeAll(children);
        game.router.pop();
      }),
      PauseButton(),
      _countdownTextComponent = TextComponent(
        text: '${countDown.toInt() + 1}',
        size: Vector2.all(50),
        position: game.size / 2,
        anchor: Anchor.center,
      ),
      _mistakeTextComponent = TextComponent(
        text: 'Mistake: $mistakeCount',
        // 10 is padding
        position: Vector2(game.size.x - 10, 10),
        anchor: Anchor.topRight,
      ),
      _scoreTextComponent = TextComponent(
        text: 'Score: $score',
        position: Vector2(game.size.x - 10,
            _mistakeTextComponent!.position.y + 40),
        anchor: Anchor.topRight,
      ),
    ]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!_countdownFinished) {
      countDown -= dt;

      _countdownTextComponent?.text = (countDown.toInt() + 1).toString();
      if (countDown < 0) {
        _countdownFinished = true;
      }
    } else {
      _countdownTextComponent?.removeFromParent();

      time += dt;

      fruitsTime.where((element) => element < time).toList().forEach((element) {
        final gameSize = game.size;

        double posX = random.nextInt(gameSize.x.toInt()).toDouble();

        Vector2 fruitPosition = Vector2(posX, gameSize.y);
        Vector2 velocity = Vector2(0, game.maxVerticalVelocity);

        final randFruit = game.fruits.random();

        add(FruitComponent(
          this,
          fruitPosition,
          acceleration: AppConfig.acceleration,
          fruit: randFruit,
          size: AppConfig.shapeSize,
          image: game.images.fromCache(randFruit.image),
          pageSize: gameSize,
          velocity: velocity,
        ));
        fruitsTime.remove(element);
      });
    }
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);

    componentsAtPoint(event.canvasPosition).forEach((element) {
      if(element is FruitComponent){
        if(element.canDragOnShape){
          element.touchAtPoint(event.canvasPosition);
        }
      }
    });
  }

  void gameOver() {
    game.router.pushNamed('game-over');
  }

  void addScore() {
    score++;
    _scoreTextComponent?.text = 'Score: $score';
  }

  void addMistake(){
    mistakeCount++;
    _mistakeTextComponent?.text = 'Mistake: $mistakeCount';
    if(mistakeCount >= 3){
      gameOver();
    }
  }
}
