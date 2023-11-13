import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter_fruit_ninja/src/config/app_config.dart';
import 'package:flutter_fruit_ninja/src/models/fruit_model.dart';
import 'package:flutter_fruit_ninja/src/routes/game_over_page.dart';
import 'package:flutter_fruit_ninja/src/routes/game_page.dart';
import 'package:flutter_fruit_ninja/src/routes/home_page.dart';
import 'package:flutter_fruit_ninja/src/routes/pause_game.dart';

class MainRouterGame extends FlameGame {
  late final RouterComponent router;
  late double maxVerticalVelocity;

  final List<FruitModel> fruits = [
    FruitModel(image: "apple.png"),
    FruitModel(image: "banana.png"),
    FruitModel(image: "kiwi.png"),
    FruitModel(image: "orange.png"),
    FruitModel(image: "peach.png"),
    FruitModel(image: "pineapple.png"),
    FruitModel(image: "bomb.png", isBomb: true),
  ];

  @override
  void onLoad() async {
    super.onLoad();

    for (final fruit in fruits) {
      await images.load(fruit.image);
    }

    addAll([
      ParallaxComponent(
          parallax: Parallax(
              [await ParallaxLayer.load(ParallaxImageData('bg.png'))])),
      router = RouterComponent(initialRoute: 'home', routes: {
        'home': Route(HomePage.new),
        'game-page': Route(GamePage.new),
        'pause': PauseRoute(),
        'game-over': GameOverRoute()
      })
    ]);
  }



  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    getMaxVerticalVelocity(size);
  }

  void getMaxVerticalVelocity(Vector2 size) {
    maxVerticalVelocity = sqrt(2 *
        (AppConfig.gravity.abs() + AppConfig.acceleration.abs()) *
        (size.y - AppConfig.objSize * 2));
  }
}
