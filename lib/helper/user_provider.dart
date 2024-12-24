


import 'package:discount_deals/helper/shared_pref.dart';
import 'package:discount_deals/model/user_model.dart';
import 'package:flutter/material.dart';
class UserProvider extends ChangeNotifier {
  UserModel? _user; // Allow _user to be null

  UserModel? get user => _user;


  // Method to fetch user details from SharedPref or any other source
  Future<void> fetchUserDetails() async {
    // Simulated user data retrieval
    UserModel userData = await SharedPref.getUser();

    _user = userData;
    notifyListeners(); // Notify listeners about the data change
  }

  // Method to update user details
  void updateUserDetails(UserModel updatedUser) {
    _user = updatedUser;
    notifyListeners(); // Notify listeners about the data change
  }
}
