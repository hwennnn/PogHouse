// Define a CustomPainter to paint the bubble background.
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BubblePainter extends CustomPainter {
  BubblePainter({this.isIncoming});

  final bool isIncoming;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Color(0xffF1F1F1)
      ..style = PaintingStyle.fill;
    final Path bubble = Path();
    final width = size.width;
    final height = size.height;

    if (!isIncoming) {
      bubble
        ..moveTo(width - 22.0, height)
        ..lineTo(17.0, height)
        ..cubicTo(7.61, height, 0.0, height - 7.61, 0.0, height - 17.0)
        ..lineTo(0.0, 17.0)
        ..cubicTo(0.0, 7.61, 7.61, 0.0, 17.0, 0.0)
        ..lineTo(width - 21, 0.0)
        ..cubicTo(width - 11.61, 0.0, width - 4.0, 7.61, width - 4.0, 17.0)
        ..lineTo(width - 4.0, height - 11.0)
        ..cubicTo(width - 4.0, height - 1.0, width, height, width, height)
        ..lineTo(width + 0.05, height - 0.01)
        ..cubicTo(width - 4.07, height + 0.43, width - 8.16, height - 1.06,
            width - 11.04, height - 4.04)
        ..cubicTo(
            width - 16.0, height, width - 19.0, height, width - 22.0, height)
        ..close();
    } else {
      bubble
        ..moveTo(22.0, height)
        ..lineTo(width - 17, height)
        ..cubicTo(
            width - 7.61, height, width, height - 7.61, width, height - 17.0)
        ..lineTo(width, 17.0)
        ..cubicTo(width, 7.61, width - 7.61, 0.0, width - 17.0, 0.0)
        ..lineTo(21, 0.0)
        ..cubicTo(11.61, 0.0, 4.0, 7.61, 4.0, 17.0)
        ..lineTo(4.0, height - 11.0)
        ..cubicTo(4.0, height - 1.0, 0.0, height, 0.0, height)
        ..lineTo(-0.05, height - 0.01)
        ..cubicTo(
            4.07, height + 0.43, 8.16, height - 1.06, 11.04, height - 4.04)
        ..cubicTo(16.0, height, 19.0, height, 22.0, height)
        ..close();
    }

    canvas.drawPath(bubble, paint);
  }

  @override
  bool shouldRepaint(BubblePainter oldPainter) => true;
}

// This is my custom RenderObject.
class BubbleMessage extends SingleChildRenderObjectWidget {
  BubbleMessage({
    Key key,
    this.painter,
    Widget child,
  }) : super(key: key, child: child);

  final CustomPainter painter;

  @override
  RenderCustomPaint createRenderObject(BuildContext context) {
    return RenderCustomPaint(
      painter: painter,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderCustomPaint renderObject) {
    renderObject..painter = painter;
  }
}
