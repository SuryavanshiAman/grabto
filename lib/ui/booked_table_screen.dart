import 'package:discount_deals/theme/theme.dart';
import 'package:discount_deals/utils/dashed_line.dart';
import 'package:discount_deals/widget/coupon_card.dart';
import 'package:discount_deals/widget/offer_term_condtion.dart';
import 'package:discount_deals/widget/title_description_widget.dart';
import 'package:flutter/material.dart';
import 'package:discount_deals/model/terms_condition_model.dart';
import 'package:discount_deals/services/api_services.dart';
import 'package:discount_deals/model/pre_book_table_history.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:discount_deals/ui/table_paybill_screen.dart';
import 'package:discount_deals/utils/snackbar_helper.dart';
import 'package:discount_deals/utils/time_slot.dart';
import 'package:discount_deals/utils/snackbar_helper.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:io';


class BookedTableScreen extends StatefulWidget {
  String tableid;


  BookedTableScreen(this.tableid);

  @override
  State<BookedTableScreen> createState() => _BookedTableScreenState();
}

class _BookedTableScreenState extends State<BookedTableScreen> {
  List<TermConditionModel> termConditionList = [];
  bool isLoading = false;
  List<PreBookTableHistoryModel> prebookofferlistHistory = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchStoresTermCondition();
    SinglePreBookTableHistory("${widget.tableid}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundBg,

      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              child: CustomPaint(
                painter: GradientBackgroundPainter(),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 100,),
                      Container(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Check mark icon
                              ClipOval(
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade400,
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipOval( // Ensures the image is also circular
                                    child: Image.asset(
                                      "assets/images/grabto_logo_without_text.png",
                                      fit: BoxFit
                                          .cover, // Ensures the image covers the circular area
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 20),
                              // Text "Your table is booked!"
                              Text(
                                prebookofferlistHistory[0].table_status
                                    .toLowerCase() == "cancelled"
                                    ? "Your table is Cancelled!"
                                    : "Your table is booked!",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  // fontFamily: 'Cursive',
                                  color: Colors.red.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),

                      Container(
                        height: 295,
                        child: _buildOfferCard(prebookofferlistHistory),
                      ),


                      if(prebookofferlistHistory[0].table_status
                          .toLowerCase() != "cancelled" )
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // Space between the texts
                            children: [
                              Text(
                                'Can it make it to the restaurant? ',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // When the "Cancel booking" text is clicked, show the dialog
                                  _showCancelDialog(context,
                                      "${prebookofferlistHistory[0].id}");
                                },
                                child: Text(
                                  'Cancel booking',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: MyColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: 10,),
                      Divider( // Adds the horizontal line
                        color: Color(0xFF757575),
                        // Color of the line
                        thickness: 1.0,
                        // Thickness of the line
                        indent: 20.0,
                        // Space before the line starts (left side)
                        endIndent: 20.0, // Space after the line ends (right side)
                      ),

                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: OfferTermsWidget(termConditionList),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),



            Positioned(
              bottom: 20,
              right: 0,
              left: 0,

              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: _buildButton(
                    'Done',  Colors.red, Colors.white
                ),
              ),
            ),

            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                // Adjust opacity as needed
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      MyColors.primary,
                    ),
                    // Change the color
                    strokeWidth: 4,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> SinglePreBookTableHistory(String book_table_id) async {
    print('SinglePreBookTableHistory: book_table_id $book_table_id');

    setState(() {
      isLoading = true;
    });

    try {
      final body = {"book_table_id": "$book_table_id"};
      final response = await ApiServices.SinglePreBookTableHistory(body);
      print('SinglePreBookTableHistory: response $response');
      if (response != null) {
        setState(() {
          prebookofferlistHistory = response;
          isLoading = false; // Set isLoading to false when fetching ends
        });
      } else {
        setState(() {
          isLoading = false; // Set isLoading to false when fetching ends
        });
      }
    } catch (e) {
      print('SinglePreBookTableHistory: $e');
      setState(() {
        isLoading = false; // Set isLoading to false in case of error
      });
    }
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


  Widget _buildOfferCard(
      List<PreBookTableHistoryModel> prebookofferlistHistory) {
    return SizedBox(
      height: 390, // Adjust height based on card content
      child: PageView.builder(
        itemCount: prebookofferlistHistory.length,
        controller: PageController(viewportFraction: 1.0),
        // Controls card width
        itemBuilder: (context, index) {
          var offer = prebookofferlistHistory[index];

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Container(
                  height: 45,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  // width: double.infinity,
                  decoration: BoxDecoration(
                    color: MyColors.offerCardColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${offer.title}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  padding: EdgeInsets.all(12.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      left: BorderSide(color: MyColors.offerCardColor),
                      right: BorderSide(color: MyColors.offerCardColor),
                      bottom: BorderSide(color: MyColors.offerCardColor),
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Left side: Title and Description
                          Expanded(
                            flex: 2, // Takes up 50% of the width
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TitleDescriptionWidget(
                                title: offer.store_name,
                                description: offer.address,
                                titleFontSize: 16,
                                descriptionFontSize: 13,
                              ),
                            ),
                          ),

                          // Right side: Icons (Phone, Location)
                          Expanded(
                            flex: 1, // Takes up 50% of the width
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // Centers the icons horizontally
                              children: [
                                if (offer.mobile.isNotEmpty)
                                  GestureDetector(
                                    onTap: () {
                                      _makePhoneCall(offer.mobile);
                                    },
                                    child: _buildIcon(Icons.phone),
                                  ),
                                if (offer.map_link.isNotEmpty)
                                  GestureDetector(
                                    onTap: () {
                                      _launchMaps(context, offer.map_link);
                                    },
                                    child: _buildIcon(Icons.location_on),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      DashedLine(
                        color: Color(0xFF757575),
                        margin: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildRowWithIcon(
                                    icon: Icons.phone,
                                    text: "Number of guests: ${offer
                                        .no_of_guest}",
                                  ),
                                  SizedBox(height: 5),
                                  _buildRowWithIcon(
                                    icon: Icons.calendar_month,
                                    text: "${offer.booking_date} at ${offer
                                        .booking_time}",
                                  ),

                                ],
                              ),
                            ],
                          ),
                          TitleDescriptionWidget(
                            title: 'Status',
                            description: offer.table_status.toLowerCase() ==
                                "cancelled" ? "Canceled" : offer.table_status,
                            titleFontSize: 14,
                            descriptionFontSize: 12,
                            titleFontWeight: FontWeight.w400,

                            descriptionFontWeight: FontWeight.bold,
                            descriptionColor: offer.table_status
                                .toLowerCase() == "cancelled"
                                ? Colors.red
                                : MyColors.offerCardColor,
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Expanded(
                          //   child: GestureDetector(
                          //     onTap: () {
                          //       Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //           builder: (context) => BookedTableScreen(),
                          //         ),
                          //       );
                          //     },
                          //     child: _buildButton(
                          //       'View details',
                          //       MyColors.offerCardColor,
                          //       Colors.white,
                          //     ),
                          //   ),
                          // ),
                          // Expanded(
                          //   child: _buildButton(
                          //     'Pay bill',
                          //    checkDateTimeStatus(offer.booking_date, offer.booking_time) ?  MyColors.offerCardColor: Colors.grey.shade300,
                          //     checkDateTimeStatus(offer.booking_date, offer.booking_time) ?  MyColors.whiteBG:Colors.grey ,
                          //   ),
                          // ),
                          if(prebookofferlistHistory[0].table_status
                              .toLowerCase() == "cancelled")
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: _buildButton(
                                  'Cancelled',  Colors.red, Colors.white
                                  ),
                            ),
                          ),

                          if(prebookofferlistHistory[0].table_status
                              .toLowerCase() != "cancelled")
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (isBookingTimePassed(
                                      offer.booking_date, offer.booking_time)) {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TablePaybillScreen(
                                                  offer, offer.store_name,
                                                  offer.address)),
                                    );
                                  }
                                },
                                child: _buildButton(
                                    'Pay bill', isBookingTimePassed(
                                    offer.booking_date, offer.booking_time)
                                    ? Colors.red
                                    : Colors.grey.shade300, isBookingTimePassed(
                                    offer.booking_date, offer.booking_time)
                                    ? Colors.white
                                    : Colors.grey),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 15),
                      // Container(
                      //   width: double.infinity, // Ensures the container takes full width
                      //   padding: EdgeInsets.all(10.0),  // Optional padding for spacing
                      //   decoration: BoxDecoration(
                      //     color: Colors.green.shade50,  // Background color of the container
                      //     borderRadius: BorderRadius.circular(10.0),  // Rounded corners
                      //   ),
                      //   child: Text(
                      //     'You may have to wait for your table to get ready!',
                      //     textAlign: TextAlign.center,  // Center the text
                      //     style: TextStyle(
                      //       fontSize: 12.0,  // Font size for the text
                      //       color: Colors.green,  // Text color
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                SizedBox(height: 15),

              ],
            ),
          );
        },
      ),
    );
  }

  // Function to show the custom dialog
  void _showCancelDialog(BuildContext context, String history_id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // Rounded corners
          ),
          elevation: 10.0,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Are you sure you want to cancel your booking?',
                  style: TextStyle(
                      fontSize: 19.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // Align buttons in the center
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          // Optionally, perform cancellation logic here
                          print('Booking Cancelled!');
                          BookPreCancel(context, "${history_id}");
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: MyColors.primaryColorLight,
                          // Custom color
                          padding: EdgeInsets.symmetric(horizontal: 20,
                              vertical: 10),
                        ),
                        child: Text(
                          'Yes',
                          style: TextStyle(color: MyColors.primaryColor),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: MyColors.primaryColor,
                          // Custom background color
                          padding: EdgeInsets.symmetric(horizontal: 20,
                              vertical: 10),
                        ),
                        child: Text(
                          "No",
                          style: TextStyle(color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ), // Space between the buttons

                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> BookPreCancel(BuildContext context,
      String history_id) async {
    print(
        'BookPreCancel: history_id:$history_id');
    setState(() {
      isLoading = true;
    });
    try {
      final body = {
        "history_id": "$history_id"
      };
      final response = await ApiServices.BookPreCancel(body);
      print('BookPreCancel response: $response');
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        String res = response['res'];
        String msg = response['msg'];

        showSuccessMessage(context, message: "$msg");
        Navigator.of(context).pop();
        SinglePreBookTableHistory("${widget.tableid}");

        setState(() {
          isLoading = false;
        });
      } else if (response != null) {
        String res = response['res'];
        String msg = response['msg'];
        // Handle unsuccessful response or missing 'res' field
        showErrorMessage(context, message: "$msg");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  bool checkDateTimeStatus(String date, String time) {
    try {
      String dateTimeStr = "$date $time";
      DateFormat format = DateFormat("yyyy-MM-dd hh:mm a");
      DateTime givenDateTime = format.parse(dateTimeStr);
      DateTime currentDateTime = DateTime.now();
      return currentDateTime.isAfter(givenDateTime);
    } catch (e) {
      print("Error parsing date and time: $e");
      return false;
    }
  }

  _makePhoneCall(String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      print('Error: Phone number is null or empty');
      return;
    }
    final url = 'tel:$phoneNumber';
    print(
        'Phone number: $phoneNumber'); // Print the phone number to the console
    try {
      await launch('$url');
    } catch (e) {
      bool checkDateTimeStatus(String date, String time) {
        try {
          // Date aur time ko combine kar ke ek full datetime string banate hain
          String dateTimeStr = "$date $time";

          // Diye gaye format ke saath ek DateFormat object banate hain
          DateFormat format = DateFormat("yyyy-MM-dd hh:mm a");

          // Diye gaye dateTime string ko DateTime object mein convert karte hain
          DateTime givenDateTime = format.parse(dateTimeStr);

          // Current dateTime lete hain
          DateTime currentDateTime = DateTime.now();

          // Agar current dateTime given dateTime se badh kar hai, to true return karega
          return currentDateTime.isAfter(givenDateTime);
        } catch (e) {
          print("Error parsing date and time: $e");
          return false;
        }
      }
      print('Error launching phone call: $e');
      // Handle the error gracefully, such as displaying an error message to the user
    }
  }

  _launchMaps(BuildContext context, storeMap_link) async {
    // Use the provided storeMap_link if available
    String url = storeMap_link;

    // Check if storeMap_link is empty or null
    if (storeMap_link == null || storeMap_link.isEmpty) {
      showErrorMessage(context, message: "Map link not available");
      return;
    }

    // Check if any of the URLs can be launched
    if (await canLaunch(url)) {
      print('Launching map application');
      await launch(url);
    }
    // else if (await canLaunch(googleUrl)) {
    //   print('Launching Google Maps');
    //   await launch(googleUrl);
    // }
    // else if (await canLaunch(appleUrl)) {
    //   print('Launching Apple Maps');
    //   await launch(appleUrl);
    // }
    else {
      throw 'Could not launch map application';
    }
  }


  Widget _buildIcon(IconData icon) {
    return Container(
      margin: EdgeInsets.only(left: 8.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF6200EE),
      ),
      padding: EdgeInsets.all(8.0),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildRowWithIcon({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, color: MyColors.offerCardColor, size: 18.0),
        SizedBox(width: 8.0),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildButton(String text, Color backgroundColor, Color textColor) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
            fontSize: 12,
          ),
        ),
      ),
    );
  }


}

class GradientBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gradient = LinearGradient(
        colors: [
          Colors.green.shade100,
          Colors.green.shade200,
          MyColors.backgroundBg
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter
      // center: Alignment.center,
      // radius: 0.8,
    );

    final paint = Paint()
      ..shader = gradient.createShader(
          Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
