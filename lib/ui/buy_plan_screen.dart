
import 'package:discount_deals/theme/theme.dart';
import 'package:flutter/material.dart';

class BuyPlanScreen extends StatelessWidget {
  const BuyPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundBg,
      appBar: AppBar(
        backgroundColor: MyColors.backgroundBg,
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        title: Text(
          "",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body:  Container(
        color: MyColors.backgroundBg,
        child: SingleChildScrollView(
          child: Container(
            color: MyColors.backgroundBg,
            height: MediaQuery.of(context).size.height,
            child: Column(

              children: [
                Card(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  color: Colors.black,
                  //shadowColor: Colors.blue,
                  //elevation: 5,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: Container(
                    height: 120,
                    width: 120,
                    child: Image.asset("assets/images/membership.png",fit:BoxFit.scaleDown,),
                  ),
                ),

                Center(
                  child: Container(
                    //width: 230,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Buy Membership",
                          style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.w600,
                              color: MyColors.primaryColor),
                        ),

                        Center(
                            child: Text(
                              "Avail the best of deals near you",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: MyColors.txtTitleColor),
                            )),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CircularImageWithText(
                              imageUrl: 'https://img.freepik.com/premium-vector/shield-label-badge-premium-quality-product-medals-realistic-flat-labels-badges-premium-quality_553860-336.jpg',
                              bottomText: 'Get Upto\n70% Off',
                            ),
                          ),
                          Expanded(
                            child: CircularImageWithText(
                              imageUrl: 'https://img.freepik.com/premium-vector/shield-label-badge-premium-quality-product-medals-realistic-flat-labels-badges-premium-quality_553860-336.jpg',
                              bottomText: '120+ Outlets to choose from',
                            ),
                          ),
                          Expanded(
                            child: CircularImageWithText(
                              imageUrl: 'https://img.freepik.com/premium-vector/shield-label-badge-premium-quality-product-medals-realistic-flat-labels-badges-premium-quality_553860-336.jpg',
                              bottomText: 'Deals on Food\nStay & Spa',
                            ),
                          ),
                        ],

                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CircularImageWithText(
                              imageUrl: 'https://img.freepik.com/premium-vector/shield-label-badge-premium-quality-product-medals-realistic-flat-labels-badges-premium-quality_553860-336.jpg',
                              bottomText: 'Get Best Deals\nNear You',
                            ),
                          ),
                          Expanded(
                            child: CircularImageWithText(
                              imageUrl: 'https://img.freepik.com/premium-vector/shield-label-badge-premium-quality-product-medals-realistic-flat-labels-badges-premium-quality_553860-336.jpg',
                              bottomText: 'No Condition\nDeals',
                            ),
                          ),
                          Expanded(
                            child: CircularImageWithText(
                              imageUrl: 'https://img.freepik.com/premium-vector/shield-label-badge-premium-quality-product-medals-realistic-flat-labels-badges-premium-quality_553860-336.jpg',
                              bottomText: 'And Much\nMore...',
                            ),
                          ),
                        ],

                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),

                Container(
                  height: 40,
                  width: double.maxFinite,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    onPressed: () {

                    },
                    child: Text(
                      "Pay Now",
                      style: TextStyle(
                          fontSize: 15, color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(
                          MyColors.btnBgColor),
                    ),
                  ),
                ),


                SizedBox(
                  height: 30,
                ),



              ],
            ),
          ),
        ),
      ),
    );
  }
}
class CircularImageWithText extends StatelessWidget {
  final String imageUrl;
  final String bottomText;

  CircularImageWithText({required this.imageUrl, required this.bottomText});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,


      child: Column(

        children: [
          // Circular image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              //color: Colors.black,
              image: DecorationImage(
                //image: NetworkImage(imageUrl),
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 5,),
          // Positioned at the bottom
          Text(
            bottomText,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w500
            ),
          ),
        ],
      ),
    );
  }
}