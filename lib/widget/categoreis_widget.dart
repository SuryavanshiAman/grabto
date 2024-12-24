import 'package:cached_network_image/cached_network_image.dart';
import 'package:discount_deals/model/categories_model.dart';
import 'package:discount_deals/ui/subcategories_screen.dart';
import 'package:flutter/material.dart';

class CategoreisWidget extends StatelessWidget {
  List<CategoriesModel> categories = [];

  CategoreisWidget(this.categories);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2, // Adjusting crossAxisCount based on screen width
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
        ),
        itemCount: categories.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          var category = categories[index];
          return InkWell(
            onTap: () {
              navigateToTopSubCategories(
                  context, category.category_name, category.id);
            },

            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: category.image,
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
                    width: MediaQuery.of(context).size.width > 600 ? 220 : 110, // Adjusting container width based on screen width
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x20000000),
                          blurRadius: 20.0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        category.category_name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width > 600 ? 22 : 20, // Adjusting font size based on screen width
                          //backgroundColor: Colors.black12,
                          fontWeight: FontWeight.w600,
                          height: 0,
                          letterSpacing: -0.44,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> navigateToTopSubCategories(
      BuildContext context, String categoryName, int categoryId) async {
    final route = MaterialPageRoute(
      builder: (context) => SubCategoriesScreen(categoryName, categoryId),
    );

    await Navigator.push(context, route);
  }
}
