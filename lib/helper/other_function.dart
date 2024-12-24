
class OtherFunction{

  static String formatDateString(String dateString) {
    // Split the date and time
    List<String> parts = dateString.split(' ');

    // Extract date part
    String datePart = parts[0];

    // Split date into year, month, and day
    List<String> dateParts = datePart.split('-');

    // Get day, month, and year
    int day = int.parse(dateParts[2]);
    int month = int.parse(dateParts[1]);
    int year = int.parse(dateParts[0]);

    // Convert month number to month name
    List<String> months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    String monthName = months[month - 1];

    // Return formatted date string
    return '$day $monthName $year';
  }
}