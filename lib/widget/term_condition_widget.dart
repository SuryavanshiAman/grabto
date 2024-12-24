import 'package:discount_deals/model/terms_condition_model.dart';
import 'package:flutter/material.dart';

class TermConditionWidget extends StatelessWidget {
  final List<TermConditionModel> termConditions;

  TermConditionWidget(this.termConditions);

  @override
  Widget build(BuildContext context) {
    return termConditions.isEmpty
        ? Container() // Return an empty container if termConditions list is empty
        : Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 3,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Text(
                  "Terms & Condition",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
              ListView.builder(

                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: termConditions.length,
                itemBuilder: (context, index) {
                  final termCondition = termConditions[index];
                  return Text("${index + 1}. ${termCondition.termCondition}");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

