import 'dart:io';

import 'package:discount_deals/helper/razorpay_service.dart';
import 'package:discount_deals/helper/shared_pref.dart';
import 'package:discount_deals/model/pre_book_table_model.dart';
import 'package:discount_deals/model/user_model.dart';
import 'package:discount_deals/services/api.dart';
import 'package:discount_deals/services/api_services.dart';
import 'package:discount_deals/theme/theme.dart';
import 'package:discount_deals/ui/apply_voucher_screen.dart';
import 'package:discount_deals/ui/book_table_screen.dart';
import 'package:discount_deals/model/store_model.dart';
import 'package:discount_deals/ui/booked_table_screen.dart';

import 'package:discount_deals/utils/dashed_line.dart';
import 'package:discount_deals/utils/snackbar_helper.dart';
import 'package:discount_deals/widget/coupon_card.dart';
import 'package:discount_deals/widget/offer_term_condtion.dart';
import 'package:discount_deals/widget/title_description_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:discount_deals/model/terms_condition_model.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';

class ConfirmBookingScreen extends StatefulWidget {
  String guest, visitingdate, visitingtime, type;
  PreBookTable preBookTable;

  ConfirmBookingScreen(this.guest, this.visitingdate, this.visitingtime,
      this.type, this.preBookTable);

  @override
  State<ConfirmBookingScreen> createState() => _ConfirmBookingScreenState();
}

class _ConfirmBookingScreenState extends State<ConfirmBookingScreen> {
  int userId = 0;
  int storeId = 0;
  String storeName = '';
  String storeAddress = '';
  String storeAddress2 = '';
  String storeCountry = '';
  String storeState = '';
  String storePostcode = '';
  double? bookingFee,
      availableSeats,
      prebookAmount,
      gstPercentage,
      gstAmount,
      afterGstPrebookAmount;
  bool isLoading = false;
  String _appName = '';
  String userEmail = '';
  String userMobile = '';
    List<TermConditionModel> termConditionList = [];


  void billDetails() {
    // Parse the string values into doubles
    bookingFee = double.tryParse(widget.preBookTable.booking_fee);
    availableSeats = double.tryParse(widget.guest);

    // Ensure bookingFee and availableSeats are not null (use ?? 0.0 as default)
    double effectiveBookingFee = bookingFee ?? 0.0;
    double effectiveAvailableSeats = availableSeats ?? 0.0;

    // Calculate prebook amount
    prebookAmount = effectiveBookingFee * effectiveAvailableSeats;

    // Assign GST percentage (as a decimal)
    gstPercentage = 18; // 18%

    // Calculate GST amount (integer value)
    gstAmount = (prebookAmount! * (gstPercentage! / 100))
        .toInt()
        .toDouble(); // Converting to int and back to double

    // Calculate the total amount including GST
    afterGstPrebookAmount = prebookAmount! + gstAmount!;

    // You can now use `after_gst_prebookAmount` for further calculations or display it.
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    RazorpayService.initialize();
    getUserDetails();
    _loadAppName();
    billDetails();
    fetchStoresTermCondition();
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundBg,
      appBar:AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 10,right: 20), // Add some top padding to align better
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$storeName',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,  // Prevent overflow
                ),
                maxLines: 1,  // Limit to one line for the name
              ),
              SizedBox(height: 4), // Space between store name and address
              Text(
                '$storeAddress $storeAddress2 $storeCountry',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: MyColors.textColor,
                ),
                overflow: TextOverflow.ellipsis,  // Prevent overflow
                maxLines: 1,  // Limit to one line for the address
              ),
            ],
          ),
        ),
        backgroundColor: MyColors.backgroundBg,
      )

      ,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarvedCoupon(
                  storeAddress,
                  storeAddress2,
                  storeCountry,
                  storeName,
                  widget.guest,
                  widget.visitingdate,
                  widget.visitingtime,
                  widget.type,
                  widget.preBookTable),
              SizedBox(
                height: 20,
              ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
              //   child: Text(
              //     'Additional Offers',
              //     style: TextStyle(
              //       fontSize: 18,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              // InkWell(
              //   onTap: (){
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => ApplyVoucherScreen()),
              //     );
              //   },
              //   child: Container(
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       border: Border.all(color: Colors.grey, width: 1.0),
              //       borderRadius: BorderRadius.circular(20),
              //     ),
              //     padding: const EdgeInsets.only(
              //         left: 16, right: 16, top: 10, bottom: 10),
              //     child: Row(
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         Expanded(
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               // Title with text wrapping
              //               Text(
              //                 "Apply coupons & Bank offers",
              //                 style: TextStyle(
              //                   fontSize: 15,
              //                   fontWeight: FontWeight.bold,
              //                 ),
              //               ),
              //               SizedBox(height: 5),
              //               // Spacing between title and booking fee
              //               Row(
              //                 crossAxisAlignment: CrossAxisAlignment.center,
              //                 children: [
              //                   ClipRect(
              //                     child: Container(
              //                       height: 40, // Set your desired height
              //                       width: 40, // Set your desired width
              //                       child: Image.asset(
              //                         'assets/images/exclusive_img.png',
              //                         fit: BoxFit
              //                             .cover, // Optional: Adjust the fit as needed
              //                       ),
              //                     ),
              //                   ),
              //                   SizedBox(width: 10),
              //                   // Spacing between booking fee and available seats
              //                   // Available seats text with text wrapping
              //                   Expanded(
              //                     child: Text(
              //                       'Up to 15% off with HDFC Bank Credit Cards',
              //                       maxLines: 2,
              //                       // Maximum number of lines for the text
              //                       overflow: TextOverflow.ellipsis,
              //                       // Shows ellipsis if text exceeds maxLines
              //                       style: TextStyle(
              //                         fontSize: 14,
              //                         color: Colors.black87,
              //                       ),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ],
              //           ),
              //         ),
              //         // Right-side icon
              //         Icon(
              //           Icons.arrow_forward_ios, // Icon of your choice
              //           size: 18,
              //           color: Colors.black87, // Color of the icon
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                child: Text(
                  'Bill Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  // Background color of the container
                  border: Border.all(color: Colors.grey, width: 1),
                  // Border with 1px width
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left-aligned text
                        Text(
                          'Pre-book offer x ${widget.guest} guests',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: MyColors.txtDescColor,
                          ),
                        ),
                        // Right-aligned text
                        Text(
                          '\u{20B9}$prebookAmount',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(height: 8),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     // Left-aligned text
                    //     Text(
                    //       'Discount',
                    //       style: TextStyle(
                    //         fontSize: 14,
                    //         fontWeight: FontWeight.w400,
                    //         color: MyColors.txtDescColor,
                    //       ),
                    //     ),
                    //     Text(
                    //       '- \u{20B9}2',
                    //       style: TextStyle(
                    //         fontSize: 14,
                    //         fontWeight: FontWeight.w400,
                    //         color: Colors.green,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left-aligned text
                        Text(
                          Platform.isIOS ? 'GST 18% Included' : 'GST 18%',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: MyColors.txtDescColor,
                          ),
                        ),
                        Text(
                          '\u{20B9}$gstAmount',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Container(
                            color: Colors.grey.shade300,
                            height: 0.5,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left-aligned text
                        Text(
                          'To Pay',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        // Right-aligned text
                        Text(
                          '$afterGstPrebookAmount',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              OfferTermsWidget(termConditionList),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    //   bottomNavigationBar: Container(
    //     padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
    //     decoration: BoxDecoration(
    //       color: Colors.white, // Background color of the Container
    //       borderRadius: BorderRadius.only(
    //         topLeft: Radius.circular(16), // Adjust the radius as needed
    //         topRight: Radius.circular(16), // Adjust the radius as needed
    //       ),
    //     ),
    //     child: Padding(
    //       padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
    //       child: Container(
    //         height: 50,
    //         child: ElevatedButton(
    //           onPressed: () {
    //             String user_id = "$userId";
    //             String store_id = widget.preBookTable.store_id;
    //             String offerId = "${widget.preBookTable.id}";
    //             String guest = widget.guest;
    //             String type = widget.type;
    //             String bookdate = widget.visitingdate;
    //             String booktime = widget.visitingtime;
    //             String pre_book_amount = "$prebookAmount";
    //             String gst_percentage = "$gstPercentage";
    //             String gst_amount = "$gstAmount";
    //             String afterGstAmount = "$afterGstPrebookAmount";
    //             String payamount = "$afterGstAmount";

    //             print(
    //                 "Proceed to pay user_id:$user_id, store_id:$store_id, Guest: $guest, Visiting Date: $bookdate, Type: $type, Visiting Time: $booktime, Offer ID: $offerId, Pre-Book Amount: $pre_book_amount, GST Percentage: $gst_percentage, GST Amount: $gst_amount, After GST Amount: $afterGstAmount");

    //             bookPreOffer(
    //                 user_id,
    //                 store_id,
    //                 offerId,
    //                 guest,
    //                 type,
    //                 bookdate,
    //                 booktime,
    //                 pre_book_amount,
    //                 gst_percentage,
    //                 gst_amount,
    //                 afterGstAmount,
    //                 payamount);

    //             // Navigator.push(
    //             //   context,
    //             //   MaterialPageRoute(builder: (context) => BookedTableScreen()),
    //             // );

    //           },
    //           style: ElevatedButton.styleFrom(
    //             backgroundColor: MyColors.primary,
    //             // Change this to your desired color
    //             shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(
    //                   12), // Adjust the radius for side rounding
    //             ),
    //           ),
    //           child: Text(
    //             "Proceed to pay ₹$afterGstPrebookAmount",
    //             style: TextStyle(
    //               color: Colors.white,
    //               fontWeight: FontWeight.bold,
    //               fontSize: 17,
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
    bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: Container(
            height: 50,
            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      setState(() {
                        isLoading = true;
                      });

                      String user_id = "$userId";
                      String store_id = widget.preBookTable.store_id;
                      String offerId = "${widget.preBookTable.id}";
                      String guest = widget.guest;
                      String type = widget.type;
                      String bookdate = widget.visitingdate;
                      String booktime = widget.visitingtime;
                      String booking_Fee = "$bookingFee";
                      String pre_book_amount = "$prebookAmount";
                      String gst_percentage = "$gstPercentage";
                      String gst_amount = "$gstAmount";
                      String afterGstAmount = "$afterGstPrebookAmount";
                      String payamount = "$afterGstAmount";

                      print(
                          "Proceed to pay user_id:$user_id, store_id:$store_id, Guest: $guest, Visiting Date: $bookdate, Type: $type, Visiting Time: $booktime, Offer ID: $offerId, Pre-Book Amount: $pre_book_amount, GST Percentage: $gst_percentage, GST Amount: $gst_amount, After GST Amount: $afterGstAmount");

                      await bookPreOffer(
                          user_id,
                          store_id,
                          offerId,
                          guest,
                          type,
                          bookdate,
                          booktime,
                          booking_Fee,
                          pre_book_amount,
                          gst_percentage,
                          gst_amount,
                          afterGstAmount,
                          payamount);

                      setState(() {
                        isLoading = false;
                      });
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isLoading
                  ? CircularProgressIndicator(color: MyColors.primaryColor)
                  : Text(
                      "Proceed to pay ₹$afterGstPrebookAmount",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> fetchStoresFullView(String store_id, user_id) async {
    setState(() {
      isLoading = true;
    });
    try {
      final body = {
        "store_id": "$store_id",
        "user_id": "$user_id",
      };
      final response = await ApiServices.api_store_fullview(body);

      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final data = response['data'];
        // Ensure that the response data is in the expected format
        if (data != null && data is Map<String, dynamic>) {
          //print('verify_otp data: $data');
          StoreModel store = StoreModel.fromMap(data);

          setState(() {
            storeId = store!.id;
            storeName = store!.storeName;
            storeAddress = store!.address;
            storeAddress2 = store!.address2;
            storeCountry = store!.country;
            storeState = store!.state;
            storePostcode = store!.postcode;
          });

          print("store: " + data.toString());
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

  Future<void> getUserDetails() async {
    // SharedPref sharedPref=new SharedPref();
    // userName = (await SharedPref.getUser()).name;
    UserModel n = await SharedPref.getUser();
    print("getUserDetails: " + n.name);
    setState(() {
      userId = n.id;
      userEmail = n.email;
      userMobile = n.mobile;
      fetchStoresFullView("${widget.preBookTable.store_id}", userId);
    });
  }

  Future<void> _loadAppName() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      setState(() {
        _appName = packageInfo.appName;
      });
      print('App Name: $_appName');
    } catch (e) {
      print('Error getting app name: $e');
    }
  }

  Future<void> bookPreOffer(
      String user_id,
      String store_id,
      String offerId,
      String guest,
      String type,
      String bookdate,
      String booktime,
      String booking_fee,
      String pre_book_amount,
      String gst_percentage,
      String gst_amount,
      String afterGstAmount,
      String payamount) async {
    setState(() {
      isLoading = true;
    });
    try {
      final body = {
        "user_id": "$user_id",
        "store_id": "$store_id",
        "offer_book_tbl_id": "$offerId",
        "no_of_guest": "$guest",
        "type": "$type",
        "booking_date": "$bookdate",
        "booking_time": "$booktime",
        "booking_fee": "$booking_fee",
        "amount": "$pre_book_amount",
        "gst_percentage": "$gst_percentage",
        "gst_amount": "$gst_amount",
        "after_gst_amount": "$afterGstAmount",
        "pay_amount": "$payamount",
      };
      final response = await ApiServices.bookedPreOffer(body);
      print('bookPreOffer data: 2');
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final data = response['data'];

        // Ensure that the response data is in the expected format
        if (data != null && data is Map<String, dynamic>) {
          print('bookPreOffer data: $data');

          final String order_id = data['id'] ;
          final int amount = data['amount'] as int;
          final app_key1 = response['app_key'];
          print('bookPreOffer order_id: $order_id');
          print('bookPreOffer amount: $amount');
          print('bookPreOffer app_key1: $app_key1');


          setState(() async {
            isLoading = false;

            RazorpayService.startPayment(
              orderId: '$order_id',
              apiKey: '$app_key1',
              amount: amount,
              name: '$_appName',
              description: 'book table',
              email: '$userEmail',
              contact: '$userMobile',
              duration: 120,
              app_image: "$image",
              successCallback: (PaymentSuccessResponse response) {
                String bundle =
                    '{"razorpay_payment_id":"${response.paymentId}","razorpay_order_id":"${response.orderId}","razorpay_signature":"${response.signature}"}';
                print('bookPreOffer PaymentSuccessful::bundle $bundle');

                UpdateBookPreOffer(user_id, "${response.orderId}", bundle);
              },
              errorCallback: (PaymentFailureResponse response) {
                String bundle =
                    '{"Error":"${response.error}","code":"${response.code.toString()}","message":"${response.message}"}';

                print(
                    'bookPreOffer Payment Error: ${response.code.toString()} - ${response.message}');
                UpdateBookPreOffer(user_id, "$order_id", bundle);
              },
              externalWalletCallback: (ExternalWalletResponse response) {
                // Handle external wallet payments here
                String bundle = '{"walletName":"${response.walletName}"}';

                print('bookPreOffer External Wallet: ${response.walletName}');
                UpdateBookPreOffer(user_id, "$order_id", bundle);
              },
            );
          });
        } else {
          setState(() {
            isLoading = false;
          });
          // Handle invalid response data format
          showErrorMessage(context, message: 'Invalid response data format');
        }
      } else if (response != null) {
        setState(() {
          isLoading = false;
        });
        String msg = response['msg'];
        // Handle unsuccessful response or missing 'res' field
        showErrorMessage(context, message: msg);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    } finally {
      RazorpayService.initialize();
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> UpdateBookPreOffer(
      String user_id, String razorpay_order_id, String bundle) async {
    print(
        'UpdateBookPreOffer data: user_id:$user_id, razorpay_order_id:$razorpay_order_id, bundle $bundle');
    setState(() {
      isLoading = true;
    });
    try {
      final body = {
        "user_id": "$userId",
        "razorpay_order_id": "$razorpay_order_id",
        "bundle": bundle,
      };
      final response = await ApiServices.UpdateBookPreOffer(body);
      print('UpdateBookPreOffer response: $response');
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        String res = response['res'];
        String msg = response['msg'];
        final data = response['data'];

        print("UpdateBookPreOffer data:  : data: $data");
        
      

        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BookedTableScreen("$data")),
        );

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

}

class CarvedCoupon extends StatelessWidget {
  String storeAddress, storeAddress2, storeCountry;
  String storeName, guest, visitingdate, visitingtime, type;
  PreBookTable preBookTable;

  CarvedCoupon(
      this.storeAddress,
      this.storeAddress2,
      this.storeCountry,
      this.storeName,
      this.guest,
      this.visitingdate,
      this.visitingtime,
      this.type,
      this.preBookTable);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipPath(
        clipper: CouponClipper(
          borderRadius: 20,
          curveRadius: 20,
          curvePosition: 130, // You can adjust this value as needed
          curveAxis: Axis.horizontal,
        ),
        child: Container(
          height: 225,
          color: Color.fromARGB(255, 255, 255, 255),
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // Distribute space evenly
                children: [
                  TitleDescriptionWidget(
                    title: getDayOfWeek(visitingdate),
                    description: '$visitingdate',
                    titleFontSize: 18,
                    descriptionFontSize: 14,
                  ),
                  TitleDescriptionWidget(
                    title: '$type',
                    description: '$visitingtime',
                    titleFontSize: 18,
                    descriptionFontSize: 14,
                  ),
                  TitleDescriptionWidget(
                    title: 'for $guest',
                    description: 'guests',
                    titleFontSize: 18,
                    descriptionFontSize: 14,
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // Distribute space evenly
                children: [
                  Expanded(child: TitleDescriptionWidget(
                    title: '$storeName',
                    description: '$storeAddress $storeAddress2 $storeCountry',
                    titleFontSize: 16,
                    descriptionFontSize: 13,
                  ),)
                ],
              ),
              DashedLine(
                color: MyColors.txtDescColor2,
                margin: EdgeInsets.symmetric(vertical: 22, horizontal: 10),
              ),
              Container(
                height: 45,
                decoration: BoxDecoration(
                  border: Border.all(color: MyColors.primary, width: 1.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 5, bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        "${preBookTable.title}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getDayOfWeek(String dateString) {
    // Parse the string into a DateTime object
    DateTime date = DateTime.parse(dateString);

    // Get today's date
    DateTime today = DateTime.now();

    // Check if the given date is today's date
    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return 'Today';
    }

    // Format the date to get the day of the week
    String dayOfWeek = DateFormat('EEEE').format(date);

    return dayOfWeek; // E.g., "Monday", "Tuesday", etc.
  }
}
