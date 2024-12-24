import 'package:flutter/material.dart';

class DashedLine extends StatelessWidget {
  final double dashWidth; // Width of each dash
  final double dashSpace; // Space between dashes
  final double height; // Height of the line
  final Color color; // Color of the dashed line
  final EdgeInsetsGeometry margin; // Margin around the dashed line
  final EdgeInsetsGeometry padding; // Padding inside the dashed line

  const DashedLine({
    Key? key,
    this.dashWidth = 8.0,
    this.dashSpace = 4.0,
    this.height = 1.0,
    this.color = Colors.grey,
    this.margin = EdgeInsets.zero, // Default margin
    this.padding = EdgeInsets.zero, // Default padding
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin, // Apply margin
      padding: padding, // Apply padding
      child: CustomPaint(
        size: Size(double.infinity, height),
        painter: DashedLinePainter(dashWidth, dashSpace, color), // Pass color to painter
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final double dashWidth;
  final double dashSpace;
  final Color color; // Color of the dashed line

  DashedLinePainter(this.dashWidth, this.dashSpace, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color // Use the passed color
      ..strokeWidth = 1.0; // Line thickness

    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace; // Move to the next dash position
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
