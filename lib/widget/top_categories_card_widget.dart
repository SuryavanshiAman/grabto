import 'package:flutter/material.dart';

class TopCategoriesCardWidget extends StatelessWidget {
  final String imageUrl;
  final String categoryName;
  final VoidCallback onTap;

  const TopCategoriesCardWidget({
    Key? key,
    required this.imageUrl,
    required this.categoryName,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Container(
          width: 110,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 12),
                  child: Text(
                    categoryName,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.black, // Use your color
                      fontSize: 18,
                      letterSpacing: -0.44,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
