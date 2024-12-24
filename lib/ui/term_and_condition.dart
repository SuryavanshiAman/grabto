import 'package:discount_deals/widget/icon_text_widget.dart';
import 'package:flutter/material.dart';

import '../theme/theme.dart';

class TermsAndCondition extends StatelessWidget {
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
          "Term & Condition",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        color: MyColors.backgroundBg,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TermsAndConditionsCard(),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TermsAndConditionsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Card(
        color: MyColors.whiteBG,
        borderOnForeground: true,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black38, // Set the border color
              width: 1.0, // Set the border width
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              IconTextWidget(
                iconData: Icons.circle,
                text:
                    "As a Prime Member of Grabto you can get discount / Benefits from our Participating Brands in Various Field. The Number of Participating Brands May be Changed and Modified.",
              ),
              IconTextWidget(
                iconData: Icons.circle,
                text:
                    "All Offers Cannot be Combined With any other Offers, Discount of Advertised Special. Offer Valid Only for items which are included in the Scheme; you have to pay for costs and charges not covered in the offers.",
              ),
              IconTextWidget(
                iconData: Icons.circle,
                text:
                    "Grabto shall not be Liable for any participating deficiency in Service, Order mismatch, quality, preparation timing etc. All Reservations are Subject to availability during weekend & Rush Hours.",
              ),
              IconTextWidget(
                iconData: Icons.circle,
                text:
                    "Price, Menu & deal Subject to change without prior notice. All discounts are based on the regular menu. In case of any misunderstanding, the restaurant owner/manager\'s decision will be final. No Verbal Agreement Accepted.",
              ),
              IconTextWidget(
                iconData: Icons.circle,
                text:
                    "Mandatory Govt. Applicable Taxes, GST & Other Levies shall be extra and binding on the Membership holder. Conditions Apply.",
              ),
            ],
          ),
        ),
        // Container(
        //   child: Padding(
        //     padding: EdgeInsets.all(15),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //
        //         SizedBox(height: 10),
        //         Text(
        //           'As a Prime Member of Grabto you can get discount / Benefits from our Participating Brands in Various Field. The Number of Participating Brands May be Changed and Modified.',
        //           style: TextStyle(fontSize: 14),
        //         ),
        //         SizedBox(height: 10),
        //         Text(
        //           'All Offers Cannot be Combined With any other Offers, Discount of Advertised Special. Offer Valid Only for items which are included in the Scheme; you have to pay for costs and charges not covered in the offers.',
        //           style: TextStyle(fontSize: 14),
        //         ),
        //         SizedBox(height: 10),
        //         Text(
        //           'MY Grabto shall not be Liable for any participating deficiency in Service, Order mismatch, quality, preparation timing etc. All Reservations are Subject to availability during weekend & Rush Hours.',
        //           style: TextStyle(fontSize: 14),
        //         ),
        //         SizedBox(height: 10),
        //         Text(
        //           'Price, Menu & deal Subject to change without prior notice. All discounts are based on the regular menu. In case of any misunderstanding, the restaurant owner/manager\'s decision will be final. No Verbal Agreement Accepted.',
        //           style: TextStyle(fontSize: 14),
        //         ),
        //         SizedBox(height: 10),
        //         Text(
        //           'Mandatory Govt. Applicable Taxes, GST & Other Levies shall be extra and binding on the Membership holder. Conditions Apply.',
        //           style: TextStyle(fontSize: 14),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
