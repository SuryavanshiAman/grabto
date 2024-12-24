import 'package:discount_deals/model/categories_model.dart';
import 'package:discount_deals/services/api_services.dart';
import 'package:discount_deals/theme/theme.dart';
import 'package:discount_deals/ui/subcategories_screen.dart';
import 'package:discount_deals/widget/categoreis_widget.dart';
import 'package:flutter/material.dart';

class CategoriesBottamWidget extends StatefulWidget {
  @override
  State<CategoriesBottamWidget> createState() => _CategoriesBottamWidgetState();
}

class _CategoriesBottamWidgetState extends State<CategoriesBottamWidget> {
  List<CategoriesModel> categories = [];
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      isLoading = true;
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
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
