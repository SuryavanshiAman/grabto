import 'package:discount_deals/helper/shared_pref.dart';
import 'package:discount_deals/model/store_model.dart';
import 'package:discount_deals/model/user_model.dart';
import 'package:discount_deals/services/api_services.dart';
import 'package:discount_deals/theme/theme.dart';
import 'package:discount_deals/widget/store_widget.dart';
import 'package:flutter/material.dart';

class SortListBottamWidget extends StatefulWidget {
  @override
  State<SortListBottamWidget> createState() => _SortListBottamWidgetState();
}

class _SortListBottamWidgetState extends State<SortListBottamWidget> {
  List<StoreModel> storeList = [];
  bool isLoading = true;

  int userId = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.backgroundBg,
      //child: SortListWidget(),
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(MyColors.primaryColor),
                strokeWidth: 4,
              ),
            )
          : storeList.isEmpty
          ? Center(child: _buildNoDataWidget())
          :   StoreWidget(storeList),
    );
  }

  Widget _buildNoDataWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            width: 150,
            height: 100,
            child: Image.asset('assets/vector/blank.png')),
        // Assuming you have an image asset for 'No coupons available'
        SizedBox(height: 16),
        Text(
          'No Bookmark Available',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w200,
          ),
        ),
      ],
    );
  }

  Future<void> getUserDetails() async {
    // SharedPref sharedPref=new SharedPref();
    // userName = (await SharedPref.getUser()).name;
    UserModel n = await SharedPref.getUser();
    print("getUserDetails: " + n.name);
    setState(() {
      userId = n.id;
      fetchWishlistStores("$userId");
    });
  }

  Future<void> fetchWishlistStores(String user_id) async {
    try {
      final body = {"user_id": "$user_id"};
      final response = await ApiServices.wishlist_show(body);
      if (response != null) {
        setState(() {
          storeList = response;
          isLoading = false; // Set isLoading to false when data is fetched
        });
      }else{
        setState(() {
          isLoading = false; // Set isLoading to false when data is fetched
        });
      }
    } catch (e) {
      print('fetchStores: $e');
      setState(() {
        isLoading = false; // Set isLoading to false when data is fetched
      }); // Set isLoading to false in case of error
    }
  }
}

//sort List
class SortListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 10, // Replace with your actual number of cards
        shrinkWrap: true,
        //physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) {
              //   return AllCouponScreen(
              //       "Unlimited/Buffet", "Unlimited Buffet", 1);
              // }));
            },
            child: Container(
              margin: EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 10),
              child: Card(
                color: Colors.white,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  margin: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  "https://rishikeshcamps.in/wp-content/uploads/2023/05/restaarant.jpg"),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5, left: 5, bottom: 2),
                        child: Row(
                          children: [
                            Container(
                              child: Container(
                                child: Text(
                                  'DigiCoders Unlimited / Buffet',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.txtTitleColor,
                                    fontSize: 16,
                                    overflow: TextOverflow.ellipsis,
                                    //fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 0, left: 5, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '11 spot available',
                              style: TextStyle(
                                //fontWeight: FontWeight.bold,
                                color: MyColors.txtDescColor2,
                                fontSize: 12,
                                overflow: TextOverflow.ellipsis,
                                //fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '674 Redeemed',
                              style: TextStyle(
                                //fontWeight: FontWeight.bold,
                                color: Colors.green,
                                fontSize: 12,
                                overflow: TextOverflow.ellipsis,
                                //fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
