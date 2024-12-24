import 'package:discount_deals/services/api.dart';
import 'package:discount_deals/services/api_services.dart';
import 'package:discount_deals/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/theme.dart';

class CustomerCare extends StatefulWidget {
  @override
  State<CustomerCare> createState() => _CustomerCareState();
}

class _CustomerCareState extends State<CustomerCare> {
  bool isLoading = false;

  String email = '';
  String address = '';
  String mobile = '';
  String created_at = '';
  String updated_at = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    website_setting();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double width_90 = width * 0.95;
    double Dwidth_90 = width * 0.95;
    return Scaffold(
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
          "Customer Care",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: MyColors.backgroundBg,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                      // onTap: () {
                      //   //_sendEmail("$email");
                      //   _makePhoneCall("$mobile");
                      // },
                      child: buildContainerItem(width_90)),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          ),
          // Show a loading indicator if _isLoading is true
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.orange,
                  ),
                  // Change the color
                  strokeWidth: 4,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _sendEmail(String _email) async {
    final Uri _emailLaunchUri = Uri(
        scheme: 'mailto',
        path: '$_email',
        queryParameters: {
          'subject': '',
          'body': 'Hello,\nDiscount Deals Team'
        });

// ...

// mailto:smith@example.com?subject=Example+Subject+%26+Symbols+are+allowed%21
    launch(_emailLaunchUri.toString());
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
      print('Error launching phone call: $e');
      // Handle the error gracefully, such as displaying an error message to the user
    }
  }

  Container buildContainerItem(double width_90) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Container(
            width: width_90,
            height: 180,
            margin: EdgeInsets.only(top: 10, bottom: 24),
            decoration: BoxDecoration(
              borderRadius: new BorderRadius.all(Radius.circular(6)),
              gradient: LinearGradient(colors: [
                Color.fromRGBO(149, 72, 176, 1),
                Color.fromRGBO(104, 133, 240, 1)
              ], begin: Alignment.bottomLeft, end: Alignment.topRight),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "INDIA",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Customer Care",
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 10,),
                          if(mobile.isNotEmpty)
                          InkWell(
                            onTap: () {
                              //_sendEmail("$email");
                              _makePhoneCall("$mobile");
                            },
                            child: Text(
                              "Call:- $mobile",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(height: 5,),
                          if(email.isNotEmpty)
                          InkWell(
                            onTap: () {
                              //_sendEmail("$email");
                              _sendEmail("$email");
                            },
                            child: Text(
                              "Email:- $email",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      // IconButton(
                      //   padding: new EdgeInsets.only(right: 34, bottom: 32),
                      //   icon: new Icon(
                      //     Icons.navigate_next,
                      //     size: 60.0,
                      //     color: Colors.white,
                      //   ),
                      //   onPressed: () {
                      //     //navigateToOrderPage();
                      //   },
                      // )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> website_setting() async {
    try {
      setState(() {
        isLoading = true;
      });
      final response = await ApiServices.website_setting();

      // Check if the response is null or doesn't contain the expected data
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final data = response['data'];
        // Ensure that the response data is in the expected format
        if (data != null && data is Map<String, dynamic>) {
          //print('verify_otp data: $data');
          print("website: $data");

          email = data['email'] as String;
          address = data['address'] as String;
          mobile = data['mobile'] as String;
          created_at = data['created_at'] as String;
          updated_at = data['updated_at'] as String;

        } else {
          // Handle invalid response data format
          showErrorMessage(context, message: 'Invalid response data format');
        }
      } else if (response != null) {
        String msg = response['msg'];
        // Handle unsuccessful response or missing 'res' field
        showErrorMessage(context, message: msg);
      }
    } catch (e) {
      //print('verify_otp error: $e');
      // Handle error
      //showErrorMessage(context, message: 'An error occurred: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
