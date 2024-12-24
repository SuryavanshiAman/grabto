import 'package:cached_network_image/cached_network_image.dart';
import 'package:discount_deals/model/features_model.dart';
import 'package:discount_deals/model/gallery_model.dart';
import 'package:discount_deals/services/api_services.dart';
import 'package:discount_deals/theme/theme.dart';
import 'package:discount_deals/ui/full_screen_gallery.dart';
import 'package:flutter/material.dart';

class GalleryScreen extends StatefulWidget {
  int store_id = 0;

  GalleryScreen(this.store_id);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  bool _isLoading1 = false;
  List<GalleryModel> ambienceList = [];
  bool _isLoading2 = false;
  List<GalleryModel> foodList = [];

  @override
  void initState() {
    super.initState();
    //fetchGalleryImagesFood("${widget.store_id}", "food");
    fetchGalleryImagesAmbience("${widget.store_id}");


  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: MyColors.backgroundBg,
        appBar: AppBar(
          backgroundColor: MyColors.backgroundBg,
          title: Text('Gallery'),
          // bottom: TabBar(
          //   tabs: [
          //     Tab(text: 'Ambience'),
          //     Tab(text: 'Food'),
          //   ],
          //   labelStyle: TextStyle(
          //       color: MyColors.primaryColor,
          //       fontSize: 16,
          //       fontWeight: FontWeight.w500),
          //   unselectedLabelStyle: TextStyle(fontSize: 13),
          //   indicatorColor: MyColors.primaryColor,
          //   indicatorWeight: 0.1,
          // ),
        ),
        body: _isLoading1
            ? Center(
          child: CircularProgressIndicator(
            color: MyColors
                .primaryColor, // Set the loading indicator color
          ),
        )
            : foodList.isEmpty
            ? Center(child: _buildNoImagesWidget())
            : GalleryGrid(images: ambienceList),

        // TabBarView(
        //   children: [
        //     _isLoading1
        //         ? Center(
        //             child: CircularProgressIndicator(
        //               color: MyColors
        //                   .primaryColor, // Set the loading indicator color
        //             ),
        //           )
        //         : ambienceList.isEmpty
        //             ? _buildNoImagesWidget()
        //             : GalleryGrid(images: ambienceList),
        //     _isLoading2
        //         ? Center(
        //             child: CircularProgressIndicator(
        //               color: MyColors
        //                   .primaryColor, // Set the loading indicator color
        //             ),
        //           )
        //         : foodList.isEmpty
        //             ? _buildNoImagesWidget()
        //             : GalleryGrid(images: foodList),
        //   ],
        // ),
      ),
    );
  }

  Future<void> fetchGalleryImagesFood(String store_id, String food_type) async {
    setState(() {
      _isLoading2 = true;
    });
    try {
      final body = {"store_id": "$store_id", "food_type": "$food_type"};
      final response = await ApiServices.store_multiple_gallery(body);
      //print("object: $response");
      if (response != null) {
        setState(() {
          foodList = response;
          //_isLoading2=false;
        });
      }
      setState(() {
        _isLoading2 = false;
      });
    } catch (e) {
      print('fetchGalleryImagesFood: $e');
    } finally {
      _isLoading2 = false;
    }
  }

  Future<void> fetchGalleryImagesAmbience(
      String store_id) async {
    setState(() {
      _isLoading1 = true;
    });
    try {
      final body1 = {"store_id": "$store_id", "food_type": "food"};
      final responseFood = await ApiServices.store_multiple_gallery(body1);

      final body2 = {"store_id": "$store_id", "food_type": "ambience"};
      final responseAmbience = await ApiServices.store_multiple_gallery(body2);


      if (responseFood != null) {
        setState(() {
          foodList = responseFood;
        });
      }
      if (responseAmbience != null) {
        setState(() {
          ambienceList = responseAmbience;
        });
      }


      setState(() {
        ambienceList.addAll(foodList);
        _isLoading2 = false;
      });
    } catch (e) {
      print('fetchGalleryImagesAmbience: $e');
    } finally {
      _isLoading1 = false;
    }
  }

  Widget _buildNoImagesWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 200,
          height: 180,
          child: Image.asset('assets/vector/blank.png'), // No images available
        ),
        SizedBox(height: 16),
        Text(
          'No Images available',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w200,
          ),
        ),
      ],
    );
  }
}

class GalleryGrid extends StatefulWidget {
  final List<GalleryModel> images;

  GalleryGrid({required this.images});

  @override
  State<GalleryGrid> createState() => _GalleryGridState();
}

class _GalleryGridState extends State<GalleryGrid> {
  // Initially set to true to show the loading indicator

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: GridView.builder(
        itemCount: widget.images.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 3 / 4,
        ),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              List<String> imageUrls =
                  widget.images.map((e) => e.image).toList();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullScreenGallery(
                    images: imageUrls,
                    initialIndex: index,
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
             child:  CachedNetworkImage(
                imageUrl:widget.images[index].image,
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
              // child: Image.network(
              //   widget.images[index].image,
              //   fit: BoxFit.cover,
              //   loadingBuilder: (context, child, loadingProgress) {
              //     if (loadingProgress == null) return child;
              //     return Center(
              //       child: CircularProgressIndicator(
              //         color: MyColors.primaryColor,
              //         // Set the loading indicator color
              //         strokeWidth: 4,
              //       ),
              //     );
              //   },
              //   errorBuilder: (context, error, stackTrace) {
              //     return Image.asset(
              //       'assets/images/placeholder.png', // Placeholder image
              //       fit: BoxFit.cover,
              //     );
              //   },
              // ),
            ),
          );
        },
      ),
    );
  }
}
