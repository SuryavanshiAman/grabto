import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:discount_deals/generated/assets.dart';
import 'package:discount_deals/helper/shared_pref.dart';
import 'package:discount_deals/helper/user_provider.dart';
import 'package:discount_deals/main.dart';
import 'package:discount_deals/model/city_model.dart';
import 'package:discount_deals/model/user_model.dart';
import 'package:discount_deals/services/api.dart';
import 'package:discount_deals/services/api_services.dart';
import 'package:discount_deals/theme/theme.dart';
import 'package:discount_deals/ui/about_us_screen.dart';
import 'package:discount_deals/ui/bottom_categories_screen.dart';
import 'package:discount_deals/ui/bottom_home_screen.dart';
import 'package:discount_deals/ui/bottom_login_screen.dart';
import 'package:discount_deals/ui/bottom_profile_screen.dart';
import 'package:discount_deals/ui/bottom_sortlist_screen.dart';
import 'package:discount_deals/ui/customer_care.dart';
import 'package:discount_deals/ui/delete_screen.dart';
import 'package:discount_deals/ui/how_it_works.dart';
import 'package:discount_deals/ui/membership_plan_screen.dart';
import 'package:discount_deals/ui/redeem_screen.dart';
import 'package:discount_deals/ui/term_and_condition.dart';
import 'package:discount_deals/ui/transaction_screen.dart';
import 'package:discount_deals/utils/snackbar_helper.dart';
import 'package:discount_deals/widget/item_list_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter/src/widgets/basic.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 0;
  List<CityModel> cityList = [];
  String userName = '';
  String userEmail = '';
  String userMobile = '';
  String userimage = '';
  String dialogimage = '';
  String current_location = '';
  String home_location = '';
  String planName = '';
  String left_day = '';
  String gatewayStatus = '';
  String externalStatus = '';
  int user_id = 0;

  Future<void> _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
    await getUserDetails();
  }

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
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

    WidgetsBinding.instance.addObserver(this);
    allApiCallHome();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      // Call your function when the app resumes
      if (user_id != 0) {
        HomeBottamScreen.instance!.UserPreBookTableHistory("$user_id");
        await getUserDetails();
        await fetchCity();
        await currentMembership("$user_id");
      }
    }
  }

  Future<void> _fetchMembership() async {
    await currentMembership("$user_id");
  }

  @override
  void dispose() {
    super.dispose();
  }

  void allApiCallHome() async {
    setState(() {
      isLoading = true;
    });

    try {
      await getUserDetails();
      await fetchCity();
      await api_popup_dialog(context);
    } catch (e) {
      print('Error in API calls: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showCityDialog() async {
    final CityModel? selectedCity = await showDialog<CityModel>(
      context: context,
      builder: (BuildContext context) {
        return ItemListDialog(items: cityList);
      },
    );

    if (selectedCity != null) {
      if (user_id == 0) {
        setState(() {
          home_location = "${selectedCity.id}";
          current_location = "${selectedCity.city}";
          SharedPref.updateHomeLocation(home_location);
          SharedPref.updateCurrentLocation(current_location);

          if (HomeBottamScreen.instance != null) {
            HomeBottamScreen.instance!.getUserDetails();
          }
        });
      } else {
        user_city_updated("$user_id", "${selectedCity.id}");
      }
    }
  }

  _launchExternalMambership(String user_id) async {
    String url = '$externalPaymentGateway/$user_id';

    // Check if any of the URLs can be launched
    if (await canLaunch(url)) {
      print('Launching map application');
      await launch(url);
    } else {
      throw 'Could not launch map application';
    }
  }

  Future<void> _handleReturnFromSecondScreen() async {
    // This function will be called when returning from the second screen
    print('Returned from HomeScreen');
    await getUserDetails();
    await fetchCity();
    await currentMembership("$user_id");
  }
  Future<bool> _onWillPop() async {
    if (_selectedIndex > 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return false;
    } else {
      return await showExitConfirmation(context) ?? true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: MyColors.backgroundBg,
      appBar: AppBar(
        backgroundColor: MyColors.backgroundBg,
        actions: [
          Text(
            "${current_location}",
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 10),
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
                  Icons.pin_drop,
                  size: 24,
                  color: MyColors.primaryColor,
                ),
                onPressed: () {
                  _showCityDialog();
                },
              ),
            ),
          ),
        ],
      ),
      body: Stack(children: [
        Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
              maxHeight: MediaQuery.of(context).size.height),
          child: <Widget>[
            /// Home page
            HomeBottamScreen(
              onFetchMembership: currentMembership,
            ),

            CategoriesBottamWidget(),

            //BottomLoginScreen(),
            user_id == 0 ? const BottomLoginScreen() : SortListBottamWidget(),

            user_id == 0 ? const BottomLoginScreen() : ProfileBottomScreen(),
          ][_selectedIndex],
        ),
        // if (isLoading)
        //   Container(
        //     color: Colors.black.withOpacity(0.5),
        //     // Adjust opacity as needed
        //     child: Center(
        //       child: CircularProgressIndicator(
        //         valueColor: AlwaysStoppedAnimation<Color>(
        //           MyColors.primaryColor,
        //         ),
        //         // Change the color
        //         strokeWidth: 4,
        //       ),
        //     ),
        //   ),
      ]),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            Container(
                decoration: BoxDecoration(
                  //color: MyColors.primaryColor.withOpacity(0.0),
                  image: DecorationImage(
                    image: const AssetImage("assets/images/drawer_bg_img.jpg"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      MyColors.primaryColor.withOpacity(0.1),
                      BlendMode.darken,
                    ),
                  ),
                ), //BoxDecoration
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 50, bottom: 20),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                              // Set the clip behavior of the card
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              // Define the child widgets of the card
                              child: Container(
                                width: 70,
                                height: 70,
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: userimage.isNotEmpty
                                        ? userimage
                                        : image,
                                    fit: BoxFit.fill,
                                    placeholder: (context, url) => Image.asset(
                                      'assets/images/placeholder.png',
                                      // Path to your placeholder image asset
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Center(child: Icon(Icons.error)),
                                  ),
                                  // child: Image.network(
                                  //   userimage.isNotEmpty ? userimage : image,
                                  //   loadingBuilder: (BuildContext context,
                                  //       Widget child,
                                  //       ImageChunkEvent? loadingProgress) {
                                  //     if (loadingProgress == null) {
                                  //       return child;
                                  //     } else {
                                  //       return Center(
                                  //         child: CircularProgressIndicator(
                                  //           value: loadingProgress
                                  //                       .expectedTotalBytes !=
                                  //                   null
                                  //               ? loadingProgress
                                  //                       .cumulativeBytesLoaded /
                                  //                   (loadingProgress
                                  //                           .expectedTotalBytes ??
                                  //                       1)
                                  //               : null,
                                  //         ),
                                  //       );
                                  //     }
                                  //   },
                                  //   errorBuilder: (BuildContext context,
                                  //       Object error, StackTrace? stackTrace) {
                                  //     return Icon(Icons
                                  //         .person); // Placeholder icon for error case
                                  //   },
                                  // ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                              height: 10,
                            ),
                            Visibility(
                              visible:
                                  userName.isNotEmpty || userEmail.isNotEmpty,
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                  children: [
                                    if (userName.isNotEmpty)
                                      TextSpan(
                                        text: '$userName\n',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    if (userName.isNotEmpty &&
                                        userMobile.isNotEmpty)
                                      const WidgetSpan(
                                        child: SizedBox(
                                            height:
                                                25), // Adjust the height as needed
                                      ),
                                    if (userMobile.isNotEmpty)
                                      TextSpan(
                                        text: '$userMobile',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black.withOpacity(0.7),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    // Center(
                    //   child: SvgPicture.string(
                    //     "assets/images/drawer_img.xml",
                    //     width: 500,
                    //     height: 500,
                    //   ),
                    // ),
                  ],
                )),

            // Visibility(
            //   visible: planName.isNotEmpty && gatewayStatus == "true",
            //   child: Container(
            //     margin: EdgeInsets.all(15),
            //     width: 240,
            //     decoration: BoxDecoration(
            //       color: Colors.black, // Background color
            //       borderRadius: BorderRadius.all(Radius.circular(12)),
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.grey.withOpacity(0.5),
            //           blurRadius: 6,
            //           offset: Offset(0, 3), // Shadow effect
            //         ),
            //       ],
            //     ),
            //     child: Padding(
            //       padding: const EdgeInsets.all(10.0),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Text(
            //                 "$planName", // Invite friends to get membership
            //                 style: TextStyle(
            //                   fontWeight: FontWeight.bold,
            //                   fontSize: 16,
            //                   color: Colors.white, // White text color
            //                 ),
            //               ),
            //               SizedBox(height: 8),
            //               Text(
            //                 "$left_day Day Left", // Event time: 8.8-8.31
            //                 style: TextStyle(
            //                   fontSize: 14,
            //                   color: Colors
            //                       .white70, // Slightly faded white text color
            //                 ),
            //               ),
            //             ],
            //           ),
            //           // Placeholder for the decorative image or element
            //           Container(
            //               width: 60,
            //               height: 60,
            //               decoration: BoxDecoration(
            //                 color: Colors.grey.shade800,
            //                 borderRadius: BorderRadius.circular(30),
            //                 // Example decoration, replace with your asset if needed
            //               ),
            //               child:
            //                   Image.asset("assets/vector/membership_king.png")),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),

            //DrawerHeader
            ListTile(
              leading: const Icon(
                Icons.home,
                color: MyColors.drawerIconColor,
              ),
              title: const Text(' Home '),
              onTap: () {
                _onItemTappedd(0);
              },
            ),
            // ListTile(
            //   leading: const Icon(
            //     Icons.wallet,
            //     color: MyColors.drawerIconColor,
            //   ),
            //   title: const Text(' Wallet '),
            //   onTap: () {
            //     //Navigator.pop(context);
            //     Navigator.push(context, MaterialPageRoute(builder: (context) {
            //       return WallerScreen();
            //     }));
            //   },
            // ),
            /*ListTile(
              leading: const Icon(
                Icons.wallet_giftcard_outlined,
                color: MyColors.drawerIconColor,
              ),
              title: const Text(' Refer & Earn '),
              onTap: () {
                //Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ReferAndEarn();
                }));
              },
            ),*/
            ListTile(
              leading: const Icon(
                Icons.account_balance_wallet,
                color: MyColors.drawerIconColor,
              ),
              title: const Text(' Transaction '),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return TransactionScreen();
                }));
              },
            ),
            // Visibility(
            //   visible: gatewayStatus == "true",
            //   child: ListTile(
            //     leading: const Icon(
            //       Icons.next_plan_outlined,
            //       color: MyColors.drawerIconColor,
            //     ),
            //     title: const Text(' Plans '),
            //     onTap: () async {
            //       //Navigator.pop(context);
            //       if (user_id == 0) {
            //         NavigationUtil.navigateToLogin(context);
            //       } else {
            //         if (externalStatus == "true") {
            //           _launchExternalMambership("${user_id}");
            //         } else {
            //           // Navigate to the second screen and await the result
            //           final result = await Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) => MembershipPlansUI()),
            //           );
            //
            //           // Call the function after returning
            //           _handleReturnFromSecondScreen();
            //         }
            //       }
            //     },
            //   ),
            // ),
            // ListTile(
            //   leading: const Icon(
            //     Icons.next_plan_outlined,
            //     color: MyColors.drawerIconColor,
            //   ),
            //   title: const Text(' Redeems '),
            //   onTap: () {
            //     //Navigator.pop(context);
            //     if (user_id == 0) {
            //       NavigationUtil.navigateToLogin(context);
            //     } else {
            //       Navigator.push(context, MaterialPageRoute(builder: (context) {
            //         return RedeemHistoryScreen();
            //       }));
            //     }
            //   },
            // ),
            ListTile(
              leading: const Icon(
                Icons.support_agent,
                color: MyColors.drawerIconColor,
              ),
              title: const Text(' Customer Care '),
              onTap: () {
                //Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return CustomerCare();
                }));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.settings,
                color: MyColors.drawerIconColor,
              ),
              title: const Text(' How to use app '),
              onTap: () {
                //Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return HowItWorksScreen();
                }));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.share_rounded,
                color: MyColors.drawerIconColor,
              ),
              title: const Text(' Share '),
              onTap: () {
                _scaffoldKey.currentState?.closeDrawer();
                shareNetworkImage("$image",
                    "\nCheck out this store on Discount Deals! \n\n *Download Now* \n\n $playstoreLink");
                //Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.info_outline,
                color: MyColors.drawerIconColor,
              ),
              title: const Text(' About Us '),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AboutUsScreen()),
                );

                // Call the function after returning
                _handleReturnFromSecondScreen();

              },
            ),
            ListTile(
              leading: const Icon(
                Icons.book,
                color: MyColors.drawerIconColor,
              ),
              title: const Text(' Terms & Condition '),
              onTap: () {
                //Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return TermsAndCondition();
                }));
              },
            ),
            Visibility(
              visible: user_id != 0,
              child: ListTile(
                leading: const Icon(
                  Icons.delete_sweep_rounded,
                  color: MyColors.drawerIconColor,
                ),
                title: const Text(' Account Delete '),
                onTap: () {
                  //Navigator.pop(context);

                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return DeleteScreen();
                  }));

                  //logoutUser();
                },
              ),
            ),
            ListTile(
              leading: user_id == 0
                  ? const Icon(
                      Icons.login_outlined,
                      color: MyColors.drawerIconColor,
                    )
                  : const Icon(
                      Icons.logout_outlined,
                      color: MyColors.drawerIconColor,
                    ),
              title: user_id == 0 ? const Text(' Login ') : const Text(' Logout '),
              onTap: () {
                //Navigator.pop(context);
                if (user_id == 0) {
                  NavigationUtil.navigateToLogin(context);
                } else {
                  logoutUser();
                }
              },
            ),
          ],
        ),
      ),
      //
      bottomNavigationBar: PopScope(
        canPop: false,
        onPopInvoked: (v) {
          _onWillPop();
        },
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
                color: MyColors.bottomNavigationUnselectedColor,
              ),
              activeIcon: Icon(
                Icons.home,
                color: MyColors.bottomNavigationSelectedColor,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.category_outlined,
                  color: MyColors.bottomNavigationUnselectedColor,
                ),
                activeIcon: Icon(
                  Icons.category_rounded,
                  color: MyColors.bottomNavigationSelectedColor,
                ),
                label: "Categories"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.favorite_border,
                  color: MyColors.bottomNavigationUnselectedColor,
                ),
                activeIcon: Icon(
                  Icons.favorite,
                  color: MyColors.bottomNavigationSelectedColor,
                ),
                label: "Bookmark"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person_outline,
                  color: MyColors.bottomNavigationUnselectedColor,
                ),
                activeIcon: Icon(
                  Icons.person,
                  color: MyColors.bottomNavigationSelectedColor,
                ),
                label: "Profile")
          ],
          currentIndex: _selectedIndex,
          showUnselectedLabels: true,
          unselectedItemColor: MyColors.bottomNavigationUnselectedColor,
          selectedItemColor: MyColors.bottomNavigationSelectedColor,
          elevation: 5,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  void _onItemTappedd(int index) {
    setState(() {
      _selectedIndex = index;
    });
    //Navigator.push(context, MaterialPageRoute(builder: (context){return HomeScreen();}));
    Navigator.pop(context);

    //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBottamScreen()));
  }
  static showExitConfirmation(BuildContext context) async {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return await showModalBottomSheet(
      elevation: 5,
      // backgroundColor: primary,
      shape: const RoundedRectangleBorder(
          side: BorderSide(width: 2, color: Colors.white),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35), topRight: Radius.circular(35))),
      context: context,
      builder: (context) {
        return Container(
          height: height * 0.45,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 28.0, top: 28),
                child: InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.close)),
              ),
              SizedBox(height: height / 30),
              const Center(
                child: Text("Exit App",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: height*0.02),
              const Center(
                child: Text("Are you sure want to exit app?",
                    style: TextStyle(
                      color: MyColors.blackBG,
                      fontSize: 16,
                    )),
              ),
              SizedBox(height: height * 0.04),
              Center(
                child: SizedBox(
                  width: width * 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            // side:
                            // BorderSide(width: 1, color: Colors.white),
                            // elevation: 3,
                              backgroundColor: MyColors.redBG,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(55)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.34,
                                  vertical: height * 0.02)),
                          onPressed: () {
                            SystemNavigator.pop();
                          },
                          child: const Text("Yes",
                              style: TextStyle(
                                  color: MyColors.whiteBG,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold))),
                      SizedBox(height: height * 0.03),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:MyColors.redBG,
                              // side: const BorderSide(width: 1,color: tertiary),
                              // elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(55)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.34,
                                  vertical: height * 0.02)),
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: const Text("No",
                              style: TextStyle(
                                  color: MyColors.whiteBG,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    ) ??
        false;
  }
  Future<void> shareNetworkImage(String imageUrl, String text) async {
    setState(() {
      isLoading = true;
    });
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

    setState(() {
      isLoading = false;
    });
  }

  Future<void> getUserDetails() async {
    // SharedPref sharedPref=new SharedPref();
    // userName = (await SharedPref.getUser()).name;
    String token = await SharedPref.getToken();
    UserModel n = await SharedPref.getUser();
    print("getUserDetails: ${n.id}");
    setState(() {
      user_id = n.id;
      userName = n.name;
      userEmail = n.email;
      userMobile = n.mobile;
      userimage = n.image;
      current_location = n.current_location;
      home_location = n.home_location;

      if (user_id != 0) {
        user_details("${n.id}");
        firebaseTokenApi(context, "$token", "$user_id");
        currentMembership("$user_id");
      }
    });
  }

  Future<void> fetchCity() async {
    try {
      final response = await ApiServices.api_show_city(context);
      print('fetchCity:response  $response');
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final data = response['data'] as List<dynamic>;

        cityList = data.map((e) {
          return CityModel.fromMap(e);
        }).toList();
      } else if (response != null) {
        String msg = response['msg'];

        // Handle unsuccessful response or missing 'res' field
        showErrorMessage(context, message: msg);
      }
    } catch (e) {
      print('fetchCity: $e');
    }
  }

  void logoutUser() {
    SharedPref.logout(context);
  }

  Future<void> api_popup_dialog(BuildContext context) async {
    try {
      final response = await ApiServices.api_popup_dialog();

      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final data = response['data'];
        if (data != null &&
            data is Map<String, dynamic> &&
            data.containsKey('image')) {
          String imageUrl = data['image'] as String;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomPopup(imageUrl: imageUrl);
            },
          );
        } else {
          //showErrorMessage(context, message: 'Invalid response data format');
        }
      } else if (response != null) {
        String msg = response['msg'];
        //showErrorMessage(context, message: msg);
      }
    } catch (e) {
      print('Error in api_popup_dialog: $e');
      //showErrorMessage(context, message: 'An error occurred: $e');
    }
  }

  Future<void> user_details(String user_id) async {
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
            Provider.of<UserProvider>(context, listen: false)
                .updateUserDetails(user);
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

  Future<void> user_city_updated(String user_id, String city_id) async {
    print('UpdateUserCity datashow: $city_id');
    setState(() {
      isLoading = false;
    });
    try {
      final body = {
        "user_id": user_id,
        "city_id": city_id,
      };
      final response = await ApiServices.UpdateUserCity(context, body);

      // Check if the response is null or doesn't contain the expected data
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final data = response['data'];
        print('UpdateUserCity datashow: $data');
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

            setState(() async {
              UserModel n = await SharedPref.getUser();
              current_location = n.current_location;
              if (HomeBottamScreen.instance != null) {
                HomeBottamScreen.instance!
                    .allApiCall(n.home_location); // Add ! or null check
              }
            });
          } else {
            // Handle null user
            showErrorMessage(context, message: 'User data is invalid');
          }
        } else {
          // Handle invalid response data format
          //showErrorMessage(context, message: 'Invalid response data format');
        }
      } else if (response != null) {
        String msg = response['msg'];

        // Handle unsuccessful response or missing 'res' field
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

  Future<void> firebaseTokenApi(
      BuildContext context, String token, String userid) async {
    try {
      final body = {"token": token, "userid": userid};
      final response = await ApiServices.firebaseToken(context, body);

      // Check if the response is null or doesn't contain the expected data
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final data = response['data'];
        final msg = response['msg'];
      } else if (response != null) {
        String msg = response['msg'];
      }
    } catch (e) {
    } finally {}
  }

  Future<void> currentMembership(String user_id) async {
    print('current_membership user_id: $user_id');
    setState(() {
      isLoading = true;
    });
    try {
      final body = {
        "user_id": user_id,
      };
      final response = await ApiServices.api_CurrentMembership(body);
      print('current_membership response: $response');
      if (response != null) {
        setState(() {
          planName = response.plan_name;
          left_day = "${response.left_day}";
        });
      } else {
        planName = '';
        left_day = '';
      }
    } catch (e) {
      print('Error: $e');
      planName = '';
      left_day = '';
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}

//Notification
class NotificationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Card(
            child: ListTile(
              leading: Icon(Icons.notifications_sharp),
              title: Text('Notification 1'),
              subtitle: Text('This is a notification'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.notifications_sharp),
              title: Text('Notification 2'),
              subtitle: Text('This is a notification'),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomPopup extends StatefulWidget {
  final String imageUrl;

  CustomPopup({required this.imageUrl});

  @override
  _CustomPopupState createState() => _CustomPopupState();
}

class _CustomPopupState extends State<CustomPopup> {
  late String _imageUrl;

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _contentBox(context),
    );
  }

  Widget _contentBox(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.maxFinite,
      height: screenWidth * 0.8,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              width: double.maxFinite,
              fit: BoxFit.fill,
              height: screenWidth * 0.8,
              imageUrl: "$_imageUrl",
              placeholder: (context, url) => Image.asset(
                'assets/images/placeholder.png',
                // Path to your placeholder image asset
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              errorWidget: (context, url, error) =>
                  const Center(child: Icon(Icons.error)),
            ),
          ),
          Positioned(
            top: screenWidth <= 600 ? 5 : 10, // Adjust based on screen width
            right: screenWidth <= 600 ? 5 : 10, // Adjust based on screen width
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Container(
                width: screenWidth <= 600 ? 30 : 40,
                // Adjust based on screen width
                height: screenWidth <= 600 ? 30 : 40,
                // Adjust based on screen width
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.9),
                ),
                child: Icon(
                  Icons.close,
                  color: MyColors.primaryColor,
                  size: screenWidth <= 600
                      ? 18
                      : 24, // Adjust based on screen width
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
