import 'package:discount_deals/model/pre_book_table_model.dart';
import 'package:discount_deals/services/api_services.dart';
import 'package:discount_deals/theme/theme.dart';
import 'package:discount_deals/ui/confirm_booking_screen.dart';
import 'package:discount_deals/utils/time_slot.dart';
import 'package:discount_deals/widget/offer_term_condtion.dart';
import 'package:discount_deals/model/terms_condition_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookTableScreen extends StatefulWidget {
  String startTime;
  String endTime;
  String storeName;
  String store_id;

  BookTableScreen(this.startTime, this.endTime, this.storeName, this.store_id);

  @override
  _BookTableScreenState createState() => _BookTableScreenState();
}

class _BookTableScreenState extends State<BookTableScreen> {
  ScrollController _scrollController = ScrollController();
  int _selectedGuestNumber = 1;
  DateTime _selectedDate = DateTime.now();
  bool dataSelected=false;
  bool isDinnerTimeSlotsVisible = false,
      isLunchTimeSlotsVisible = false; // Track visibility of time slots

  int intervalInMinutes = 30;
  String startLunch = "";
  String endLunch = "06:00 PM";
  late List<String> timeSlotsLunch = [];
  String startDinner = "06:00 PM";
  String endDinner = "";
  late List<String> timeSlotsDinner = [];
  String? selectedTimeSlot, timetype; // Track the single selected time slot
  List<PreBookTable> prebookofferlist = [];
  bool isLoading = true;
  PreBookTable? selectedPreBookOffer;
  List<TermConditionModel> termConditionList = [];

  void _updateSelectedDate(DateTime date) {
    setState(() {
      _selectedDate = date;
      // Format the date to "yyyy-MM-dd" format
    });
    timeSlotsLunch = generateTimeSlots(
        startLunch, endLunch, intervalInMinutes, _selectedDate);
    timeSlotsDinner =
        generateTimeSlots(
            startDinner, endDinner, intervalInMinutes, _selectedDate);
    checkTimeSlotsVisibility(_selectedDate);
  }

  void _updateSelectedNumber(int number) {
    setState(() {
      _selectedGuestNumber = number;
    });
  }

  void toggleTimeSlotsVisibility() {
    setState(() {
      isDinnerTimeSlotsVisible = !isDinnerTimeSlotsVisible; // Toggle visibility
    });
  }

  void toggleLunchTimeSlotsVisibility() {
    setState(() {
      isLunchTimeSlotsVisible = !isLunchTimeSlotsVisible; // Toggle visibility
    });
  }

  // void checkTimeSlotsVisibility(DateTime selectedDate) {
  //   final now = DateTime.now();
  //   print(
  //       'checkTimeSlotsVisibility Current Time: ${DateFormat.jm().format(now)}');

  //   // Format the current time for comparison
  //   String timeToCheck = DateFormat.jm().format(now);
  //   print('checkTimeSlotsVisibility Time to Check: $timeToCheck');

  //   bool isTimeInRange(String time, String start, String end) {
  //     // Handle cases where the end time is on the next day
  //     if (end.compareTo(start) < 0) {
  //       // When the end time is less than the start time, it indicates it goes past midnight
  //       print(
  //           'checkTimeSlotsVisibility End time goes past midnight. Checking: $time against start: $start and end: $end');
  //       return (time.compareTo(start) >= 0 || time.compareTo(end) < 0);
  //     } else {
  //       // Normal case, both times are on the same day
  //       print(
  //           'checkTimeSlotsVisibility Normal case. Checking: $time against start: $start and end: $end');
  //       return (time.compareTo(start) >= 0 && time.compareTo(end) < 0);
  //     }
  //   }

  //   // Check lunch and dinner visibility
  //   isLunchTimeSlotsVisible = !isTimeInRange(timeToCheck, startLunch, endLunch);
  //   isDinnerTimeSlotsVisible =
  //       !isTimeInRange(timeToCheck, startDinner, endDinner);

  //   // Log the results of the visibility checks
  //   print(
  //       'checkTimeSlotsVisibility Lunch Time Slots Visible: $isLunchTimeSlotsVisible');
  //   print(
  //       'checkTimeSlotsVisibility Dinner Time Slots Visible: $isDinnerTimeSlotsVisible');
  // }
  void checkTimeSlotsVisibility(DateTime selectedDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));

    print('checkTimeSlotsVisibility Current Time: ${DateFormat.jm().format(
        now)}');

    // Format the current time for comparison
    String timeToCheck = DateFormat.jm().format(now);
    print('checkTimeSlotsVisibility Time to Check: $timeToCheck');

    bool isTimeInRange(String time, String start, String end) {
      // Handle cases where the end time is on the next day
      if (end.compareTo(start) < 0) {
        // When the end time is less than the start time, it indicates it goes past midnight
        print(
            'checkTimeSlotsVisibility End time goes past midnight. Checking: $time against start: $start and end: $end');
        return (time.compareTo(start) >= 0 || time.compareTo(end) < 0);
      } else {
        // Normal case, both times are on the same day
        print(
            'checkTimeSlotsVisibility Normal case. Checking: $time against start: $start and end: $end');
        return (time.compareTo(start) >= 0 && time.compareTo(end) < 0);
      }
    }

    // Check if selectedDate is today or tomorrow
    if (selectedDate.isAtSameMomentAs(today)) {
      // For today, check time range
      isLunchTimeSlotsVisible =
      !isTimeInRange(timeToCheck, startLunch, endLunch);
      isDinnerTimeSlotsVisible =
      !isTimeInRange(timeToCheck, startDinner, endDinner);
    } else {
      // Default case for other dates (if any)
      isLunchTimeSlotsVisible = true;
      isDinnerTimeSlotsVisible = false;
    }

    // Log the results of the visibility checks
    print(
        'checkTimeSlotsVisibility Lunch Time Slots Visible: $isLunchTimeSlotsVisible');
    print(
        'checkTimeSlotsVisibility Dinner Time Slots Visible: $isDinnerTimeSlotsVisible');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startLunch = widget.startTime ?? "10:00 AM";
    endDinner = widget.endTime ?? "10:00 PM";


    DateTime now = DateTime.now();

    // Dinner start time ko parse karna DateTime object mein
    DateTime endDinnerTime = DateFormat("hh:mm a").parse(endDinner);

    // Us time ko current date ke saath set karna
    endDinnerTime = DateTime(
        now.year, now.month, now.day, endDinnerTime.hour, endDinnerTime.minute);

    // Agar current time start dinner time se zyada hai, toh selected date ko next day set karna
    if (now.isAfter(endDinnerTime)) {
      _selectedDate = DateTime(now.year, now.month, now.day + 1); // Next day
    } else {
      _selectedDate = DateTime(now.year, now.month, now.day); // Aaj ki date
    }

    prebookoffer(widget.store_id);
    print("😋😋😋😋${widget.store_id}");
    fetchStoresTermCondition();
    checkTimeSlotsVisibility(_selectedDate);

    timeSlotsLunch = generateTimeSlots(
        startLunch, endLunch, intervalInMinutes, _selectedDate);
    timeSlotsDinner =
        generateTimeSlots(
            startDinner, endDinner, intervalInMinutes, _selectedDate);
  }

  void selectTimeSlot(String timeSlot, String type) {
    setState(() {
      selectedTimeSlot = timeSlot; // Update the selected time slot
      timetype = type; // Update the selected time slot

    });
    _scrollToBottom();
  }
  void _scrollToBottom() {
    setState(() {
      dataSelected=true;
    });
    // Check if the controller has clients (is attached to the scrollable view)
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent, // Scroll to the bottom
        duration: Duration(milliseconds: 300), // Animation duration
        curve: Curves.easeInOut, // Optional easing curve
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundBg,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            SizedBox(width: 0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Book Table',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${widget.storeName}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: MyColors.textColor,
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: MyColors.backgroundBg,
      ),
      body:
      SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: MyColors.whiteBG,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Text(
                          "Number of Guests",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(30, (index) {
                            int guestNumber = index + 1;
                            double leftMargin = index == 0 ? 16 : 4;
                            double rightMargin = index == 29 ? 16 : 4;
                            return GestureDetector(
                              onTap: () => _updateSelectedNumber(guestNumber),
                              child: Container(
                                width: 40,
                                height: 40,
                                margin: EdgeInsets.fromLTRB(
                                    leftMargin, 0, rightMargin, 0),
                                decoration: BoxDecoration(
                                  color: _selectedGuestNumber == guestNumber
                                      ? MyColors.primaryColor2
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _selectedGuestNumber == guestNumber
                                        ? MyColors.primary
                                        : Colors.grey,
                                    width: 0.8,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  guestNumber.toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: _selectedGuestNumber == guestNumber
                                        ? MyColors.primary
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                color: MyColors.whiteBG,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                          child: Text(
                            'Select date?',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(30, (index) {
                              String endTime = "11:19 PM";
                              DateTime now = DateTime.now();
                              DateTime todayEndTime = DateFormat("hh:mm a")
                                  .parse(endTime);

                              todayEndTime = DateTime(
                                now.year,
                                now.month,
                                now.day,
                                todayEndTime.hour,
                                todayEndTime.minute,
                              );

                              // Calculate the date for the given index
                              DateTime date = DateTime.now().add(
                                  Duration(days: index));

                              // Skip today's widget if current time exceeds end time
                              if (index == 0 &&
                                  DateTime.now().isAfter(todayEndTime)) {
                                return SizedBox(
                                  width: 10,); // Return an empty widget instead of null
                              }


                              String dateString =
                              DateFormat('d MMM').format(date);
                              String dayString = DateFormat('EEE').format(date);

                              double leftMargin = index == 0 ? 16 : 4;
                              double rightMargin = index == 29 ? 16 : 4;

                              return GestureDetector(
                                onTap: () => _updateSelectedDate(date),
                                child: Container(
                                  width: 65,
                                  height: 75,
                                  margin: EdgeInsets.fromLTRB(
                                      leftMargin, 0, rightMargin, 0),
                                  decoration: BoxDecoration(
                                    color: _selectedDate.year == date.year &&
                                        _selectedDate.month == date.month &&
                                        _selectedDate.day == date.day
                                        ? MyColors.primaryColor2
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: _selectedDate.year == date.year &&
                                          _selectedDate.month ==
                                              date.month &&
                                          _selectedDate.day == date.day
                                          ? MyColors.primary
                                          : Colors.grey,
                                      width: 0.6,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        dayString,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: _selectedDate.year ==
                                              date.year &&
                                              _selectedDate.month ==
                                                  date.month &&
                                              _selectedDate.day == date.day
                                              ? MyColors.primary
                                              : Colors.black,
                                        ),
                                      ),
                                      Text(
                                        dateString,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: _selectedDate.year ==
                                              date.year &&
                                              _selectedDate.month ==
                                                  date.month &&
                                              _selectedDate.day == date.day
                                              ? MyColors.primary
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 16, bottom: 16),
                          child: Text(
                            'Select the time of day to see the offers',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        if (timeSlotsLunch.isNotEmpty)
                          Container(
                            margin: EdgeInsets.only(
                                left: 16, right: 16, top: 0, bottom: 16),
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: Colors.grey, width: 1.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 10, bottom: 26),
                            child: Column(
                              children: [
                                Center(
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/lunch.png',
                                            width: 40,
                                            height: 40,
                                            // color: const Color.fromARGB(255, 250, 167, 0), // Optional: Apply tint color
                                          ),
                                          SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Lunch', // Title
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                timeSlotsLunch.isNotEmpty
                                                    ? '${timeSlotsLunch
                                                    .first} to $endLunch'
                                                    : "$startLunch to $endLunch",
                                                // Time
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: toggleLunchTimeSlotsVisibility,
                                        // Toggle lunch time slots on click
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                            border:
                                            Border.all(color: Colors.grey),
                                          ),
                                          child: Icon(
                                            isLunchTimeSlotsVisible
                                                ? Icons
                                                .keyboard_arrow_up_outlined
                                                : Icons
                                                .keyboard_arrow_down_outlined,
                                            size: 20,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isLunchTimeSlotsVisible) // Show lunch time slots if visible
                                  SizedBox(height: 20),
                                if (isLunchTimeSlotsVisible)
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Wrap(
                                      spacing: 10.0,
                                      runSpacing: 10.0,
                                      children: timeSlotsLunch
                                          .map((slot) =>
                                          TimeSlotCard(
                                            timeSlot: slot,
                                            isSelected:
                                            selectedTimeSlot == slot,
                                            onTap: () =>
                                                selectTimeSlot(slot, "Lunch"),
                                          ))
                                          .toList(),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        if (timeSlotsDinner.isNotEmpty)
                          Container(
                            margin: EdgeInsets.only(
                                left: 16, right: 16, top: 0, bottom: 16),
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: Colors.grey, width: 1.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 10, bottom: 26),
                            child: Column(
                              children: [
                                Center(
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/dinner.png',
                                            width: 40,
                                            height: 40,
                                            // color: const Color.fromARGB(255, 250, 167, 0), // Optional: Apply tint color
                                          ),

                                          SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Dinner', // Title
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                timeSlotsDinner.isNotEmpty
                                                    ? '${timeSlotsDinner
                                                    .first} to $endDinner'
                                                    : "$startDinner to $endDinner",
                                                // Time
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: toggleTimeSlotsVisibility,
                                        // Toggle time slots on click
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                            border:
                                            Border.all(color: Colors.grey),
                                          ),
                                          child: Icon(
                                            isDinnerTimeSlotsVisible
                                                ? Icons
                                                .keyboard_arrow_up_outlined
                                                : Icons
                                                .keyboard_arrow_down_outlined,
                                            size: 20,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isDinnerTimeSlotsVisible) // Show time slots if visible
                                  SizedBox(height: 20),
                                if (isDinnerTimeSlotsVisible)
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Wrap(
                                      spacing: 10.0,
                                      runSpacing: 10.0,
                                      children: timeSlotsDinner
                                          .map((slot) =>
                                          TimeSlotCard(
                                            timeSlot: slot,
                                            isSelected:
                                            selectedTimeSlot == slot,
                                            onTap: () =>
                                                selectTimeSlot(slot, "Lunch"),
                                          ))
                                          .toList(),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ]),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              if(dataSelected)
              Card(
                color: MyColors.whiteBG,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                          child: Row(
                            children: [
                              ClipRect(
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  child: Image.asset(
                                    'assets/images/exclusive_img.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Select offer to proceed?',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        PrebookOfferListWidget(
                          storeId: widget.store_id,
                          prebookofferlist: prebookofferlist,
                          onSelectedItemChanged: (selectedItem) {
                            setState(() {
                              selectedPreBookOffer = selectedItem;
                            });
                            print(
                                "Selected Item: ${selectedPreBookOffer
                                    ?.title}");
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 0, 10),
                          child: Text(
                            'Coupon & additional offers available during bill payment',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: MyColors.txtDescColor2),
                          ),
                        ),
                      ]),
                ),
              ),
              if(dataSelected)
              SizedBox(
                height: 10,
              ),
              if(dataSelected)
              OfferTermsWidget(
                  termConditionList
              ),
              SizedBox(height: 50,),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        decoration: BoxDecoration(
          color: Colors.white, // Background color of the Container
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: ElevatedButton(
            onPressed:
            (selectedTimeSlot != null && selectedPreBookOffer != null)
                ? () {
              String guest = "$_selectedGuestNumber";
              String visitingdate =
              DateFormat('yyyy-MM-dd').format(_selectedDate);
              String visitingtime = selectedTimeSlot ?? '';
              String timetype2 = timetype ?? '';

              print(
                "Proceed clicked - timetype: $timetype2,  Guest: $guest, Date: $visitingdate, Time: $visitingtime, Offer ID: ${selectedPreBookOffer!
                    .id}",
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ConfirmBookingScreen(
                            guest,
                            visitingdate,
                            visitingtime,
                            timetype!,
                            selectedPreBookOffer!)),
              );
            }
                : null, // Disable button if either is null
            style: ElevatedButton.styleFrom(
              backgroundColor:
              (selectedTimeSlot != null && selectedPreBookOffer != null)
                  ? MyColors.primary // Enabled color
                  : Colors.grey, // Disabled color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Proceed",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> fetchStoresTermCondition() async {
    try {
      final response = await ApiServices.api_store_termconditions();
      if (response != null) {
        setState(() {
          termConditionList = response;
        });
      }
    } catch (e) {
      print('fetchStores: $e');
    }
  }


  Future<void> prebookoffer(String store_id) async {
    print('prebookoffer: store_id $store_id');
    try {
      final body = {"store_id": "$store_id"};
      final response = await ApiServices.PreBookOffer(body);
      print('prebookoffer: response $response');
      if (response != null) {
        setState(() {
          prebookofferlist = response;
          isLoading = false; // Set isLoading to false when fetching ends
        });
      } else {
        setState(() {
          isLoading = false; // Set isLoading to false when fetching ends
        });
      }
    } catch (e) {
      print('prebookoffer: $e');
      setState(() {
        isLoading = false; // Set isLoading to false in case of error
      });
    }
  }
}

class TimeSlotCard extends StatelessWidget {
  final String timeSlot;
  final bool isSelected;
  final VoidCallback onTap;

  TimeSlotCard({
    required this.timeSlot,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isSelected
              ? MyColors.primaryColor.withOpacity(0.2)
              : Colors.white,
          border: Border.all(
              color: isSelected ? MyColors.primaryColor : Colors.grey),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              timeSlot,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: isSelected ? MyColors.primaryColor : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingInfoCard extends StatelessWidget {
  final String title;
  final String bookingFee;
  final String availableSeats;

  const BookingInfoCard({
    Key? key,
    required this.title,
    required this.bookingFee,
    required this.availableSeats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title with text wrapping
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 5), // Spacing between title and booking fee
        // Booking fee with text wrapping
        Text(
          'Booking Fee: ₹$bookingFee per Guest',
          style: TextStyle(
            fontSize: 12,
          ),
        ),
        SizedBox(height: 5), // Spacing between booking fee and available seats
        // Available seats text with text wrapping
        // Text(
        //   '$availableSeats seat${int.tryParse(availableSeats) != 1
        //       ? 's'
        //       : ''} left',
        //   // Pluralization for available seats
        //   style: TextStyle(
        //     fontSize: 14,
        //     color: Colors.green,
        //     fontWeight: FontWeight.bold,
        //   ),
        // )
        Text(
          '${(int.tryParse(availableSeats) ?? 0) < 0 ? 0 : int.tryParse(availableSeats)} seat${(int.tryParse(availableSeats) ?? 0) != 1 ? 's' : ''} left',
          style: TextStyle(
            fontSize: 14,
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}

class PrebookOfferListWidget extends StatefulWidget {
  final String storeId;
  final List<PreBookTable> prebookofferlist;
  final ValueChanged<PreBookTable?> onSelectedItemChanged; // Callback function

  PrebookOfferListWidget({
    required this.storeId,
    required this.prebookofferlist,
    required this.onSelectedItemChanged,
  });

  @override
  _PrebookOfferListWidgetState createState() => _PrebookOfferListWidgetState();
}

class _PrebookOfferListWidgetState extends State<PrebookOfferListWidget> {
  int? selectedItemId;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          widget.prebookofferlist.length,
              (index) =>
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      int id = widget.prebookofferlist[index].id;
                      if (selectedItemId == id) {
                        selectedItemId = null;
                        widget.onSelectedItemChanged(
                            null); // Notify deselection
                      } else {
                        selectedItemId = id;
                        widget.onSelectedItemChanged(
                            widget.prebookofferlist[index]); // Notify selection
                      }
                    });
                  },
                  child: _buildPrebookOfferWidget(
                    context,
                    widget.prebookofferlist[index],
                    selectedItemId == widget.prebookofferlist[index].id,
                  ),
                ),
              ),
        ),
      ),
    );
  }

  Widget _buildPrebookOfferWidget(BuildContext context,
      PreBookTable prebooktable, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16),
      decoration: BoxDecoration(
        color:
        isSelected ? MyColors.primaryColor.withOpacity(0.2) : Colors.white,
        border: Border.all(
          color: isSelected ? MyColors.primaryColor : Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Radio<int>(
            value: prebooktable.id,
            groupValue: selectedItemId,
            onChanged: (int? value) {
              setState(() {
                selectedItemId = value;
                widget.onSelectedItemChanged(widget.prebookofferlist
                    .firstWhere((item) => item.id == value));
              });
            },
            activeColor: MyColors.primary,
          ),
          SizedBox(width: 10),
          Expanded(
            child: BookingInfoCard(
              title: prebooktable.title,
              bookingFee: prebooktable.booking_fee,
              availableSeats: prebooktable.available_seat,
            ),
          ),
        ],
      ),
    );
  }
}
