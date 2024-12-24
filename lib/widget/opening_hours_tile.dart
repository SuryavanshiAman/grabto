import 'package:flutter/material.dart';

class OpeningHoursTile extends StatelessWidget {
  final String day;
  final String time;
  Color color;

  OpeningHoursTile({required this.day, required this.time,required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 0, right: 5, top: 5, bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            child: Text(
              '$day :-      ',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 4),
          Text(
            time,
            style: TextStyle(
              fontSize: 14,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}