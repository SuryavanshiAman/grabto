import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CategoriesCardWidget extends StatelessWidget {
  final String imgUrl;
  final String cateName;
  final VoidCallback onTap;

  const CategoriesCardWidget({
    required this.imgUrl,
    required this.cateName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double wid=180;
    return Container(
      margin: EdgeInsets.only(left: 10, right: 5),
      child: InkWell(
        onTap: onTap,
        child: Card(
          elevation: 2,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: wid,
                height: 120,
                child: CachedNetworkImage(
                  imageUrl: imgUrl,
                  fit: BoxFit.fill,
                  placeholder: (context, url) => Image.asset(
                    'assets/images/placeholder.png',
                    // Path to your placeholder image asset
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  errorWidget: (context, url, error) =>
                      Center(child: Icon(Icons.error)),
                ),
              ),
              Container(
                width: wid,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x60000000),
                      blurRadius: 20.0,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    cateName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.44,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
