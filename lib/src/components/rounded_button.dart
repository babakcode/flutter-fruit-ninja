import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';


class RoundedButton extends PositionComponent with TapCallbacks{
  final String text;
  final VoidCallback onPressed;
  final TextPainter _textDrawable;
  late final Offset _textOffset;
  late final RRect _rRect;
  late final Paint _borderPaint;
  late final Paint _bgPaint;

  RoundedButton({
    required this.text,
    required this.onPressed,
    required Color color,
    required Color borderColor,
    super.anchor = Anchor.center
})  : _textDrawable = TextPaint(
    style: const TextStyle(
      fontSize: 20,
      color: Color(0xFF000000),
      fontWeight: FontWeight.w800,
    ),
  ).toTextPainter(text) {
    size = Vector2(150, 40);
    _textOffset = Offset(
      (size.x - _textDrawable.width) / 2,
      (size.y - _textDrawable.height) / 2,
    );
    _rRect = RRect.fromLTRBR(0, 0, size.x, size.y, Radius.circular(size.y / 2));
    _bgPaint = Paint()..color = color;
    _borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = borderColor;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(_rRect, _bgPaint);
    canvas.drawRRect(_rRect, _borderPaint);
    _textDrawable.paint(canvas, _textOffset);
  }

  @override
  void onTapDown(TapDownEvent event) {
    scale = Vector2.all(1.05);
  }

  @override
  void onTapUp(TapUpEvent event) {
    scale = Vector2.all(1.0);
    onPressed.call();
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    scale = Vector2.all(1.0);
  }
}