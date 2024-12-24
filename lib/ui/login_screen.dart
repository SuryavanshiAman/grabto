import 'package:discount_deals/model/user_model.dart';
import 'package:discount_deals/ui/otp_screen.dart';
import 'package:discount_deals/ui/signup_screen.dart';
import 'package:discount_deals/utils/snackbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../services/api_services.dart';
import '../theme/theme.dart';
import '../widget/loader_hud.dart';

class LoginScreen extends StatefulWidget {

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController mobileControllerLogin = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              color: MyColors.backgroundBg,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Positioned(
                    top: 150,
                    left: 40,
                    child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        height: 200,
                        constraints: const BoxConstraints(maxHeight: 260),
                        child: Image.asset('assets/vector/login_img.png')),
                  ),
                  Container(
                    //margin: EdgeInsets.only(bottom: 15),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 350,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: MyColors.roundBg,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  80)), // Adjust the radius to make it more or less rounded
                        ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 20),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Login",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: MyColors.whiteBG),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Login to your account",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        color: MyColors.whiteBG),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 55,
                                      child: TextField(
                                        controller: mobileControllerLogin,
                                        enabled: true,
                                        cursorColor: Colors.white,
                                        keyboardType: TextInputType.number,
                                        //maxLength: 10,
                                        minLines: 1,
                                        style:
                                            TextStyle(color: MyColors.whiteBG),
                                        decoration: InputDecoration(
                                          hintText: 'Mobile Number',
                                          hintStyle: TextStyle(
                                              color: Color(0xFFDDDDDD)),
                                          prefixIcon: Icon(
                                              Icons.mobile_friendly,
                                              color: MyColors.whiteBG),
                                          enabledBorder: OutlineInputBorder(
                                            gapPadding: 0,
                                            borderSide: BorderSide(
                                                color: MyColors.primaryColor),
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: MyColors.whiteBG),
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 17,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        final mobile =
                                            mobileControllerLogin.text;
                                        user_login(mobile);
                                      },
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                            fontSize: 17, color: Colors.white),
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                MyColors.btnBgColor),
                                      ),
                                    ),
                                  ],
                                ),
                              )
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
          // Show a loading indicator if _isLoading is true
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    MyColors.primaryColor,
                  ),
                  // Change the color
                  strokeWidth: 4,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> user_login(String mobile) async {
    if (mobile.isEmpty) {
      showErrorMessage(context, message: 'Please fill mobile number');
      return;
    } else if (mobile.length != 10) {
      showErrorMessage(context,
          message: 'Please fill only 10 digit mobile number');
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });
      final body = {"mobile": mobile};
      final response = await ApiServices.api_user_login(context, body);

      // Check if the response is null or doesn't contain the expected data
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final data = response['data'];
        // Ensure that the response data is in the expected format
        if (data != null && data is Map<String, dynamic>) {
          print('user_login data: $data');
          final user = UserModel.fromMap(data);

          if (user != null) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => OtpScreen(mobile: mobile,)));
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
        showErrorMessage(context, message: 'Mobile no. is not registered.');
        showErrorMessage(context, message: msg);
        print("Aman");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SignupScreen()));
        // Handle unsuccessful response or missing 'res' field

      }
    } catch (e) {
      print('user_login error: $e');
      // Handle error
      showErrorMessage(context, message: 'An error occurred: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
