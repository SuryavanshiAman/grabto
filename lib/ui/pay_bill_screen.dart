import 'dart:io';

import 'package:discount_deals/theme/theme.dart';
import 'package:discount_deals/ui/apply_voucher_screen.dart';
import 'package:discount_deals/ui/success_screen.dart';
import 'package:discount_deals/widget/offer_term_condtion.dart';
import 'package:flutter/material.dart';
import 'package:discount_deals/model/regular_offer_model.dart';
import 'package:discount_deals/services/api_services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:discount_deals/helper/razorpay_service.dart';
import 'package:discount_deals/helper/shared_pref.dart';
import 'package:discount_deals/services/api.dart';
import 'package:discount_deals/model/user_model.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:discount_deals/utils/snackbar_helper.dart';
import 'package:lottie/lottie.dart';






class PayBillScreen extends StatefulWidget {

RegularOfferModel regularoffer;
String store_name,store_address;
  PayBillScreen(this.regularoffer,this.store_name,this.store_address);


  @override
  State<PayBillScreen> createState() => _PayBillScreenState();
}

class _PayBillScreenState extends State<PayBillScreen> {
  TextEditingController _amountController = TextEditingController();
  FocusNode _textFieldFocusNode = FocusNode(); // Create FocusNode
  double? billamount;
  double? discountPercentage;
  double? discountAmount;
  double? afterDiscountAmount;
  double? convenienceFee;
  double? convenienceFeeParcentacge = 0.0; // Initialize to a default value
  double? afterConvenienceFee;
  double? payamount;
  bool _isAmountEntered = false;
  bool _isGifShown = false;
  bool isLoading = false;
  int userId = 0;
  String _appName = '';
  String userEmail = '';
  String userMobile = '';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_textFieldFocusNode);
    });
    RazorpayService.initialize();
    ConveinceFee();
    getUserDetails();
    _loadAppName();


  }


  void billDetails() {
    // Parse the string values from the controller and offer into doubles
    double? parsedBillAmount = double.tryParse(_amountController.text)!.roundToDouble();
    double? parsedDiscountPercentage = double.tryParse(widget.regularoffer.discount_percentage);

    // Validate parsed inputs
    if (parsedBillAmount == null || parsedDiscountPercentage == null || convenienceFeeParcentacge == null) {
      print("Invalid input: bill amount, discount percentage, or convenience fee percentage is null.");
      return;
    }
    setState(() {
      _isAmountEntered = true;
      // Set parsed values to instance variables
      billamount = parsedBillAmount.roundToDouble();
      discountPercentage = parsedDiscountPercentage;

      // Calculate discount amount and update after-discount amount
      discountAmount = billamount! * (discountPercentage! / 100);
      afterDiscountAmount = billamount! - discountAmount!;

      this.convenienceFeeParcentacge=convenienceFeeParcentacge;
      // Calculate convenience fee based on the percentage
      convenienceFee = discountAmount! * (convenienceFeeParcentacge! / 100);
      afterConvenienceFee = afterDiscountAmount!.roundToDouble() + convenienceFee!;

      // Set the final payment amount
      payamount = afterConvenienceFee;
      payamount = payamount!.roundToDouble();
      // payamount = double.parse(payamount!.toStringAsFixed(2));
      // Print the final calculated amount for verification
      print("Final amount : $payamount");
    });
  }




  @override
  void dispose() {
    _textFieldFocusNode.dispose(); // Dispose the FocusNode
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get keyboard height
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: MyColors.backgroundBg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 0), // Yadi zarurat nahi ho toh ise hata bhi sakte hain
            Expanded( // Yahan `Expanded` ka use kiya
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.store_name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis, // Text truncate karega
                    maxLines: 1, // Sirf ek line mein text dikhayega
                  ),
                  Text(
                    widget.store_address,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: MyColors.textColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1, // Address ko do lines tak restrict karega
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: MyColors.backgroundBg,
      ),

      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children:<Widget> [
            SingleChildScrollView(
              padding: EdgeInsets.only(bottom: keyboardHeight), // Adjust padding based on keyboard height
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [


                    Container(
                      width: double.infinity,
                      child: Stack(
                        children: [
                          // Existing Column with your current content

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: MyColors.offerCardColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  !_isAmountEntered?"ENTER BILL AMOUNT":"YOUR BILL",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                    wordSpacing: 3.0,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  transitionBuilder: (Widget child, Animation<double> animation) {
                                    return FadeTransition(opacity: animation, child: child);
                                  },
                                  child: !_isAmountEntered
                                      ? // Amount Entry View
                                  Center(
                                    key: const ValueKey('entryView'),
                                    child: Column(
                                      children: [
                                        IntrinsicWidth(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Text(
                                                    "₹",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 40,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                  IntrinsicWidth(
                                                    child: TextField(
                                                      controller: _amountController,
                                                      focusNode: _textFieldFocusNode,
                                                      keyboardType: TextInputType.number,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 40,
                                                          fontWeight: FontWeight.w600),
                                                      decoration: const InputDecoration(
                                                        hintText: "0",
                                                        border: InputBorder.none,
                                                        hintStyle: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 36,
                                                            fontWeight: FontWeight.w800),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                height: 1,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(height: 16),

                                            ],
                                          ),
                                        ),
                                        const Text(
                                          "Proceed to cart",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.0,
                                            wordSpacing: 3.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                      : // Display entered amount with discount and Edit option
                                  Column(
                                    key: const ValueKey('displayView'),
                                    mainAxisSize: MainAxisSize.min,
                                    children: [

                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            "₹",
                                            style: TextStyle(
                                              color: Color.fromARGB(255, 244, 229, 229),
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),

                                          Text(
                                            _amountController.text,
                                            style: const TextStyle(
                                              color: Color.fromARGB(255, 244, 229, 229),
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              decoration: TextDecoration.lineThrough,
                                              decorationColor: Color.fromARGB(
                                                  255, 244, 229, 229),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "₹${afterDiscountAmount!.roundToDouble()}",
                                        style: const TextStyle(
                                          color: Colors.greenAccent,
                                          fontSize: 38,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Center(
                                        child: Container(
                                          width: 30, // Width of the triangle
                                          height: 15, // Height of the triangle
                                          child: CustomPaint(
                                            painter: TrianglePainter(color: Colors.green),
                                          ),
                                        ),
                                      ),


                                      Center(
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(10.0), // Padding inside the container
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [Colors.green, Color.fromARGB(255, 162, 198, 155)], // Gradient colors
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ),
                                            borderRadius: BorderRadius.circular(10.0), // Rounded corners
                                          ),
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    // Image
                                                    ClipOval(
                                                      child: Image.asset(
                                                        'assets/images/happy_emogi.png', // Local asset image path
                                                        width: 42,
                                                        height: 26,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8), // Space between image and text
                                                    // Flexible text
                                                    Flexible(
                                                      child: Text(
                                                        "Wow! you're saving ₹${discountAmount!.roundToDouble()}",
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          // fontWeight: FontWeight.bold,
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 10),
                                      GestureDetector(
                                        onTap: () {
                                          // Switch back to the amount entry view
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            FocusScope.of(context).requestFocus(_textFieldFocusNode);
                                          });
                                          setState(() {
                                            _isAmountEntered = false;
                                            _amountController.clear();
                                            billamount = null;
                                            _isGifShown=false;
                                          });
                                        },
                                        child: const Text(
                                          "Edit amount",
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 255, 255, 255),
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


                          ) ,

                          // GIF displayed when _isAmountEntered is true
                          if (_isAmountEntered && !_isGifShown)
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: AnimatedOpacity(
                                  opacity: _isAmountEntered ? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 300),
                                  child: Image.asset(
                                    'assets/gif/cheer_gif.gif', // Use the path to your GIF here
                                    width:300, // Adjust size as needed
                                    height: 300,
                                  ),
                                ),
                              ),
                            ),

                        ],
                      ),
                    ),

                    const SizedBox(height: 30,),

                    Center(
                      child: Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10), // Padding inside the container
                            decoration: BoxDecoration(
                              color: Colors.white, // Container background color
                              borderRadius: BorderRadius.circular(15.0), // Rounded corners
                              border: Border.all(color: Colors.grey, width: 1.0), // Outline border
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: const Offset(0, 0), // Shadow position
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Image
                                ClipOval(
                                  child: Image.asset(
                                    'assets/images/offer_discount.png', // Replace with your image path
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 15), // Space between image and column
                                // Column with two texts
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Flat ${widget.regularoffer.discount_percentage}% Off", // Replace with your title
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 5), // Space between title and subtitle
                                    Text(
                                      "on bill payment", // Replace with your subtitle
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // "+" Icon on the left side
                          Positioned(
                            left: 0, // Adjust this value to position the box
                            top: 20, // Adjust to align vertically
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25), // Shadow color with opacity
                                    spreadRadius: 1, // Spread radius
                                    blurRadius: 5, // Blur radius for softness
                                    offset: const Offset(2, 1), // Offset for shadow (x, y)
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  "+",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // "+" Icon on the right side
                          Positioned(
                            right: 0, // Adjust this value to position the box
                            top: 20, // Adjust to align vertically
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25), // Shadow color with opacity
                                    spreadRadius: 1, // Spread radius
                                    blurRadius: 5, // Blur radius for softness
                                    offset: const Offset(2, 1), // Offset for shadow (x, y)
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  "+",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20,),

                    if(billamount!=null)
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                        child: Text(
                          'Bill Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if(billamount!=null)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          // Background color of the container
                          border: Border.all(color: Colors.grey, width: 1),
                          // Border with 1px width
                          borderRadius: BorderRadius.circular(20), // Rounded corners
                        ),
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Left-aligned text
                                const Text(
                                  'Bill amount',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: MyColors.textColor,
                                  ),
                                ),
                                // Right-aligned text
                                Text(
                                  '\u{20B9}$billamount',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Left-aligned text
                                const Text(
                                  // '${widget.regularoffer.title}',
                                  'Discount',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: MyColors.txtDescColor,
                                  ),
                                ),
                                Text(
                                  '- \u{20B9}${discountAmount!.roundToDouble()}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Left-aligned text
                                const Text(
                                  'Convenience fee',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: MyColors.txtDescColor,
                                  ),
                                ),
                                Text(
                                  '\u{20B9}${convenienceFee!.roundToDouble()}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
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
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Left-aligned text
                                const Text(
                                  'To Pay',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                // Right-aligned text
                                Text(
                                  '\u{20B9}$payamount',
                                  style: const TextStyle(
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
                    const SizedBox(
                      height: 30,
                    ),
                    // OfferTermsWidget(),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom:  0 , // Move up when keyboard is visible
              left: 0,
              right: 0,

              child:Container(

                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                decoration: const BoxDecoration(
                  // color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async{

                      if(billamount==null){


                        billDetails();

                        if (_isAmountEntered && !_isGifShown) {
                          Future.delayed(const Duration(seconds: 3), () {
                            setState(() {
                              _isGifShown = true; // Mark that the GIF has been shown
                            });
                          });
                        }

                      }else{

                        setState(() {
                          isLoading = true;
                        });

                        String user_id = "$userId";
                        String store_id = widget.regularoffer.store_id;
                        String regularoffer_id = "${widget.regularoffer.id}";

                        String bill_amount = "$billamount";
                        String discount_Percentage = "$discountPercentage";
                        String discount_Amount = "$discountAmount";
                        String after_Discount_Amount = "$afterDiscountAmount";
                        String convenience_Fee_Parcentacge = "$convenienceFeeParcentacge";
                        String convenience_Fee = "$convenienceFee";
                        String after_Convenience_Fee = "$afterConvenienceFee";

                        String pay_amount = "$payamount";

                        print(
                            "payUserBill user_id:$user_id, store_id:$store_id, regularoffer_id: $regularoffer_id, bill_amount: $bill_amount, discount_Percentage: $discount_Percentage, discount_Amount: $discount_Amount, after_Discount_Amount: $after_Discount_Amount, convenience_Fee_Parcentacge: $convenience_Fee_Parcentacge, convenience_Fee: $convenience_Fee, after_Convenience_Fee: $after_Convenience_Fee, pay_amount: $pay_amount");
                   print("😊😊");
                        await regularPayBill(
                            user_id,
                            store_id,
                            regularoffer_id,
                            bill_amount,
                            discount_Percentage,
                            discount_Amount,
                            after_Discount_Amount,
                            convenience_Fee_Parcentacge,
                            convenience_Fee,
                            after_Convenience_Fee,
                            pay_amount);

                        setState(() {
                          isLoading = false;
                        });

                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: MyColors.primaryColor)
                        : Text(
                      billamount==null?"Next" :"Proceed to pay \u{20B9}$payamount",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ),


            ),
          ],
        ),



      ),

    );
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



  Future<void> ConveinceFee() async {
    try {
      final response = await ApiServices.ConveinceFee();

      // Check if the response is null or doesn't contain the expected data
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final msg = response['msg'] as String;
        final data = response['data'] ;
        if (data != null && data.isNotEmpty) {
          // Access the first item in the data array and parse the convineince_fee field
          convenienceFeeParcentacge = double.tryParse(data[0]['convineince_fee'].toString());
          print("Convenience Fee: $convenienceFeeParcentacge");
        } else {
          print("Data is empty or null.");
        }
      } else if (response != null) {
        String msg = response['msg'];

      }
    } catch (e) {
      //print('verify_otp error: $e');
      // Handle error
      //showErrorMessage(context, message: 'An error occurred: $e');
    } finally {

    }
  }

  Future<void> regularPayBill(
      String user_id,
      String store_id,
      String regularoffer_id,
      String bill_amount,
      String discount_percentage,
      String discount_amount,
      String after_discount_amount,
      String convenience_fee_percentage,
      String convenience_fee,
      String after_convenience_fee,
      String pay_amount) async {
    setState(() {
      isLoading = true;
    });
    try {
      final body = {
        "user_id": user_id,
        "store_id": store_id,
        "walkin_offer_id": regularoffer_id,
        "bill_amount": bill_amount,
        "discount_percentage": discount_percentage,
        "discount_amount": discount_amount,
        "after_discount_amount": after_discount_amount,
        "convenience_fee_percentage": convenience_fee_percentage,
        "convenience_fee": convenience_fee,
        "after_convenience_fee": after_convenience_fee,
        "pay_amount": pay_amount,
      };
      final response = await ApiServices.RegularPayBill(body);
      print('🪙🪙regularPayBill data: 2');
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final data = response['data'];

        // Ensure that the response data is in the expected format
        if (data != null && data is Map<String, dynamic>) {
          print('regularPayBill data: $data');

          final String order_id = data['id'] ;
          final int amount = data['amount'] as int;
          final app_key1 = response['app_key'];
          print('regularPayBill order_id: $order_id');
          print('regularPayBill amount: $amount');
          print('regularPayBill app_key1: $app_key1');


          setState(() async {
            isLoading = false;
print("🙉🙉🙉");
            RazorpayService.startPayment(
              orderId: order_id,
              apiKey: '$app_key1',
              amount: amount,
              name: _appName,
              description: 'bill pay',
              email: userEmail,
              contact: userMobile,
              duration: 120,
              app_image: image,
              successCallback: (PaymentSuccessResponse response) {
                String bundle =
                    '{"razorpay_payment_id":"${response.paymentId}","razorpay_order_id":"${response.orderId}","razorpay_signature":"${response.signature}"}';
                print('regularPayBill PaymentSuccessful::bundle $bundle');

                UpdateRegularPayBill(user_id, "${response.orderId}", bundle,pay_amount);
              },
              errorCallback: (PaymentFailureResponse response) {
                String bundle =
                    '{"Error":"${response.error}","code":"${response.code.toString()}","message":"${response.message}"}';

                print(
                    'regularPayBill Payment Error: ${response.code.toString()} - ${response.message}');
                UpdateRegularPayBill(user_id, order_id, bundle,pay_amount);
              },
              externalWalletCallback: (ExternalWalletResponse response) {
                // Handle external wallet payments here
                String bundle = '{"walletName":"${response.walletName}"}';

                print('regularPayBill External Wallet: ${response.walletName}');
                UpdateRegularPayBill(user_id, order_id, bundle,pay_amount);
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

  Future<void> UpdateRegularPayBill(
      String user_id, String razorpay_order_id, String bundle,String pay_amount) async {
    print(
        'UpdateRegularPayBill data: user_id:$user_id, razorpay_order_id:$razorpay_order_id, bundle $bundle');
    setState(() {
      isLoading = true;
    });
    try {
      final body = {
        "user_id": "$userId",
        "razorpay_order_id": razorpay_order_id,
        "bundle": bundle,
      };
      final response = await ApiServices.UpdateRegularPayBill(body);
      print('UpdateRegularPayBill response: $response');
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        String res = response['res'];
        String msg = response['msg'];
        final data = response['data'];

        print("UpdateRegularPayBill data:  : data: $data");

        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SuccessScreen(msg,pay_amount)),
        );

        setState(() {
          isLoading = false;
        });
      } else if (response != null) {
        String res = response['res'];
        String msg = response['msg'];
        // Handle unsuccessful response or missing 'res' field
        showErrorMessage(context, message: msg);
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






 class TrianglePainter extends CustomPainter {
  Color color;
TrianglePainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color // Triangle color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width / 2, 0); // Top point
    path.lineTo(0, size.height); // Bottom-left point
    path.lineTo(size.width, size.height); // Bottom-right point
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}