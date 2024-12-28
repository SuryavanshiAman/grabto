import 'package:flutter/material.dart';
import 'package:discount_deals/theme/theme.dart';
import 'package:lottie/lottie.dart';



class SuccessScreen extends StatelessWidget {
  String msg = "";

  SuccessScreen(this.msg);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text('Coupon Applied'),
      //   //backgroundColor: Colors.green, // Set the app bar color to indicate success
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: 180,
                height: 180,
                child: Lottie.asset('assets/lottie/check.json'),
              ),
              // ),
            ),
            SizedBox(height: 20),
            SizedBox(
              // height: 200,
              width: 300,
              child: Text(
                '$msg!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 10),
            Text(
              'Thank you for your using.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigate to another screen or perform any action
              },
              child: Text(
                'Continue',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
