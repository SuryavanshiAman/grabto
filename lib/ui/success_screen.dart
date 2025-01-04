import 'package:discount_deals/ui/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:discount_deals/theme/theme.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';



class SuccessScreen extends StatelessWidget {
  String msg = "";
  String payment="";

  SuccessScreen(this.msg,this.payment, {super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    // Format the current date and time
    String formattedDate = DateFormat('MMMM,dd,yyy HH:mm a').format(now);
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text('Coupon Applied'),
      //   //backgroundColor: Colors.green, // Set the app bar color to indicate success
      // ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,

          children: [
            const SizedBox(height: 50),
            Center(
              child: Container(
                width: 250,
                height: 250,
                // color: Colors.red,
                child: Lottie.asset('assets/lottie/success.json',fit: BoxFit.fill,),
              ),
              // ),
            ),
            // const SizedBox(height: 20),
            Text(
              '₹$payment',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              // height: 200,
              width: 300,
              child: Text(
                '$msg!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Bill amunt paid on $formattedDate ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Thank you for your using.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                // Navigate to another screen or perform any action
              },
              child: const Text(
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
