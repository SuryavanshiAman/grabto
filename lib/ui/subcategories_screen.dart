import 'package:discount_deals/helper/shared_pref.dart';
import 'package:discount_deals/model/sub_categories_model.dart';
import 'package:discount_deals/model/user_model.dart';
import 'package:discount_deals/services/api_services.dart';
import 'package:discount_deals/theme/theme.dart';
import 'package:discount_deals/ui/all_coupon_screen.dart';
import 'package:discount_deals/widget/sub_categories_card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubCategoriesScreen extends StatefulWidget {
  String appBarName;
  int category_id;

  SubCategoriesScreen(this.appBarName, this.category_id);

  @override
  State<SubCategoriesScreen> createState() => _SubCategoriesScreenState();
}

class _SubCategoriesScreenState extends State<SubCategoriesScreen> {
  List<SubCategoriesModel> subCategoriesList = [];

  bool isLoading = false;
  String cityId="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
    fetchSubCategories(widget.category_id);
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
                  //SizedBox(height: 10),
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
                  //               controller: searchText,
                  //               decoration: InputDecoration(
                  //                 hintText: 'Search',
                  //
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
                  SizedBox(height: 10),
                  Expanded(
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: MyColors.primaryColor,
                            ),
                          )
                        : subCategoriesList.isEmpty
                            ? _buildNoSubCategoryWidget()
                            : ListView.builder(
                                itemCount: subCategoriesList.length,
                                itemBuilder: (context, index) {
                                  SubCategoriesModel subCategoriesModel =
                                      subCategoriesList[index];
                                  return SubCategoriesCardWidget(
                                    imgUrl: subCategoriesModel.image,
                                    subcategoryName:
                                        subCategoriesModel.subcategory_name,
                                    spotAvailable: "",
                                    redeemed: "",
                                    onTap: () {
                                      navigateToAllCouponScreen(
                                        context,
                                        subCategoriesModel.subcategory_name,
                                        subCategoriesModel.category_id,
                                        subCategoriesModel.id,
                                      );
                                    },
                                  );
                                },
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

  Future<void> navigateToAllCouponScreen(BuildContext context,
      String subCategoryName, String category_id, int subcategory_id) async {
    final route = MaterialPageRoute(
        builder: (context) => AllCouponScreen("$subCategoryName", "",
            "$category_id", "$subcategory_id", "", "", "", "","$cityId",""));
    await Navigator.push(context, route);
  }

  Future<void> getUserDetails() async {
    // SharedPref sharedPref=new SharedPref();
    // userName = (await SharedPref.getUser()).name;
    UserModel n = await SharedPref.getUser();
    print("getUserDetails: " + n.name);
    setState(() {
      cityId = n.home_location;
    });

  }

  Future<void> fetchSubCategories(int category_id) async {
    setState(() {
      isLoading = true;
    });
    try {
      final body = {"category_id": "$category_id"};
      final response = await ApiServices.fetchSubCategories(body);
      if (response != null) {
        setState(() {
          subCategoriesList = response;
        });
      }
    } catch (e) {
      print('fetchSubCategories: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildNoSubCategoryWidget() {
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
}
