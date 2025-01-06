import 'package:cached_network_image/cached_network_image.dart';
import 'package:discount_deals/helper/shared_pref.dart';
import 'package:discount_deals/model/pre_book_table_history.dart';
import 'package:discount_deals/model/user_model.dart';
import 'package:discount_deals/services/api.dart';
import 'package:discount_deals/services/api_services.dart';
import 'package:discount_deals/theme/theme.dart';
import 'package:discount_deals/widget/doted_line.dart';
import 'package:flutter/material.dart';
import 'package:discount_deals/model/regular_offer_history.dart';
import 'package:intl/intl.dart';
import 'package:discount_deals/model/book_table_pay_bill_history.dart';


class TransactionScreen extends StatefulWidget {
  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: "Book" and "Pay Bill"
      child: Scaffold(
        backgroundColor: MyColors.backgroundBg,
        appBar: AppBar(
          backgroundColor: MyColors.backgroundBg,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios)),
          centerTitle: true,
          title: Text(
            "Transaction",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Booking Table'),
              Tab(text: 'Pay Bill'),
            ],
            padding: EdgeInsets.all(10),
            // indicator: BoxDecoration(
            //   color: MyColors.primaryColor, // Color of the indicator
            //   borderRadius: BorderRadius.circular(50.0), // Rounded corners
            // ),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: MyColors.primaryColor,
            // Set the indicator color
            labelColor: MyColors.primaryColor,
            // Set the color of the active tab text
            unselectedLabelColor:
            Colors.grey, // Set the color of the inactive tab text
          ),
        ),
        body: TabBarView(
          children: [
            BookTab(), // Content of the "Book" tab
            PayBillTab(), // Content of the "Pay Bill" tab
          ],
        ),
      ),
    );
  }


}

class BookTab extends StatefulWidget {

  @override
  _BookTabState createState() => _BookTabState();
}

class _BookTabState extends State<BookTab> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool isLoading = true;
  List<PreBookTableHistoryModel> prebookofferlistHistory = [];
  int userId = 0;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    // Start the animation when the widget is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
    getUserDetails();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // Show loading indicator when data is loading
      return Center(
        child: CircularProgressIndicator(
          color: MyColors.primaryColor,
        ),
      );
    } else if (prebookofferlistHistory.isEmpty) {
      // Show "No Data" widget when the list is empty
      return Center(
        child: _buildNoHistoryFound(),
      );
    } else {
      // Show list when data is available
      return FadeTransition(
        opacity: _animation,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: prebookofferlistHistory.length,
            itemBuilder: (context, index) {
              return _buildOrderCard(prebookofferlistHistory[index]);
            },
          ),
        ),
      );
    }
  }

  Future<void> getUserDetails() async {
    // SharedPref sharedPref=new SharedPref();
    // userName = (await SharedPref.getUser()).name;
    UserModel n = await SharedPref.getUser();
    print("getUserDetails: " + n.name);
    setState(() {
      userId = n.id;
    });
    prebookofferHistory("${userId}");
  }


  Future<void> prebookofferHistory(String user_id) async {
    print('BookPreOfferHistory: user_id $user_id');

    setState(() {
      isLoading = true;
    });

    try {
      final body = {"user_id": "$user_id"};
      final response = await ApiServices.BookPreOfferHistory(body);
      print('BookPreOfferHistory: response $response');
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
      print('BookPreOfferHistory: $e');
      setState(() {
        isLoading = false; // Set isLoading to false in case of error
      });
    }
  }

  Widget _buildNoHistoryFound() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 200,
          height: 180,
          child: Image.asset('assets/vector/blank.png'),
        ),
        SizedBox(height: 16),
        Text(
          'No Data',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderCard(PreBookTableHistoryModel preBookTableHistory) {
    return Card(
      color: Color.fromARGB(255, 255, 255, 255),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        preBookTableHistory.store_name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('Offer: ${preBookTableHistory.title}'),
                      Text("Table booked for ${preBookTableHistory
                          .booking_date}, ${preBookTableHistory
                          .booking_time}, ${preBookTableHistory
                          .no_of_guest} Guest's"),
                      SizedBox(height: 16),
                      Text(
                        "Bill Details",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${preBookTableHistory.no_of_guest} Guest's: ",
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            "₹${preBookTableHistory.amount}",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text(
                      //       "Discount price: ",
                      //       style: TextStyle(fontSize: 12),
                      //     ),
                      //     Text(
                      //       "₹10",
                      //       style: TextStyle(fontSize: 12),
                      //     ),
                      //   ],
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "GST 18% : ",
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            "₹${preBookTableHistory.gst_amount}",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      DottedLine(
                        height: 2,
                        color: Colors.black,
                        width: double.infinity,
                        dashWidth: 6.0,
                        dashSpacing: 6.0,
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Price: ',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "₹${preBookTableHistory.pay_amount}",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Image
                SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    Text(
                      "${preBookTableHistory.table_status}",
                      style: TextStyle(
                          color: MyColors.offerCardColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: preBookTableHistory.logo,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Container(
                                color: Colors.grey.shade300,
                                child: Center(
                                    child: CircularProgressIndicator()),
                              ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),

                  ],
                ),
              ],
            ),
            SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                // Handle your tap event here
                print("View Details clicked!");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TablePayBillHistory(
                          preBookTableHistory: preBookTableHistory,
                        ),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "View Details",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.orange,
                    size: 24,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TablePayBillHistory extends StatefulWidget {
  PreBookTableHistoryModel preBookTableHistory;

  TablePayBillHistory({required this.preBookTableHistory});

  @override
  _TablePayBillHistoryState createState() => _TablePayBillHistoryState();
}


class _TablePayBillHistoryState extends State<TablePayBillHistory> {

  bool isLoading = true;
  TablePayBillHistoryModel? tablePayBillHistoryModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bookTablePayBillHistory("${widget.preBookTableHistory.id}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundBg,
      appBar: AppBar(
        backgroundColor: MyColors.backgroundBg,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        title: Text(
          "Table Pay Bill Details",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading ?
      // Show loading indicator when data is loading
      Center(
        child: CircularProgressIndicator(
          color: MyColors.primaryColor,
        ),
      )
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card 1: Store Details
                Card(
                  elevation: 4,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.preBookTableHistory.store_name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ""+widget.preBookTableHistory.table_status,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: MyColors.offerCardColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Order Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text('Offer: ${widget.preBookTableHistory.title}'),
                                  Text("Table booked for ${widget.preBookTableHistory
                                      .booking_date}, ${widget.preBookTableHistory
                                      .booking_time}, ${widget.preBookTableHistory
                                      .no_of_guest} Guest's"),
                                ],
                              ),
                            ),
                            // Image
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: widget.preBookTableHistory.logo,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          Container(
                                            color: Colors.grey.shade300,
                                            child: Center(
                                                child: CircularProgressIndicator()),
                                          ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),

                // Card 2: Bill Details
                SizedBox(height: 16), // Add some space between cards
                Card(
                  elevation: 4,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Table Booking Details",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ""+widget.preBookTableHistory.payment_status,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: MyColors.offerCardColor,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${widget.preBookTableHistory
                                  .no_of_guest} Guest's: ",
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              "₹${widget.preBookTableHistory.amount}",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "GST 18% : ",
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              "₹${widget.preBookTableHistory.gst_amount}",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        DottedLine(
                          height: 2,
                          color: Colors.black,
                          width: double.infinity,
                          dashWidth: 6.0,
                          dashSpacing: 6.0,
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Price: ',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "₹${widget.preBookTableHistory.pay_amount}",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Card 3: Payment Details
                SizedBox(height: 16), // Add some space between cards
                // Card 3: Payment Details
                SizedBox(height: 16), // Add some space between cards
                if(tablePayBillHistoryModel != null)
                  Card(
                    elevation: 4,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Pay Bill Details",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${tablePayBillHistoryModel?.payment_status ?? ''}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: MyColors.offerCardColor,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Bill Amount:",
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                "₹${tablePayBillHistoryModel?.bill_amount ?? 0}",
                                // Use null-aware operator to handle null
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Discount: ",
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                "- ₹${tablePayBillHistoryModel?.discount_amount ??
                                    0}", // Use null-aware operator to handle null
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Convenience Fee: ",
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                "₹${tablePayBillHistoryModel?.convineince_fee ??
                                    0}", // Use null-aware operator to handle null
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          DottedLine(
                            height: 2,
                            color: Colors.black,
                            width: double.infinity,
                            dashWidth: 6.0,
                            dashSpacing: 6.0,
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Price: ',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "₹${tablePayBillHistoryModel?.pay_amount ?? 0}",
                                // Use null-aware operator to handle null
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> bookTablePayBillHistory(String offerbook_history_id) async {
    print(
        'bookTablePayBillHistory: offerbook_history_id $offerbook_history_id');

    setState(() {
      isLoading = true;
    });

    try {
      final body = {"offerbook_history_id": "$offerbook_history_id"};
      final response = await ApiServices.BookTablePayBillHistory(
          body); // Assuming this returns a single object
      print('bookTablePayBillHistory: response $response');

      if (response != null) {
        setState(() {
          tablePayBillHistoryModel =
              response; // Assign the response to tablePayBillHistoryModel
          isLoading = false; // Set isLoading to false when fetching ends
        });
      } else {
        setState(() {
          tablePayBillHistoryModel = null; // If no response, set model to null
          isLoading = false; // Set isLoading to false when fetching ends
        });
      }
    } catch (e) {
      print('bookTablePayBillHistory: $e');
      setState(() {
        tablePayBillHistoryModel = null; // In case of error, set model to null
        isLoading = false; // Set isLoading to false in case of error
      });
    }
  }

}


class PayBillTab extends StatefulWidget {
  @override
  _PayBillTabState createState() => _PayBillTabState();
}

class _PayBillTabState extends State<PayBillTab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool isLoading = false;
  List<RegularOfferHistory> regularofferlistHistory = [];
  int userId = 0;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    // Start the animation when the widget is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });

    getUserDetails();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // Show loading indicator when data is loading
      return Center(
        child: CircularProgressIndicator(
          color: MyColors.primaryColor,
        ),
      );
    } else if (regularofferlistHistory.isEmpty) {
      // Show "No Data" widget when the list is empty
      return Center(
        child: _buildNoHistoryFound(),
      );
    } else {
      // Show list when data is available
      return FadeTransition(
        opacity: _animation,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: regularofferlistHistory.length,
            itemBuilder: (context, index) {
              return _buildOrderCard(regularofferlistHistory[index]);
            },
          ),
        ),
      );
    }
  }


  Future<void> getUserDetails() async {
    // SharedPref sharedPref=new SharedPref();
    // userName = (await SharedPref.getUser()).name;
    UserModel n = await SharedPref.getUser();
    print("getUserDetails: " + n.name);
    setState(() {
      userId = n.id;
    });
    userRegularPayBillHistory("${userId}");
  }


  Future<void> userRegularPayBillHistory(String user_id) async {
    print('userRegularPayBillHistory: user_id $user_id');

    setState(() {
      isLoading = true;
    });

    try {
      final body = {"user_id": "$user_id"};
      final response = await ApiServices.UserRegularPayBillHistory(body);
      print('userRegularPayBillHistory: response $response');
      if (response != null) {
        setState(() {
          regularofferlistHistory = response;
          isLoading = false; // Set isLoading to false when fetching ends
        });
      } else {
        setState(() {
          isLoading = false; // Set isLoading to false when fetching ends
        });
      }
    } catch (e) {
      print('userRegularPayBillHistory: $e');
      setState(() {
        isLoading = false; // Set isLoading to false in case of error
      });
    }
  }

  Widget _buildNoHistoryFound() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 200,
          height: 180,
          child: Image.asset('assets/vector/blank.png'),
        ),
        SizedBox(height: 16),
        Text(
          'No Data',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }


  Widget _buildOrderCard(RegularOfferHistory regularOffer) {
    return Card(
      color: const Color.fromARGB(255, 255, 255, 255),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "#${regularOffer.razorpay_order_id}",
                  style: TextStyle(fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Colors.red),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${regularOffer.store_name}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('Offer: ${regularOffer.title}'),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Date: ${formatDateTime(regularOffer.date)}",
                            style: TextStyle(fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Bill Details",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total bill: ",
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            "₹${regularOffer.bill_amount}",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Discount amount: ",
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            "- ₹${regularOffer.discount_amount}",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Convenience Fee: ",
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            "₹${regularOffer.convenience_fee}",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      DottedLine(
                        height: 2,
                        color: Colors.black,
                        width: double.infinity,
                        dashWidth: 6.0,
                        dashSpacing: 6.0,
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Pay amount: ',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "₹${regularOffer.pay_amount}",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Image
                SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    Text(
                      "${regularOffer.payment_status}",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 84, 235, 9)
                      ),
                    ),

                    SizedBox(
                      width: 60,
                      height: 60,
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: regularOffer.logo,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Container(
                                color: Colors.grey.shade300,
                                child: Center(
                                    child: CircularProgressIndicator()),
                              ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),

                  ],
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }


  String formatDateTime(String input) {
    // Parse the input string to a DateTime object
    DateTime dateTime = DateTime.parse(input);

    // Format the DateTime object to the desired output format
    String formattedDate = DateFormat('dd-MMM-yy h:mm a').format(dateTime);

    return formattedDate;
  }
}


