import 'dart:ffi';
import 'package:discount_deals/helper/other_function.dart';
import 'package:discount_deals/helper/shared_pref.dart';
import 'package:discount_deals/model/coupon_model.dart';
import 'package:discount_deals/model/terms_condition_model.dart';
import 'package:discount_deals/model/user_model.dart';
import 'package:discount_deals/services/api.dart';
import 'package:discount_deals/services/api_services.dart';
import 'package:discount_deals/theme/theme.dart';
import 'package:discount_deals/ui/coupon_details_screen.dart';
import 'package:discount_deals/ui/membership_plan_screen.dart';
import 'package:discount_deals/utils/snackbar_helper.dart';
import 'package:discount_deals/widget/coupon_card.dart';
import 'package:discount_deals/widget/doted_line.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AllCouponsWidget extends StatefulWidget {
  final List<CouponModel> couponsList;
  List<TermConditionModel> termConditionList = [];
  String storeLogoImageUrl = "";
  String storeName = '';
  String premium = '';
  String storeQR = '';

  AllCouponsWidget(this.couponsList, this.termConditionList,
      this.storeLogoImageUrl, this.storeName, this.premium, this.storeQR);

  @override
  State<AllCouponsWidget> createState() => _AllCouponsWidgetState();
}

class _AllCouponsWidgetState extends State<AllCouponsWidget> {
  bool _isLoading = false;
  int userId = 0;
  String result = "";
  String gatewayStatus = "";
  String externalStatus = "";

  @override
  void initState() {
    super.initState();

    SharedPref.getGatewayStatus().then((gateway) {
      gatewayStatus = gateway;
      print("gatewayStatus status: " + gatewayStatus);
    }).catchError((error) {
      print('Failed to get gateway status: $error');
    });

    SharedPref.getExternalLinkStatus().then((external) {
      externalStatus = external;
      print("gatewayStatus externalStatus: " + externalStatus);
    }).catchError((error) {
      print('Failed to get gateway status: $error');
    });

    getUserDetails();
    _fetchData();
  }

  _launchExternalMambership(String user_id) async {
    String url = '$externalPaymentGateway';

    // Check if any of the URLs can be launched
    if (await canLaunch(url)) {
      print('Launching map application');
      await launch(url);
    } else {
      throw 'Could not launch map application';
    }
  }

  Future<void> _fetchData() async {
    // Set _isLoading to true when starting to fetch data
    setState(() {
      _isLoading = true;
    });

    try {
      await Future.delayed(Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      // Handle error if necessary
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: MyColors.primaryColor,
              ),
            )
          : widget.couponsList.isEmpty
              ? _buildNoCouponsWidget()
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: widget.couponsList.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final CouponModel coupon = widget.couponsList[index];

                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      constraints: BoxConstraints(maxHeight: 105.0),
                      // Set your maximum height here

                      child: Center(
                        child: CouponCard(
                          backgroundColor: MyColors.primaryColor,
                          curveAxis: Axis.vertical,
                          //height: 0,
                          firstChild: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          '${coupon.couponTitle}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.clip,
                                          ),
                                        ),
                                      ),
                                    ]),
                                SizedBox(
                                  height: 5,
                                ),
                                DottedLine(
                                  height: 2,
                                  color: Colors.white,
                                  width: double.infinity,
                                  dashWidth: 6.0,
                                  dashSpacing: 6.0,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        'Offer:-\n${coupon.couponDescription}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      'Coupons\n${coupon.numberOfCoupon}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Container(
                          //   margin: EdgeInsets.symmetric(
                          //       horizontal: 20, vertical: 10),
                          //   child: Text(
                          //     "${coupon.couponTitle}\n(${coupon.numberOfCoupon} coupons)",
                          //     textAlign: TextAlign.start,
                          //     style: TextStyle(
                          //         fontSize: 14,
                          //         color: MyColors.whiteBG,
                          //         fontWeight: FontWeight.w700,
                          //         //overflow: TextOverflow.ellipsis
                          //     ),
                          //     //maxLines: 2,
                          //   ),
                          // ),
                          secondChild: Container(
                            decoration: BoxDecoration(
                              color: MyColors.blackBG,
                            ),
                            child: Center(
                              child: Card(
                                elevation: 2,
                                color: MyColors.blackBG,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                    color: MyColors.primaryColor,
                                    width: 1.0,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 15,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      if (userId == 0) {
                                        NavigationUtil.navigateToLogin(context);
                                      } else {
                                        if (gatewayStatus == "true") {
                                          if (coupon.numberOfCoupon == "0") {
                                            navigateToMaterialPageRoute(
                                                context, '$userId');
                                          } else {
                                            user_details("$userId", coupon);
                                          }
                                        } else {
                                          showErrorMessage(context,
                                              message:
                                                  "Currently, coupons are not available for this store.");
                                        }
                                      }
                                    },
                                    child: Text(
                                      'Redeem\nNow',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
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
    });
  }

  Widget _buildNoCouponsWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            width: 150,
            height: 50,
            child: Image.asset('assets/vector/blank.png')),
        // Assuming you have an image asset for 'No coupons available'
        SizedBox(height: 16),
        Text(
          'No coupons available',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w200,
          ),
        ),
      ],
    );
  }

  Future<void> navigateToCouponDetailsScreen(
      BuildContext context,
      List<TermConditionModel> termConditionList,
      CouponModel couponModel,
      String storeLogoImageUrl,
      String storeName,
      String qrStore) async {
    // var res = await Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => const SimpleBarcodeScannerPage(),
    //     ));
    // setState(() async {
    //   if (res is String) {
    //     result = res.trim();
    //     if (result != "-1") {
    //       print("qrcode: $result : $qrStore");
    //
    //       if (result == "$qrStore") {
    //         final route = MaterialPageRoute(
    //           builder: (context) => CouponDetailsScreen(termConditionList,
    //               couponModel, storeLogoImageUrl, storeName, result),
    //         );
    //
    //         await Navigator.push(context, route);
    //       } else {
    //         showSnackBar(context, "Invalid QR code");
    //       }
    //     } else {}
    //   }
    // });
  }

  Future<void> navigateToMaterialPageRoute(
      BuildContext context, String user_id) async {
    // showErrorMessage(context,
    //     message: "First you buy plan");

    if (externalStatus == "true") {
      _launchExternalMambership('$user_id');
    } else {
      final route =
          MaterialPageRoute(builder: (context) => MembershipPlansUI());
      await Navigator.push(context, route);
    }
  }

  Future<void> user_details(String user_id, CouponModel coupon) async {
    try {
      final body = {
        "user_id": user_id,
      };
      final response = await ApiServices.user_details(context, body);

      // Check if the response is null or doesn't contain the expected data
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final data = response['data'];
        // Ensure that the response data is in the expected format
        if (data != null && data is Map<String, dynamic>) {
          final user = UserModel.fromMap(data);

          if (user != null) {
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
            widget.premium = user.premium;

            if (widget.premium == "true") {
              navigateToCouponDetailsScreen(
                  context,
                  widget.termConditionList,
                  coupon,
                  widget.storeLogoImageUrl,
                  widget.storeName,
                  widget.storeQR);
            } else {
              navigateToMaterialPageRoute(context, '$user_id');
            }
          } else {
            // Handle null user
            showErrorMessage(context, message: 'User data is invalid');
          }
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
    } finally {}
  }
}
