import 'dart:ffi';
import 'dart:io';

import 'package:discount_deals/helper/InAppScreen.dart';
import 'package:discount_deals/helper/razorpay_service.dart';
import 'package:discount_deals/helper/shared_pref.dart';
import 'package:discount_deals/model/plan_model.dart';
import 'package:discount_deals/model/user_model.dart';
import 'package:discount_deals/services/api.dart';
import 'package:discount_deals/services/api_services.dart';
import 'package:discount_deals/theme/theme.dart';
import 'package:discount_deals/utils/snackbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentScreen extends StatefulWidget {
  PlanModel? planModel;

  //PaymentScreen(this.planModel);
  final GlobalKey<_PaymentScreenState> _paymentScreenKey = GlobalKey();

// In the build method of PaymentScreen, assign the key to the widget
  PaymentScreen(this.planModel, {Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isLoading = false;
  String _appName = '';
  String userEmail = '';
  String userMobile = '';
  String buttonApply = "Apply";
  int userId = 0;

  String discountVa = '';
  String subtotalVa = '';
  String netPriceString = '';
  String offerPriceString = '';
  String gstPriceString = '';

  // String netPriceVa = '';
  TextEditingController saleController = TextEditingController();
  late PurchaseProvider _purchaseProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _purchaseProvider = Provider.of<PurchaseProvider>(context, listen: false);
    _initializeAndFetchInfo();

    getUserDetails();
    _loadAppName();
    showDetails();
  }

  Future<void> _initializeAndFetchInfo() async {
    // Initialize with a sample user ID or obtain dynamically
    await _purchaseProvider.initialize('sample_user_id');
    await _purchaseProvider.fetchPurchaserInfo();
  }

  Future<void> _purchaseProduct(
      String user_id, String productId, String orderId) async {
    setState(() {
      isLoading = true;
    });
    try {
      final result = await _purchaseProvider.fetchProductAndDiscount('${productId}'); // Replace with your product ID
      final   _product = result['product'] as Product;
      final  _paymentDiscount = result['paymentDiscount'] as PaymentDiscount?;


      await _purchaseProvider.purchaseProduct(
        context,
        productId,
        discount: _paymentDiscount,
        successCallback: (purchaserInfo) {
          var originalAppUserId = purchaserInfo.originalAppUserId;
          var nonSubscriptionTransactions =
              purchaserInfo.nonSubscriptionTransactions;
          //revenueCatId
          dynamic transaction = nonSubscriptionTransactions[0];
          String revenueCatId = transaction.revenueCatId;
          //productId
          String productId = transaction.productId;
          //purchaseDate
          String purchaseDate = transaction.purchaseDate;
          //remove $ from $originalAppUserId
          originalAppUserId = originalAppUserId.replaceAll("\$", "");
          //remove RCAnonymousID: from originalAppUserId
          originalAppUserId =
              originalAppUserId.replaceAll("RCAnonymousID:", "");
          var userDDD = {
            "user_id": "$originalAppUserId",
          };
          //productAdded
          var productAdded = {
            "product_id": "$productId",
            "revenueCatId": "$revenueCatId",
            "purchaseDate": "$purchaseDate",
            "originalAppUserId": "$originalAppUserId",
          };
          //save product data to server
          var userdata = {
            "originalAppUserId": "$originalAppUserId",
            "id": "0",
            "revenueCatId": "$revenueCatId",
            "productId": "$productId",
            "purchaseDate": "$purchaseDate"
          };

          var bundle = {
            "userDDD": "$userDDD",
            "productAdded": "$productAdded",
            "userdata": "$userdata",
          };

          // Handle successful purchase here
          print("Purchase successful: $bundle");

          // showSuccessMessage(context, message: "Purchase successful: ");
          updatePaymentStatus(user_id, "$orderId", "$bundle");
        },
        errorCallback: (errorMessage) {
          // Handle purchase error here
          print("Purchase error: $errorMessage");
          showErrorMessage(context, message: "Purchase error: $errorMessage");
        },
      );
    } catch (e) {
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> showDetails() async {
    setState(() {
      isLoading = true;
    });
    discountVa = "";
    subtotalVa = widget.planModel!.offerPrice;
    //netPriceVa = widget.planModel!.netPrice;
    netPriceString = widget.planModel!.netPrice;
    offerPriceString = widget.planModel!.offerPrice;
    double netPrice = double.tryParse(netPriceString) ?? 0.0;
    double offerPrice = double.tryParse(offerPriceString) ?? 0.0;
    double gstPrice = netPrice - offerPrice;
    gstPriceString = "${gstPrice}";
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getUserDetails() async {
    // SharedPref sharedPref=new SharedPref();
    // userName = (await SharedPref.getUser()).name;
    UserModel n = await SharedPref.getUser();
    print("getUserDetails: " + n.dob);
    setState(() {
      userId = n.id;
      userEmail = n.email;
      userMobile = n.mobile;
    });
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
            child: Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        title: Text(
          "Payment Summary",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          isLoading
              ? Container(
                  color:
                      Colors.black.withOpacity(0.5), // Adjust opacity as needed
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        MyColors.primaryColor,
                      ),
                      // Change the color
                      strokeWidth: 4,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "${widget.planModel!.name}".toUpperCase(),
                              overflow: TextOverflow.visible,
                              // Change to TextOverflow.visible to allow wrapping
                              style: TextStyle(
                                  color: MyColors.primaryColor, fontSize: 18),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 80,
                          color: Colors.white,
                          padding: EdgeInsets.all(15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextField(
                                  enabled: true,
                                  controller: saleController,
                                  cursorColor: MyColors.blackBG,
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  minLines: 1,
                                  style: TextStyle(color: MyColors.blackBG),
                                  decoration: InputDecoration(
                                    hintText: 'Sales Code (Optional)',
                                    hintStyle:
                                        TextStyle(color: Color(0xFFDDDDDD)),
                                    enabledBorder: OutlineInputBorder(
                                      gapPadding: 0,
                                      borderSide:
                                          BorderSide(color: MyColors.blackBG),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: MyColors.primaryColor),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    final salecode = saleController.text;

                                    //getsalecode(salecode);

                                    if (buttonApply == "Apply") {
                                      if(Platform.isIOS){
                                        getsalecodeIos("$salecode","ios");
                                      }
                                    else{
                                        getsalecodeAndroid("$salecode","android");
                                      }
                                    } else {
                                      setState(() {
                                        saleController.text='';
                                        buttonApply = "Apply";
                                      });
                                      showDetails();
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: MyColors.primaryColor,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 20),
                                    child: Text(
                                      "${buttonApply}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Left-aligned text
                                  Text(
                                    '${widget.planModel!.duration}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  // Right-aligned text
                                  Text(
                                    '\u{20B9} ${convertToDouble(widget.planModel!.offerPrice)}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Visibility(
                                visible: discountVa.isNotEmpty,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Left-aligned text
                                    Text(
                                      'Discount',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.green,
                                      ),
                                    ),
                                    Text(
                                      '- \u{20B9} ${convertToDouble(discountVa)}',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
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
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Left-aligned text
                                  Text(
                                    'Subtotal',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  // Right-aligned text
                                  Text(
                                    '\u{20B9} ${convertToDouble(subtotalVa)}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Left-aligned text
                                  Text(
                                    Platform.isIOS? 'GST 18% Included': 'GST 18%',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.green,
                                    ),
                                  ),
                                  Text(
                                    '\u{20B9} ${convertToDouble(gstPriceString)}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
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
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Left-aligned text
                                  Text(
                                    'Net payable amount',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  // Right-aligned text
                                  Text(
                                Platform.isIOS?    '\u{20B9} ${convertToDouble(offerPriceString)}':'\u{20B9} ${convertToDouble(netPriceString)}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Container(
                                  width: double.maxFinite,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (widget.planModel != null) {
                                        var salecode = "";
                                        if (buttonApply == "Apply") {
                                          salecode = "";
                                        } else {
                                          salecode = saleController.text;
                                        }

                                        if (Platform.isIOS) {
                                          appstore_gateway_open(
                                              widget.planModel,
                                              "$userId",
                                              "$discountVa",
                                              "$gstPriceString",
                                              "$offerPriceString",
                                              "$salecode");
                                        } else {
                                          buyPlan(
                                              widget.planModel,
                                              "$userId",
                                              "$discountVa",
                                              "$gstPriceString",
                                              "$offerPriceString",
                                              "$salecode");
                                        }

                                        // You can navigate to another screen or perform any other action here
                                      }
                                    },
                                    child: Text(
                                      "Pay",
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.white),
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              MyColors.btnBgColor),
                                    ),
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
        ],
      ),
    );
  }

  double convertToDouble(String input) {
    // Try parsing the input string to double
    try {
      double value = double.parse(input.replaceAll(RegExp(r','),
          '.')); // Replace ',' with '.' for international number formatting
      return double.parse(
          value.toStringAsFixed(1)); // Limit precision to one decimal place
    } catch (e) {
      // If parsing fails, return 0.0
      return 0.0;
    }
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

  Future<void> getsalecodeIos(String salecode,String type) async {
    if (salecode.isEmpty) {
      showErrorMessage(context, message: 'Please fill salecode');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final body = {
        "salecode": "$salecode",
        "type": "$type",
      };
      final response = await ApiServices.getsalecode(body);
      print('salecode data: 2');
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final data = response['data'];

        // Ensure that the response data is in the expected format
        if (data != null && data is Map<String, dynamic>) {
          print('getsalecode data: $data');

          final percentage = data['percentage'] as String;
          print('getsalecode app_key1: $percentage');

          double percentageValue = double.parse(percentage);
          double planPrice = double.parse(widget.planModel!.offerPrice);
          double discount = (percentageValue / 100) * planPrice;
          double discountedPrice = planPrice - discount;

          double gstAmount = (discountedPrice * 18) / 100;
          // double finalPrice = discountedPrice + gstAmount;
          double finalPrice = discountedPrice ;


          setState(() {
            // if (Platform.isIOS) {
            //   buttonApply = "Remove";
            // } else {
              discountVa = "$discount";
              subtotalVa = "$discountedPrice";
              gstPriceString = "$gstAmount";
              // netPriceString = "$finalPrice";
              offerPriceString='$finalPrice';
              buttonApply = "Remove";
            // }
          });

          print("getsalecode: " + data.toString());
        } else {
          // Handle invalid response data format
          showErrorMessage(context, message: 'Invalid response data format');
        }
      } else if (response != null) {
        String msg = response['msg'];
        saleController.text = '';
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

  Future<void> getsalecodeAndroid(String salecode,String type) async {
    if (salecode.isEmpty) {
      showErrorMessage(context, message: 'Please fill salecode');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final body = {
        "salecode": "$salecode",
        "type": "$type",
      };
      final response = await ApiServices.getsalecode(body);
      print('salecode data: 2');
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final data = response['data'];

        // Ensure that the response data is in the expected format
        if (data != null && data is Map<String, dynamic>) {
          print('getsalecode data: $data');

          final percentage = data['percentage'] as String;
          print('getsalecode app_key1: $percentage');

          double percentageValue = double.parse(percentage);
          double planPrice = double.parse(widget.planModel!.offerPrice);
          double discount = (percentageValue / 100) * planPrice;
          double discountedPrice = planPrice - discount;

          double gstAmount = (discountedPrice * 18) / 100;
          double finalPrice = discountedPrice + gstAmount;


          setState(() {
            // if (Platform.isIOS) {
            //   buttonApply = "Remove";
            // } else {
            discountVa = "$discount";
            subtotalVa = "$discountedPrice";
            gstPriceString = "$gstAmount";
            netPriceString = "$finalPrice";
            // offerPriceString='$finalPrice';
            buttonApply = "Remove";
            // }
          });

          print("getsalecode: " + data.toString());
        } else {
          // Handle invalid response data format
          showErrorMessage(context, message: 'Invalid response data format');
        }
      } else if (response != null) {
        String msg = response['msg'];
        saleController.text = '';
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

  Future<void> buyPlan(
      PlanModel? selectedPlan,
      String user_id,
      String discount_price,
      String gst_price,
      String pay_amount,
      String salecode) async {
    setState(() {
      isLoading = true;
    });
    try {
      print('buyPlan data: 2 userid: $user_id, plan_id: ${selectedPlan!.id}, discount_price: $discount_price, gst_price: $gst_price, pay_amount: $pay_amount, salecode: $salecode');

      final body = {
        "user_id": "$user_id",
        "plan_id": "${selectedPlan!.id}",
        "discount_price": "$discount_price",
        "gst_price": "$gst_price",
        "pay_amount": "$pay_amount",
        "salecode": "$salecode",
      };
      final response = await ApiServices.gateway_open(body);
      print('buyPlan data: 2');
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final data = response['data'];

        // Ensure that the response data is in the expected format
        if (data != null && data is Map<String, dynamic>) {
          print('buyPlan data: $data');

          final order_id = data['id'] as String;
          final int amount = data['amount'] as int;
          final app_key1 = response['app_key'];
          print('buyPlan order_id: $order_id');
          print('buyPlan amount: $amount');
          print('buyPlan app_key1: $app_key1');
          // final order_id_test = 'order_OfEXgFIOJjHih6';
          // final app_key1_test = 'rzp_live_lO7G8ieosuWNWk';

          final order_id_test = 'order_OfE7jEGVhvmysX';
          final app_key1_test = 'rzp_test_HNgCYoQZ9HmHb2';

          final int amount1 = 200;

          setState(() async {
            isLoading = false;

            // RazorpayService.startPayment(
            //   // orderId: '$order_id_test',
            //   // apiKey: '$app_key1_test',
            //   orderId: '$order_id',
            //   apiKey: '$app_key1',
            //   amount: amount,
            //   // Amount in the smallest currency unit (e.g., cents for USD)
            //   name: '$_appName',
            //   description: '${selectedPlan.name}',
            //   email: '$userEmail',
            //   contact: '$userMobile',
            //   duration: 120,
            //   app_image: "$image",
            //   successCallback: (PaymentSuccessResponse response) {
            //     // Handle payment success here
            //     String bundle =
            //         '{"razorpay_payment_id":"${response.paymentId}","razorpay_order_id":"${response.orderId}","razorpay_signature":"${response.signature}"}';
            //     print('buyPlan PaymentSuccessful::bundle $bundle');
            //
            //     updatePaymentStatus(user_id, "${response.orderId}", bundle);
            //   },
            //   errorCallback: (PaymentFailureResponse response) {
            //     String bundle =
            //         '{"Error":"${response.error}","code":"${response.code.toString()}","message":"${response.message}"}';
            //
            //     print(
            //         'buyPlan Payment Error: ${response.code.toString()} - ${response.message}');
            //     // updatePaymentStatus(user_id, "${response.error}", bundle);
            //   },
            //   externalWalletCallback: (ExternalWalletResponse response) {
            //     // Handle external wallet payments here
            //     print('buyPlan External Wallet: ${response.walletName}');
            //   },
            // );
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
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> appstore_gateway_open(
      PlanModel? selectedPlan,
      String user_id,
      String discount_price,
      String gst_price,
      String pay_amount,
      String salecode) async {
    // showSnackBar(context, 'Selected Plan: ${selectedPlan!.name}');
    // print('gateway_open data: 1');
    setState(() {
      isLoading = true;
    });
    try {
      print('buyPlan data: userid: $user_id, plan_id: ${selectedPlan!.id}, discount_price: $discount_price, gst_price: $gst_price, pay_amount: $pay_amount, salecode: $salecode');
      final body = {
        "user_id": "$user_id",
        "plan_id": "${selectedPlan!.id}",
        "discount_price": "$discount_price",
        "gst_price": "$gst_price",
        "pay_amount": "$pay_amount",
        "salecode": "$salecode",
      };
      final response = await ApiServices.appstore_gateway_open(body);
      print('buyPlan data: 2');
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final data = response['data'];

        // Ensure that the response data is in the expected format
        if (data != null && data is Map<String, dynamic>) {
          print('appstore_gateway_open data: $data');

          final order_id = data['razorpay_order_id'] as String;
          final amount = data['pay_amount'];
          print('appstore_gateway_open order_id: $order_id');
          print('appstore_gateway_open amount: $amount');

          if (Platform.isIOS) {
            if(salecode=='') {
              print('appstore_gateway_open appleProductId: ${selectedPlan!.appleProductId}');

              if (await _purchaseProvider
                  .checkProductExist('${selectedPlan!.appleProductId}')) {
                _purchaseProduct(
                    user_id, '${selectedPlan!.appleProductId}', '$order_id');


              } else {
                showErrorMessage(context,
                    message:
                    "Product does not exist: ${selectedPlan!.appleProductId}");
                print(
                    "Product with salecode does not exist: ${selectedPlan!.appleProductId}");
              }
            }else{
              print('appstore_gateway_open appleProductId: ${selectedPlan!.appleProductIdOffer}');
              if (await _purchaseProvider
                  .checkProductExist('${selectedPlan!.appleProductIdOffer}')) {
                _purchaseProduct(
                    user_id, '${selectedPlan!.appleProductIdOffer}', '$order_id');
              } else {
                showErrorMessage(context,
                    message:
                    "Product does not exist: ${selectedPlan!.appleProductIdOffer}");
                print(
                    "Product without salecode does not exist: ${selectedPlan!.appleProductIdOffer}");
              }
            }

          } else {
            print("Only Ios platform ");
          }
          print("store: " + data.toString());
        } else {
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
    } finally {}
  }

  Future<void> updatePaymentStatus(
      String user_id, String razorpay_order_id, String bundle) async {
    print('updatePaymentStatus data: 1');
    setState(() {
      isLoading = true;
    });
    try {
      final body = {
        "user_id": "$userId",
        "razorpay_order_id": "$razorpay_order_id",
        "bundle": bundle,
      };
      final response = await ApiServices.update_gateway(body);
      print('updatePaymentStatus data: 2 : response: $response');
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        String res = response['res'];
        String msg = response['msg'];
        final data = response['data'];

        // Ensure that the response data is in the expected format
        if (data != null && data is Map<String, dynamic>) {
          //print('verify_otp data: $data');
          final user = UserModel.fromMap(data);

          if (user != null) {
            //print('verify_otp data: 1');

            await SharedPref.userLogin({
              SharedPref.KEY_ID: user.id,
              SharedPref.KEY_CURRENT_MONTH: user.current_month,
              SharedPref.KEY_PREMIUM: user.premium,
              SharedPref.KEY_STATUS: user.status,
              SharedPref.KEY_NAME: user.name,
              SharedPref.KEY_EMAIL: user.email,
              SharedPref.KEY_MOBILE: user.mobile,
              SharedPref.KEY_DOB: user.dob,
              SharedPref.KEY_OTP: user.otp,
              SharedPref.KEY_IMAGE: user.image,
              SharedPref.KEY_HOME_LOCATION: user.home_location,
              SharedPref.KEY_CURRENT_LOCATION: user.current_location,
              SharedPref.KEY_LAT: user.lat,
              SharedPref.KEY_LONG: user.long,
              SharedPref.KEY_CREATED_AT: user.created_at,
              SharedPref.KEY_UPDATED_AT: user.updated_at,
            });
            setState(() {
              isLoading = false;
            });

            navigateToSuccessScreen("$msg");
          } else {
            setState(() {
              isLoading = false;
            });
            // Handle null user
            showErrorMessage(context, message: 'User data is invalid');
          }
        } else {
          setState(() {
            isLoading = false;
          });
          // Handle invalid response data format
          //showErrorMessage(context, message: 'Invalid response data format');
        }
        setState(() {
          isLoading = false;
        });
      } else if (response != null) {
        String res = response['res'];
        String msg = response['msg'];
        // Handle unsuccessful response or missing 'res' field
        showErrorMessage(context, message: "$res $msg");
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

  Future<void> navigateToSuccessScreen(String msg) async {
    showSuccessMessage(context, message: "$msg");
    Navigator.pop(context);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SuccessScreen("$msg")),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  String msg = "";

  SuccessScreen(this.msg);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text('Coupon Applied'),
      //   //backgroundColor: Colors.green, // Set the app bar color to indicate success
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              '$msg!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Thank you for your using.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigate to another screen or perform any action
              },
              child: Text(
                'Continue',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
