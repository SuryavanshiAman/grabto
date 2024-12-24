import 'dart:async';
import 'dart:io' show Platform;
import 'package:discount_deals/helper/shared_pref.dart';
import 'package:discount_deals/model/user_model.dart';
import 'package:discount_deals/services/api_services.dart';
import 'package:discount_deals/theme/theme.dart';
import 'package:discount_deals/ui/home_screen.dart';
import 'package:discount_deals/ui/intro_screen.dart';
import 'package:discount_deals/utils/snackbar_helper.dart';
import 'package:discount_deals/widget/my_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/animation.dart';

class YourTickerProvider implements TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }
}

class SplashScreen extends StatefulWidget {
  String? token;

  SplashScreen({required this.token});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    SharedPref.updateToken("${widget.token}");
    getwayStatus();

    Timer(Duration(seconds: 3), () {
      navigateToScreen(context);
    });

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: YourTickerProvider(),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: MyColors.splashBg,
        child: Stack(
          children: [
            //Lottie.asset('assets/lottie/gift.json'),

            Center(
              // child: ScaleTransition(
              //   scale: _animation,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                // child: Image.asset('assets/images/grabto_logo_without_bg.png'),
                child: Image.asset('assets/gif/grabto_logo.gif'),
              ),
              // ),
            ),

            // Text at the bottom
            Container(
              margin: EdgeInsets.only(bottom: 15),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width: 36, height: 36, child: MyProgressBar()),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Loading...",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> navigateToScreen(BuildContext context) async {
    //print("hello data");
    print("userId: " + SharedPref.isLoggedIn().toString());
    int isLoggedIn = await SharedPref.isLoggedIn();
    if (isLoggedIn == 0) {
      Navigator.pop(context);
      await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IntroScreen(),
          ));
    } else {
      Navigator.pop(context);
      await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ));
    }
  }

  Future<void> getwayStatus() async {
    try {
      final response = await ApiServices.getwayStatus(context);
      // Check if the response is null or doesn't contain the expected data
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {

        if (Platform.isAndroid) {
          String android = response['android'];
          String external_android = response['external_android'];
          String about_external_status = response['about_external_status_android'];

          print('GatewayStatus: Android = ' + android + ', external_android = ' + external_android);
          SharedPref.updateGatewayStatus("${android}");
          SharedPref.updateExternalLinkStatus("${external_android}");
          SharedPref.updateAboutExternalLinkStatus("${about_external_status}");

        } else if (Platform.isIOS) {

          String ios = response['ios'];
          String external_ios = response['external_ios'];
          String about_external_status = response['about_external_status_ios'];
          //
          print('GatewayStatus: IOS = ' + ios + ', external_ios = ' + external_ios);
          SharedPref.updateGatewayStatus("${ios}");
          SharedPref.updateExternalLinkStatus("${external_ios}");
          SharedPref.updateAboutExternalLinkStatus("${about_external_status}");

        } else {
          String android = response['android'];
          String external_android = response['external_android'];
          String about_external_status = response['about_external_status_android'];

          print('GatewayStatus: Android = ' + android + ', external_android = ' + external_android);
          SharedPref.updateGatewayStatus("${android}");
          SharedPref.updateExternalLinkStatus("${external_android}");
          SharedPref.updateAboutExternalLinkStatus("${about_external_status}");
        }
      }
    } catch (e) {
    } finally {}
  }
}
