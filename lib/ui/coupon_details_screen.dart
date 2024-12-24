import 'package:cached_network_image/cached_network_image.dart';
import 'package:discount_deals/helper/shared_pref.dart';
import 'package:discount_deals/model/coupon_model.dart';
import 'package:discount_deals/model/terms_condition_model.dart';
import 'package:discount_deals/model/user_model.dart';
import 'package:discount_deals/services/api_services.dart';
import 'package:discount_deals/theme/theme.dart';
import 'package:discount_deals/utils/snackbar_helper.dart';
import 'package:discount_deals/widget/coupon_card.dart';
import 'package:discount_deals/widget/term_condition_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:discount_deals/ui/scan_code_screen.dart';
// import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class CouponDetailsScreen extends StatefulWidget {
  List<TermConditionModel> termConditionList = [];
  CouponModel couponModel;
  String storeLogoImageUrl = "";
  String storeName = '';
  String salecode = '';

  CouponDetailsScreen(this.termConditionList, this.couponModel,
      this.storeLogoImageUrl, this.storeName,this.salecode);

  @override
  State<CouponDetailsScreen> createState() => _CouponDetailsScreenState();
}

class _CouponDetailsScreenState extends State<CouponDetailsScreen> {
  String result = '';
  TextEditingController _controller = TextEditingController();
  bool isLoading = false;
  int user_Id = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
    _controller = TextEditingController(text: '1'); // Set initial text to "1"
  }

  int itemCount = 1;
  String couponCode = '';
  bool couponApplied = false;

  void increment() {
    setState(() {
      int numberOfCoupon = int.parse(widget.couponModel.numberOfCoupon);
      if (itemCount < numberOfCoupon) {
        itemCount++;
      }
    });
  }

  void decrement() {
    setState(() {
      if (itemCount > 1) {
        itemCount--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.blueBG,
      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        centerTitle: true,
        title: Text(
          "Coupon Details",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Container(
        height:double.maxFinite,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              MyColors.blueBG,
              MyColors.blueBG, // Add more colors if needed
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Container(
              // decoration: BoxDecoration(
              //   gradient: LinearGradient(
              //     colors: [Colors.blue, Colors.blue], // Define the colors for the gradient
              //     begin: Alignment.topLeft, // Define the starting point of the gradient
              //     end: Alignment.bottomRight, // Define the ending point of the gradient
              //   ),
              //   //borderRadius: BorderRadius.circular(15), // Optional: Add border radius if needed
              // ),
              //color: MyColors.primaryColor,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Container(
                      //   margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      //   child: Card(
                      //     color: Colors.white,
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //     clipBehavior: Clip.antiAliasWithSaveLayer,
                      //     elevation: 2,
                      //     child: Column(
                      //       children: [
                      //         Row(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           children: [
                      //             Card(
                      //               margin: EdgeInsets.symmetric(vertical: 20),
                      //               color: Colors.white,
                      //               //shadowColor: Colors.blue,
                      //               elevation: 5,
                      //               clipBehavior: Clip.antiAliasWithSaveLayer,
                      //               shape: RoundedRectangleBorder(
                      //                 borderRadius: BorderRadius.circular(35),
                      //               ),
                      //               child: Container(
                      //                 height: 70,
                      //                 width: 70,
                      //                 // decoration: BoxDecoration(
                      //                 //   image: DecorationImage(
                      //                 //     image: NetworkImage(
                      //                 //         "${widget.storeLogoImageUrl}"),
                      //                 //     fit: BoxFit.fill,
                      //                 //   ),
                      //                 // ),
                      //                 child: CachedNetworkImage(
                      //                   imageUrl: "${widget.storeLogoImageUrl}",
                      //                   fit: BoxFit.fill,
                      //                   placeholder: (context, url) =>
                      //                       Image.asset(
                      //                         'assets/images/placeholder.png',
                      //                         // Path to your placeholder image asset
                      //                         fit: BoxFit.cover,
                      //                         width: double.infinity,
                      //                         height: double.infinity,
                      //                       ),
                      //                   errorWidget: (context, url, error) =>
                      //                       Center(child: Icon(Icons.error)),
                      //                 ),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //         SizedBox(
                      //           height: 10,
                      //         ),
                      //         Center(
                      //           child: Container(
                      //             width: 230,
                      //             child: Column(
                      //               crossAxisAlignment: CrossAxisAlignment.center,
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               children: [
                      //                 Text(
                      //                   "${widget.storeName}",
                      //                   textAlign: TextAlign.center,
                      //                   style: TextStyle(
                      //                       fontSize: 20,
                      //                       fontWeight: FontWeight.w600,
                      //                       color: MyColors.txtTitleColor),
                      //                 ),
                      //                 SizedBox(
                      //                   height: 10,
                      //                 ),
                      //                 Center(
                      //                   child: RichText(
                      //                     textAlign: TextAlign.center,
                      //                     // Center align the text
                      //                     text: TextSpan(
                      //                       style: TextStyle(
                      //                         fontSize: 14,
                      //                         fontWeight: FontWeight.w400,
                      //                         color: MyColors.txtTitleColor,
                      //                       ),
                      //                       children: [
                      //                         TextSpan(
                      //                           text:
                      //                           "${widget.couponModel
                      //                               .couponTitle}",
                      //                           style: TextStyle(
                      //                             fontWeight: FontWeight.bold,
                      //                           ),
                      //                         ),
                      //                         TextSpan(
                      //                           text:
                      //                           "\n${widget.couponModel
                      //                               .couponDescription} (${widget
                      //                               .couponModel
                      //                               .numberOfCoupon} coupons available now)",
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //         SizedBox(
                      //           height: 30,
                      //         ),
                      //
                      //         Container(
                      //           child: Row(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             children: <Widget>[
                      //               IconButton(
                      //                 icon: Icon(Icons.remove),
                      //                 onPressed: decrement,
                      //               ),
                      //               Text(
                      //                 itemCount.toString(),
                      //                 style: TextStyle(fontSize: 20),
                      //               ),
                      //               IconButton(
                      //                 icon: Icon(Icons.add),
                      //                 onPressed: increment,
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //         Container(
                      //             margin: EdgeInsets.symmetric(
                      //                 horizontal: 15, vertical: 15),
                      //             height: 55,
                      //             child: TextField(
                      //               enabled: true,
                      //               cursorColor: MyColors.blackBG,
                      //               controller: _controller,
                      //               minLines: 1,
                      //               style: TextStyle(color: MyColors.blackBG),
                      //               decoration: InputDecoration(
                      //                 hintText: 'QR Code',
                      //                 hintStyle:
                      //                 TextStyle(color: Color(0xFFDDDDDD)),
                      //                 suffixIcon: GestureDetector(
                      //                   onTap: () {
                      //                     // Handle suffix icon tap here
                      //                     String saleCode = _controller.text;
                      //                     String user_id = "${user_Id}";
                      //                     String store_id =
                      //                         "${widget.couponModel.storeId}";
                      //                     String coupon_id =
                      //                         "${widget.couponModel.id}";
                      //
                      //                     apply_coupon(
                      //                         user_id,
                      //                         store_id,
                      //                         saleCode,
                      //                         itemCount.toString(),
                      //                         coupon_id);
                      //                   },
                      //                   child: Icon(Icons.send,
                      //                       color: MyColors.blackBG),
                      //                 ),
                      //                 enabledBorder: OutlineInputBorder(
                      //                   gapPadding: 0,
                      //                   borderSide:
                      //                   BorderSide(color: MyColors.blackBG),
                      //                   borderRadius: BorderRadius.circular(10.0),
                      //                 ),
                      //                 focusedBorder: OutlineInputBorder(
                      //                   borderSide: BorderSide(
                      //                       color: MyColors.primaryColor),
                      //                   borderRadius: BorderRadius.circular(10.0),
                      //                 ),
                      //               ),
                      //             )),
                      //         Text(
                      //           "Or",
                      //           style: TextStyle(
                      //               fontSize: 15,
                      //               fontWeight: FontWeight.w600,
                      //               color: MyColors.txtTitleColor),
                      //         ),
                      //         Container(
                      //           margin: EdgeInsets.symmetric(
                      //               horizontal: 15, vertical: 15),
                      //           width: double.maxFinite,
                      //           height: 55,
                      //           //color:MyColors.blackBG,
                      //           decoration: BoxDecoration(
                      //             border: Border.all(
                      //               color: MyColors.primaryColor,
                      //               // Color of the border
                      //               width: 1, // Width of the border
                      //             ),
                      //             borderRadius: BorderRadius.circular(
                      //                 10), // Optional: For rounded corners
                      //           ),
                      //
                      //           child: InkWell(
                      //             onTap: () async {
                      //               var res = await Navigator.push(
                      //                   context,
                      //                   MaterialPageRoute(
                      //                     builder: (context) =>
                      //                     const SimpleBarcodeScannerPage(),
                      //                   ));
                      //               setState(() {
                      //                 if (res is String) {
                      //                   result = res;
                      //                   if (result != "-1") {
                      //                     print("$result");
                      //                     String saleCode = result;
                      //                     String user_id = "${user_Id}";
                      //                     String store_id =
                      //                         "${widget.couponModel.storeId}";
                      //                     _controller.text = result;
                      //                     // apply_coupon(user_id, store_id,
                      //                     //     saleCode, itemCount.toString());
                      //                     // Navigator.push(
                      //                     //     context,
                      //                     //     MaterialPageRoute(
                      //                     //       builder: (context) =>
                      //                     //           ScanCodeScreen(result),
                      //                     //     ));
                      //                   } else {
                      //                     showSnackBar(
                      //                         context, "QR code not scanned");
                      //                   }
                      //                 }
                      //               });
                      //             },
                      //             child: Center(
                      //               child: Text(
                      //                 'Scan Qr Code',
                      //                 style: TextStyle(
                      //                     color: MyColors.primaryColor,
                      //                     fontSize: 17,
                      //                     fontWeight: FontWeight.bold),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //
                      //
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // Container(
                      //   margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                      //   child: TermConditionWidget(widget.termConditionList),
                      // ),
                      // SizedBox(
                      //   height: 40,
                      // ),
                      Container(
                        height: 450,
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: CouponCard(
                          backgroundColor: MyColors.whiteBG,
                          curveAxis: Axis.horizontal,
                          //height: MediaQuery.of(context).size.height,
                          firstChild: Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                Card(
                                  margin: EdgeInsets.only(top: 20, bottom: 10),
                                  color: Colors.white,
                                  //shadowColor: Colors.blue,
                                  elevation: 5,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(35),
                                  ),
                                  child: Container(
                                    height: 70,
                                    width: 70,
                                    child: CachedNetworkImage(
                                      imageUrl: "${widget.storeLogoImageUrl}",
                                      fit: BoxFit.fill,
                                      placeholder: (context, url) => Image.asset(
                                        'assets/images/placeholder.png',
                                        // Path to your placeholder image asset
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Center(child: Icon(Icons.error)),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    width: 250,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${widget.storeName}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color: MyColors.txtTitleColor),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Stack(
                                          children: [
                                            Container(
                                              width: 300,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                  color: Colors.blue,
                                                  // Set the color of the border
                                                  width:
                                                      1, // Set the width of the border
                                                ),
                                              ),
                                              child: RichText(
                                                textAlign: TextAlign.center,
                                                // Center align the text
                                                text: TextSpan(
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w400,
                                                    color: MyColors.txtTitleColor,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          "${widget.couponModel.couponTitle}",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    // TextSpan(
                                                    //   text: "\n${widget.couponModel.couponDescription} (${widget.couponModel.numberOfCoupon} coupons available now)",
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          secondChild: Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: Card(
                                    borderOnForeground: false,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    //clipBehavior: Clip.antiAliasWithSaveLayer,
                                    elevation: 5,
                                    color: MyColors.blueBG,
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                              "Available Coupon",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.normal),
                                            ),
                                          ),
                                          Container(
                                            width: 80,
                                            padding: EdgeInsets.only(top: 10,bottom: 10,right: 10,left: 20),
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.only(
                                                    topLeft: Radius.circular(100),
                                                    topRight: Radius.circular(15),
                                                    bottomRight: Radius.circular(15),

                                                  ),
                                            ),
                                            child: Center(
                                              child: Text(

                                                "${widget.couponModel.numberOfCoupon}",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 15),
                                    height: 65,
                                    child: TextField(
                                      enabled: true,
                                      readOnly: true,
                                      cursorColor: MyColors.blackBG,
                                      controller: _controller,
                                      minLines: 1,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(color: MyColors.blackBG),
                                      decoration: InputDecoration(
                                        hintText: 'Enter Coupon',
                                        hintStyle: TextStyle(
                                            color: MyColors.txtDescColor),
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            // Handle suffix icon tap here
                                            String itemCount = _controller.text;
                                            String user_id = "${user_Id}";
                                            String store_id =
                                                "${widget.couponModel.storeId}";
                                            String coupon_id =
                                                "${widget.couponModel.id}";
                                            String saleCode =
                                                "${widget.salecode}";

                                            apply_coupon(
                                                user_id,
                                                store_id,
                                                saleCode,
                                                itemCount.toString(),
                                                coupon_id);
                                          },
                                          child: Card(
                                            color: Colors.red,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            elevation: 15,
                                            child: Container(
                                              width: 100,
                                              //margin: EdgeInsets.all(5),
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Redeem",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          gapPadding: 0,
                                          borderSide:
                                              BorderSide(color: MyColors.blackBG),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: MyColors.primaryColor),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
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
      ),
    );
  }

  Future<void> getUserDetails() async {
    // SharedPref sharedPref=new SharedPref();
    // userName = (await SharedPref.getUser()).name;
    UserModel n = await SharedPref.getUser();
    print("getUserDetails: " + n.name);
    setState(() {
      user_Id = n.id;
    });
  }

  Future<void> apply_coupon(String user_id, String store_id, String qrcode,
      String couponCount, String coupon_id) async {
    if (qrcode.isEmpty) {
      showErrorMessage(context, message: 'Please fill sales code');
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });
      final body = {
        "user_id": user_id,
        "store_id": store_id,
        "qrcode": qrcode,
        "qty": couponCount,
        "coupon_id": coupon_id
      };
      print(
          'apply_coupon data: user_id: $user_id store_id: $store_id qrcode": $qrcode qty: $couponCount coupon_id: $coupon_id');
      final response = await ApiServices.apply_coupon(context, body);

      // Check if the response is null or doesn't contain the expected data
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        String msg = response['msg'];
        final data = response['data'];
        // Ensure that the response data is in the expected format
        if (data != null && data is Map<String, dynamic>) {
          print('apply_coupon data: $data');

          navigateToSuccessScreen("$msg");
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
      print('apply_coupon error: $e');
      // Handle error
      //showErrorMessage(context, message: 'An error occurred: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> navigateToSuccessScreen(String msg) async {
    //showSuccessMessage(context, message: msg);
    Navigator.pop(context);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SuccessScreen("$msg")),
    );

    // final route = MaterialPageRoute(
    //   builder: (context) => SuccessScreen(msg),
    // );
    //
    // await Navigator.push(context, route);
  }
}

Widget buildTextField(
    String labelText, String placeholder, bool isPasswordTextField) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 35.0),
    child: TextField(
      //obscureText: isPasswordTextField ? showPassword : false,
      decoration: InputDecoration(
          suffixIcon: isPasswordTextField
              ? IconButton(
                  onPressed: () {},
                  // onPressed: () {
                  //   setState(() {
                  //     showPassword = !showPassword;
                  //   });
                  // },
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: Colors.grey,
                  ),
                )
              : null,
          contentPadding: EdgeInsets.only(bottom: 3),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          )),
    ),
  );
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
              color: MyColors.primaryColor,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              '$msg!',
              style: TextStyle(
                fontSize: 24,
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
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
