import 'dart:async';
import 'dart:io';

import 'package:discount_deals/helper/shared_pref.dart';
import 'package:discount_deals/model/store_model.dart';
import 'package:discount_deals/model/user_model.dart';
import 'package:discount_deals/services/api_services.dart';
import 'package:discount_deals/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';

class AddRatingScreen extends StatefulWidget {
  StoreModel? storeModel;

  AddRatingScreen(this.storeModel);

  @override
  State<AddRatingScreen> createState() => _AddRatingScreenState();
}

class _AddRatingScreenState extends State<AddRatingScreen> {
  late PageController _pageController;
  int _currentPage = 0; // Track the current page

  final picker = ImagePicker();
  TextEditingController descController = TextEditingController();
  File? _imageFile;
  double rating = 0.0;
  int userid = 0;
  bool isLoading = false;

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Choose from gallery'),
              onTap: () {
                _pickImageFromGallery();
                Navigator.pop(
                    context); // Close the modal bottom sheet after selection
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Take a photo'),
              onTap: () {
                _takePhotoWithCamera();
                Navigator.pop(
                    context); // Close the modal bottom sheet after selection
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _takePhotoWithCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> getUserDetails() async {
    // SharedPref sharedPref=new SharedPref();
    // userName = (await SharedPref.getUser()).name;
    UserModel n = await SharedPref.getUser();
    print("getUserDetails: " + n.name);
    setState(() {
      userid = n.id;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.white,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.storeModel!.storeName}",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                Text(
                  "${widget.storeModel!.address}",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                size: 28,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            elevation: 0,
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                strokeWidth: 4,
              ),
            )
          : Stack(
              children: [
                PageView(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      // switch (_currentPage) {
                      //   case 0:
                      //     if (rating == 0.0)
                      //     {
                      //       showErrorMessage(context,
                      //           message: 'Please select a rating.');
                      //       return;
                      //     }
                      //   case 1:
                      //     if (_imageFile == null) {
                      //       showErrorMessage(context,
                      //           message: 'Please select an image.');
                      //       return;
                      //     }
                      //   case 2:
                      //     if (descController.text.isEmpty) {
                      //       showErrorMessage(context,
                      //           message: 'Please fill in the description.');
                      //       return;
                      //     }
                      // }
                      _currentPage = page;
                    });
                  },
                  children: [
                    _getMarkRatingLayout(),
                    _getAddPhotoScreen(),
                    _getWriteReviewScreen(),
                  ],
                ),
              ],
            ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                if (_pageController.page != 0) {
                  _pageController.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                }
              },
              child: Text(
                'Back',
                style: TextStyle(
                    color: _currentPage == 0 ? Colors.grey : Colors.orange,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (_currentPage != 2) {
                  switch (_currentPage) {
                    case 0:
                      if (rating == 0.0)
                      {
                        showErrorMessage(context,
                            message: 'Please select a rating.');
                        return;
                      }
                    case 1:
                      if (_imageFile == null) {
                        showErrorMessage(context,
                            message: 'Please select an image.');
                        return;
                      }
                    case 2:
                      if (descController.text.isEmpty) {
                        showErrorMessage(context,
                            message: 'Please fill in the description.');
                        return;
                      }
                  }

                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                } else {
                  switch (_currentPage) {
                    case 2:
                      if (descController.text.isEmpty) {
                        showErrorMessage(context,
                            message: 'Please fill in the description.');
                        return;
                      }
                  }

                  submitReview("${userid}", "${widget.storeModel!.id}",
                      "$rating", "${descController.text}", _imageFile);
                }
              },
              child: Text(
                _currentPage == 2 ? 'Submit' : 'Next',
                style: TextStyle(
                    color: _currentPage == 2 ? Colors.orange : Colors.orange,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getMarkRatingLayout() {
    return Container(
      child: Column(
        children: [
          Container(
            width: 250,
            height: 250,
            child: Center(
              child: Image.asset(
                "assets/vector/review.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              "How was your overall experience with ${widget.storeModel!.storeName}?",
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 30),
          Center(
            child: RatingBar.builder(
              initialRating: rating,
              // Set initial rating to the variable
              minRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 40,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (newRating) {
                // Update the rating variable
                setState(() {
                  rating = newRating;
                });
              },
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Rating: $rating', // Display the rating count
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getAddPhotoScreen() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Add photos for review",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 50),
          InkWell(
            onTap: () {
              _openImagePicker(context);
            },
            child: Container(
              height: 160,
              width: 300,
              margin: EdgeInsets.all(12),
              decoration: _imageFile != null
                  ? BoxDecoration(
                      color: Colors.black12,
                      image: DecorationImage(
                        image: FileImage(_imageFile!),
                        fit: BoxFit
                            .cover, // Adjust the BoxFit as per your requirement
                      ),
                    )
                  : BoxDecoration(
                      color: Colors.black12,
                    ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image, size: 40, color: Colors.grey.shade500),
                  SizedBox(height: 10),
                  Text("Choose From Gallery",
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getWriteReviewScreen() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            SizedBox(height: 30),
            Container(
                height: 250,
                width: 200,
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Image.asset("assets/vector/top_picks.png")),
            Text(
              "What are your top picks?",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 25),
                child: buildTextField(
                    labelText: "Name the dish/drink you liked",
                    placeholder: "For eg. Chicken tikka",
                    controller: descController)),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required String labelText,
    required String placeholder,
    bool isPasswordTextField = false,
    bool isReadOnly = false,
    required TextEditingController controller,
    String? initialValue,
    Function()? onTap, // Optional onTap parameter
  }) {
    // Set initial value if provided
    if (initialValue != null && initialValue.isNotEmpty) {
      controller.text = initialValue;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        controller: controller,
        //obscureText: isPasswordTextField ? showPassword : false,
        readOnly: isReadOnly,
        onTap: onTap,
        // Use the provided onTap function, if any
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 3),
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Future<void> submitReview(String user_id, String storeId, String rating,
      String description, File? image) async {
    //showSuccessMessage(context, message:" click submit");
    setState(() {
      isLoading = true;
    });
    try {
      final response = await ApiServices.add_review(
        userId: "$user_id",
        storeId: "$storeId",
        rating: "$rating",
        description: "$description",
        image: image!,
      );

      // Check if the response is null or doesn't contain the expected data
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final msg = response['msg'] as String;

        showSuccessMessage(context, message: msg);

        setState(() {
          Navigator.pop(context);
        });
      } else if (response != null) {
        String msg = response['msg'];

        showErrorMessage(context, message: msg);
      }
    } catch (e) {
      //print('verify_otp error: $e');
      // Handle error
      //showErrorMessage(context, message: 'An error occurred: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
