import 'package:flutter/material.dart';
import 'package:discount_deals/model/terms_condition_model.dart';

class OfferTermsWidget extends StatefulWidget {
  List<TermConditionModel> termConditionList;


  OfferTermsWidget(this.termConditionList);

  @override
  _OfferTermsWidgetState createState() => _OfferTermsWidgetState();
}

class _OfferTermsWidgetState extends State<OfferTermsWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Title with a toggle button
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Terms and Conditions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
              ],
            ),
          ),
        ),
        // Expandable content (terms)
        if (isExpanded)
          ListView.builder(
            shrinkWrap: true, // Makes the ListView fit inside the parent widget
            physics:
                NeverScrollableScrollPhysics(), // Prevents ListView from scrolling separately
            itemCount: widget.termConditionList.length, // Number of terms
            itemBuilder: (context, index) {
              return _buildTerm(widget.termConditionList[index]);
            },
          ),
        // Custom divider at the bottom
        // Divider(thickness: 1, color: Colors.black87),
      ],
    );
  }

  // Helper method to create a term with bullet point
  Widget _buildTerm(TermConditionModel term) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 4), // Align bullet vertically
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black87,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              term.termCondition,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
