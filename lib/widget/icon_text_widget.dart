
import 'package:flutter/material.dart';

import '../theme/theme.dart';

class IconTextWidget extends StatelessWidget {
  final IconData iconData;
  final String text;

  IconTextWidget({required this.iconData, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: Icon(iconData, size: 14, color: MyColors.primaryColor),
          ), // Icon widget
          SizedBox(width: 10), // SizedBox for spacing between icon and text
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow
                  .visible, // Change to TextOverflow.visible to allow wrapping
            ),
          ), // Text widget wrapped in Flexible
        ],
      ),
    );
  }
}