import 'dart:io';

import 'package:discount_deals/helper/razorpay_service.dart';
import 'package:discount_deals/helper/shared_pref.dart';
import 'package:discount_deals/model/plan_model.dart';
import 'package:discount_deals/model/user_model.dart';
import 'package:discount_deals/services/api_services.dart';
import 'package:discount_deals/ui/payment_screen.dart';
import 'package:discount_deals/utils/snackbar_helper.dart';
import 'package:discount_deals/widget/icon_text_widget.dart';
import 'package:discount_deals/widget/select_plan_widget.dart';
import 'package:flutter/material.dart';
import '../theme/theme.dart';

class MembershipPlansUI extends StatefulWidget {
  @override
  State<MembershipPlansUI> createState() => _MembershipPlansUIState();
}

class _MembershipPlansUIState extends State<MembershipPlansUI> {



  List<PlanModel> plans = [];
  PlanModel? selectedPlan;
  bool isLoading = false;
  String banner_image = '';
  String _appName = '';
  String userEmail = '';
  String userMobile = '';
  int userId = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    RazorpayService.initialize(); // Initialize Razorpay

    if (Platform.isIOS) {
      fetchPlans("ios");
    }else{
      fetchPlans("android");
    }



    api_membership_banner();
    getUserDetails();

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
  void dispose() {
    RazorpayService.dispose();
    super.dispose();
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
          "Membership Plans",
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
                        Colors.orange,
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
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            // Placeholder color while image is loading
                            image: DecorationImage(
                              image: NetworkImage("$banner_image"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: banner_image.isEmpty
                              ? Center(
                                  child: Container(
                                    color: Colors.black.withOpacity(0.5),
                                    // Adjust opacity as needed
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.orange,
                                        ),
                                        // Change the color
                                        strokeWidth: 4,
                                      ),
                                    ),
                                  ), // Show loading indicator if image URL is empty
                                )
                              : null, // Do not show loading indicator if image URL is provided
                        ),
                        SizedBox(height: 20.0),
                        Center(
                          child: Text(
                            'Select a Membership Plan',
                            style: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Center(
                          child: Text(
                            'Your access to premium restaurants\nand vip access',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        SelectPlanCard(
                          plans: plans,
                          onTap: onProceed,
                        ),
                        Container(
                          width: 100,
                          //height: 100,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black38, // Set the border color
                              width: 1.0, // Set the border width
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            children: [
                              IconTextWidget(
                                iconData: Icons.circle,
                                text: "Get up to 50% on Deals.",
                              ),
                              IconTextWidget(
                                iconData: Icons.circle,
                                text: "Get best deals near you.",
                              ),
                              IconTextWidget(
                                iconData: Icons.circle,
                                text:
                                    "Access to participate in various exciteing offers by Grabto.",
                              ),
                              IconTextWidget(
                                iconData: Icons.circle,
                                text:
                                    "Chance to enjoy great offers and save money.",
                              ),
                              IconTextWidget(
                                iconData: Icons.circle,
                                text:
                                    "Prime members have chance to save money on every deals.",
                              ),
                              IconTextWidget(
                                iconData: Icons.circle,
                                text:
                                    "Prime Membership is passport to  dive in the world of  great offers and deals.",
                              ),
                              IconTextWidget(
                                iconData: Icons.circle,
                                text:
                                    "Prime Member will enjoy exciting offers in various segments like Restaurant, Spa, Gym, Salon, Health checkup, Movie tickets, and Online Vouchers etc.",
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 17,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: ElevatedButton(
                            onPressed: () {
                              if (selectedPlan != null) {

                                navigateToPaymentSummary(context,selectedPlan);
                                //buyPlan(selectedPlan, "$userId");

                                // You can navigate to another screen or perform any other action here
                              }
                            },
                            child: Text(
                              "Proceed",
                              style:
                                  TextStyle(fontSize: 17, color: Colors.white),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  MyColors.btnBgColor),
                            ),
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

  void onProceed(PlanModel? plan) {
    setState(() {
      selectedPlan = plan; // Capture the selected plan
    });
  }







  Future<void> api_membership_banner() async {
    try {
      setState(() {
        isLoading = true;
      });
      final response = await ApiServices.api_membership_banner();

      // Check if the response is null or doesn't contain the expected data
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final data = response['data'];
        // Ensure that the response data is in the expected format
        if (data != null && data is Map<String, dynamic>) {
          //print('verify_otp data: $data');
          print("website: $data");

          setState(() {
            banner_image = data['image'] as String;
          });
        } else {
          // Handle invalid response data format
          showErrorMessage(context, message: 'Invalid response data format');
        }
      } else if (response != null) {
        String msg = response['msg'];
        // Handle unsuccessful response or missing 'res' field
        showErrorMessage(context, message: msg);
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      //print('verify_otp error: $e');
      // Handle error
      //showErrorMessage(context, message: 'An error occurred: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchPlans(String type) async {
    setState(() {
      isLoading = true;
    });
    try {
      final body = {
        "type": type,
      };

      final response = await ApiServices.show_plans(body);
      if (response != null) {
        setState(() {
          plans = response;
        });
        selectedPlan = plans.isNotEmpty ? plans.first : null;
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('fetchPlans: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void navigateToPaymentSummary(BuildContext context,PlanModel? selectedPlan,) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(selectedPlan),
      ),
    );
  }


}



