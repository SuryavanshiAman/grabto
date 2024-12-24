import 'package:cached_network_image/cached_network_image.dart';
import 'package:discount_deals/helper/shared_pref.dart';
import 'package:discount_deals/model/categories_model.dart';
import 'package:discount_deals/model/great_offer_model.dart';
import 'package:discount_deals/model/locality_model.dart';
import 'package:discount_deals/model/store_model.dart';
import 'package:discount_deals/model/sub_categories_model.dart';
import 'package:discount_deals/model/user_model.dart';
import 'package:discount_deals/services/api_services.dart';
import 'package:discount_deals/theme/theme.dart';
import 'package:discount_deals/ui/all_coupon_screen.dart';
import 'package:discount_deals/ui/booked_table_screen.dart';
import 'package:discount_deals/ui/coupon_fullview_screen.dart';
import 'package:discount_deals/ui/home_screen.dart';
import 'package:discount_deals/ui/search_screen.dart';
import 'package:discount_deals/ui/subcategories_screen.dart';
import 'package:discount_deals/ui/top_categories_screen.dart';
import 'package:discount_deals/ui/table_paybill_screen.dart';
import 'package:discount_deals/utils/dashed_line.dart';
import 'package:discount_deals/utils/snackbar_helper.dart';
import 'package:discount_deals/utils/time_slot.dart';
import 'package:discount_deals/widget/categories_card_widget.dart';
import 'package:discount_deals/widget/coupon_card.dart';
import 'package:discount_deals/widget/great_offer_widget.dart';
import 'package:discount_deals/widget/ticket_widget.dart';
import 'package:discount_deals/widget/title_description_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';
import 'package:discount_deals/model/pre_book_table_history.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'dart:io';


class HomeBottamScreen extends StatefulWidget {
  final Future<void> Function(String) onFetchMembership;

  HomeBottamScreen({required this.onFetchMembership});

  @override
  State<HomeBottamScreen> createState() => _HomeBottamScreenState();

  // Static getter to access the instance of _HomeBottomScreenState
  static _HomeBottamScreenState? get instance =>
      _HomeBottamScreenState.instance;
}

class _HomeBottamScreenState extends State<HomeBottamScreen> with WidgetsBindingObserver{
  final CarouselSliderController _controller = CarouselSliderController();

  List imageSlider = [];
  List<CategoriesModel> categories = [];
  List<StoreModel> trendingStoreList = [];
  List<StoreModel> recentStoreList = [];
  List<StoreModel> topCollectionStoreList = [];

  List<GreatOfferModel> greatOfferList1 = [];
  List<GreatOfferModel> greatOfferList2 = [];
  List<SubCategoriesModel> wahtyourchoicList = [];
  List<LocalityModel> localtiyList = [];
  String userName = '';
  bool isLoading = false;
  String cityId = "";
  List<PreBookTableHistoryModel> prebookofferlistHistory = [];
  int user_id=0;
  var topCategoriesController = TextEditingController();

  static _HomeBottamScreenState? _instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _instance = this;
    WidgetsBinding.instance.addObserver(this);
    getUserDetails();
  }
  @override
  void dispose() {
    // Unregistering the observer
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      // This is called when the app is resumed (comes to the foreground)
      print("App has resumed and is in the foreground!");
      // You can perform any action you want here, like refreshing data.
      if (user_id != 0) {
        UserPreBookTableHistory("");
      }
    }
  }

  static _HomeBottamScreenState? get instance => _instance;

  List<Map<String, dynamic>> topCollection = [
    {
      'imgUrl':
      'https://lh3.googleusercontent.com/p/AF1QipNEsQ1otg5pAlXzH58z_VyugPEYCZAGFXaSdI9q=w1080-h608-p-no-v0',
    },
    {
      'imgUrl': 'https://10619-2.s.cdn12.com/rests/original/110_536113530.jpg',
    },
    {
      'imgUrl':
      'https://content.jdmagicbox.com/comp/ahmedabad/r5/079pxx79.xx79.210130161448.z7r5/catalogue/-soz2ewh9fy.jpg?clr=',
    },
    {
      'imgUrl':
      'https://cdn.dribbble.com/users/36464/screenshots/2377234/media/e97032947d984e74b72da6421547e1b8.jpg',
    },
    {
      'imgUrl':
      'https://img.freepik.com/free-vector/buy-one-get-one-free-sticker-label-design_1017-16289.jpg'
    },
    {
      'imgUrl':
      'https://static2.bigstockphoto.com/4/2/4/large1500/424853807.jpg'
    },
    {
      'imgUrl':
      'https://img.freepik.com/free-vector/buy-one-get-one-free-sale-deals-background_1017-40813.jpg'
    },

    // Add more items as needed
  ];

  Future<void> getUserDetails() async {
    // SharedPref sharedPref=new SharedPref();
    // userName = (await SharedPref.getUser()).name;
    UserModel n = await SharedPref.getUser();
    print("getUserDetails: bottomHomeScreen " + n.home_location);
    UserPreBookTableHistory("${n.id}");
    setState(() {
      user_id=n.id;
      cityId = n.home_location;
    });
    await allApiCall(cityId);
  }

  Future<void> allApiCall(String _cityId) async {
    setState(() {
      isLoading = true;
    });
    try {
      // UserModel n = await SharedPref.getUser();
      // widget.onFetchMembership("${n.id}");
      // UserPreBookTableHistory("${n.id}");

      fetchShowSlider("${_cityId}");
      fetchCategories();
      fetchTrendingStore(
          "",
          "10",
          "",
          "",
          "",
          "1",
          "",
          "",
          "${_cityId}",
          "");
      fetchRecentStore(
          "",
          "10",
          "",
          "",
          "",
          "",
          "1",
          "",
          "${_cityId}",
          "");
      fetchTopCollectionStore(
          "",
          "10",
          "",
          "",
          "",
          "",
          "",
          "1",
          "${_cityId}",
          "");
      getName();
      fetchGreatOffers1("");
      fetchGreatOffers2("2");
      fetchWhatYourChoice();
      fetchCityLocality("${_cityId}");
    } catch (e) {
      print('Error in API calls: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _handleRefresh() async {
    try {
      // Simulate network fetch or database query
      await Future.delayed(Duration(seconds: 2));
      // Update the list of items and refresh the UI
      UserModel n = await SharedPref.getUser();
      widget.onFetchMembership("${n.id}");
      UserPreBookTableHistory("${n.id}");
      setState(() {
        allApiCall(cityId);
      });
    } catch (error) {
      // Handle the error, e.g., by displaying a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to refresh: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: MyColors.backgroundBg,
        constraints: BoxConstraints(
            maxWidth: MediaQuery
                .of(context)
                .size
                .width,
            maxHeight: MediaQuery
                .of(context)
                .size
                .height),
        child: RefreshIndicator(
          color: Colors.white,
          backgroundColor: MyColors.primaryColor,
          onRefresh: _handleRefresh,
          child: SingleChildScrollView(
            child: Column(
              children: [
                //Name Layout start
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 20, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Welcome,",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: MyColors.blackBG),
                          ),
                        ],
                      ),
                      Text(
                        "$userName",
                        style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w900,
                            color: MyColors.primaryColor),
                      ),
                    ],
                  ),
                ),
                //Name Layout end

                //Search bar start
                InkWell(
                  onTap: () {
                    _navigateToSearchScreen(context);
                  },
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    height: 46,
                    child: Material(
                      elevation: 1, // Set the elevation value as needed
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        height: 55,
                        padding: const EdgeInsets.all(10),
                        decoration: ShapeDecoration(
                          color: MyColors.searchBg,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              margin: EdgeInsets.only(right: 10),
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      width: 28,
                                      height: 28,
                                      child: Icon(
                                        Icons.search,
                                        color: MyColors.primaryColor,
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(
                              child: Text(
                                'Search',
                                style: TextStyle(
                                  color: Color(0x993C3C43),
                                  fontSize: 17,
                                  fontFamily: 'SF Pro Text',
                                  fontWeight: FontWeight.w400,
                                  height: 0.08,
                                  letterSpacing: -0.41,
                                ),
                              ),
                            ),
                            Container(
                              width: 18,
                              height: 18,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                //Search bar start

                SizedBox(
                  height: 25,
                ),

                //Slider bar start
                Visibility(
                  visible: imageSlider.isNotEmpty,
                  child: Center(
                    child: CarouselSlider(
                      carouselController: _controller,
                      items: imageSlider.map((json) {
                        return GestureDetector(
                          onTap: () {
                            print("url: " + json['image']);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CouponFullViewScreen(
                                            "${json['store_id']}")));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              imageUrl: json['image'],
                              fit: BoxFit.fill,
                              placeholder: (context, url) =>
                                  Image.asset(
                                    'assets/images/placeholder.png',
                                    // Path to your placeholder image asset
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                              errorWidget: (context, url, error) =>
                                  Center(child: Icon(Icons.error)),
                            ),
                            // Image.network(
                            //   json['image'],
                            //   errorBuilder: (context, error, stackTrace) {
                            //     return Center(
                            //       child: Image.asset(
                            //         'assets/images/placeholder.png',
                            //         // Path to your placeholder image asset
                            //         fit: BoxFit.cover,
                            //         width: double.infinity,
                            //         height: double.infinity,
                            //       ),
                            //     );
                            //   },
                            //   fit: BoxFit.cover,
                            // ),
                          ),
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 165,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        reverse: true,
                        disableCenter: true,
                        aspectRatio: 16 / 9,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        viewportFraction: 0.75,
                      ),
                    ),
                  ),
                ),
                //Slider bar end

                //categories start
                if(prebookofferlistHistory.isNotEmpty)
                  Container(
                    margin:
                    EdgeInsets.only(top: 25, left: 15, right: 15, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "My Booking",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                // Container(
                //   margin: EdgeInsets.symmetric(horizontal: 10),
                //   child: ClipPath(
                //     clipper: CouponClipper(
                //       borderRadius: 20,
                //       curveRadius: 20,
                //       curvePosition: 150,
                //       curveAxis: Axis.horizontal,
                //       clockwise: false,
                //     ),
                //     child: Container(
                //       height: 305,
                //       color: Color(0xFFf2f2f2),
                //       padding: EdgeInsets.all(15),
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.start,
                //         children: [
                //           Row(
                //             children: [
                //               Text(
                //                 "Confirmed",
                //                 style: TextStyle(color: Colors.green,
                //                     fontSize: 14, fontWeight: FontWeight.bold),
                //               ),
                //             ],
                //           ),
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //             children: [
                //               TitleDescriptionWidget(
                //                 title: 'Today',
                //                 description: '18 Oct 2024',
                //                 titleFontSize: 18,
                //                 descriptionFontSize: 14,
                //               ),
                //               TitleDescriptionWidget(
                //                 title: 'Dinner',
                //                 description: '06:30 PM',
                //                 titleFontSize: 18,
                //                 descriptionFontSize: 14,
                //               ),
                //               TitleDescriptionWidget(
                //                 title: 'for 2',
                //                 description: 'guests',
                //                 titleFontSize: 18,
                //                 descriptionFontSize: 14,
                //               ),
                //             ],
                //           ),
                //           SizedBox(height: 15),
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //             children: [
                //               TitleDescriptionWidget(
                //                 title: 'Bombay Mezbaan',
                //                 description: 'Vikas Nagar, Lucknow',
                //                 titleFontSize: 16,
                //                 descriptionFontSize: 13,
                //               ),
                //               Row(
                //                 children: [
                //                   // First icon in a circular container
                //                   Container(
                //                     margin: EdgeInsets.only(left: 8.0), // Space between the icons
                //                     decoration: BoxDecoration(
                //                       shape: BoxShape.circle,
                //                       color: Colors.red.shade100, // Light background color
                //                     ),
                //                     padding: EdgeInsets.all(8.0), // Padding for the icon
                //                     child: Icon(
                //                       Icons.phone, // Icon
                //                       color: Colors.red, // Icon color
                //                       size: 20, // Icon size
                //                     ),
                //                   ),
                //                   // Second icon in a circular container
                //                   Container(
                //                     margin: EdgeInsets.only(left: 8.0),
                //                     decoration: BoxDecoration(
                //                       shape: BoxShape.circle,
                //                       color: Colors.red.shade100, // Light background color
                //                     ),
                //                     padding: EdgeInsets.all(8.0), // Padding for the icon
                //                     child: Icon(
                //                       Icons.location_pin, // Icon
                //                       color: Colors.red, // Icon color
                //                       size: 20, // Icon size
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             ],
                //           ),
                //
                //
                //           DashedLine(
                //             color: MyColors.txtDescColor2,
                //             margin: EdgeInsets.symmetric(vertical: 22, horizontal: 10),
                //           ),
                //           Container(
                //             height: 45,
                //             decoration: BoxDecoration(
                //               border: Border.all(color: MyColors.primary, width: 1.0),
                //               borderRadius: BorderRadius.circular(10),
                //             ),
                //             padding: const EdgeInsets.only(
                //                 left: 15, right: 15, top: 5, bottom: 5),
                //             child: Row(
                //               crossAxisAlignment: CrossAxisAlignment.center,
                //               children: [
                //                 Expanded(
                //                   child: Text(
                //                     "Flat 20% Off on Total Bill",
                //                     style: TextStyle(
                //                       fontSize: 16,
                //                       fontWeight: FontWeight.bold,
                //                     ),
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //           SizedBox(height: 15),
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space the buttons evenly
                //             children: [
                //               // First button
                //               Expanded(
                //                 child: GestureDetector(
                //                   onTap: (){
                //                     Navigator.push(
                //                       context,
                //                       MaterialPageRoute(
                //                           builder: (context) => BookedTableScreen()),
                //                     );
                //                   },
                //                   child: Container(
                //                     margin: EdgeInsets.only(right: 10), // Space between the buttons
                //                     decoration: BoxDecoration(
                //                       color: MyColors.primaryColorLight, // Background color of the button
                //                       borderRadius: BorderRadius.circular(10), // Rounded corners
                //                     ),
                //                     padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Padding inside the button
                //                     child: Center(
                //                       child: Text(
                //                         'View details', // Button text
                //                         style: TextStyle(
                //                           fontWeight: FontWeight.bold,
                //                           color: MyColors.primaryColor, // Text color
                //                           fontSize: 16,
                //                         ),
                //                       ),
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //               // Second button
                //               Expanded(
                //                 child: Container(
                //                   margin: EdgeInsets.only(left: 10), // Space between the buttons
                //                   decoration: BoxDecoration(
                //                     color: Colors.grey.shade300, // Light background color for the button
                //                     borderRadius: BorderRadius.circular(10), // Rounded corners
                //                   ),
                //                   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Padding inside the button
                //                   child: Center(
                //                     child: Text(
                //                       'Pay bill now', // Button text
                //                       style: TextStyle(
                //                         fontWeight: FontWeight.bold,
                //                         color: Colors.grey, // Gray text color
                //                         fontSize: 16, // Text size
                //                       ),
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //
                //             ],
                //           ),
                //
                //
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                if(prebookofferlistHistory.isNotEmpty)
                  Container(
                    height: 270,
                    child: _buildOfferCard(prebookofferlistHistory),
                  ),

                // Column(
                //   children: [
                //     Container(
                //       height: 45,
                //       margin: EdgeInsets.symmetric(horizontal: 10),
                //       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                //       width: double.infinity,
                //       decoration: BoxDecoration(
                //         color: MyColors.offerCardColor,
                //         borderRadius: BorderRadius.only(
                //           topLeft: Radius.circular(20),
                //           topRight: Radius.circular(20),
                //           bottomLeft: Radius.circular(20),
                //           bottomRight: Radius.circular(20),
                //         ), // Side rounded corners
                //       ),
                //       child: Row(
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Text(
                //             "Flat 20% Off on Total Bill",
                //             style: TextStyle(
                //               fontSize: 18,
                //               fontWeight: FontWeight.bold,
                //               color: Color(
                //                   0xFFFFFFFF), // Black text color
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //     Container(
                //       margin: EdgeInsets.symmetric(horizontal: 30),
                //       padding: EdgeInsets.all(12.0),
                //       width: double.infinity,
                //       decoration: BoxDecoration(
                //         color: Colors.white, // Background color
                //         border: Border(
                //           left: BorderSide(color: MyColors.offerCardColor),  // Left border
                //           right: BorderSide(color:MyColors.offerCardColor), // Right border
                //           bottom: BorderSide(color: MyColors.offerCardColor), // Bottom border
                //           // No top border specified
                //         ),
                //         borderRadius: BorderRadius.only(
                //           topLeft: Radius.circular(0),
                //           topRight: Radius.circular(0),
                //           bottomLeft: Radius.circular(20),
                //           bottomRight: Radius.circular(20),
                //         ), // Bottom rounded corners
                //       ),
                //       child: Column(
                //         children: [
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //             children: [
                //               TitleDescriptionWidget(
                //                 title: 'Bombay Mezbaan',
                //                 description: 'Vikas Nagar, Lucknow',
                //                 titleFontSize: 16,
                //                 descriptionFontSize: 13,
                //               ),
                //               Row(
                //                 children: [
                //                   // First icon in a circular container
                //                   Container(
                //                     margin: EdgeInsets.only(left: 8.0),
                //                     decoration: BoxDecoration(
                //                       shape: BoxShape.circle,
                //                       color: Color(
                //                           0xFF6200EE), // Light background color
                //                     ),
                //                     padding: EdgeInsets.all(8.0),
                //                     child: Icon(
                //                       Icons.phone,
                //                       color: Colors.white,
                //                       // Secondary color for icons
                //                       size: 20,
                //                     ),
                //                   ),
                //                   // Second icon in a circular container
                //                   Container(
                //                     margin: EdgeInsets.only(left: 8.0),
                //                     decoration: BoxDecoration(
                //                       shape: BoxShape.circle,
                //                       color: Color(
                //                           0xFF6200EE), // Light background color
                //                     ),
                //                     padding: EdgeInsets.all(8.0),
                //                     child: Icon(
                //                       Icons.location_on,
                //                       // Corrected to Icons.location_on
                //                       color: Colors.white,
                //                       // Secondary color for icons
                //                       size: 20,
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             ],
                //           ),
                //           SizedBox(height: 15),
                //           DashedLine(
                //             color: Color(0xFF757575),
                //             // Text description color
                //             margin: EdgeInsets.symmetric(
                //                 vertical: 0, horizontal: 10),
                //           ),
                //           SizedBox(height: 10),
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //             children: [
                //               Column(
                //                 children: [
                //                   Row(
                //                     mainAxisAlignment: MainAxisAlignment.start, // Aligns the content to the start
                //                     children: [
                //                       Icon(
                //                         Icons.man, // Icon of your choice
                //                         color: MyColors.offerCardColor, // Icon color
                //                         size: 18.0, // Icon size
                //                       ),
                //                       SizedBox(width: 8.0), // Space between icon and text
                //                       Text(
                //                         "Numbers of guest's 2", // Text next to the icon
                //                         style: TextStyle(
                //                           fontSize: 14,
                //                           fontWeight: FontWeight.w500,
                //                           color: Colors.black, // Text color
                //                         ),
                //                       ),
                //                     ],
                //                   ),
                //                   SizedBox(height: 5),
                //                   Row(
                //                     mainAxisAlignment: MainAxisAlignment.start, // Aligns the content to the start
                //                     children: [
                //                       Icon(
                //                         Icons.calendar_month, // Icon of your choice
                //                         color: MyColors.offerCardColor, // Icon color
                //                         size: 18.0, // Icon size
                //                       ),
                //                       SizedBox(width: 8.0), // Space between icon and text
                //                       Text(
                //                         "08 Nov at 08:30 PM", // Text next to the icon
                //                         style: TextStyle(
                //                           fontSize: 14,
                //                           fontWeight: FontWeight.w500,
                //                           color: Colors.black, // Text color
                //                         ),
                //                       ),
                //                     ],
                //                   ),
                //                 ],
                //               ),
                //               TitleDescriptionWidget(
                //                 title: 'Status',
                //                 description: 'Confirmed',
                //                 titleFontSize: 14,
                //                 descriptionFontSize: 12,
                //                 titleFontWeight: FontWeight.w400,
                //                 descriptionFontWeight: FontWeight.bold,
                //                 descriptionColor: MyColors.offerCardColor,
                //               ),
                //             ],
                //           ),

                //           SizedBox(height: 15),
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //             children: [
                //               // First button
                //               Expanded(
                //                 child: GestureDetector(
                //                   onTap: () {
                //                     Navigator.push(
                //                       context,
                //                       MaterialPageRoute(
                //                         builder: (context) =>
                //                             BookedTableScreen(),
                //                       ),
                //                     );
                //                   },
                //                   child: Container(
                //                     margin: EdgeInsets.only(right: 10),
                //                     decoration: BoxDecoration(
                //                       color: MyColors.offerCardColor,
                //                       // Primary button color
                //                       borderRadius: BorderRadius.circular(10),
                //                     ),
                //                     padding: EdgeInsets.symmetric(
                //                         vertical: 10, horizontal: 20),
                //                     child: Center(
                //                       child: Text(
                //                         'View details',
                //                         style: TextStyle(
                //                           fontWeight: FontWeight.bold,
                //                           color: Color(0xFFFFFFFF),
                //                           // White text color
                //                           fontSize: 12,
                //                         ),
                //                       ),
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //               // Second button
                //               Expanded(
                //                 child: Container(
                //                   margin: EdgeInsets.only(left: 10),
                //                   decoration: BoxDecoration(
                //                     color: Colors.grey.shade300,
                //                     // Light background color for the button
                //                     borderRadius: BorderRadius.circular(10),
                //                   ),
                //                   padding: EdgeInsets.symmetric(
                //                       vertical: 10, horizontal: 20),
                //                   child: Center(
                //                     child: Text(
                //                       'Pay bill',
                //                       style: TextStyle(
                //                         fontWeight: FontWeight.bold,
                //                         color: Colors.grey, // Gray text color
                //                         fontSize: 12,
                //                       ),
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //             ],
                //           ),


                //         ],
                //       )
                //     ),
                //   ],
                // ),
                // Container(
                //   margin: EdgeInsets.symmetric(horizontal: 10),
                //   child: ClipPath(
                //     clipper: CouponClipper(
                //       borderRadius: 20,
                //       curveRadius: 20,
                //       curvePosition: 150,
                //       curveAxis: Axis.horizontal,
                //       clockwise: false,
                //     ),
                //     child: Material(
                //       elevation: 4,
                //       // Add elevation here
                //       borderRadius: BorderRadius.circular(20),
                //       // Match the border radius with the clipper
                //       child: Container(
                //         height: 305,
                //         color: Colors.green.shade50,
                //         // Background color for the card
                //         padding: EdgeInsets.all(15),
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.start,
                //           children: [
                //             Row(
                //               children: [
                //                 Text(
                //                   "Confirmed",
                //                   style: TextStyle(
                //                     color: Color(0xFF6200EE),
                //                     // Secondary color for text
                //                     fontSize: 14,
                //                     fontWeight: FontWeight.bold,
                //                   ),
                //                 ),
                //               ],
                //             ),
                //             Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //               children: [
                //                 TitleDescriptionWidget(
                //                   title: 'Bombay Mezbaan',
                //                   description: 'Vikas Nagar, Lucknow',
                //                   titleFontSize: 16,
                //                   descriptionFontSize: 13,
                //                 ),
                //                 Row(
                //                   children: [
                //                     // First icon in a circular container
                //                     Container(
                //                       margin: EdgeInsets.only(left: 8.0),
                //                       decoration: BoxDecoration(
                //                         shape: BoxShape.circle,
                //                         color: Color(
                //                             0xFF6200EE), // Light background color
                //                       ),
                //                       padding: EdgeInsets.all(8.0),
                //                       child: Icon(
                //                         Icons.phone,
                //                         color: Colors.white,
                //                         // Secondary color for icons
                //                         size: 20,
                //                       ),
                //                     ),
                //                     // Second icon in a circular container
                //                     Container(
                //                       margin: EdgeInsets.only(left: 8.0),
                //                       decoration: BoxDecoration(
                //                         shape: BoxShape.circle,
                //                         color: Color(
                //                             0xFF6200EE), // Light background color
                //                       ),
                //                       padding: EdgeInsets.all(8.0),
                //                       child: Icon(
                //                         Icons.location_on,
                //                         // Corrected to Icons.location_on
                //                         color: Colors.white,
                //                         // Secondary color for icons
                //                         size: 20,
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //               ],
                //             ),
                //             SizedBox(height: 15),
                //             Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //               children: [
                //                 TitleDescriptionWidget(
                //                   title: 'Today',
                //                   description: '18 Oct 2024',
                //                   titleFontSize: 18,
                //                   descriptionFontSize: 14,
                //                 ),
                //                 TitleDescriptionWidget(
                //                   title: 'Dinner',
                //                   description: '06:30 PM',
                //                   titleFontSize: 18,
                //                   descriptionFontSize: 14,
                //                 ),
                //                 TitleDescriptionWidget(
                //                   title: 'for 2',
                //                   description: 'guests',
                //                   titleFontSize: 18,
                //                   descriptionFontSize: 14,
                //                 ),
                //               ],
                //             ),
                //             DashedLine(
                //               color: Color(0xFF757575),
                //               // Text description color
                //               margin: EdgeInsets.symmetric(
                //                   vertical: 22, horizontal: 10),
                //             ),
                //             Container(
                //               height: 45,
                //               decoration: BoxDecoration(
                //                 border: Border.all(
                //                     color: Color(0xFF6200EE), width: 1.0),
                //                 // Primary border color
                //                 borderRadius: BorderRadius.circular(10),
                //               ),
                //               padding: const EdgeInsets.all(5),
                //               child: Row(
                //                 crossAxisAlignment: CrossAxisAlignment.center,
                //                 children: [
                //                   Expanded(
                //                     child: Text(
                //                       "Flat 20% Off on Total Bill",
                //                       style: TextStyle(
                //                         fontSize: 16,
                //                         fontWeight: FontWeight.bold,
                //                         color: Color(
                //                             0xFF000000), // Black text color
                //                       ),
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //             SizedBox(height: 15),
                //             Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //               children: [
                //                 // First button
                //                 Expanded(
                //                   child: GestureDetector(
                //                     onTap: () {
                //                       Navigator.push(
                //                         context,
                //                         MaterialPageRoute(
                //                           builder: (context) =>
                //                               BookedTableScreen(),
                //                         ),
                //                       );
                //                     },
                //                     child: Container(
                //                       margin: EdgeInsets.only(right: 10),
                //                       decoration: BoxDecoration(
                //                         color: Color(0xFF6200EE),
                //                         // Primary button color
                //                         borderRadius: BorderRadius.circular(10),
                //                       ),
                //                       padding: EdgeInsets.symmetric(
                //                           vertical: 10, horizontal: 20),
                //                       child: Center(
                //                         child: Text(
                //                           'View details',
                //                           style: TextStyle(
                //                             fontWeight: FontWeight.bold,
                //                             color: Color(0xFFFFFFFF),
                //                             // White text color
                //                             fontSize: 16,
                //                           ),
                //                         ),
                //                       ),
                //                     ),
                //                   ),
                //                 ),
                //                 // Second button
                //                 Expanded(
                //                   child: Container(
                //                     margin: EdgeInsets.only(left: 10),
                //                     decoration: BoxDecoration(
                //                       color: Colors.grey.shade300,
                //                       // Light background color for the button
                //                       borderRadius: BorderRadius.circular(10),
                //                     ),
                //                     padding: EdgeInsets.symmetric(
                //                         vertical: 10, horizontal: 20),
                //                     child: Center(
                //                       child: Text(
                //                         'Pay bill now',
                //                         style: TextStyle(
                //                           fontWeight: FontWeight.bold,
                //                           color: Colors.grey, // Gray text color
                //                           fontSize: 16,
                //                         ),
                //                       ),
                //                     ),
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ),
                // ),

                Container(
                  margin:
                  EdgeInsets.only(top: 25, left: 15, right: 15, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Categories",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      InkWell(
                        onTap: () {
                          navigateToTopCategoriesScreen();
                        },
                        child: Row(
                          children: [
                            Text(
                              "View All",
                              style: TextStyle(
                                  color: MyColors.txtDescColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.arrow_forward,
                              size: 15,
                              color: MyColors.primaryColor,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 125,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      CategoriesModel category = categories[index];
                      return CategoriesCardWidget(
                        imgUrl: category.image,
                        cateName: category.category_name,
                        onTap: () {
                          navigateToTopSubCategories(
                              context, category.category_name, category.id);
                        },
                      );
                    },
                    itemCount: categories.length,
                    //reverse: true,
                    //itemExtent: 100,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                //categories end

                //Great Offers start
                if (!greatOfferList1.isEmpty)
                  Container(
                    margin: EdgeInsets.only(
                        top: 25, left: 15, right: 15, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Great Offers",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                if (!greatOfferList1.isEmpty)
                  GreatOffersWidget(greatOfferList1, "${cityId}"),
                // SizedBox(
                //   height: 10,
                // ),
                // GreatOffersWidget(greatOfferList2),

                if (!localtiyList.isEmpty)
                  Container(
                    margin: EdgeInsets.only(
                        top: 25, left: 15, right: 15, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Popular Location",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                if (!localtiyList.isEmpty) LocationWidget(localtiyList),

                SizedBox(
                  height: 0,
                ),
                //GreatOffersWidget(greatOfferList2),
                //Great Offers end

                // //What your choice start
                // Container(
                //   margin: EdgeInsets.only(top: 25, left: 15, right: 15, bottom: 15),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text(
                //         "What your choice's",
                //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                //       ),
                //     ],
                //   ),
                // ),
                // YourChoiceHomeWidget(wahtyourchoicList),
                //What your choice start end

                //Trending Restrount start
                if (!trendingStoreList.isEmpty)
                  Container(
                    margin: EdgeInsets.only(
                        top: 25, left: 15, right: 15, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Trending Restaurants",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return AllCouponScreen(
                                      "Trending Restaurants",
                                      "",
                                      "",
                                      "",
                                      "",
                                      "1",
                                      "",
                                      "",
                                      "$cityId",
                                      "");
                                }));
                          },
                          child: Row(
                            children: [
                              Text(
                                "View All",
                                style: TextStyle(
                                    color: MyColors.txtDescColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.arrow_forward,
                                size: 15,
                                color: MyColors.primaryColor,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                if (!trendingStoreList.isEmpty)
                  TrendingRestruantWidget(trendingStoreList),
                //Trending Restrount end

                //Top collection start
                if (!recentStoreList.isEmpty)
                  Container(
                    margin: EdgeInsets.only(
                        top: 25, left: 15, right: 15, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recent Joined",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return AllCouponScreen(
                                      "Recent Joined",
                                      "",
                                      "",
                                      "",
                                      "",
                                      "",
                                      "1",
                                      "",
                                      "$cityId",
                                      "");
                                }));
                          },
                          child: Row(
                            children: [
                              Text(
                                "View All",
                                style: TextStyle(
                                    color: MyColors.txtDescColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.arrow_forward,
                                size: 15,
                                color: MyColors.primaryColor,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                if (!recentStoreList.isEmpty)
                  RecentJoinedWidget(recentStoreList),

                if (!topCollectionStoreList.isEmpty)
                  Container(
                    margin: EdgeInsets.only(
                        top: 25, left: 15, right: 15, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Top Collections",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return AllCouponScreen(
                                      "Top Collections",
                                      "",
                                      "",
                                      "",
                                      "",
                                      "",
                                      "",
                                      "1",
                                      "$cityId",
                                      "");
                                }));
                          },
                          child: Row(
                            children: [
                              Text(
                                "View All",
                                style: TextStyle(
                                    color: MyColors.txtDescColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.arrow_forward,
                                size: 15,
                                color: MyColors.primaryColor,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                if (!topCollectionStoreList.isEmpty)
                  TopCollectionWidget(topCollectionStoreList, 0.0),

                //TopCollectionWidget(topCollection, 0.0),
                //TopCollectionWidget(topCollection, 0.0),
                //Top collection end

                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOfferCard(
      List<PreBookTableHistoryModel> prebookofferlistHistory) {
    return SizedBox(
      // height: 270, // Adjust height based on card content
      child: PageView.builder(
        itemCount: prebookofferlistHistory.length,
        controller: PageController(viewportFraction: 1.0),
        // Controls card width
        itemBuilder: (context, index) {
          var offer = prebookofferlistHistory[index];

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Container(
                  height: 45,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  // width: double.infinity,
                  decoration: BoxDecoration(
                    color: MyColors.offerCardColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${offer.title}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  padding: EdgeInsets.all(12.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      left: BorderSide(color: MyColors.offerCardColor),
                      right: BorderSide(color: MyColors.offerCardColor),
                      bottom: BorderSide(color: MyColors.offerCardColor),
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     TitleDescriptionWidget(
                      //       title: offer.store_name,
                      //       description: offer.address,
                      //       titleFontSize: 16,
                      //       descriptionFontSize: 13,
                      //     ),
                      //     Row(
                      //       children: [
                      //         if(offer.mobile.isNotEmpty)
                      //           GestureDetector(
                      //             onTap: () {
                      //               _makePhoneCall(offer.mobile);
                      //             },
                      //             child: _buildIcon(Icons.phone),
                      //           ),
                      //         if(offer.map_link.isNotEmpty)
                      //           GestureDetector(
                      //             onTap: () {
                      //               _launchMaps(context, offer.map_link);
                      //             },
                      //             child: _buildIcon(Icons.location_on),
                      //           ),
                      //
                      //       ],
                      //     ),
                      //   ],
                      // ),
                      Row(
                        children: [
                          // Left side: Title and Description
                          Expanded(
                            flex: 2, // Takes up 50% of the width
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TitleDescriptionWidget(
                                title: offer.store_name,
                                description: offer.address,
                                titleFontSize: 16,
                                descriptionFontSize: 13,
                              ),
                            ),
                          ),

                          // Right side: Icons (Phone, Location)
                          Expanded(
                            flex: 1, // Takes up 50% of the width
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center, // Centers the icons horizontally
                              children: [
                                if (offer.mobile.isNotEmpty)
                                  GestureDetector(
                                    onTap: () {
                                      _makePhoneCall(offer.mobile);
                                    },
                                    child: _buildIcon(Icons.phone),
                                  ),
                                if (offer.map_link.isNotEmpty)
                                  GestureDetector(
                                    onTap: () {
                                      _launchMaps(context, offer.map_link);
                                    },
                                    child: _buildIcon(Icons.location_on),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      DashedLine(
                        color: Color(0xFF757575),
                        margin: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildRowWithIcon(
                                    icon: Icons.phone,
                                    text: "Number of guests: ${offer
                                        .no_of_guest}",
                                  ),
                                  SizedBox(height: 5),
                                  _buildRowWithIcon(
                                    icon: Icons.calendar_month,
                                    text: "${offer.booking_date} at ${offer
                                        .booking_time}",
                                  ),

                                ],
                              ),
                            ],
                          ),
                          TitleDescriptionWidget(
                            title: 'Status',
                            description: offer.table_status,
                            titleFontSize: 14,
                            descriptionFontSize: 12,
                            titleFontWeight: FontWeight.w400,
                            descriptionFontWeight: FontWeight.bold,
                            descriptionColor: MyColors.offerCardColor,
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BookedTableScreen("${offer.id}"),
                                  ),
                                );
                              },
                              child: _buildButton(
                                'View details',
                                MyColors.offerCardColor,
                                Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (isBookingTimePassed(
                                    offer.booking_date, offer.booking_time)) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TablePaybillScreen(
                                                offer, offer.store_name,
                                                offer.address)),
                                  );
                                }
                              },
                              child: _buildButton(
                                  'Pay bill', isBookingTimePassed(
                                  offer.booking_date, offer.booking_time)
                                  ? Colors.red
                                  : Colors.grey.shade300, isBookingTimePassed(
                                  offer.booking_date, offer.booking_time)
                                  ? Colors.white
                                  : Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _makePhoneCall(String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      print('Error: Phone number is null or empty');
      return;
    }
    final url = 'tel:$phoneNumber';
    print(
        'Phone number: $phoneNumber'); // Print the phone number to the console
    try {
      await launch('$url');
    } catch (e) {
      print('Error launching phone call: $e');
      // Handle the error gracefully, such as displaying an error message to the user
    }
  }

  _launchMaps(BuildContext context, storeMap_link) async {
    // Use the provided storeMap_link if available
    String url = storeMap_link;

    // Check if storeMap_link is empty or null
    if (storeMap_link == null || storeMap_link.isEmpty) {
      showErrorMessage(context, message: "Map link not available");
      return;
    }

    // Check if any of the URLs can be launched
    if (await canLaunch(url)) {
      print('Launching map application');
      await launch(url);
    }
    // else if (await canLaunch(googleUrl)) {
    //   print('Launching Google Maps');
    //   await launch(googleUrl);
    // }
    // else if (await canLaunch(appleUrl)) {
    //   print('Launching Apple Maps');
    //   await launch(appleUrl);
    // }
    else {
      throw 'Could not launch map application';
    }
  }


  Widget _buildIcon(IconData icon) {
    return Container(
      margin: EdgeInsets.only(left: 8.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF6200EE),
      ),
      padding: EdgeInsets.all(8.0),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildRowWithIcon({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, color: MyColors.offerCardColor, size: 18.0),
        SizedBox(width: 8.0),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildButton(String text, Color backgroundColor, Color textColor) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
            fontSize: 12,
          ),
        ),
      ),
    );
  }


  Future<void> getName() async {
    // SharedPref sharedPref=new SharedPref();
    // userName = (await SharedPref.getUser()).name;
    final UserModel n = await SharedPref.getUser();
    print("name: " + n.name);
    userName = n.name;
  }

  Future<void> navigateToTopCategoriesScreen() async {
    final route = MaterialPageRoute(
        builder: (context) => TopCategoriesScreen("Categories", categories));

    await Navigator.push(context, route);
  }

  Future<void> navigateToTopSubCategories(BuildContext context, String categoryName, int categoryId) async {
    final route = MaterialPageRoute(
      builder: (context) => SubCategoriesScreen(categoryName, categoryId),
    );

    await Navigator.push(context, route);
  }

  Future<void> fetchShowSlider(String city_id,) async {
    try {
      final body = {
        "city_id": "$city_id",
      };
      final response = await ApiServices.Api_show_slider(body);
      if (response != null) {
        setState(() {
          imageSlider = response;
        });
      } else {
        setState(() {
          imageSlider = [];
        });
      }
    } catch (e) {
      setState(() {
        imageSlider.clear();
      });
      print('ShowSliderError: $e');
    }
  }

  Future<void> fetchCategories() async {
    try {
      final response = await ApiServices.fetchCategories();
      if (response != null) {
        setState(() {
          categories = response;
        });
      }
    } catch (e) {
      print('fetchCategories: $e');
    }
  }

  Future<void> fetchRecentStore(String user_id,
      String store_limit,
      String cat_id,
      String subcat_id,
      String offer_id,
      String trending_status,
      String recent_status,
      String topcollection_status,
      String city_id,
      String localtiy_id) async {
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
        "locality_id": "$localtiy_id",
      };
      final response = await ApiServices.all_store(body);
      if (response != null) {
        print('fetchRecentStore: if');
        print('fetchRecentStore: response: $response');
        setState(() {
          recentStoreList = response;
        });
      } else {
        setState(() {
          recentStoreList = [];
        });
      }
    } catch (e) {
      print('fetchRecentStore bottom Home Screen: $e');
    }
  }

  Future<void> fetchTrendingStore(String user_id,
      String store_limit,
      String cat_id,
      String subcat_id,
      String offer_id,
      String trending_status,
      String recent_status,
      String topcollection_status,
      String city_id,
      String localtiy_id) async {
    try {
      final body = {
        "user_id": "$user_id",
        "store_limit": "$store_limit",
        "cat_id": "$cat_id",
        "subcat_id": "$subcat_id",
        "offer_id": "$offer_id",
        "trending_status": "$trending_status",
        // "recent_status": "$recent_status",
        // "topcollection_status": "$topcollection_status",
        "city_id": "$city_id",
        "locality_id": "$localtiy_id",
      };

      final response = await ApiServices.trending_store(body);
      if (response != null) {
        setState(() {
          trendingStoreList = response;
        });
      } else {
        setState(() {
          trendingStoreList = [];
        });
      }
    } catch (e) {
      print('fetchRecentStore: $e');
    }
  }

  Future<void> fetchTopCollectionStore(String user_id,
      String store_limit,
      String cat_id,
      String subcat_id,
      String offer_id,
      String trending_status,
      String recent_status,
      String topcollection_status,
      String city_id,
      String localtiy_id) async {
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
        "locality_id": "$localtiy_id",
      };
      final response = await ApiServices.all_store(body);
      if (response != null) {
        setState(() {
          topCollectionStoreList = response;
        });
      } else {
        setState(() {
          topCollectionStoreList = [];
        });
      }
    } catch (e) {
      print('fetchRecentStore: $e');
    }
  }

  Future<void> fetchGreatOffers1(String api_no) async {
    try {
      final response = await ApiServices.show_offer(api_no);
      if (response != null) {
        setState(() {
          greatOfferList1 = response;
        });
      }
    } catch (e) {
      print('fetchGreatOffers1: $e');
    }
  }

  Future<void> fetchGreatOffers2(String api_no) async {
    try {
      final response = await ApiServices.show_offer(api_no);
      if (response != null) {
        setState(() {
          greatOfferList2 = response;
        });
      }
    } catch (e) {
      print('fetchGreatOffers2: $e');
    }
  }

  Future<void> fetchWhatYourChoice() async {
    try {
      final body = {"category_id": ""};
      final response = await ApiServices.fetchSubCategories(body);
      if (response != null) {
        setState(() {
          wahtyourchoicList = response;
        });
      }
    } catch (e) {
      print('fetchSubCategories: $e');
    }
  }

  Future<void> fetchCityLocality(String city_id) async {
    try {
      final body = {"city_id": "$city_id"};

      final response = await ApiServices.ShowLocality(context, body);
      print('fetchCityLocality:response  $response');
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final data = response['data'] as List<dynamic>;

        localtiyList = data.map((e) {
          return LocalityModel.fromMap(e);
        }).toList();
      } else if (response != null) {
        String msg = response['msg'];

        // Handle unsuccessful response or missing 'res' field
        //showErrorMessage(context, message: msg);
      }
    } catch (e) {
      print('fetchCityLocality: $e');
    }
  }

  Future<void> _navigateToSearchScreen(BuildContext context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => SearchStoreScreen()));
  }

  Future<void> UserPreBookTableHistory(String user_id) async {
    print('UserPreBookTableHistory: user_id $user_id');

    setState(() {
      isLoading = true;
    });

    try {
      final body = {"user_id": "$user_id"};
      final response = await ApiServices.UserPreBookTableHistory(body);
      print('UserPreBookTableHistory: response $response');
      if (response != null) {
        setState(() {
          prebookofferlistHistory = response;
          isLoading = false; // Set isLoading to false when fetching ends
        });
      } else {
        setState(() {
          prebookofferlistHistory =[];
          isLoading = false; // Set isLoading to false when fetching ends
        });
      }
    } catch (e) {
      print('UserPreBookTableHistory: $e');
      setState(() {
        isLoading = false; // Set isLoading to false in case of error
      });
    }
  }


}

//What your choice
class YourChoiceHomeWidget extends StatelessWidget {
  final List<SubCategoriesModel> yourChoiceItems;
  String city_id;

  YourChoiceHomeWidget(this.yourChoiceItems, this.city_id);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 120,
        child: ListView.builder(
          itemBuilder: (context, index) {
            final item = yourChoiceItems[index];
            return buildYourChoiceWidget(context, item);
          },
          itemCount: yourChoiceItems.length,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  Widget buildYourChoiceWidget(BuildContext context, SubCategoriesModel item) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AllCouponScreen(
              "${item.subcategory_name}",
              "",
              "",
              "${item.id}",
              "",
              "",
              "",
              "",
              "$city_id",
              "");
        }));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(item.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 0),
              child: Center(
                child: Text(
                  item.subcategory_name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//TrendingResturant
class TrendingRestruantWidget extends StatelessWidget {
  final List<StoreModel> restaurantsItems;

  TrendingRestruantWidget(this.restaurantsItems);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 290,
      child: ListView.builder(
        itemBuilder: (context, index) {
          final store = restaurantsItems[index];
          return buildRestaurantsWidget(
              context,
              store.id,
              store.banner,
              // Use the logo property from StoreModel
              store.storeName,
              // Use the store_name property from StoreModel
              store.address,
              // Use the address property from StoreModel
              store.distance,
              // Use the distance property from StoreModel
              store.offers);
        },
        itemCount: restaurantsItems.length, // Use the length of the list
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget buildRestaurantsWidget(BuildContext context, int id, String imgUrl,
      String restaurantName, String location, String distance, String offers) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      // Margins ko responsive banane ke liye adjust kiya gaya hai
      width: MediaQuery
          .of(context)
          .size
          .width * 0.70,
      // Container ki width ko screen ke 90% par set kiya gaya hai
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CouponFullViewScreen("$id");
          }));
        },
        child: Card(
          color: Colors.white,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: double.infinity,
                height: 290,
                child: CachedNetworkImage(
                  imageUrl: imgUrl,
                  fit: BoxFit.fill,
                  placeholder: (context, url) =>
                      Image.asset(
                        'assets/images/vertical_placeholder.jpg',
                        // Path to your placeholder image asset
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                  errorWidget: (context, url, error) =>
                      Center(child: Icon(Icons.error)),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black87,
                        Colors.black
                      ],
                    ),
                  ),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(12, 5, 25, 5),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: MyColors.redBG,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20))),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Container(
                            //     width: 20,height: 20,
                            //     child: Image.asset("assets/images/offer_2.png")),
                            Text(
                              "Offer :- $offers",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 15,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          restaurantName,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: MyColors.whiteBG,
                            fontSize: 19,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Widget buildRestaurantsWidget(BuildContext context, int id, String imgUrl,
//     String restaurantName, String location, String distance, String offers) {
//   return Container(
//     margin: EdgeInsets.only(left: 10, right: 5),
//     child: InkWell(
//       onTap: () {
//         Navigator.push(context, MaterialPageRoute(builder: (context) {
//           return CouponFullViewScreen("$id");
//         }));
//       },
//       child: Card(
//         color: Colors.white,
//         elevation: 5,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         clipBehavior: Clip.antiAliasWithSaveLayer,
//         child: Stack(
//           alignment: Alignment.bottomCenter,
//           children: [
//             // Container(
//             //   width: 250,
//             //   child: Column(
//             //     children: [
//             //       Container(
//             //         height: 282,
//             //         decoration: BoxDecoration(
//             //           image: DecorationImage(
//             //             image: NetworkImage(imgUrl),
//             //             fit: BoxFit.fill,
//             //           ),
//             //         ),
//             //       ),
//             //     ],
//             //   ),
//             // ),
//             Container(
//               width: 250,
//               child: Column(
//                 children: [
//                   FadeInImage(
//                     placeholder: AssetImage("assets/images/placeholder.png"),
//                     // Placeholder image
//                     image: NetworkImage(imgUrl),
//                     // Network image
//                     fit: BoxFit.fill,
//                     width: double.infinity,
//                     height: 282,
//                   ),
//                 ],
//               ),
//             ),
//
//             Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [Colors.transparent, Colors.black87, Colors.black],
//                 ),
//               ),
//               height: 120,
//               width: 250,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Container(
//                     padding: EdgeInsets.fromLTRB(12, 5, 25, 5),
//                     decoration: BoxDecoration(
//                         shape: BoxShape.rectangle,
//                         color: MyColors.blueBG,
//                         borderRadius: BorderRadius.only(
//                             topRight: Radius.circular(20),
//                             bottomRight: Radius.circular(20))),
//                     child: Expanded(
//                       // Use Expanded to allow text to wrap if needed
//                       child: Text(
//                         "Offer :- $offers",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w700,
//                           color: Colors.white,
//                           fontSize: 18,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Container(
//                     margin: EdgeInsets.symmetric(horizontal: 15),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           // Use Expanded to allow text to wrap if needed
//                           child: Text(
//                             restaurantName,
//                             style: TextStyle(
//                               fontWeight: FontWeight.w700,
//                               color: MyColors.whiteBG,
//                               fontSize: 19,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   // Container(
//                   //   margin: EdgeInsets.only(left: 15, top: 8, bottom: 15),
//                   //   child: Row(
//                   //     children: [
//                   //       Expanded( // Use Expanded to allow text to wrap if needed
//                   //         child: Text(
//                   //           location,
//                   //           style: TextStyle(
//                   //             fontWeight: FontWeight.w200,
//                   //             color: MyColors.whiteBG,
//                   //             fontSize: 12,
//                   //             overflow: TextOverflow.ellipsis,
//                   //           ),
//                   //         ),
//                   //       ),
//                   //     ],
//                   //   ),
//                   // ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
}

//RecentJoined
// class RecentJoinedWidget extends StatelessWidget {
//   final List<StoreModel> stores; // Renamed from restaurantsItems
//
//   RecentJoinedWidget(this.stores);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 180,
//       child: ListView.builder(
//         itemBuilder: (context, index) {
//           return buildStoreWidget(
//             context,
//             stores[index].id,
//             stores[index].banner, // Accessing the logo field of StoreModel
//             stores[index].storeName,
//             // Accessing the store_name field of StoreModel
//             stores[index].address, // Accessing the address field of StoreModel
//             stores[index]
//                 .distance, // Accessing the distance field of StoreModel
//           );
//         },
//         itemCount: stores.length,
//         scrollDirection: Axis.horizontal,
//       ),
//     );
//   }
//
//   Widget buildStoreWidget(BuildContext context, int id, String imgUrl,
//       String storeName, String location, String distance) {
//     return Container(
//       margin: EdgeInsets.only(left: 10, right: 5),
//       child: InkWell(
//         onTap: () {
//           Navigator.push(context, MaterialPageRoute(builder: (context) {
//             return CouponFullViewScreen("$id");
//           }));
//         },
//         child: Card(
//           borderOnForeground: true,
//           //color: Colors.white,
//           elevation: 3,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//           clipBehavior: Clip.antiAliasWithSaveLayer,
//           child: Container(
//             color: Colors.white,
//             padding: EdgeInsets.all(8),
//             width: 170,
//             child: Column(
//               children: [
//                 Container(
//                   height: 105,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: NetworkImage(imgUrl),
//                       fit: BoxFit.fill,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(top: 8),
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 150,
//                         child: Container(
//                           child: Text(
//                             storeName,
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black, // Modify color as needed
//                               fontSize: 13.5,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   child: Container(
//                     width: 160,
//                     margin: EdgeInsets.only(top: 2),
//                     child: Row(
//                       children: [
//                         Container(
//                           child: Text(
//                             location,
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.grey, // Modify color as needed
//                               fontSize: 12,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ),
//                         Container(
//                           margin: EdgeInsets.symmetric(horizontal: 5),
//                           width: 1,
//                           height: 10,
//
//                           color: distance == ''
//                               ? Colors.transparent
//                               : Colors.grey, // Modify color as needed
//                         ),
//                         Text(
//                           "$distance km",
//                           style: TextStyle(
//                             color: distance == ''
//                                 ? Colors.transparent
//                                 : Colors.red,
//                             // Set color to transparent when distance is 0
//                             fontSize: 12,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// new RecentJoined

class RecentJoinedWidget extends StatelessWidget {
  final List<StoreModel> stores; // Renamed from restaurantsItems

  RecentJoinedWidget(this.stores);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return buildStoreWidget(
            context,
            stores[index].id,
            stores[index].banner,
            // Accessing the logo field of StoreModel
            stores[index].storeName,
            // Accessing the store_name field of StoreModel
            stores[index].address,
            // Accessing the address field of StoreModel
            stores[index].distance,
            // Accessing the distance field of StoreModel
            stores[index].offers,
          );
        },
        itemCount: stores.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  /* Widget buildStoreWidget(BuildContext context, int id, String imgUrl,
      String storeName, String location, String distance, String offers) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 5),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CouponFullViewScreen("$id");
          }));
        },
        child: Card(
          borderOnForeground: true,
          //color: Colors.white,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Container(
            color: Colors.black87,
            //padding: EdgeInsets.all(8),
            width: 220,
            child: Column(
              children: [
                Container(
                  height: 139,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imgUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(12, 5, 25, 5),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: MyColors.blueBG,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20))),
                        child: Expanded(
                          // Use Expanded to allow text to wrap if needed
                          child: Text(
                            "Offer :- $offers",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: 18,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Expanded(
                              // Use Expanded to allow text to wrap if needed
                              child: Text(
                                storeName,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: MyColors.whiteBG,
                                  fontSize: 19,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Container(
                      //   margin: EdgeInsets.only(left: 15, top: 8, bottom: 15),
                      //   child: Row(
                      //     children: [
                      //       Expanded( // Use Expanded to allow text to wrap if needed
                      //         child: Text(
                      //           location,
                      //           style: TextStyle(
                      //             fontWeight: FontWeight.w200,
                      //             color: MyColors.whiteBG,
                      //             fontSize: 12,
                      //             overflow: TextOverflow.ellipsis,
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  // child: Column(
                  //   children: [
                  //     Container(
                  //       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  //       child: Row(
                  //         children: [
                  //           Expanded(
                  //             child: Text(
                  //               storeName,
                  //               style: TextStyle(
                  //                 fontWeight: FontWeight.bold,
                  //                 color: Colors.white, // Modify color as needed
                  //                 fontSize: 15.5,
                  //                 overflow: TextOverflow.ellipsis,
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //
                  //     Container(
                  //       margin: EdgeInsets.symmetric(horizontal: 8),
                  //       child: Row(
                  //         children: [
                  //           Expanded(
                  //             child: Text(
                  //               "Offer :- $offers",
                  //               style: TextStyle(
                  //                 fontWeight: FontWeight.bold,
                  //                 color: MyColors.primaryColor, // Modify color as needed
                  //                 fontSize: 15,
                  //                 overflow: TextOverflow.ellipsis,
                  //               ),
                  //             ),
                  //           ),
                  //           if (distance.isNotEmpty) ...[
                  //             Flexible(
                  //               child: Container(
                  //                 margin: EdgeInsets.symmetric(horizontal: 5),
                  //                 width: 1,
                  //                 height: 10,
                  //                 color: Colors.grey, // Modify color as needed
                  //               ),
                  //             ),
                  //             Text(
                  //               "$distance km",
                  //               style: TextStyle(
                  //                 color: Colors.red,
                  //                 // Set color to transparent when distance is 0
                  //                 fontSize: 12,
                  //                 overflow: TextOverflow.ellipsis,
                  //               ),
                  //             ),
                  //           ],
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }*/
  Widget buildStoreWidget(BuildContext context, int id, String imgUrl,
      String storeName, String location, String distance, String offers) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CouponFullViewScreen("$id");
          }));
        },
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width *
              0.49, // Adjust the width according to your requirement
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .width * 0.9,
                // Adjust the height according to your requirement
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(100),
                    topLeft: Radius.circular(100),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(100),
                    topLeft: Radius.circular(100),
                    // bottomRight: Radius.circular(15),
                    // bottomLeft: Radius.circular(15),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: imgUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Image.asset(
                          'assets/images/vertical_placeholder.jpg',
                          // Path to your placeholder image asset
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                    width: double.infinity,
                    height: double.infinity,
                    errorWidget: (context, url, error) =>
                        Center(child: Icon(Icons.error)),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.5,
                    // Adjust the width according to your requirement
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black87,
                          Colors.black
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        // bottomRight: Radius.circular(15),
                        // bottomLeft: Radius.circular(15),
                      ),
                    ),

                    child: Container(
                      //width: double.maxFinite,
                      margin: EdgeInsets.fromLTRB(0, 5, 17, 10),
                      padding: EdgeInsets.fromLTRB(12, 5, 15, 5),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: MyColors.redBG,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            child: Image.asset(
                              'assets/images/offer_2.png',
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "$offers",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 13,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LocationWidget extends StatelessWidget {
  final List<LocalityModel> locationItems;

  LocationWidget(this.locationItems);

  @override
  Widget build(BuildContext context) {
    if (locationItems.isEmpty) {
      return SizedBox.shrink(); // Return an empty widget if the list is empty
    }

    return Container(
      height: 135,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return locationCard(context, locationItems[index]);
        },
        itemCount: locationItems.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget locationCard(BuildContext context, LocalityModel locality) {
    return InkWell(
      onTap: () {
        navigateToAllCouponScreen(context, "${locality.locality}",
            "${locality.city_id}", "${locality.id}");
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 0, 5, 0),
        child: Column(
          children: [
            Container(
              height: 100,
              width: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: locality.image,
                  fit: BoxFit.fill,
                  placeholder: (context, url) =>
                      Image.asset(
                        'assets/images/placeholder.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                  errorWidget: (context, url, error) =>
                      Center(
                        child: Icon(Icons.error),
                      ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              locality.locality,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> navigateToAllCouponScreen(BuildContext context,
      String locationName, String city_id, String localtiy_id) async {
    //showErrorMessage(context, message: "city_id: "+city_id+", localtiyId: "+localtiy_id);
    final route = MaterialPageRoute(
        builder: (context) =>
            AllCouponScreen(
                "$locationName",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "$city_id",
                "$localtiy_id"));
    await Navigator.push(context, route);
  }
}

//Top Collection
class TopCollectionWidget extends StatelessWidget {
  List<StoreModel> restaurantsItems;
  dynamic leftMrgin;

  TopCollectionWidget(this.restaurantsItems, this.leftMrgin);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .width * 0.32,
      child: ListView.builder(
        itemBuilder: (context, index) {
          //return buildRestaurantsWidget(context, "" + restaurantsItems[index]['imgUrl']);
          if (index == 0) {
            return Padding(
              padding: EdgeInsets.only(left: leftMrgin),
              child: buildRestaurantsWidget(
                  context,
                  "" + restaurantsItems[index].logo,
                  restaurantsItems[index].id),
            );
          } else {
            // For other items, no left margin
            return buildRestaurantsWidget(context,
                "" + restaurantsItems[index].logo, restaurantsItems[index].id);
          }
        },
        itemCount: restaurantsItems.length,
        //reverse: true,
        //itemExtent: 100,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget buildRestaurantsWidget(BuildContext context, String imgUrl, int id) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 2),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CouponFullViewScreen("$id");
          }));
        },
        child: Card(
          color: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width *
                0.3, // Adjust the width according to your requirement
            height: MediaQuery
                .of(context)
                .size
                .width *
                0.3, // Adjust the height according to your requirement
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: imgUrl,
                fit: BoxFit.fill,
                placeholder: (context, url) =>
                    Image.asset(
                      'assets/images/vertical_placeholder.jpg',
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
        ),
      ),
    );
  }
}
