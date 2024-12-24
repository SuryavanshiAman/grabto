import 'package:discount_deals/theme/theme.dart';
import 'package:flutter/material.dart';

class ApplyVoucherScreen extends StatefulWidget {
  const ApplyVoucherScreen({super.key});

  @override
  State<ApplyVoucherScreen> createState() => _ApplyVoucherScreenState();
}

class _ApplyVoucherScreenState extends State<ApplyVoucherScreen> {
  List<Map<String, dynamic>> offerList = [
    {
      'title': 'Special Discount',
      'shortDescription': 'Get 15% off on all items',
      'longDescription': 'Enjoy a flat 15% discount on your total purchase. This offer is valid for all products in the store.',
      'discount': 15,
    },
    {
      'title': 'Festive Offer',
      'shortDescription': '20% discount on select products',
      'longDescription': 'Celebrate the festive season with a special 20% discount on selected items. Limited time only!',
      'discount': 20,
    },
    {
      'title': 'Limited Time Offer',
      'shortDescription': 'Flat 25% off for today only',
      'longDescription': 'Take advantage of our exclusive offer of a flat 25% discount, valid only for today. Hurry up!',
      'discount': 25,
    },
    {
      'title': 'Limited Time Offer',
      'shortDescription': 'Flat 25% off for today only',
      'longDescription': 'Take advantage of our exclusive offer of a flat 25% discount, valid only for today. Hurry up!',
      'discount': 25,
    },
    {
      'title': 'Limited Time Offer',
      'shortDescription': 'Flat 25% off for today only',
      'longDescription': 'Take advantage of our exclusive offer of a flat 25% discount, valid only for today. Hurry up!',
      'discount': 25,
    },
    {
      'title': 'Limited Time Offer',
      'shortDescription': 'Flat 25% off for today only',
      'longDescription': 'Take advantage of our exclusive offer of a flat 25% discount, valid only for today. Hurry up!',
      'discount': 25,
    },
    {
      'title': 'Limited Time Offer',
      'shortDescription': 'Flat 25% off for today only',
      'longDescription': 'Take advantage of our exclusive offer of a flat 25% discount, valid only for today. Hurry up!',
      'discount': 25,
    },
    // Add more offers here
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundBg,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            SizedBox(width: 0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Apply Coupon',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Your Cart \u{20B9}11.0',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: MyColors.textColor,
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: MyColors.backgroundBg,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Fixed TextField with rounded corners, hint text, and "Apply" button inside
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter coupon code',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey, // Set the color for the hint text
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10), // Rounded corners
                        ),
                        suffixIcon: TextButton(
                          onPressed: () {
                            // Handle apply coupon logic here
                          },
                          child: Text(
                            'Apply',
                            style: TextStyle(
                              color: MyColors.primary, // Use your primary color
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16), // Optional spacing after TextField
              // "More offers" header
              Row(
                children: [
                  Text(
                    'More offers',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16), // Spacing between "More offers" and the offers list

              // Use ListView.builder to generate OfferCard widgets
              ListView.builder(
                shrinkWrap: true, // Makes the ListView fit within the available space
                physics: NeverScrollableScrollPhysics(), // Disable ListView's scrolling
                itemCount: offerList.length, // Number of items in your offer list
                itemBuilder: (context, index) {
                  final offer = offerList[index];
                  return OfferCard(
                    title: offer['title'], // Dynamic title for each offer
                    shortDescription: offer['shortDescription'], // Dynamic short description for each offer
                    longDescription: offer['longDescription'], // Dynamic long description for each offer
                    discount: offer['discount'], // Dynamic discount for each offer
                  );
                },
              ),
            ],
          ),
        ),
      ),

    );
  }
}



class OfferCard extends StatelessWidget {
  final String title;
  final String shortDescription;
  final String longDescription;
  final int discount;

  const OfferCard({
    Key? key,
    required this.title,
    required this.shortDescription,
    required this.longDescription,
    required this.discount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Stack( // Use Stack to overlay the button
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  shortDescription,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  longDescription,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Discount: $discount%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: MyColors.primary, // Assuming you have a primary color
                  ),
                ),
              ],
            ),
            Positioned( // Position the "Apply" button
              right: 0,
              top: 0,
              child: TextButton(
                onPressed: () {
                  // Handle apply logic here
                },
                child: Text(
                  'Apply',
                  style: TextStyle(
                    color: MyColors.primary, // Your primary color
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

