import 'package:discount_deals/model/user_model.dart';
import 'package:discount_deals/ui/intro_screen.dart';
import 'package:discount_deals/ui/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static const String SHARED_PREF_NAME = "digicodersapp";

  static const String KEY_ID = "id";
  static const String KEY_CURRENT_MONTH = "current_month";
  static const String KEY_PREMIUM = "premium";
  static const String KEY_STATUS = "status";
  static const String KEY_NAME = "name";
  static const String KEY_EMAIL = "email";
  static const String KEY_MOBILE = "mobile";
  static const String KEY_DOB = "dob";
  static const String KEY_OTP = "otp";
  static const String KEY_IMAGE = "image";
  static const String KEY_HOME_LOCATION = "home_location";
  static const String KEY_CURRENT_LOCATION = "current_location";
  static const String KEY_LAT = "lat";
  static const String KEY_LONG = "long";
  static const String KEY_CREATED_AT = "created_at";
  static const String KEY_UPDATED_AT = "updated_at";
  static const String KEY_TOKEN = "token";

  static const String KEY_GATEWAY_STATUS = "gateway_status";
  static const String KEY_EXTERNAL_LINK = "external";
  static const String KEY_ABOUT_EXTERNAL_STATUS= "about_external_status";

  static Future<void> userLogin(Map<String, dynamic> userData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(KEY_ID, userData[KEY_ID] ?? 0);
    await prefs.setString(KEY_CURRENT_MONTH, userData[KEY_CURRENT_MONTH] ?? '');
    await prefs.setString(KEY_PREMIUM, userData[KEY_PREMIUM] ?? '');
    await prefs.setString(KEY_STATUS, userData[KEY_STATUS] ?? '');
    await prefs.setString(KEY_NAME, userData[KEY_NAME] ?? '');
    await prefs.setString(KEY_EMAIL, userData[KEY_EMAIL] ?? '');
    await prefs.setString(KEY_MOBILE, userData[KEY_MOBILE] ?? '');
    await prefs.setString(KEY_DOB, userData[KEY_DOB] ?? '');
    await prefs.setString(KEY_OTP, userData[KEY_OTP] ?? '');
    await prefs.setString(KEY_IMAGE, userData[KEY_IMAGE] ?? '');
    await prefs.setString(KEY_HOME_LOCATION, userData[KEY_HOME_LOCATION] ?? '');
    await prefs.setString(
        KEY_CURRENT_LOCATION, userData[KEY_CURRENT_LOCATION] ?? '');
    await prefs.setString(KEY_LAT, userData[KEY_LAT] ?? '');
    await prefs.setString(KEY_LONG, userData[KEY_LONG] ?? '');
    await prefs.setString(KEY_CREATED_AT, userData[KEY_CREATED_AT] ?? '');
    await prefs.setString(KEY_UPDATED_AT, userData[KEY_UPDATED_AT] ?? '');
  }

  static Future<int> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int id = prefs.getInt(KEY_ID) ?? 0;
    return id;
  }

  // static Future<void> logout(BuildContext context) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.clear();
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) => LoginScreen(token: "",)),
  //   );
  // }

  static Future<void> logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => IntroScreen()),
      (Route<dynamic> route) => false, // Remove all routes
    );
  }

  static Future<UserModel> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return UserModel(
      id: prefs.getInt(KEY_ID) ?? 0,
      current_month: prefs.getString(KEY_CURRENT_MONTH) ?? '',
      premium: prefs.getString(KEY_PREMIUM) ?? '',
      status: prefs.getString(KEY_STATUS) ?? '',
      name: prefs.getString(KEY_NAME) ?? '',
      email: prefs.getString(KEY_EMAIL) ?? '',
      mobile: prefs.getString(KEY_MOBILE) ?? '',
      dob: prefs.getString(KEY_DOB) ?? '',
      otp: prefs.getString(KEY_OTP) ?? '',
      image: prefs.getString(KEY_IMAGE) ?? '',
      home_location: prefs.getString(KEY_HOME_LOCATION) ?? '',
      current_location: prefs.getString(KEY_CURRENT_LOCATION) ?? '',
      lat: prefs.getString(KEY_LAT) ?? '',
      long: prefs.getString(KEY_LONG) ?? '',
      created_at: prefs.getString(KEY_CREATED_AT) ?? '',
      updated_at: prefs.getString(KEY_UPDATED_AT) ?? '',
    );
  }

  static Future<void> updateHomeLocation(String homeLocation) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(KEY_HOME_LOCATION, homeLocation);
  }

  static Future<void> updateCurrentLocation(String currentLocation) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(KEY_CURRENT_LOCATION, currentLocation);
  }

  static Future<String> getHomeLocation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_HOME_LOCATION) ?? '';
  }

  static Future<void> updateToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(KEY_TOKEN, token);
  }

  static Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_TOKEN) ?? '';
  }

  static Future<void> updateGatewayStatus(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(KEY_GATEWAY_STATUS, token);
  }

  static Future<String> getGatewayStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_GATEWAY_STATUS) ?? '';
  }

  static Future<void> updateExternalLinkStatus(String status) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(KEY_EXTERNAL_LINK, status);
  }

  static Future<String> getExternalLinkStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_EXTERNAL_LINK) ?? '';
  }

  static Future<void> updateAboutExternalLinkStatus(String status) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(KEY_ABOUT_EXTERNAL_STATUS, status);
  }

  static Future<String> getAboutExternalLinkStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_ABOUT_EXTERNAL_STATUS) ?? '';
  }
}
