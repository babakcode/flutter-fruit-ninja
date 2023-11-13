import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fruit_ninja/src/game.dart';

import '../components/rounded_button.dart';

class HomePage extends Component with HasGameReference<MainRouterGame> {
  late final RoundedButton _button1;

  @override
  void onLoad() async {
    super.onLoad();

    add(_button1 = RoundedButton(
        text: "Start",
        onPressed: () {
          game.router.pushNamed('game-page');
        },
        color: Colors.blue,
        borderColor: Colors.white,
    ),
    );
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    // button in center of page
    _button1.position = size / 2;
  }
}
