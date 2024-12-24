import 'package:discount_deals/model/plan_model.dart';
import 'package:discount_deals/theme/theme.dart';
import 'package:flutter/material.dart';

class SelectPlanCard extends StatefulWidget {
  final List<PlanModel> plans;
  final Function(PlanModel)? onTap;

  SelectPlanCard({
    required this.plans,
    this.onTap,
  });

  @override
  _SelectPlanCardState createState() => _SelectPlanCardState();
}

class _SelectPlanCardState extends State<SelectPlanCard> {
  int currentIndex = 0;
  double selectedScale = 1.0; // Scale factor for selected card
  double unselectedScale = 0.8; // Scale factor for unselected card

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("SelectPlanCard: ${widget.plans}");
  }

  String calculatePercentage(String originalPriceStr, String discountedPriceStr) {
    int originalPrice = int.tryParse(originalPriceStr) ?? 0;
    int discountedPrice = int.tryParse(discountedPriceStr) ?? 0;

    if (originalPrice > discountedPrice) {
      int discountPercentage =
          ((originalPrice - discountedPrice) / originalPrice * 100).round();
      return '$discountPercentage';
    } else {
      return '0';
    }
  }

  String calculatePerMonthValue(String no_month, String totalPrice) {
    String firstTwoCharacters = no_month.substring(0, 2);
    int intValue = int.tryParse(firstTwoCharacters) ?? 0;
    int priceValue = int.tryParse(totalPrice) ?? 0;
    double result = priceValue / intValue;
    String formattedResult = result.toStringAsFixed(2);
    return formattedResult;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 185, // Set a fixed height for the container
      child: PageView.builder(
        itemCount: widget.plans.length,
        controller: PageController(
          viewportFraction: 1 / 2.7,
          initialPage: currentIndex,
        ),
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
          // Update the selected plan when scrolling
          if (widget.onTap != null) widget.onTap!(widget.plans[index]);
        },
        itemBuilder: (context, index) {
          final plan = widget.plans[index];
          final isSelected = index == currentIndex;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.0),
            // Adjust padding here
            child: GestureDetector(
              onTap: () {
                if (mounted) {
                  setState(() {
                    currentIndex = index;
                  });
                  // Update the selected plan when tapping
                  if (widget.onTap != null) widget.onTap!(plan);
                }
              },
              child: isSelected
                  ? SizedBox(
                      child: Transform.scale(
                        scale: selectedScale, // Use selected scale factor
                        child: _buildCard(plan, isSelected),
                      ),
                    )
                  : SizedBox(
                      child: Transform.scale(
                        scale: unselectedScale, // Use unselected scale factor
                        child: _buildCard(plan, isSelected),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard(PlanModel plan, bool isSelected) {
    return Container(
      height: 190,
      child: Column(
        children: [
          Material(
            elevation: isSelected ? 8 : 5,
            borderRadius: BorderRadius.circular(10.0),
            color: MyColors.backgroundBg,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
                border: Border.all(
                  color: isSelected ? MyColors.primaryColor : Colors.black38,
                  width: 3.0,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 300,
                    height: 30,
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      color: isSelected
                          ? MyColors.primaryColor
                          : Colors.transparent,
                    ),
                    child: Center(
                      child: Text(
                        plan.name, // Use plan name from PlanModel
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color:
                                isSelected ? MyColors.whiteBG : Colors.black38,
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          plan.duration, // Use plan duration from PlanModel
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                        Visibility(
                          visible: "${calculatePercentage(plan.salePrice, plan.offerPrice)}"!="0",
                          child: Text(
                            "- ${calculatePercentage(plan.salePrice, plan.offerPrice)}%",
                            // Use plan duration from PlanModel
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "${calculatePerMonthValue(plan.duration, plan.offerPrice)}\u20B9/m",
                          // Use plan duration from PlanModel
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Visibility(
                              visible: "${calculatePercentage(plan.salePrice, plan.offerPrice)}"!="0",
                              child: Text(
                                '\u20B9 ${plan.salePrice}',
                                // Use plan original price from PlanModel
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black38,
                                    fontSize: 14,
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: Colors.black38,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '\u20B9 ${plan.offerPrice}',
                              // Use plan discounted price from PlanModel
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          Icon(
            Icons.arrow_drop_down,
            size: 30,
            color: isSelected ? MyColors.primaryColor : Colors.transparent,
          )
        ],
      ),
    );
  }


}
