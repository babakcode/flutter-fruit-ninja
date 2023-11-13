import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart' hide Game;
import 'package:flutter_fruit_ninja/src/game.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  Flame.device.fullScreen();
  Flame.device.setLandscape();

  runApp(GameWidget(game: MainRouterGame()));
}

