import 'package:flutter/material.dart';

class TitleDescriptionWidget extends StatelessWidget {
  final String title;
  final String description;
  final double titleFontSize;
  final double descriptionFontSize;
  final Color? titleColor; // Optional color for title
  final Color? descriptionColor; // Optional color for description
  final FontWeight? titleFontWeight; // Optional font weight for title
  final FontWeight? descriptionFontWeight; // Optional font weight for description

  const TitleDescriptionWidget({
    Key? key,
    required this.title,
    required this.description,
    this.titleFontSize = 20.0,
    this.descriptionFontSize = 14.0,
    this.titleColor = Colors.black, // Default color for title
    this.descriptionColor = Colors.grey, // Default color for description
    this.titleFontWeight = FontWeight.normal, // Default font weight for title
    this.descriptionFontWeight = FontWeight.normal, // Default font weight for description
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: titleFontSize,
            color: titleColor, // Use title color parameter
            fontWeight: titleFontWeight, // Use title font weight parameter
          ),
        ),
        Text(
          description,
          style: TextStyle(
            fontSize: descriptionFontSize,
            color: descriptionColor, // Use description color parameter
            fontWeight: descriptionFontWeight, // Use description font weight parameter
          ),
          textAlign: TextAlign.start,
          maxLines: 1,
        ),
      ],
    );
  }
}
