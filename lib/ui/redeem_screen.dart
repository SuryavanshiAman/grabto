import 'package:discount_deals/helper/shared_pref.dart';
import 'package:discount_deals/model/redeem_model.dart';
import 'package:discount_deals/model/user_model.dart';
import 'package:discount_deals/services/api.dart';
import 'package:discount_deals/theme/theme.dart';
import 'package:discount_deals/ui/buy_plan_screen.dart';
import 'package:flutter/material.dart';

import '../services/api_services.dart';

class RedeemHistoryScreen extends StatefulWidget {
  @override
  State<RedeemHistoryScreen> createState() => _RedeemHistoryScreenState();
}

class _RedeemHistoryScreenState extends State<RedeemHistoryScreen> {
  List<RedeemModel> redeemList = [];
  int userid = 0;
  bool isLoading = true; // Start with isLoading set to true

  @override
  void initState() {
    super.initState();
    getUserDetails();
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
          "Redeems",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                strokeWidth: 4,
              ),
            )
          : RedeemWidget(
              redeemList), // Render RedeemWidget only when isLoading is false
    );
  }

  Future<void> getUserDetails() async {
    UserModel n = await SharedPref.getUser();
    setState(() {
      userid = n.id;
      fetchRedeemHistory("$userid");
      print('fetchRedeemHistory: userid2 $userid');
    });
  }

  Future<void> fetchRedeemHistory(String user_id) async {
    print('fetchRedeemHistory: userid $user_id');
    try {
      final body = {"user_id": "$user_id"};
      final response = await ApiServices.apply_coupon_history(body);
      print('fetchRedeemHistory: response $response');
      if (response != null) {
        setState(() {
          redeemList = response;
          isLoading = false; // Set isLoading to false when fetching ends
        });
      } else {
        setState(() {
          isLoading = false; // Set isLoading to false when fetching ends
        });
      }
    } catch (e) {
      print('fetchRedeemHistory: $e');
      setState(() {
        isLoading = false; // Set isLoading to false in case of error
      });
    }
  }
}

class RedeemWidget extends StatelessWidget {
  final List<RedeemModel> redeemList;

  RedeemWidget(this.redeemList);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: redeemList.isEmpty
          ? _buildNoRedeemsWidget()
          : ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: redeemList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final redeem = redeemList[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: buildList(context, redeem),
                );
              },
            ),
    );
  }

  Widget buildList(BuildContext context, RedeemModel redeem) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Material(
        elevation: 4, // Adjust the elevation value as needed
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          width: double.infinity,
          //height: 120,
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Material(
                elevation: 4, // Set the elevation value as needed
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  width: 50,
                  height: 50,
                  //margin: const EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(width: 1, color: MyColors.primaryColor),
                    // Update color
                    image: DecorationImage(
                        image: NetworkImage(
                            redeem.logo.isEmpty ? image : redeem.logo),
                        // Access RedeemModel properties
                        fit: BoxFit.fill),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      redeem.storeName, // Access RedeemModel properties
                      style: TextStyle(
                          color: MyColors.blackBG, // Update color
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "${redeem.couponTitle} (${redeem.qty} coupon use)",
                            style: TextStyle(
                              color: MyColors.blackBG, // Update color
                              fontSize: 13,
                              letterSpacing: .3,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines:
                                null, // Allow the text to take multiple lines
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: <Widget>[
                        Text("Redeem on: ${redeem.createdAt}",
                            style: TextStyle(
                                color: Colors.grey, // Update color
                                fontSize: 12,
                                letterSpacing: .3)),
                      ],
                    ),
                    // const SizedBox(
                    //   height: 6,
                    // ),
                    // Row(
                    //   children: <Widget>[
                    //     Text("get ${redeem.couponDiscount}% off",
                    //         style: TextStyle(
                    //             color: MyColors.blackBG, // Update color
                    //             fontSize: 15,
                    //             fontWeight: FontWeight.bold,
                    //             letterSpacing: .3)),
                    //   ],
                    // ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoRedeemsWidget() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
                width: 200,
                height: 180,
                child: Image.asset('assets/vector/blank.png')),
          ),
          // Assuming you have an image asset for 'No coupons available'
          SizedBox(height: 16),
          Text(
            'No Redeems available',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w200,
            ),
          ),
        ],
      ),
    );
  }
}
