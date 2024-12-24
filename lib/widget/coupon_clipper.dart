import 'package:flutter/material.dart';


class CouponClipper extends CustomClipper<Path> {
  const CouponClipper({
    this.borderRadius = 8,
    this.curveRadius = 20,
    this.curvePosition = 100,
    this.curveAxis = Axis.horizontal,
    this.direction = TextDirection.ltr,
    this.clockwise = false,
  }) : assert(
  curvePosition > borderRadius,
  "'curvePosition' should be greater than the 'borderRadius'",
  );

  final double borderRadius;
  final double curveRadius;
  final double curvePosition;
  final Axis curveAxis;
  final TextDirection direction;
  final bool clockwise;

  @override
  Path getClip(Size size) {
    double directionalCurvePosition = curvePosition;

    if (curveAxis == Axis.vertical && direction == TextDirection.rtl) {
      directionalCurvePosition = size.width - curvePosition - curveRadius;
    }

    final Radius arcRadius = Radius.circular(borderRadius);
    final Path path = Path();

    path.moveTo(0, borderRadius - 2);

    if (curveAxis == Axis.horizontal) {
      path.lineTo(0, directionalCurvePosition);
      path.quadraticBezierTo(
        curveRadius / 1.5,
        directionalCurvePosition + (curveRadius / 2),
        0,
        directionalCurvePosition + curveRadius,
      );
    }

    path.lineTo(0, size.height - borderRadius);
    path.arcToPoint(
      Offset(borderRadius, size.height),
      radius: arcRadius,
      clockwise: clockwise,
    );

    path.lineTo(size.width - borderRadius, size.height);
    path.arcToPoint(
      Offset(size.width, size.height - borderRadius),
      radius: arcRadius,
      clockwise: clockwise,
    );

    if (curveAxis == Axis.horizontal) {
      path.lineTo(size.width, directionalCurvePosition + curveRadius);
      path.quadraticBezierTo(
        size.width - (curveRadius / 1.5),
        directionalCurvePosition + (curveRadius / 2),
        size.width,
        directionalCurvePosition,
      );
    }

    path.lineTo(size.width, borderRadius);
    path.arcToPoint(
      Offset(size.width - borderRadius, 0),
      radius: arcRadius,
      clockwise: clockwise,
    );

    if (curveAxis == Axis.vertical) {
      path.lineTo(directionalCurvePosition + curveRadius, 0);
      path.quadraticBezierTo(
        (directionalCurvePosition - (curveRadius / 2)) + curveRadius,
        curveRadius / 1.5,
        directionalCurvePosition - curveRadius + curveRadius,
        0,
      );
    }

    path.lineTo(borderRadius, 0);
    path.arcToPoint(
      Offset(0, borderRadius),
      radius: arcRadius,
      clockwise: clockwise,
    );

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => oldClipper != this;
}
