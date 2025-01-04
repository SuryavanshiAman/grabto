import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:discount_deals/generated/assets.dart';
import 'package:discount_deals/helper/shared_pref.dart';
import 'package:discount_deals/model/coupon_model.dart';
import 'package:discount_deals/model/features_model.dart';
import 'package:discount_deals/model/menu_model.dart';
import 'package:discount_deals/model/pre_book_table_model.dart';
import 'package:discount_deals/model/regular_offer_model.dart';
import 'package:discount_deals/model/review_model.dart';
import 'package:discount_deals/model/store_model.dart';
import 'package:discount_deals/model/terms_condition_model.dart';
import 'package:discount_deals/model/time_model.dart';
import 'package:discount_deals/model/user_model.dart';
import 'package:discount_deals/services/api.dart';
import 'package:discount_deals/services/api_services.dart';
import 'package:discount_deals/theme/theme.dart';
import 'package:discount_deals/ui/all_review_screen.dart';
import 'package:discount_deals/ui/book_table_screen.dart';
import 'package:discount_deals/ui/gallery_screen.dart';
import 'package:discount_deals/ui/pay_bill_screen.dart';
import 'package:discount_deals/utils/snackbar_helper.dart';
import 'package:discount_deals/widget/add_rating_widget.dart';
import 'package:discount_deals/widget/all_coupons_widget.dart';
import 'package:discount_deals/widget/coupon_card.dart';
import 'package:discount_deals/widget/doted_line.dart';
import 'package:discount_deals/widget/features_widget.dart';
import 'package:discount_deals/widget/menu_card_widget.dart';
import 'package:discount_deals/widget/opneing_hours.dart';
import 'package:discount_deals/widget/term_condition_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:discount_deals/ui/all_coupon_screen.dart';


class CouponFullViewScreen extends StatefulWidget {
  String id = "";

  CouponFullViewScreen(this.id);

  @override
  State<CouponFullViewScreen> createState() => _CouponFullViewScreenState();
}

class _CouponFullViewScreenState extends State<CouponFullViewScreen> {
  StoreModel? store;
  List<MenuModel> menuList = [];
  List<TimeModel> timeList = [];
  List<TimeModel> timeListUpdated = [];
  List<FeaturesModel> featuresList = [];
  List<ReviewModel> reviewList = [];
  List<PreBookTable> prebookofferlist = [];
  List<RegularOfferModel> regularofferlist = [];
  List ambienceList = [];

  List<TermConditionModel> termConditionList = [];
  List<CouponModel> couponsList = [];

  int storeId = 0;
  String storeName = '';
  String storeMobile = '';
  String storeAddress = '';
  String storeAddress2 = '';
  String storeCountry = '';
  String storeState = '';
  String storePostcode = '';
  String storeBannerImageUrl = '';
  String storeLogoImageUrl = '';
  String storeQR = '';
  String storeMap_link = '';
  String storeLat = '';
  String storeLong = '';
  String storeSubcategory_names = '';
  String wishlist_status = '';
  String premium = '';
  String review_count = '';
  String avg_rating = '';
  String start_time = '';
  String end_time = '';
  String subcategory_name = '';
  String avg_type = '';
  String category_id = '';
  String subcategory_id = '';
  String cityId = '';
  String category_name = '';
  String kyc_status = '';

  bool isLoading = true; // Initially set to true to show loading indicator
  int userId = 0;

  Future<void> shareNetworkImage(String imageUrl, String text) async {
    final http.Response response = await http.get(Uri.parse(imageUrl));
    final Directory directory = await getTemporaryDirectory();
    final File file = await File('${directory.path}/Image.png')
        .writeAsBytes(response.bodyBytes);
    await Share.shareXFiles(
      [
        XFile(file.path),
      ],
      text: text,
    );
  }

  void currentDayTiming(List<TimeModel> timeList) {
    // Get the current day as a string (e.g., "Monday", "Tuesday")
    DateTime now = DateTime.now();
    String currentDay;

    switch (now.weekday) {
      case DateTime.monday:
        currentDay = 'Monday';
        break;
      case DateTime.tuesday:
        currentDay = 'Tuesday';
        break;
      case DateTime.wednesday:
        currentDay = 'Wednesday';
        break;
      case DateTime.thursday:
        currentDay = 'Thursday';
        break;
      case DateTime.friday:
        currentDay = 'Friday';
        break;
      case DateTime.saturday:
        currentDay = 'Saturday';
        break;
      case DateTime.sunday:
        currentDay = 'Sunday';
        break;
      default:
        currentDay = '';
        break;
    }

    // Search for the matching day's timings in timeList
    for (var time in timeList) {
      if (time.day == currentDay) {
        print('currentDayTiming ($currentDay) Start Time: ${time.start_time}');
        print('Today ($currentDay) End Time: ${time.end_time}');
        start_time = time.start_time;
        end_time = time.end_time;
        return; // Stop after finding the current day's timing
      }
    }

    print('No timings available for today ($currentDay).');
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    // starRating(widget.id.toString());
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

  _launchMaps() async {
    // Define URLs for Google Maps and Apple Maps
    String googleUrl = 'https://www.google.com/maps?q=${storeLat},${storeLong}';
    String appleUrl = 'https://maps.apple.com/?sll=${storeLat},${storeLong}';

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

  Future<void> fetchData() async {
    getUserDetails();
    starRating(widget.id);
    fetchStoresMenus(widget.id);
    fetchStoresTiming(widget.id);
    fetchStoresFeatures(widget.id);
    fetchStoresTermCondition(widget.id);

    show_store_reviews(widget.id);
    store_review_rating(widget.id);
    fetchGalleryImagesAmbience(widget.id, "ambience");
    prebookoffer(widget.id);
    regularOffer(widget.id);
    AverageType(widget.id);

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isLoading = false; // Set to false to hide loading indicator
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Call the fetchStoresCoupons function when navigating back from ScreenB
        fetchStoresCoupons(widget.id, "$userId");
        return true;
      },
      child: Scaffold(
          backgroundColor: MyColors.backgroundBg,
          appBar: AppBar(
            backgroundColor: MyColors.backgroundBg,
            leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back_ios)),
            actions: [
              Container(
                width: 45,
                height: 45,
                margin: const EdgeInsets.only(right: 15),
                child: Card(
                  elevation: 2,
                  color: Colors.white,
                  shadowColor: MyColors.primaryColorLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.share,
                      size: 24,
                      color: MyColors.primaryColor,
                    ),
                    onPressed: () {
                      // Handle notification button press
                      // You can show a notification or navigate to a notification page, etc.
                      shareNetworkImage("$storeLogoImageUrl",
                          "\nCheck out this store on Discount Deals! $storeName $playstoreLink");
                    },
                  ),
                ),
              ),
              Container(
                width: 45,
                height: 45,
                margin: const EdgeInsets.only(right: 15),
                child: Card(
                  elevation: 2,
                  color: Colors.white,
                  shadowColor: MyColors.primaryColorLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  child: IconButton(
                    icon: Icon(
                      wishlist_status == 'true'
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 24,
                      color:
                      wishlist_status == 'true' ? Colors.red : Colors.black,
                    ),
                    onPressed: () {
                      wishlist("$userId", "${widget.id}");
                    },
                  ),
                ),
              ),
            ],
          ),
          body: isLoading
              ? Center(
            child: Container(
              color: Colors.black
                  .withOpacity(0.5), // Adjust opacity as needed
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    MyColors.primaryColor,
                  ),
                  // Change the color
                  strokeWidth: 4,
                ),
              ),
            ), // Show loading indicator
          )
              : Stack(
            children: [
              Container(
                color: MyColors.backgroundBg,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 2,
                          child: Stack(
                            children: [
                              Container(
                                child: Column(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          navigateToGallerScreen(storeId);
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.all(0),
                                          width: double.infinity,
                                          height: MediaQuery
                                              .of(context)
                                              .size
                                              .width *
                                              0.65,
                                          child: ambienceList.isEmpty
                                              ? CachedNetworkImage(
                                            imageUrl:
                                            storeBannerImageUrl,
                                            fit: BoxFit.fill,
                                            placeholder:
                                                (context, url) =>
                                                Image.asset(
                                                  'assets/images/placeholder.png',
                                                  fit: BoxFit.cover,
                                                  width:
                                                  double.infinity,
                                                  height:
                                                  double.infinity,
                                                ),
                                            errorWidget: (context,
                                                url, error) =>
                                                const Center(
                                                    child: Icon(Icons
                                                        .error)),
                                          )
                                              : Center(
                                            child: CarouselSlider(
                                              items: ambienceList
                                                  .map((json) {
                                                return GestureDetector(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        10),
                                                    child:
                                                    CachedNetworkImage(
                                                      imageUrl: json[
                                                      'image'],
                                                      fit: BoxFit
                                                          .fill,
                                                      placeholder: (context,
                                                          url) =>
                                                          Image
                                                              .asset(
                                                            'assets/images/placeholder.png',
                                                            fit: BoxFit
                                                                .cover,
                                                            width: double
                                                                .infinity,
                                                            height: double
                                                                .infinity,
                                                          ),
                                                      errorWidget: (context,
                                                          url,
                                                          error) =>
                                                          const Center(
                                                              child:
                                                              Icon(
                                                                  Icons.error)),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                              options:
                                              CarouselOptions(
                                                height: 200,
                                                enlargeCenterPage:
                                                true,
                                                autoPlay: true,
                                                reverse: true,
                                                disableCenter: true,
                                                aspectRatio: 16 / 9,
                                                autoPlayCurve: Curves
                                                    .fastOutSlowIn,
                                                enableInfiniteScroll:
                                                true,
                                                autoPlayAnimationDuration:
                                                const Duration(
                                                    milliseconds:
                                                    800),
                                                viewportFraction:
                                                0.85,
                                              ),
                                            ),
                                          ),
                                        )),
                                    SizedBox(
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .width *
                                          0.08, // Adjust according to your requirement
                                    ),
                                    Center(
                                      child: Container(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width,
                                        padding: const EdgeInsets.all(8),
                                        // color: Colors.red,
                                        // Adjust according to your requirement
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "$storeName ",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: MediaQuery
                                                      .of(
                                                      context)
                                                      .size
                                                      .width *
                                                      0.07,
                                                  //decoration: TextDecoration.underline,
                                                  // Adjust according to your requirement
                                                  fontWeight:
                                                  FontWeight.w600,
                                                  color: MyColors
                                                      .txtTitleColor),
                                            ),

                                            // Container(height: 1,width: double.infinity,color: Colors.black,),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Center(
                                              child: Text(
                                                "Address:- $storeAddress $storeAddress2 $storeCountry $storeState, $storePostcode",
                                                textAlign:
                                                TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: MediaQuery
                                                        .of(
                                                        context)
                                                        .size
                                                        .width *
                                                        0.032,
                                                    // Adjust according to your requirement
                                                    fontWeight:
                                                    FontWeight.w400,
                                                    color:
                                                    MyColors.blackBG),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Row(
                                      //     crossAxisAlignment: CrossAxisAlignment.start,
                                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      //   children: [
                                      //     Container(
                                      //       width: MediaQuery
                                      //           .of(context)
                                      //           .size
                                      //           .width*0.7 ,
                                      //       color: Colors.red,
                                      //       // Adjust according to your requirement
                                      //       child: Column(
                                      //         mainAxisAlignment:
                                      //         MainAxisAlignment.center,
                                      //         children: [
                                      //           Text(
                                      //             "$storeName ",
                                      //             textAlign: TextAlign.center,
                                      //             style: TextStyle(
                                      //                 fontSize: MediaQuery
                                      //                     .of(
                                      //                     context)
                                      //                     .size
                                      //                     .width *
                                      //                     0.07,
                                      //                 //decoration: TextDecoration.underline,
                                      //                 // Adjust according to your requirement
                                      //                 fontWeight:
                                      //                 FontWeight.w600,
                                      //                 color: MyColors
                                      //                     .txtTitleColor),
                                      //           ),
                                      //
                                      //           // Container(height: 1,width: double.infinity,color: Colors.black,),
                                      //           SizedBox(
                                      //             height: 10,
                                      //           ),
                                      //           Center(
                                      //             child: Text(
                                      //               "Address:- $storeAddress $storeAddress2 $storeCountry $storeState, $storePostcode",
                                      //               textAlign:
                                      //               TextAlign.center,
                                      //               style: TextStyle(
                                      //                   fontSize: MediaQuery
                                      //                       .of(
                                      //                       context)
                                      //                       .size
                                      //                       .width *
                                      //                       0.032,
                                      //                   // Adjust according to your requirement
                                      //                   fontWeight:
                                      //                   FontWeight.w400,
                                      //                   color:
                                      //                   MyColors.blackBG),
                                      //             ),
                                      //           ),
                                      //         ],
                                      //       ),
                                      //     ),
                                      //     // Column(
                                      //     //   children: [
                                      //     //     Container(
                                      //     //
                                      //     //       child: Card(
                                      //     //         elevation: 2,
                                      //     //
                                      //     //         color: Color(0xff136449),
                                      //     //         shape: RoundedRectangleBorder(
                                      //     //           borderRadius:
                                      //     //           BorderRadius.circular(10),
                                      //     //         ),
                                      //     //         child: Padding(
                                      //     //           padding: EdgeInsets.only(left: 8,right: 8,top: 5,bottom: 5),
                                      //     //           child: Row(
                                      //     //             mainAxisAlignment:
                                      //     //             MainAxisAlignment.center,
                                      //     //             children: [
                                      //     //
                                      //     //               Icon(
                                      //     //                 Icons.star,
                                      //     //                 color: Colors.white,
                                      //     //                 size: 18,
                                      //     //               ),
                                      //     //               SizedBox(width: 5),
                                      //     //               Text(
                                      //     //                 "${star??""}",
                                      //     //                 style: TextStyle(
                                      //     //                   color: Colors.white,
                                      //     //                   fontSize: 14,
                                      //     //                   fontWeight:
                                      //     //                   FontWeight.bold,
                                      //     //                 ),
                                      //     //               ),
                                      //     //             ],
                                      //     //           ),
                                      //     //         ),
                                      //     //       ),
                                      //     //     ),
                                      //     //     Text(
                                      //     //       "${noOfRating??""}ratings",
                                      //     //       style: TextStyle(
                                      //     //         color: Colors.grey,
                                      //     //         fontSize: 12,
                                      //     //         fontWeight:
                                      //     //         FontWeight.w500,
                                      //     //       ),
                                      //     //     ),
                                      //     //     Image.asset("assets/images/google.png",scale: 28,),
                                      //     //   ],
                                      //     // ),
                                      //   ],
                                      // ),
                                    ),
                                    SizedBox(
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .width *
                                          0.015, // Adjust according to your requirement
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceEvenly,
                                          children: [
                                            _buildCard(
                                              context: context,
                                              icon: Icons.pin_drop,
                                              text: 'Location',
                                              onTap: _launchMaps,
                                            ),
                                            _buildCard(
                                              context: context,
                                              icon: Icons.call,
                                              text: 'Contact',
                                              onTap: () {
                                                _makePhoneCall(
                                                    storeMobile);
                                              },
                                            ),
                                            _buildCard(
                                              context: context,
                                              icon: Icons.edit_note,
                                              text: 'Review',
                                              onTap: () {
                                                if (userId == 0) {
                                                  NavigationUtil
                                                      .navigateToLogin(
                                                      context);
                                                } else {
                                                  _navigateToAddRatingScreen(
                                                      context);
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (avg_type.isNotEmpty ||
                                        subcategory_name.isNotEmpty)
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        // Distributes the widgets with space between them
                                        children: [
                                          if (avg_type
                                              .isNotEmpty) // Show the widget only if avg_type is not empty
                                            _buildCard(
                                              context: context,
                                              icon: Icons.currency_rupee,
                                              text: '$avg_type',
                                              onTap: () {
                                                // _makePhoneCall(storeMobile);
                                              },
                                            ),
                                          if (avg_type.isNotEmpty &&
                                              subcategory_name
                                                  .isNotEmpty) const SizedBox(
                                              width: 16),
                                          // Space between the containers if both are present
                                          if (subcategory_name
                                              .isNotEmpty) // Show the widget only if subcategory_name is not empty
                                            _buildCard(
                                              context: context,
                                              icon: Icons.rice_bowl_outlined,
                                              text: '$subcategory_name',
                                              onTap: () {
                                                navigateToAllCouponScreen(
                                                  context,
                                                  subcategory_name,
                                                  category_id,
                                                  subcategory_id,
                                                );
                                              },
                                            ),
                                        ],
                                      ),

                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle
                                            ),
                                            child: Card(
                                              elevation: 2,

                                              color: Colors.green,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(20),

                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.all(4.0),
                                                child: Icon(
                                                  Icons.star,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            " ${star??"4.0"},",
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight:
                                              FontWeight.w600,
                                                fontFamily: "afacadFlux"
                                            ),
                                          ),
                                          Text(
                                            "  ${noOfRating??"4.0"}",
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight:
                                              FontWeight.w600,
                                                fontFamily: "afacadFlux"
                                            ),
                                          ),
                                          const Text(
                                            "  Google ratings",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight:
                                              FontWeight.w600,
                                              fontFamily: "afacadFlux"
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // SizedBox(
                                    //   height: MediaQuery
                                    //       .of(context)
                                    //       .size
                                    //       .width *
                                    //       0.045, // Adjust according to your requirement
                                    // ),
                                  ],
                                ),
                              ),
                              Positioned(
                                left: MediaQuery
                                    .of(context)
                                    .size
                                    .width *
                                    0.02,
                                top: MediaQuery
                                    .of(context)
                                    .size
                                    .width *
                                    0.50,
                                // Adjust according to your requirement
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Card(
                                      color: Colors.white,
                                      elevation: 5,
                                      clipBehavior:
                                      Clip.antiAliasWithSaveLayer,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(35),
                                      ),
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(2.0),
                                        child: Card(
                                          color: Colors.white,
                                          elevation: 3,
                                          clipBehavior:
                                          Clip.antiAliasWithSaveLayer,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                250),
                                          ),
                                          child: Container(
                                            height: MediaQuery
                                                .of(context)
                                                .size
                                                .width *
                                                0.15,
                                            // Adjust according to your requirement
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width *
                                                0.15,
                                            // Adjust according to your requirement
                                            child: CachedNetworkImage(
                                              imageUrl: storeLogoImageUrl,
                                              fit: BoxFit.fill,
                                              placeholder:
                                                  (context, url) =>
                                                  Image.asset(
                                                    'assets/images/placeholder.png',
                                                    // Path to your placeholder image asset
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                  ),
                                              errorWidget: (context, url,
                                                  error) =>
                                                  const Center(
                                                      child: Icon(
                                                          Icons.error)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(
                                          MediaQuery
                                              .of(context)
                                              .size
                                              .width *
                                              0.065),
                                      // Adjust according to your requirement
                                      child: InkWell(
                                        onTap: () {
                                          navigateToGallerScreen(storeId);
                                        },
                                        child: Center(
                                          child: ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(20),
                                            // Rounded corners for the container
                                            child: Container(
                                              color: const Color(0x50000000),
                                              // Transparent black color (#50000000)
                                              padding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 3,
                                                  horizontal: 10),
                                              child: const Text(
                                                "Gallery",
                                                style: TextStyle(
                                                    color:
                                                    MyColors.whiteBG,
                                                    fontWeight:
                                                    FontWeight.w400),
                                              ),
                                            ),
                                          ),
                                        ),

                                        // child: Icon(
                                        //   Icons.camera_alt_outlined,
                                        //   color: MyColors.primaryColor,
                                        // ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),


                            ],
                          ),
                        ),
                      ),

                      //Coupon code start
                      // Container(
                      //   margin: EdgeInsets.only(
                      //       top: 20, left: 15, right: 15, bottom: 10),
                      //   child: Row(
                      //     mainAxisAlignment:
                      //         MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text(
                      //         "Coupons",
                      //         style: TextStyle(
                      //             fontSize: 16,
                      //             fontWeight: FontWeight.bold),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // AllCouponsWidget(couponsList, termConditionList,
                      //     storeLogoImageUrl, storeName, premium, storeQR),
                      //Coupon code end

                      // OfferCardRow(),
                      Container(
                        margin: const EdgeInsets.only(
                            top: 20, left: 15, right: 15, bottom: 10),
                        child: const Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Pre-Book offer",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      PrebookOfferListWidget(
                        start_time: "$start_time",
                        end_time: "$end_time",
                        storeName: "$storeName",
                        storeId: "${widget.id}",
                        prebookofferlist: prebookofferlist,
                        termsAndConditions: termConditionList,
                        kycStatus:kyc_status,

                      ),

                      Container(
                        margin: const EdgeInsets.only(
                            top: 15, left: 15, right: 15, bottom: 10),
                        child: const Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Regular offer",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      RegularOfferListWidget(
                        kycStatus:kyc_status,
                        regularofferlist: regularofferlist,
                        termsAndConditions: termConditionList,
                        storeName: storeName,
                        addresss: "$storeAddress $storeAddress2 $storeCountry $storeState, $storePostcode",
                      ),
                      const SizedBox(
                        height: 8,
                      ),

                      // if (!termConditionList.isEmpty)
                      //   TermConditionWidget(termConditionList),
                      // if (!termConditionList.isEmpty)
                      //   SizedBox(
                      //     height: 8,
                      //   ),
                      Visibility(
                        visible: storeSubcategory_names.isNotEmpty ||
                            timeList.isNotEmpty,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                  color: MyColors.primaryColor,
                                  width: 1), // Define the border side
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            elevation: 3,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 0,
                                        left: 5,
                                        right: 15,
                                        bottom: 10),
                                    child: const Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Timing",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight:
                                              FontWeight.w800),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Visibility(
                                  //   visible:
                                  //   storeSubcategory_names.isNotEmpty,
                                  //   child: Container(
                                  //     margin: EdgeInsets.only(bottom: 10),
                                  //     child: Row(
                                  //       children: [
                                  //         Container(
                                  //           width: 18,
                                  //           height: 18,
                                  //           child: Icon(
                                  //             Icons.food_bank_outlined,
                                  //             size: 18,
                                  //           ),
                                  //         ),
                                  //         SizedBox(width: 5),
                                  //         Expanded(
                                  //           child: Text(
                                  //             storeSubcategory_names,
                                  //             style: TextStyle(
                                  //               fontSize: 14,
                                  //               fontWeight:
                                  //               FontWeight.w500,
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                  Visibility(
                                    visible: timeList.isNotEmpty,
                                    child: OpeningHours(
                                        timeList, getTimeList(timeList)),
                                  ),
                                  const SizedBox(height: 10),
                                  // Visibility(
                                  //   visible: storeAddress.isNotEmpty ||
                                  //       storeAddress2.isNotEmpty ||
                                  //       storeState.isNotEmpty ||
                                  //       storeCountry.isNotEmpty ||
                                  //       storePostcode.isNotEmpty,
                                  //   child: Container(
                                  //     child: Row(
                                  //       children: [
                                  //         Container(
                                  //           width: 18,
                                  //           height: 18,
                                  //           child: Icon(
                                  //             Icons.location_on_outlined,
                                  //             size: 18,
                                  //           ),
                                  //         ),
                                  //         SizedBox(width: 5),
                                  //         Expanded(
                                  //           child: Text(
                                  //             "$storeAddress $storeAddress2 $storeState $storeCountry , $storePostcode",
                                  //             style: TextStyle(
                                  //               fontSize: 14,
                                  //               fontWeight: FontWeight.w500,
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      Visibility(
                        visible: featuresList.isNotEmpty,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                  color: MyColors.primaryColor,
                                  width: 1), // Define the border side
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            elevation: 3,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 0,
                                        left: 5,
                                        right: 15,
                                        bottom: 10),
                                    child: const Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Features",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight:
                                              FontWeight.w800),
                                        ),
                                      ],
                                    ),
                                  ),
                                  FeaturesWidget(featuresList),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      Visibility(
                        visible: menuList.isNotEmpty,
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 20, left: 15, right: 15, bottom: 10),
                          child: const Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Menu",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: menuList.isNotEmpty,
                        child: MenuWidget(menuList),
                      ),

                      // Container(
                      //   margin: EdgeInsets.only(
                      //       top: 20, left: 15, right: 15, bottom: 5),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text(
                      //         "Reviews",
                      //         style: TextStyle(
                      //             fontSize: 16, fontWeight: FontWeight.bold),
                      //       ),
                      //       Text(
                      //         "View All",
                      //         style: TextStyle(
                      //             color: MyColors.primaryColor,
                      //             fontSize: 14,
                      //             fontWeight: FontWeight.bold),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      //RecviewsWidget(),

                      //ReviewsPage(store, reviewList),

                      Container(
                        //margin: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 10, left: 15),
                              child: const Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Review & Ratings",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            reviewList.isNotEmpty
                                ? Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 10, left: 15),
                                  child: Row(
                                    children: [
                                      Text(
                                        "${avg_rating} ",
                                        style: const TextStyle(
                                            fontSize: 35,
                                            fontWeight:
                                            FontWeight.bold),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                        children: [
                                          RatingBar.builder(
                                            initialRating:
                                            double.parse(
                                                avg_rating),
                                            minRating: 3,
                                            direction:
                                            Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemSize: 15,
                                            itemBuilder:
                                                (context, _) =>
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                            onRatingUpdate:
                                                (rating) {
                                              print(rating);
                                            },
                                          ),
                                          Text(
                                            "${review_count} reviews",
                                            style: const TextStyle(
                                              decoration:
                                              TextDecoration
                                                  .underline,
                                              decorationColor:
                                              MyColors
                                                  .primaryColor,
                                              color: MyColors
                                                  .primaryColor,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                    height:
                                    230, // Adjust the height as needed
                                    child:
                                    _getReviewLay(reviewList)),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                          color:
                                          MyColors.txtDescColor,
                                          height: 1,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                          onTap: () {
                                            navigateToAllReviewScreen(
                                                context,
                                                reviewList);
                                          },
                                          child: const Text(
                                            "See all reviews ",
                                            style: TextStyle(
                                              color: MyColors
                                                  .txtDescColor,
                                              fontSize: 15,
                                            ),
                                          )),
                                      const Icon(
                                        Icons.arrow_forward,
                                        color:
                                        MyColors.primaryColor,
                                        size: 24,
                                      ),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                          color:
                                          MyColors.txtDescColor,
                                          height: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                InkWell(
                                  onTap: () {
                                    _navigateToAddRatingScreen(
                                        context);
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(
                                              12),
                                          border: Border.all(
                                              color: MyColors
                                                  .primaryColor)),
                                      width: double.infinity,
                                      child: const Center(
                                          child: Text(
                                            "Add Review",
                                            style: TextStyle(
                                                color: MyColors
                                                    .primaryColor,
                                                fontSize: 15,
                                                fontWeight:
                                                FontWeight.w400),
                                          ))),
                                )
                              ],
                            )
                                : _buildNoReviewWidget(),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 150,
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 110, // Increase height for more space
                    padding: const EdgeInsets.fromLTRB(15, 40, 10, 15),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.0),
                          Colors.white.withOpacity(0.5),
                          Colors.white,
                          Colors.white,
                        ],
                        stops: [
                          0.0,
                          0.2,
                          0.4,
                          1.0,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /// qwerty
                        // First Button Container
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                  if(kyc_status=="Approve"){
                              if(prebookofferlist.isEmpty){
                                showErrorMessage(context, message: "Pre-Book Offer not available");

                              }else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BookTableScreen(
                                              "$start_time",
                                              "$end_time",
                                              "$storeName",
                                              "${widget.id}")),
                                );
                              }
                  }else{
                    showErrorMessage(context, message: "Store temporarily unavailable here.  Kindly visit store for more details.");
                  }
                            },
                            child: Container(
                              height: 60,
                              // Height for the button
                              margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                              // Add margin for spacing
                              decoration: BoxDecoration(
                                color: MyColors.blueBG,
                                borderRadius: BorderRadius.circular(
                                    10), // Rounded corners
                              ),
                              child: Center(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  // category_name.toLowerCase() == "Saloon" ||category_name.toLowerCase() == "Spa"
                                  //     ? "Book Appointment"
                                  //     : "Book a Table",
                                  category_name=="Saloon"? "Book Appointment": kyc_status!="Pending"?"Book a Table":"Service Unavailable",
                                  style: const TextStyle(
                                      color: MyColors.whiteBG,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Second Button Container
                        /// qwerty
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if(kyc_status=="Approve"){
                                if(regularofferlist.isEmpty){
                                  showErrorMessage(context, message: "Regular Offer not available");

                                }else {

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PayBillScreen(
                                                regularofferlist[0], storeName,
                                                "$storeAddress $storeAddress2 $storeCountry $storeState, $storePostcode")),
                                  );
                                }
                              }else{
                                showErrorMessage(context, message: "Store temporarily unavailable here.  Kindly visit store for more details.");
                              }
                              // if(regularofferlist.isEmpty){
                              //   showErrorMessage(context, message: "Regular Offer not available");
                              //
                              // }else {
                              //
                              //   Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             PayBillScreen(
                              //                 regularofferlist[0], storeName,
                              //                 "$storeAddress $storeAddress2 $storeCountry $storeState, $storePostcode")),
                              //   );
                              // }
                            },
                            child: Container(
                              height: 60,
                              // Height for the button
                              margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                              // Add margin for spacing
                              decoration: BoxDecoration(
                                color: MyColors.primaryColor,
                                borderRadius: BorderRadius.circular(
                                    10), // Rounded corners
                              ),
                              child: Center(
                                child: Text(
                                  kyc_status!="Pending"?'Pay Bill Now':"Service Unavailable",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: MyColors.whiteBG,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )

        // bottomNavigationBar: BottomAppBar(
        //   color: Colors.transparent,
        //   height: 60,
        //   padding: EdgeInsets.all(0),
        //   child: Container(
        //     height: 10,
        //     decoration: BoxDecoration(
        //       gradient: LinearGradient(
        //         colors: [
        //           Colors.transparent, // Top color with transparency
        //           Colors.blueAccent.withOpacity(0.6), // Bottom color with transparency
        //         ],
        //        begin: Alignment.topCenter,
        //         end: Alignment.bottomCenter,
        //       ),
        //     ),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
        //       children: [
        //         ElevatedButton(
        //           onPressed: () {
        //             print('Button 1 pressed');
        //           },
        //           child: Text('Button 1'),
        //         ),
        //         ElevatedButton(
        //           onPressed: () {
        //             print('Button 2 pressed');
        //           },
        //           child: Text('Button 2'),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),

        //Drawer
      ),
    );
  }

  Future<void> navigateToGallerScreen(int store_id) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryScreen(store_id),
      ),
    );
  }

  Future<void> fetchStoresTermCondition(String store_id) async {
    try {
      final response = await ApiServices.api_store_termconditions();
      if (response != null) {
        setState(() {
          termConditionList = response;
        });
      }
    } catch (e) {
      print('fetchStores: $e');
    }
  }

  Future<void> fetchStoresCoupons(String store_id, String user_id) async {
    print('api_related_coupons: store_id: $store_id ,user_id: $user_id');
    try {
      final body = {"store_id": "$store_id", "user_id": "$user_id"};
      final response = await ApiServices.api_related_coupons(body);
      if (response != null) {
        setState(() {
          couponsList = response;
        });
      }
    } catch (e) {
      print('api_related_coupons: $e');
    }
  }
  var star;
  var noOfRating;
   starRating(String storeId)async{
    print("🙈🙈🙈");
    print("$storeId");
    try {
      final url = '$BASE_URL/get-store-review?store_id=$storeId';
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      var data = jsonDecode(response.body);
      if (data["error"] == false) {
        print("😊😊😊😊😊data");
        print(data);
setState(() {
  star=data['data'][0]['rating'];
  noOfRating=data['data'][0]['no_of_rating'];
  print(star);
});
      }
    } catch (e) {
      print('zzzzzzzz: $e');
    }
  }
  Future<void> fetchStoresFeatures(String store_id) async {
    try {
      final body = {"store_id": "$store_id"};
      final response = await ApiServices.api_features(body);
      if (response != null) {
        setState(() {
          featuresList = response;
        });
      }
    } catch (e) {
      print('fetchStores: $e');
    }
  }

  Future<void> fetchStoresTiming(String store_id) async {
    try {
      final body = {"store_id": "$store_id"};
      final response = await ApiServices.api_store_timings(body);
      if (response != null) {
        setState(() {
          timeList = response;
          // timeListUpdated = response;

          print(
              'fetchStores:sizedata ${timeList.length}     ${timeListUpdated
                  .length}');
        });
        currentDayTiming(timeList);
      }
    } catch (e) {
      print('fetchStores: $e');
    }
  }

  Future<void> fetchStoresMenus(String store_id) async {
    try {
      final body = {
        "store_id": "$store_id",
      };
      final response = await ApiServices.api_related_menu(body);
      if (response != null) {
        setState(() {
          menuList = response;
        });
      }
    } catch (e) {
      print('fetchStores: $e');
    }
  }

  Future<void> fetchStoresFullView(String store_id, user_id) async {
    try {
      final body = {
        "store_id": "$store_id",
        "user_id": "$user_id",
      };
      final response = await ApiServices.api_store_fullview(body);

      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final data = response['data'];
        print("Aman:$data");

        // Ensure that the response data is in the expected format
        if (data != null && data is Map<String, dynamic>) {

          store = StoreModel.fromMap(data);

          setState(() {
            storeId = store!.id;
            storeName = store!.storeName;
            storeMobile = store!.mobile;
            storeAddress = store!.address;
            storeAddress2 = store!.address2;
            storeCountry = store!.country;
            storeState = store!.state;
            storePostcode = store!.postcode;
            storeBannerImageUrl = store!.banner;
            storeLogoImageUrl = store!.logo;
            storeQR = store!.qrCode;
            storeMap_link = store!.mapLink;
            storeLat = store!.latitude;
            storeLong = store!.longitude;
            storeSubcategory_names = store!.subcategoryName;
            wishlist_status = store!.wishlistStatus;
            category_id = store!.categoryId;
            subcategory_id = store!.subcategoryId;
            subcategory_name = store!.subcategoryName;
            category_name=store!.categoryName;
            kyc_status=store!.kycStatus;
          });

          print("store: " + data.toString());
          print('fetchStoresFullView data: ${category_name}');
        } else {
          // Handle invalid response data format
          // showErrorMessage(context, message: 'Invalid response data format');
        }

      } else if (response != null) {
        String msg = response['msg'];

        // Handle unsuccessful response or missing 'res' field
        // showErrorMessage(context, message: msg);
      }
    } catch (e) {
      //print('verify_otp error: $e');
      // Handle error
      //showErrorMessage(context, message: 'An error occurred: $e');
    } finally {}
  }

  Future<void> getUserDetails() async {
    // SharedPref sharedPref=new SharedPref();
    // userName = (await SharedPref.getUser()).name;
    UserModel n = await SharedPref.getUser();
    print("getUserDetails: " + n.name);
    setState(() {
      userId = n.id;
      premium = n.premium;
      cityId = n.home_location;
      fetchStoresFullView(widget.id, "${userId}");
      fetchStoresCoupons(widget.id, "${userId}");
    });
  }

  Future<void> wishlist(String user_id, String store_id) async {
    try {
      final body = {"user_id": user_id, "store_id": store_id};
      final response = await ApiServices.wishlist(body);

      // Check if the response is null or doesn't contain the expected data
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final msg = response['msg'] as String;

        setState(() {
          wishlist_status = response['wishlist_status'] as String;
          wishlist_status == "true"
              ? showSuccessMessage(context, message: msg)
              : showErrorMessage(context, message: msg);
        });
      } else if (response != null) {
        String msg = response['msg'];

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

  Future<void> show_store_reviews(String store_id) async {
    setState(() {
      isLoading = true;
    });
    try {
      final body = {"store_id": "$store_id"};
      final response = await ApiServices.show_store_reviews(body);
      if (response != null) {
        setState(() {
          reviewList = response;
        });
      }
    } catch (e) {
      print('fetchStores: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> store_review_rating(String storeId) async {
    //showSuccessMessage(context, message:" click submit");
    setState(() {
      isLoading = true;
    });
    try {
      final body = {"store_id": "$storeId"};
      final response = await ApiServices.store_review_rating(body);

      // Check if the response is null or doesn't contain the expected data
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final msg = response['msg'] as String;

        final data = response['data'];
        if (data != null && data is Map<String, dynamic>) {
          //print('verify_otp data: $data');
          print("store_review_rating: $data");

          setState(() {
            avg_rating = data['avg_rating'] as String;
            review_count = data['review_count'] as String;
          });
        } else {
          // Handle invalid response data format
          showErrorMessage(context, message: 'Invalid response data format');
        }
      } else if (response != null) {
        String msg = response['msg'];

        //showErrorMessage(context, message: msg);
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

  Future<void> _navigateToAddRatingScreen(BuildContext context) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => AddRatingScreen(store)));

    await show_store_reviews("${storeId}");
    await store_review_rating("${storeId}");
  }

  Widget _buildNoReviewWidget() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Container(
        //   width: 200,
        //   height: 180,
        //   child: Image.asset('assets/vector/blank.png'), // No images available
        // ),
        SizedBox(height: 16),
        Text(
          'No Reviews available',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w200,
          ),
        ),
      ],
    );
  }

  void navigateToAllReviewScreen(BuildContext context,
      List<ReviewModel> reviewModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllReviewScreen(reviewDataList: reviewList),
      ),
    );
  }

  Widget _getReviewLay(List<ReviewModel> reviewList) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: reviewList.map((review) {
          return Container(
            margin: const EdgeInsets.only(left: 5),
            child: _buildReviewItem(review),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildReviewItem(ReviewModel review) {
    return Container(
      width: 250,
      // Fixed width
      height: 205,
      // Fixed height
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: MyColors.txtDescColor, width: 0.3),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(review.userImage),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "${review.name}",
                  style: const TextStyle(
                    color: MyColors.primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis, // Prevent overflow
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(6, 4, 8, 4),
                decoration: BoxDecoration(
                  color: (review.rating <= 2.0)
                      ? MyColors.primaryColor
                      : (review.rating == 3.0)
                      ? Colors.yellow
                      : Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    Text(
                      "${review.rating}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Flexible(
            child: Text(
              review.description,
              style: const TextStyle(
                color: MyColors.txtDescColor2,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis, // Prevent overflow
              maxLines: 2, // Limit to 2 lines
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: 250,
            height: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                review.image,
                fit: BoxFit.cover, // Maintain aspect ratio without overflow
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    // Image has loaded successfully
                    return child;
                  } else {
                    // Image is still loading, display a loading indicator
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  // Handle error if image fails to load
                  return const Center(
                    child: Icon(
                      Icons.error_outline,
                      color: Colors.red,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<TimeModel> getTimeList(List<TimeModel> timelist) {
    List<TimeModel> filterList = [];

    for (int i = 1; i < timeList.length; i++) {
      filterList.add(timelist[i]);
    }

    return filterList;
  }

  Future<void> fetchGalleryImagesAmbience(String store_id,
      String food_type) async {
    setState(() {
      isLoading = true;
    });
    try {
      final body = {"store_id": "$store_id", "food_type": "$food_type"};
      final response = await ApiServices.store_multiple_galleryJson(body);
      print("object: $response");
      if (response != null) {
        setState(() {
          ambienceList = response;

          print('fetchGalleryImagesAmbience: $response');
        });
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('fetchGalleryImagesAmbience: $e');
    } finally {
      isLoading = false;
    }
  }

  Future<void> prebookoffer(String store_id) async {
    print('prebookoffer: store_id $store_id');
    try {
      final body = {"store_id": "$store_id"};
      final response = await ApiServices.PreBookOffer(body);
      print('prebookoffer: response $response');
      if (response != null) {
        setState(() {
          prebookofferlist = response;
          isLoading = false; // Set isLoading to false when fetching ends
        });
      } else {
        setState(() {
          isLoading = false; // Set isLoading to false when fetching ends
        });
      }
    } catch (e) {
      print('prebookoffer: $e');
      setState(() {
        isLoading = false; // Set isLoading to false in case of error
      });
    }
  }

  Future<void> regularOffer(String store_id) async {
    print('regularOffer: store_id $store_id');
    try {
      final body = {"store_id": "$store_id"};
      final response = await ApiServices.RegularOffer(body);
      print('regularOffer: response $response');
      if (response != null) {
        setState(() {
          regularofferlist = response;
          isLoading = false; // Set isLoading to false when fetching ends
        });
      } else {
        setState(() {
          isLoading = false; // Set isLoading to false when fetching ends
        });
      }
    } catch (e) {
      print('regularOffer: $e');
      setState(() {
        isLoading = false; // Set isLoading to false in case of error
      });
    }
  }

  Future<void> AverageType(String store_id) async {
    try {
      setState(() {
        isLoading = true;
      });
      final body = {"store_id": "$store_id"};
      final response = await ApiServices.AverageType(body);

      // Check if the response is null or doesn't contain the expected data
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final data = response['data'];
        // Ensure that the response data is in the expected format
        if (data != null && data is Map<String, dynamic>) {
          //print('verify_otp data: $data');
          print("website: $data");

          avg_type = data['description'] as String;
          // subcategory_name = data['subcategory_name'] as String;
        } else {
          // Handle invalid response data format
          showErrorMessage(context, message: 'Invalid response data format');
        }
      } else if (response != null) {
        String msg = response['msg'];
        // Handle unsuccessful response or missing 'res' field
        // showErrorMessage(context, message: msg);
      }
    } catch (e) {

    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> navigateToAllCouponScreen(BuildContext context,
      String subCategoryName, String category_id, String subcategory_id) async {
    final route = MaterialPageRoute(
        builder: (context) =>
            AllCouponScreen(
                "$subCategoryName",
                "",
                "$category_id",
                "$subcategory_id",
                "",
                "",
                "",
                "",
                "$cityId",
                ""));
    await Navigator.push(context, route);
  }

  Widget _buildCard({
    required BuildContext context,
    required IconData icon,
    required String text,
    required Function onTap,
  }) {
    final cardWidth = MediaQuery
        .of(context)
        .size
        .width * 0.3;

    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Center(
        child: Card(
          elevation: 5,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              color: MyColors.primaryColor,
              width: 1.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: MyColors.primaryColor,
                ),
                const SizedBox(width: 5),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OfferCard extends StatelessWidget {
  final String title, image, offerType, discount, description;

  const OfferCard({
    required this.title,
    required this.image,
    required this.offerType,
    required this.discount,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey.shade400, width: 0.9),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 6)
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          _buildImage(),
          Text(offerType.toUpperCase(),
              style: const TextStyle(fontSize: 17, color: Colors.black)),
          Text("$discount% Off",
              style: const TextStyle(
                  fontSize: 17, letterSpacing: 1, fontWeight: FontWeight.w500)),
          Text(description,
              style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      height: 30,
      child: Text(
        title,
        style: const TextStyle(
            color: MyColors.primary, fontWeight: FontWeight.w400, fontSize: 12),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildImage() {
    return image.isEmpty
        ? const SizedBox(width: 24, height: 24)
        : CachedNetworkImage(
      width: 24,
      height: 24,
      imageUrl: image,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}

class OfferCardRow extends StatelessWidget {
  final List<String> termsAndConditions = [
    "You must accept all terms to use the application.",
    "Ensure that your data is kept confidential.",
    "Your usage of the app is subject to our policies.",
    "The company reserves the right to make changes without notice.",
    "You agree to our privacy policy by using this app.",
    "You agree to our privacy policy by using this app.",
    "You agree to our privacy policy by using this app.",
    "You agree to our privacy policy by using this app.",
  ];

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // Aligns text to left and button to right
                children: [
                  const Text(
                    "TODAY'S DISCOUNT",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: MyColors.primary,
                    ),
                  ),
                  // Close Button
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context); // Closes the bottom sheet
                    },
                  ),
                ],
              ),
              const Text(
                'FLAT 15% Off',
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Term and Conditions',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 16.0),
              // Generate terms and conditions dynamically from the list
              ...termsAndConditions.map((term) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("• "), // Bullet point
                      Expanded(
                        child: Text(term),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Walk-in offers',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const Text('Also applicable on table booking',
              style: TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 20),
          SizedBox(
            height: 190,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: InkWell(
                          onTap: () {
                            _showBottomSheet(context);
                          },
                          child: const OfferCard(
                              title: "TODAY'S\nDISCOUNT",
                              offerType: "Flat",
                              discount: "20",
                              description: "on total bill",
                              image: ""),
                        )),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _showBottomSheet(context);
                        },
                        child: OfferCardView(
                          title: "Current Offers",
                          offerList: [
                            Offer(
                                image: 'https://via.placeholder.com/150',
                                offerType: 'Flat',
                                discount: '20',
                                description: 'Use HDFCDINERS'),
                            Offer(
                                image: 'https://via.placeholder.com/150',
                                offerType: 'Flat',
                                discount: '30',
                                description: 'Use ABCD123'),
                            Offer(
                                image: 'https://via.placeholder.com/150',
                                offerType: 'Flat',
                                discount: '15',
                                description: 'Use XYZ789'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const CircleAvatar(
                    radius: 13,
                    backgroundColor: MyColors.primary,
                    child: Icon(Icons.add, color: Colors.white, size: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Offer {
  final String image, offerType, discount, description;

  Offer({required this.image,
    required this.offerType,
    required this.discount,
    required this.description});
}

class OfferCardView extends StatelessWidget {
  final String title;
  final List<Offer> offerList;

  const OfferCardView({required this.title, required this.offerList});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey.shade400, width: 0.9),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 6)
          ]),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildTitle(),
        const SizedBox(height: 4),
        OfferSlider(offerList: offerList),
      ]),
    );
  }

  Widget _buildTitle() {
    return Container(
      height: 30,
      child: Text(
        title,
        style: const TextStyle(
            color: MyColors.primary, fontWeight: FontWeight.w400, fontSize: 12),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class OfferSlider extends StatefulWidget {
  final List<Offer> offerList;

  const OfferSlider({required this.offerList});

  @override
  _OfferSliderState createState() => _OfferSliderState();
}

class _OfferSliderState extends State<OfferSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(
            () => setState(() => _currentPage = _pageController.page!.round()));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 114,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.offerList.length,
            itemBuilder: (context, index) =>
                OfferCardContainer(offer: widget.offerList[index]),
          ),
        ),
        SmoothPageIndicator(
          controller: _pageController,
          count: widget.offerList.length,
          effect: const WormEffect(
              dotHeight: 5,
              dotWidth: 5,
              spacing: 2,
              activeDotColor: MyColors.primary,
              dotColor: Colors.grey),
        ),
      ],
    );
  }
}

class OfferCardContainer extends StatelessWidget {
  final Offer offer;

  const OfferCardContainer({required this.offer});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildImage(),
      Text(offer.offerType.toUpperCase(),
          style: const TextStyle(fontSize: 17, color: Colors.black)),
      Text("${offer.discount}% Off",
          style: const TextStyle(
              fontSize: 17, letterSpacing: 1, fontWeight: FontWeight.w500)),
      Text(offer.description,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
    ]);
  }

  Widget _buildImage() {
    return offer.image.isEmpty
        ? const SizedBox(width: 24, height: 24)
        : CachedNetworkImage(
      width: 24,
      height: 24,
      imageUrl: offer.image,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}

class PrebookOfferListWidget extends StatelessWidget {
  String start_time, end_time, storeName, storeId,kycStatus;

  final List<PreBookTable> prebookofferlist;

  final List<TermConditionModel> termsAndConditions;

  PrebookOfferListWidget({required this.start_time,
    required this.end_time,
    required this.storeName,
    required this.storeId,
    required this.prebookofferlist,
    required this.termsAndConditions,
    required this.kycStatus,
  });

  void _showBottomSheet(BuildContext context, String title) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            // Wrap everything inside SingleChildScrollView to enable scrolling
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Pre-Book offer",
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: MyColors.primary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                Text(
                  '$title',
                  style: const TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Term and Conditions',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 16.0),
                Column(
                  children: [
                    ...termsAndConditions.map((term) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("• ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            Expanded(
                              child: Text(term.termCondition),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          prebookofferlist.length, // Specify item count here
              (index) =>
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: _buildPrebookOfferWidget(
                    context, prebookofferlist[index]),
              ),
        ),
      ),
    );
  }

  Widget _buildPrebookOfferWidget(BuildContext context,
      PreBookTable prebooktable) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Center(
        child: CouponCard(
          backgroundColor: MyColors.primaryColor,
          curveAxis: Axis.vertical,
          firstChild: GestureDetector(
            onTap: () {
              _showBottomSheet(
                  context, "${prebooktable.title}");
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '${prebooktable.title}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Available for limited',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  const SizedBox(height: 5),
                  DottedLine(
                    height: 2,
                    color: Colors.white,
                    width: double.infinity,
                    dashWidth: 6.0,
                    dashSpacing: 6.0,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '${prebooktable.available_seat} slots available',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          secondChild: Container(
            decoration: const BoxDecoration(
              color: MyColors.blackBG,
            ),
            child: Center(
              child: Card(
                elevation: 2,
                color: MyColors.blackBG,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(
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
kycStatus=="Approve"?
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                BookTableScreen("$start_time",
                                    "$end_time", "$storeName", "$storeId")),
                      ):showErrorMessage(context, message: "Store temporarily unavailable here.Kindly visit store for more details.");
                    },
                    child: const Text(
                     'Book\nNow',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
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
  }
}

class RegularOfferListWidget extends StatelessWidget {
  final List<RegularOfferModel> regularofferlist;
  final List<TermConditionModel> termsAndConditions;
  final String storeName, addresss,kycStatus;

  RegularOfferListWidget(
      {required this.regularofferlist, required this.termsAndConditions, required this.storeName, required this.addresss,required this.kycStatus});

  void _showBottomSheet(BuildContext context, String title) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            // Wrap everything inside SingleChildScrollView to enable scrolling
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Today's Discount",
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: MyColors.primary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                Text(
                  '$title',
                  style: const TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Term and Conditions',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 16.0),
                Column(
                  children: [
                    ...termsAndConditions.map((term) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("• ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            Expanded(
                              child: Text(term.termCondition),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          regularofferlist.length,
              (index) =>
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: _buildRegularOfferWidget(
                    context, regularofferlist[index]),
              ),
        ),
      ),
    );
  }

  Widget _buildRegularOfferWidget(BuildContext context,
      RegularOfferModel regularoffer) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Center(
        child: CouponCard(
          backgroundColor: MyColors.primaryColor,
          curveAxis: Axis.vertical,
          firstChild: GestureDetector(
            onTap: () {
              _showBottomSheet(context, regularoffer.title);
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "Today's discount",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          regularoffer.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  DottedLine(
                    height: 2,
                    color: Colors.white,
                    width: double.infinity,
                    dashWidth: 6.0,
                    dashSpacing: 6.0,
                  ),
                  const SizedBox(height: 5),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Tab to view offers',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          secondChild: Container(
            decoration: const BoxDecoration(
              color: MyColors.blackBG,
            ),
            child: Center(
              child: Card(
                elevation: 2,
                color: MyColors.blackBG,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(
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
                      kycStatus=="Approve"?   Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PayBillScreen(
                                    regularoffer, storeName, "$addresss")),
                      ):showErrorMessage(context, message: "Store temporarily unavailable here.Kindly visit store for more details.");
                    },
                    child: const Text(
                     'Pay\nBill',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
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
  }
}
