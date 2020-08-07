import 'package:flutter/material.dart';
import 'package:flutter_shared/src/widgets/slide_down_clock/slide_direction.dart';

class ClipHalfRect extends CustomClipper<Rect> {
  ClipHalfRect({
    @required this.percentage,
    @required this.isUp,
    @required this.slideDirection,
  });

  final double percentage;
  final bool isUp;
  final SlideDirection slideDirection;

  @override
  Rect getClip(Size size) {
    Rect rect;
    if (slideDirection == SlideDirection.down) {
      if (isUp) {
        // -1.0 -> 0.0
        rect = Rect.fromLTRB(
            0.0, size.height * -percentage, size.width, size.height);
      } else {
        // 0 -> 1
        rect = Rect.fromLTRB(
          0.0,
          0.0,
          size.width,
          size.height * (1 - percentage),
        );
      }
    } else {
      if (isUp) {
        rect =
            Rect.fromLTRB(0.0, size.height * (1 + percentage), size.width, 0.0);
      } else {
        rect = Rect.fromLTRB(
            0.0, size.height * percentage, size.width, size.height);
      }
    }
    return rect;
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
