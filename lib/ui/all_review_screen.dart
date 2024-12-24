import 'package:discount_deals/model/review_model.dart';
import 'package:discount_deals/theme/theme.dart';
import 'package:flutter/material.dart';

class AllReviewScreen extends StatelessWidget {
  const AllReviewScreen({Key? key, required this.reviewDataList}) : super(key: key);

  final List<ReviewModel> reviewDataList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        centerTitle: true,
        title: Text(
          "Reviews",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ReviewListWidget(reviewDataList: reviewDataList),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class ReviewListWidget extends StatelessWidget {
  final List<ReviewModel> reviewDataList;

  ReviewListWidget({required this.reviewDataList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: reviewDataList.length,
      itemBuilder: (context, index) {
        return FutureBuilder<ReviewModel>(
          future: Future.delayed(Duration(seconds: 1), () => reviewDataList[index]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingWidget();
            } else if (snapshot.hasError) {
              return _buildErrorWidget(snapshot.error.toString());
            } else {
              final reviewData = snapshot.data!;
              return _buildReviewCard(reviewData);
            }
          },
        );
      },
    );
  }

  Widget _buildReviewCard(ReviewModel reviewData) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(reviewData.userImage),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "${reviewData.name}",
                  style: TextStyle(
                    color: MyColors.primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis, // Prevent overflow
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(6, 4, 8, 4),
                decoration: BoxDecoration(
                  color: MyColors.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    Text(
                      "${reviewData.rating}",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),

          SizedBox(height: 6),
          Text(
            reviewData.description,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              reviewData.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 150,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: MyColors.primaryColor,
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String errorMessage) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: Text(
          errorMessage,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
