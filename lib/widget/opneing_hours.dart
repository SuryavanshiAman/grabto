import 'package:discount_deals/model/time_model.dart';
import 'package:discount_deals/widget/opening_hours_tile.dart';
import 'package:flutter/material.dart';

class OpeningHours extends StatefulWidget {
  List<TimeModel> timeList;
  List<TimeModel> updatedList;

  OpeningHours(this.timeList, this.updatedList);

  @override
  _OpeningHoursState createState() => _OpeningHoursState();
}

class _OpeningHoursState extends State<OpeningHours> {
  bool showMore = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.watch_later_outlined,
                size: 18,
              ),
              SizedBox(
                width: 5,
              ),
              OpeningHoursTile(
                day: widget.timeList.first.day,
                time: widget.timeList.first.operation_status != "Closing"
                    ? '${widget.timeList.first.start_time} - ${widget.timeList.first.end_time}'
                    : '${widget.timeList.first.operation_status}',
                color: widget.timeList.first.operation_status != "Closing"
                    ? Colors.grey
                    : Colors.red,
              ),
              Container(
                child: InkWell(
                  child: Visibility(
                    visible: false,
                    child: Icon(
                      showMore
                          ? Icons.keyboard_arrow_up_sharp
                          : Icons.keyboard_arrow_down_sharp,
                      size: 24,
                      color: Colors.blue,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      showMore = !showMore;
                    });
                  },
                ),
              ),
            ],
          ),
          if (showMore)
            Container(
              margin: EdgeInsets.only(left: 22),
              child: Column(
                children: List.generate(widget.updatedList.length, (index) {
                  final currentTime = widget.updatedList[index];
                  final nextTime = widget.updatedList[index];
                  return OpeningHoursTile(
                    day: currentTime.day,
                    time: currentTime.operation_status != "Closing"
                        ? '${currentTime.start_time} - ${nextTime.end_time}'
                        : '${currentTime.operation_status}',
                    color: currentTime.operation_status != "Closing"
                        ? Colors.grey
                        : Colors.red,
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}
