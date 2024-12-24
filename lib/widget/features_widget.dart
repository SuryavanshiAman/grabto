import 'package:discount_deals/model/features_model.dart';
import 'package:discount_deals/widget/feature_tile_widget.dart';
import 'package:flutter/material.dart';

class FeaturesWidget extends StatefulWidget {
  List<FeaturesModel> featuresList = [];

  FeaturesWidget(this.featuresList);

  @override
  _FeaturesWidgetState createState() => _FeaturesWidgetState();
}

class _FeaturesWidgetState extends State<FeaturesWidget> {
  bool showMore = false;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      // To limit the size to children's size
      childAspectRatio: 4,
      //// Adjust aspect ratio as needed
      physics: NeverScrollableScrollPhysics(),
      children: [
        for (var feature in widget.featuresList)
          FeatureTile(
            title: feature.name,
            image: feature.image,
          ),
      ],
    );
  }
}