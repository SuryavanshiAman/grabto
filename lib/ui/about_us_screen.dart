import 'package:discount_deals/helper/shared_pref.dart';
import 'package:discount_deals/model/user_model.dart';
import 'package:discount_deals/services/api.dart';
import 'package:discount_deals/ui/membership_plan_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/theme.dart';

class AboutUsScreen extends StatefulWidget {
  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {

  String aboutExternalStatus = '';
  int user_id = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();


    SharedPref.getAboutExternalLinkStatus().then((external) {
      aboutExternalStatus = external;
      print("gatewayStatus aboutExternalStatus: " + aboutExternalStatus);
    }).catchError((error) {
      print('Failed to get gateway status: $error');
    });
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

  Future<void> getUserDetails() async {
    // SharedPref sharedPref=new SharedPref();
    // userName = (await SharedPref.getUser()).name;
    String token = await SharedPref.getToken();
    UserModel n = await SharedPref.getUser();
    print("getUserDetails: ${n.id}");
    setState(() {
      user_id = n.id;
    });
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
          "About Us",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        color: MyColors.backgroundBg,
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                "Welcome to Grabto - Your Gateway to Savings!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Divider(color: Colors.grey),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.local_offer, color: Colors.green),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Grabto is one of the pioneering deals and discounts application in India with full-fledged operations. Today we have continued our presence online and offline with more than 500+ outlets in various industries like Restaurants, Hotels, Salons, Spas, Gyms, and Entertainment Centers.",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.card_membership, color: Colors.blue),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Grabto brings several discount coupons where you can save money once you purchase a membership. We charge for the coupon one time for a validity period, and you will get a huge number of coupons. Shoppers save money, experience the fun of choices while eating, enjoying outings, and having luxury time with unbelievable deals. Grabto means lots of discounts in one window solution.",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.update, color: Colors.orange),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "We have constantly changed our interface to present the information attractively - by product categories, brand, stores, and localities - making it easy for our customers to find the best deals conveniently. Grabto's easy search finds deals and discounts quickly. Check out current online deals.",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible:
                   aboutExternalStatus == "true",
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (user_id == 0) {
                            NavigationUtil.navigateToLogin(context);
                          } else {
                            if (aboutExternalStatus == "true") {
                              _launchExternalMambership("${user_id}");
                            }
                          }
                        },
                        child: Text(
                          "Our Membership Plans",
                          style: TextStyle(fontSize: 17, color: Colors.white),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              MyColors.btnBgColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Grabto - Powered by\n\"Shree Laxmi Enterprises\"",
                      style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic,),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
