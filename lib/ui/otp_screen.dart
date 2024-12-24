import 'package:discount_deals/helper/shared_pref.dart';
import 'package:discount_deals/model/user_model.dart';
import 'package:discount_deals/services/api_services.dart';
import 'package:discount_deals/ui/home_screen.dart';
import 'package:discount_deals/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';

import '../theme/theme.dart';

class OtpScreen extends StatefulWidget {
  String mobile;

  OtpScreen({required this.mobile});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool isLoading = false;
  String text = '';

  void _onKeyboardTap(String value) {
    setState(() {
      text = text + value;
    });
  }

  Widget otpNumberWidget(int position) {
    try {
      return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            border: Border.all(color: MyColors.primaryColor, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: Center(
            child: Text(
          text[position],
          style: TextStyle(color: Colors.black, fontSize: 20),
        )),
      );
    } catch (e) {
      return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            border: Border.all(color: MyColors.txtDescColor2, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: MyColors.blackBG,
            ),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 16,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 30),
                              height: 200,
                              constraints: const BoxConstraints(maxHeight: 260),
                              child: Image.asset('assets/vector/otp_img.png')),
                        ),
                        Text('Enter verification code',
                            style: TextStyle(
                                color: MyColors.txtTitleColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w500)),
                        Text(
                            'Enter the 4 digit number that \n we sent to ${widget.mobile}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: MyColors.txtDescColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w500)),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          constraints: const BoxConstraints(
                            maxWidth: 300,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              otpNumberWidget(0),
                              otpNumberWidget(1),
                              otpNumberWidget(2),
                              otpNumberWidget(3),
                              //otpNumberWidget(4),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              verify_otp(widget.mobile, text);
                            },
                            child: Text(
                              "Verify",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  MyColors.btnBgColor),
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.42,
                            constraints: BoxConstraints(maxHeight: 290),
                            child: NumericKeyboard(
                              onKeyboardTap: _onKeyboardTap,
                              textColor: MyColors.primaryColor,
                              rightIcon: Icon(
                                Icons.backspace,
                                color: MyColors.primaryColor,
                              ),
                              rightButtonFn: () {
                                setState(() {
                                  text = text.substring(0, text.length - 1);
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  )
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

  Future<void> verify_otp(String mobile, String otp) async {
    if (mobile.isEmpty) {
      showErrorMessage(context, message: 'Please fill mobile number');
      return;
    } else if (otp.length != 4) {
      showErrorMessage(context, message: 'Please fill only 4 digit otp');
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });
      final body = {"mobile": mobile, "otp": otp};
      final response = await ApiServices.verify_otp(context, body);

      // Check if the response is null or doesn't contain the expected data
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final data = response['data'];
        // Ensure that the response data is in the expected format
        if (data != null && data is Map<String, dynamic>) {
          //print('verify_otp data: $data');
          final user = UserModel.fromMap(data);

          if (user != null) {
            //print('verify_otp data: 1');

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

            // Pop all screens until reaching the first screen
            Navigator.popUntil(context, (route) => route.isFirst);

            // Replace the current screen with the login screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
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
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
