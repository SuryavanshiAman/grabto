List<String> generateTimeSlots(String startTime, String endTime, int intervalInMinutes, DateTime selectedDate) {
  List<String> timeSlots = [];
  DateTime start = _parseTime(startTime, selectedDate);
  DateTime end = _parseTime(endTime, selectedDate).subtract(Duration(minutes: 1)); // Exclude end time by subtracting 1 minute
  DateTime now = DateTime.now();

  bool isToday = selectedDate.year == now.year && 
                 selectedDate.month == now.month && 
                 selectedDate.day == now.day;

  while (start.isBefore(end) || start.isAtSameMomentAs(end)) {
    // If the date is today, filter slots based on the current time
    if (!isToday || start.isAfter(now) || start.isAtSameMomentAs(now)) {
      String formattedTime = _formatTimeWithPeriod(start);
      timeSlots.add(formattedTime);
    }
    start = start.add(Duration(minutes: intervalInMinutes));
  }

  return timeSlots;
}

// Helper function to parse a time string to a DateTime object
DateTime _parseTime(String time, DateTime date) {
  final timeParts = time.split(' ');
  final hourMinute = timeParts[0].split(':');
  int hour = int.parse(hourMinute[0]);
  int minute = int.parse(hourMinute[1]);
  final period = timeParts[1];

  if (period == 'PM' && hour != 12) {
    hour += 12;
  } else if (period == 'AM' && hour == 12) {
    hour = 0;
  }

  return DateTime(date.year, date.month, date.day, hour, minute);
}

// Helper function to format DateTime to a readable time format with AM/PM
String _formatTimeWithPeriod(DateTime time) {
  int hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
  String period = time.hour >= 12 ? 'PM' : 'AM';
  String formattedTime = '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period';
  return formattedTime;
}

bool isBookingTimePassed(String bookingDate, String bookingTime) {
  try {
    // Convert the AM/PM time to 24-hour format
    final timeParts = bookingTime.split(' ');
    final isPM = timeParts[1].toLowerCase() == 'pm';
    final time = timeParts[0].split(':');
    int hour = int.parse(time[0]);
    final minute = int.parse(time[1]);

    if (isPM && hour != 12) {
      hour += 12; // Convert PM hours to 24-hour format
    } else if (!isPM && hour == 12) {
      hour = 0; // Handle midnight (12 AM)
    }

    // Combine the booking date and converted time
    DateTime bookingDateTime = DateTime.parse(
      "$bookingDate ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:00",
    );

    // Get the current date and time
    DateTime currentDateTime = DateTime.now();

    // Check if the booking time is in the past
    return currentDateTime.isAfter(bookingDateTime);
  } catch (e) {
    print("Error parsing date or time: $e");
    return false;
  }
}



