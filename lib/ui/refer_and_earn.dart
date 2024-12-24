import 'package:custom_clippers/custom_clippers.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../theme/theme.dart';

class ReferAndEarn extends StatelessWidget {
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
            child: Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        title: Text(
          "Refer & Earn",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        color: MyColors.backgroundBg,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Center(
                child: Container(
                    constraints: const BoxConstraints(maxHeight: 240),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Image.asset('assets/vector/vect_refer.png')),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Refer Your Friends",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: MyColors.txtTitleColor),
              ),
              Text(
                "Invite your friends and earn money",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: MyColors.txtDescColor),
              ),
              SizedBox(
                height: 40,
              ),

              ClipPath(
                clipper: MultiplePointsClipper(Sides.bottom, heightOfPoint: 10),

                child: Container(
                  height: 200,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.all(20),
                  color: Colors.red,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      DottedBorder(
                        borderType: BorderType.RRect,
                        radius: Radius.circular(12),
                        strokeWidth: 1,
                        dashPattern: [6, 3],
                        // Adjust the dash pattern as needed
                        color: MyColors.whiteBG,
                        child: Container(
                          width: 180,
                          height: 50,
                          // Your container content goes here
                          child: Center(
                            child: Text('DIGIC20',style: TextStyle(fontSize: 22,color: MyColors.whiteBG),),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        width: 200,height: 40,
                        child: ElevatedButton(
                          onPressed: () {

                          },
                          child: Text(
                            "Share Your Code",
                            style: TextStyle(fontSize: 16, color: MyColors.whiteBG),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                MyColors.primaryColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
