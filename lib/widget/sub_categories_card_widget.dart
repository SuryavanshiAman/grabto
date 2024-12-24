import 'package:cached_network_image/cached_network_image.dart';
import 'package:discount_deals/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SubCategoriesCardWidget extends StatelessWidget {
  final String imgUrl;
  final String subcategoryName;
  final String spotAvailable;
  final String redeemed;
  final VoidCallback onTap;

  const SubCategoriesCardWidget({
    Key? key,
    required this.imgUrl,
    required this.subcategoryName,
    required this.spotAvailable,
    required this.redeemed,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 10),
          child: Card(
            color: Colors.white,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              height: 140,
              color: Colors.white,
              //padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 140,
                          width: double.infinity,
                          child: CachedNetworkImage(
                            imageUrl: imgUrl,
                            fit: BoxFit.fill,
                            placeholder: (context, url) => Image.asset(
                              'assets/images/placeholder.png',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                            errorWidget: (context, url, error) =>
                                Center(child: Icon(Icons.error)),
                          ),

                        ),

                        // FadeInImage with placeholder
                        // FadeInImage(
                        //   placeholder:
                        //       AssetImage('assets/images/placeholder.png'),
                        //   image: NetworkImage(imgUrl),
                        //   fit: BoxFit.fill,
                        //   height: 140,
                        //   width: double.infinity,
                        //
                        //   // Optional: You can add a fade duration if needed
                        //   fadeInDuration: Duration(milliseconds: 100),
                        //
                        //   // Use this callback to hide the loader when the image is fully loaded
                        //   imageErrorBuilder: (context, error, stackTrace) {
                        //     return Container(); // Return an empty container to hide the loader
                        //   },
                        // ),

                        Container(
                          height: 140,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x30000000),
                                blurRadius: 20.0,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              subcategoryName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: MyColors.whiteBG,
                                fontSize: 20,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
