import 'package:discount_deals/services/api.dart';
import 'package:discount_deals/theme/theme.dart';
import 'package:flutter/material.dart';

class BottomLoginScreen extends StatefulWidget {
  const BottomLoginScreen({super.key});

  @override
  State<BottomLoginScreen> createState() => _BottomLoginScreenState();
}

class _BottomLoginScreenState extends State<BottomLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: MyColors.backgroundBg,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Replace 'assets/your_image.png' with the path to your image
              Container(
                  width: 250,
                  height: 180,
                  child: Image.asset('assets/vector/vect_login.png')),
              SizedBox(height: 20),
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(MyColors.primaryColor),
                  ),
                  onPressed: () {
                    NavigationUtil.navigateToLogin(context);
                  },
                  child: Text('Login',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
