import 'package:discount_deals/ui/intro_screen.dart';
import 'package:flutter/material.dart';

//const URL="https://discountdeal.himanshukashyap.com";
//const URL="https://discountdealsindia.com";
// const BASE_URL = "https://grabto.in";
// const BASE_URL = "https://grabto.nodexnet.com";
const BASE_URL = "https://grabto.in";
const image = BASE_URL + "/Website/images/grabto.jpg";
// const playstoreLink ="https://play.google.com/store/apps/details?id=digi.coders.discountDeals.discount_deals";
const playstoreLink="https://shorturl.at/v13fS";

const externalPaymentGateway = '$BASE_URL/get_membership';
// const externalPaymentGateway = '$BASE_URL/';

//Guest User
const UserName = "Guest User";
const UserEmail = "guset@gmail.com";
const Usercurrent_location = "Lucknow";
const Userhome_location = "";

class NavigationUtil {
  static void navigateToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IntroScreen(),
      ),
    );
  }
}
