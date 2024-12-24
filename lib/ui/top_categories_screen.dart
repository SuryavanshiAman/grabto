import 'package:discount_deals/model/categories_model.dart';
import 'package:discount_deals/services/api_services.dart';
import 'package:discount_deals/ui/subcategories_screen.dart';
import 'package:discount_deals/widget/categoreis_widget.dart';
import 'package:discount_deals/widget/top_categories_card_widget.dart';
import 'package:flutter/material.dart';

import '../theme/theme.dart';

class TopCategoriesScreen extends StatefulWidget {
  var nameFromHome = "";
  List<CategoriesModel> categories = [];

  TopCategoriesScreen( this.nameFromHome,this.categories);

  @override
  State<TopCategoriesScreen> createState() => _TopCategoriesScreenState();
}

class _TopCategoriesScreenState extends State<TopCategoriesScreen> {

  List<CategoriesModel> categories = [];
  bool isLoading=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundBg,
      appBar: AppBar(
        backgroundColor: MyColors.backgroundBg,
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        title: Text(
          "${widget.nameFromHome}",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        color: MyColors.backgroundBg,
        child: isLoading
            ? Center(
          child: CircularProgressIndicator(
            color: MyColors.primaryColor,
          ),
        )
            : categories.isEmpty
            ? _buildNoDataWidget()
            : SingleChildScrollView(
          child: Column(
            children: [
              // The commented-out search bar code remains as is

              CategoreisWidget(categories),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoDataWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 150,
          height: 100,
          child: Image.asset('assets/vector/blank.png'),
        ),
        SizedBox(height: 16),
        Text(
          'No available',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w200,
          ),
        ),
      ],
    );
  }

  Future<void> fetchCategories() async {
    setState(() {
      isLoading=true;
    });
    try {
      final response = await ApiServices.fetchCategories();
      if (response != null) {
        setState(() {
          categories = response;
        });
      }
    } catch (e) {
      print('fetchCategories: $e');
    }finally{
      setState(() {
        isLoading=false;
      });
    }
  }

}

// class TopCategoriesWidget extends StatelessWidget {
//   final List<CategoriesModel> categories;
//
//   const TopCategoriesWidget({Key? key, required this.categories}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 10),
//       child: GridView.builder(
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: 5.0,
//           mainAxisSpacing: 5.0,
//         ),
//         itemCount: categories.length,
//         shrinkWrap: true,
//         physics: NeverScrollableScrollPhysics(),
//         itemBuilder: (context, index) {
//           final category = categories[index];
//           return TopCategoriesCardWidget(
//             imageUrl: category.image,
//             categoryName: category.category_name,
//             onTap: () {
//               // Handle onTap action here
//               Navigator.push(context, MaterialPageRoute(builder: (context) {
//                 return SubCategoriesScreen(category.category_name, category.id); // Assuming you have a SubCategoriesScreen widget
//               }));
//             },
//           );
//         },
//       ),
//     );
//   }
// }


