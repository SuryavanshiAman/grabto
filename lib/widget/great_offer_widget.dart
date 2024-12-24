import 'package:cached_network_image/cached_network_image.dart';
import 'package:discount_deals/model/great_offer_model.dart';
import 'package:discount_deals/ui/all_coupon_screen.dart';
import 'package:flutter/material.dart';

class GreatOffersWidget extends StatelessWidget {
  final List<GreatOfferModel> offerItems;
  String city_id;

  GreatOffersWidget(this.offerItems,this.city_id);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      //height: 200,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return buildGreatOffersWidget(context, offerItems[index]);
        },
        itemCount: offerItems.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget buildGreatOffersWidget(
      BuildContext context, GreatOfferModel offerModel) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 5),
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) {
                return AllCouponScreen(
                    "${offerModel.offerName}", "","","","${offerModel.id}","","","","$city_id","");
              }));
        },
        child: Card(
          elevation: 2,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Container(
            margin: EdgeInsets.all(0),
            //width: MediaQuery.of(context).size.width * 0.35, // Adjust the width according to your requirement
            width: MediaQuery.of(context).size.width * 0.68, // Adjust the width according to your requirement
            child: Container(
              height: MediaQuery.of(context).size.width * 0.2, // Adjust the height according to your requirement
              width: MediaQuery.of(context).size.width * 0.2, // Adjust the width according to your requirement
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: offerModel.image,
                  fit: BoxFit.fill,
                  placeholder: (context, url) => Image.asset(
                    'assets/images/vertical_placeholder.jpg',
                    // Path to your placeholder image asset
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  errorWidget: (context, url, error) =>
                      Center(child: Icon(Icons.error)),
                ),
              ),
            ),
          ),
        ),

      ),
    );
  }
}
