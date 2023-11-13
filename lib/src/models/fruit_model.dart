import 'package:flutter/material.dart';

class FruitModel {
  String image;
  bool isBomb;
  Color color;

  FruitModel({
    required this.image,
    this.isBomb = false,
    this.color = Colors.transparent,
  });
}
