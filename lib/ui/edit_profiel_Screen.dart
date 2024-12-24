import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:discount_deals/helper/image_selection.dart';
import 'package:discount_deals/helper/shared_pref.dart';
import 'package:discount_deals/helper/user_provider.dart';
import 'package:discount_deals/model/city_model.dart';
import 'package:discount_deals/model/user_model.dart';
import 'package:discount_deals/services/api.dart';
import 'package:discount_deals/services/api_services.dart';
import 'package:discount_deals/utils/snackbar_helper.dart';
import 'package:discount_deals/widget/item_list_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../theme/theme.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  List<CityModel> cityList = [];

  final picker = ImagePicker();
  File? _imageFile;

  int userId = 0;
  String userName = '';
  String userEmail = '';
  String userImage = '';
  String userLocation = '';
  String userDob = '';
  String cityId = '';

  bool isLoading = false;

  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Initial date when the picker opens
      firstDate: DateTime(1900), // Earliest selectable date
      lastDate: DateTime.now(), // Latest selectable date
    );

    if (picked != null && picked != _selectedDate) {
      //setState(() {
      _selectedDate = picked;
      print("date: $_selectedDate");
      _dobController.text =
          "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}";
      //});
    }
  }

  void _showCityDialog() async {
    final CityModel? selectedCity = await showDialog<CityModel>(
      context: context,
      builder: (BuildContext context) {
        return ItemListDialog(items: cityList);
      },
    );

    if (selectedCity != null) {
      setState(() {
        cityId= "${selectedCity.id}";
        locationController.text = selectedCity.city;
        userLocation=selectedCity.city;
        //showErrorMessage(context, message: selectedCity.city);

      });
    }
  }

  @override
  void dispose() {
    _dobController.dispose();

    super.dispose();
  }

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
        if (_imageFile != null) {
          update_profile_image("$userId", _imageFile);
        }
      });
    }
  }

  Future<void> _takePhotoWithCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        if (_imageFile != null) {
          update_profile_image("$userId", _imageFile);
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
    fetchCity();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Pass back the updated user details when pressing the back button
          Navigator.pop(context, {
            'name': nameController.text,
            'email': emailController.text,
            'location': locationController.text,
            'dob': _dobController.text,
            // Add other user details as needed
          });
          return true;
        },
        child: Scaffold(
          backgroundColor: MyColors.backgroundBg,
          appBar: AppBar(
            backgroundColor: MyColors.backgroundBg,
            leading: InkWell(
                onTap: () {
                  Navigator.pop(context, {
                    'name': nameController.text,
                    'email': emailController.text,
                    'location': locationController.text,
                    'dob': _dobController.text,
                    // Add other user details as needed
                  });
                },
                child: Icon(Icons.arrow_back_ios)),
            centerTitle: true,
            title: Text(
              "Edit Profile",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          body: Stack(
            children: [
              Container(
                color: MyColors.backgroundBg,
                padding: EdgeInsets.only(left: 16, top: 25, right: 16),
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: Stack(
                          children: [
                            ProfileImageWidget(
                              imageFile: _imageFile,
                              // Pass the selected image file
                              userImage:
                                  userImage, // Pass the URL of the default user image
                            ),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () {
                                    //showErrorMessage(context, message: "Click");
                                    // Call the method to open the image picker modal bottom sheet
                                    _openImagePicker(context);
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 4,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      ),
                                      color: MyColors.primaryColor,
                                    ),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      buildTextField(
                        labelText: "Full Name",
                        placeholder: "Enter Your Name",
                        isPasswordTextField: false,
                        isReadOnly: false,
                        controller: nameController,
                        initialValue: userName.isNotEmpty ? userName : null,
                      ),
                      buildTextField(
                        labelText: "E-mail",
                        placeholder: "Enter Your Email",
                        isPasswordTextField: false,
                        isReadOnly: false,
                        controller: emailController,
                        initialValue: userEmail.isNotEmpty ? userEmail : null,
                      ),
                      // buildTextField(
                      //   labelText: "DOB",
                      //   placeholder: "Enter Your DOB",
                      //   isPasswordTextField: false,
                      //   isReadOnly: true,
                      //   controller: _dobController,
                      //   initialValue: userDob.isNotEmpty ? userDob : "",
                      //   onTap: () {
                      //     _selectDate(
                      //         context); // Open date picker when tapping on TextField
                      //   },
                      // ),
                      buildTextField(
                        labelText: "Location",
                        placeholder: "Enter Your City",
                        isPasswordTextField: false,
                        isReadOnly: true,
                        controller: locationController,
                        initialValue:
                            userLocation.isNotEmpty ? userLocation : null,
                          onTap: () {
                            _showCityDialog();
                          }
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              side: MaterialStateProperty.all<BorderSide>(
                                BorderSide(
                                    color: MyColors
                                        .primaryColor), // Change the color here
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  MyColors.primaryColor),
                            ),
                            onPressed: () {
                              Navigator.pop(context, {
                                'name': nameController.text,
                                'email': emailController.text,
                                'location': locationController.text,
                                'dob': _dobController.text,
                                // Add other user details as needed
                              });
                            },
                            child: Text("Cancel",
                                style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 2.2,
                                    color: Colors.white)),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              final user_Id = userId;
                              final name = nameController.text;
                              final email = emailController.text;
                              final city_id = cityId;
                              final cityName = locationController.text;
                              // final dob = _dobController.text;
                              final dob = "";

                              update_profile(
                                  '$user_Id', name, email, city_id,cityName, dob);
                            },
                            style: ButtonStyle(
                              side: MaterialStateProperty.all<BorderSide>(
                                BorderSide(
                                    color: MyColors
                                        .primaryColor), // Change the color here
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  MyColors.primaryColor),
                            ),
                            child: Text(
                              "Save",
                              style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 2.2,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              // Show a loading indicator if _isLoading is true
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  // Adjust opacity as needed
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                       MyColors.primary,
                      ),
                      // Change the color
                      strokeWidth: 4,
                    ),
                  ),
                ),
            ],
          ),
        ));
  }

  Future<void> getUserDetails() async {
    // SharedPref sharedPref=new SharedPref();
    // userName = (await SharedPref.getUser()).name;
    UserModel n = await SharedPref.getUser();
    print("getUserDetails: " + n.name);
    setState(() {
      userId = n.id;
      userName = n.name;
      userEmail = n.email;
      userImage = n.image;
      userLocation = n.current_location;
      cityId = n.home_location;
      userDob = n.dob;
    });
  }

  Future<void> update_profile_image(String user_id, File? imageFile) async {
    if (imageFile == null) {
      showErrorMessage(context, message: 'Please select image');
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });
      final response = await ApiServices.update_profile_image(
          userId: "$user_id", image: imageFile);

      // Check if the response is null or doesn't contain the expected data
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final data = response['data'];
        // Ensure that the response data is in the expected format
        if (data != null && data is Map<String, dynamic>) {
          //print('verify_otp data: $data');
          final user = UserModel.fromMap(data);
          showSuccessMessage(context, message: response['msg'].toString());
          if (user != null) {
            //print('verify_otp data: 1');

            await SharedPref.userLogin({
              SharedPref.KEY_ID: user.id,
              SharedPref.KEY_CURRENT_MONTH: user.current_month,
              SharedPref.KEY_PREMIUM: user.premium,
              SharedPref.KEY_STATUS: user.status,
              SharedPref.KEY_NAME: user.name,
              SharedPref.KEY_EMAIL: user.email,
              SharedPref.KEY_MOBILE: user.mobile,
              SharedPref.KEY_DOB: user.dob,
              SharedPref.KEY_OTP: user.otp,
              SharedPref.KEY_IMAGE: user.image,
              SharedPref.KEY_HOME_LOCATION: user.home_location,
              SharedPref.KEY_CURRENT_LOCATION: user.current_location,
              SharedPref.KEY_LAT: user.lat,
              SharedPref.KEY_LONG: user.long,
              SharedPref.KEY_CREATED_AT: user.created_at,
              SharedPref.KEY_UPDATED_AT: user.updated_at,
            });

            Provider.of<UserProvider>(context, listen: false)
                .updateUserDetails(user);

            getUserDetails();
          } else {
            // Handle null user
            showErrorMessage(context, message: 'User data is invalid');
          }
        } else {
          // Handle invalid response data format
          showErrorMessage(context, message: 'Invalid response data format');
        }
      } else if (response != null) {
        String msg = response['msg'];

        // Handle unsuccessful response or missing 'res' field
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

  Future<void> update_profile(String user_id, String name, String email,
      String city_id,String cityName, String dob) async {
    if (name.isEmpty) {
      showErrorMessage(context, message: 'Please fill name');
      return;
    } else if (email.isEmpty) {
      showErrorMessage(context, message: 'Please fill email');
      return;
    }
    // else if (dob.isEmpty) {
    //   showErrorMessage(context, message: 'Please fill dob');
    //   return;
    // }
    else if (cityName.isEmpty) {
      showErrorMessage(context, message: 'Please fill location');
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });
      final body = {
        "user_id": user_id,
        "name": name,
        "email": email,
        "home_location": city_id,
        "current_location": city_id,
        "dob": dob,
      };
      final response = await ApiServices.update_profile(context, body);

      // Check if the response is null or doesn't contain the expected data
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final data = response['data'];
        // Ensure that the response data is in the expected format
        if (data != null && data is Map<String, dynamic>) {
          //print('verify_otp data: $data');
          final user = UserModel.fromMap(data);
          showSuccessMessage(context, message: response['msg'].toString());
          if (user != null) {
            //print('verify_otp data: 1');

            await SharedPref.userLogin({
              SharedPref.KEY_ID: user.id,
              SharedPref.KEY_CURRENT_MONTH: user.current_month,
              SharedPref.KEY_PREMIUM: user.premium,
              SharedPref.KEY_STATUS: user.status,
              SharedPref.KEY_NAME: user.name,
              SharedPref.KEY_EMAIL: user.email,
              SharedPref.KEY_MOBILE: user.mobile,
              SharedPref.KEY_DOB: user.dob,
              SharedPref.KEY_OTP: user.otp,
              SharedPref.KEY_IMAGE: user.image,
              SharedPref.KEY_HOME_LOCATION: user.home_location,
              SharedPref.KEY_CURRENT_LOCATION: user.current_location,
              SharedPref.KEY_LAT: user.lat,
              SharedPref.KEY_LONG: user.long,
              SharedPref.KEY_CREATED_AT: user.created_at,
              SharedPref.KEY_UPDATED_AT: user.updated_at,
            });

            getUserDetails();
          } else {
            // Handle null user
            showErrorMessage(context, message: 'User data is invalid');
          }
        } else {
          // Handle invalid response data format
          showErrorMessage(context, message: 'Invalid response data format');
        }
      } else if (response != null) {
        String msg = response['msg'];

        // Handle unsuccessful response or missing 'res' field
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

  Future<void> fetchCity() async {
    try {
      final response = await ApiServices.api_show_city(context);
      print('fetchCity:response  $response');
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final data = response['data'] as List<dynamic>;

        cityList = data.map((e) {
          return CityModel.fromMap(e);
        }).toList();
      } else if (response != null) {
        String msg = response['msg'];

        // Handle unsuccessful response or missing 'res' field
        showErrorMessage(context, message: msg);
      }
    } catch (e) {
      print('fetchCity: $e');
    }
  }

  bool showPassword = false;

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
        obscureText: isPasswordTextField ? showPassword : false,
        readOnly: isReadOnly,
        onTap: onTap,
        // Use the provided onTap function, if any
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          suffixIcon: isPasswordTextField
              ? IconButton(
                  onPressed: () {
                    // Toggle password visibility
                    showPassword = !showPassword;
                    controller.clear();
                  },
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: Colors.grey,
                  ),
                )
              : null,
          contentPadding: EdgeInsets.only(bottom: 3),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

class ProfileImageWidget extends StatelessWidget {
  final File? imageFile;
  final String userImage;

  const ProfileImageWidget({
    Key? key,
    required this.userImage,
    this.imageFile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(
            width: 4, color: Theme.of(context).scaffoldBackgroundColor),
        boxShadow: [
          BoxShadow(
              spreadRadius: 2,
              blurRadius: 10,
              color: Colors.black.withOpacity(0.1),
              offset: Offset(0, 10))
        ],
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: imageFile != null
            ? Image.file(
                imageFile!,
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              )
            : CachedNetworkImage(
          imageUrl: userImage.isNotEmpty ? userImage : image,
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
        // Image.network(
        //         userImage.isNotEmpty ? userImage : image,
        //         loadingBuilder: (BuildContext context, Widget child,
        //             ImageChunkEvent? loadingProgress) {
        //           if (loadingProgress == null) {
        //             return child;
        //           } else {
        //             return Center(
        //               child: CircularProgressIndicator(
        //                 value: loadingProgress.expectedTotalBytes != null
        //                     ? loadingProgress.cumulativeBytesLoaded /
        //                         (loadingProgress.expectedTotalBytes ?? 1)
        //                     : null,
        //               ),
        //             );
        //           }
        //         },
        //         errorBuilder: (BuildContext context, Object error,
        //             StackTrace? stackTrace) {
        //           return Icon(Icons.person); // Placeholder icon for error case
        //         },
        //       ),
      ),
    );
  }
}
