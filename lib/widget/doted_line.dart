import 'package:flutter/material.dart';

class DottedLine extends StatelessWidget {
  final double height;
  final double width;
  final Color color;
  final double dashWidth;
  final double dashSpacing;

  DottedLine({
    this.height = 1.0,
    this.width = double.infinity,
    this.color = Colors.black,
    this.dashWidth = 5.0,
    this.dashSpacing = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final boxWidth = constraints.constrainWidth();
          final dashHeight = height;
          final dashCount = (boxWidth / (dashWidth + dashSpacing)).floor();
          return Flex(
            children: List.generate(dashCount, (_) {
              return SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: color),
                ),
              );
            }),
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
          );
        },
      ),
    );
  }
}
