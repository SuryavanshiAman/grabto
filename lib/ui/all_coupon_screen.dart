import 'package:discount_deals/helper/shared_pref.dart';
import 'package:discount_deals/model/store_model.dart';
import 'package:discount_deals/model/user_model.dart';
import 'package:discount_deals/services/api_services.dart';
import 'package:discount_deals/ui/coupon_fullview_screen.dart';
import 'package:discount_deals/widget/store_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../theme/theme.dart';


class AllCouponScreen extends StatefulWidget {
  String appBarName;
  String store_limit;
  String cat_id;
  String subcat_id;
  String offer_id;
  String trending_status;
  String recent_status;
  String topcollection_status;
  String city_id;
  String localtiy_id;

  AllCouponScreen(
      this.appBarName,
      this.store_limit,
      this.cat_id,
      this.subcat_id,
      this.offer_id,
      this.trending_status,
      this.recent_status,
      this.topcollection_status,
      this.city_id,
      this.localtiy_id);

  @override
  State<AllCouponScreen> createState() => _AllCouponScreenState();
}

class _AllCouponScreenState extends State<AllCouponScreen> {
  List<StoreModel> storeList = [];
  bool isLoading = false; // Add a isLoading flag

  @override
  void initState() {
    super.initState();

    fetchStores(
      "",
      widget.store_limit,
      widget.cat_id,
      widget.subcat_id,
      widget.offer_id,
      widget.trending_status,
      widget.recent_status,
      widget.topcollection_status,
      widget.city_id,
      widget.localtiy_id,
    );
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
          "" + widget.appBarName,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // SizedBox(height: 10),
                  // Container(
                  //   height: 46,
                  //   padding: EdgeInsets.symmetric(horizontal: 20),
                  //   child: Material(
                  //     elevation: 1,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(20),
                  //     ),
                  //     child: Container(
                  //       padding: const EdgeInsets.all(10),
                  //       decoration: ShapeDecoration(
                  //         color: MyColors.searchBg,
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(20),
                  //         ),
                  //       ),
                  //       child: Row(
                  //         children: [
                  //           Icon(
                  //             Icons.search,
                  //             color: MyColors.primaryColor,
                  //           ),
                  //           SizedBox(width: 10),
                  //           Expanded(
                  //             child: TextField(
                  //               decoration: InputDecoration(
                  //                 hintText: 'Search',
                  //                 border: InputBorder.none,
                  //                 isDense: true,
                  //                 contentPadding: EdgeInsets.zero,
                  //               ),
                  //               style: TextStyle(
                  //                 color: Color(0x993C3C43),
                  //                 fontSize: 17,
                  //               ),
                  //               onChanged: (value) {
                  //                 // Handle search
                  //               },
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Expanded(
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: MyColors.primaryColor,
                            ),
                          )
                        : storeList.isEmpty
                            ? _buildNoDataWidget()
                            : StoreWidget(storeList),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataWidget() {
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

  Future<void> fetchStores(
      String user_id,
      String store_limit,
      String cat_id,
      String subcat_id,
      String offer_id,
      String trending_status,
      String recent_status,
      String topcollection_status,
      String city_id,
      String localtiy_id) async {
    setState(() {
      isLoading = true;
    });
    try {
      final body = {
        "user_id": "$user_id",
        "store_limit": "$store_limit",
        "cat_id": "$cat_id",
        "subcat_id": "$subcat_id",
        "offer_id": "$offer_id",
        "trending_status": "$trending_status",
        "recent_status": "$recent_status",
        "topcollection_status": "$topcollection_status",
        "city_id": "$city_id",
        //"city_id": "9",
        "locality_id": "$localtiy_id",
      };
      final response;

      if (widget.appBarName == "Trending Restaurants") {
        response = await ApiServices.trending_store(body);
      } else {
        response = await ApiServices.all_store(body);
      }

      if (response != null) {
        setState(() {
          storeList = response;
          //isLoading = false; // Set isLoading to false when data is fetched
        });
      }
    } catch (e) {
      print('fetchStores: $e');
      //isLoading = false; // Set isLoading to false in case of error
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
