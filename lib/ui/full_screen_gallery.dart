
import 'package:discount_deals/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class FullScreenGallery extends StatelessWidget {
  final List<String> images;
  final int initialIndex;

  FullScreenGallery({required this.images, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundBg,
      body: Container(
        child: PhotoViewGallery.builder(
          itemCount: images.length,
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(images[index]),
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 2,
            );
          },
          scrollPhysics: const BouncingScrollPhysics(),
          loadingBuilder: (context, event) => Center(
            child: CircularProgressIndicator(),
          ),
          backgroundDecoration: BoxDecoration(
            color: Colors.black,
          ),
          pageController: PageController(initialPage: initialIndex),
        ),
      ),
    );
  }
}