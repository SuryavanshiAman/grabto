import 'package:discount_deals/helper/shared_pref.dart';
import 'package:discount_deals/model/city_model.dart';
import 'package:discount_deals/model/user_model.dart';
import 'package:discount_deals/services/api_services.dart';
import 'package:discount_deals/ui/otp_screen.dart';
import 'package:discount_deals/utils/snackbar_helper.dart';
import 'package:discount_deals/widget/date_picker.dart';
import 'package:discount_deals/widget/item_list_dialog.dart';
import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'package:flutter/services.dart';

class SignupScreen extends StatefulWidget {
final String mobile;

  const SignupScreen({super.key ,required this.mobile});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController dobCont = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateTime? _selectedDate;
  List<CityModel> cityList = [];
  int cityId = 0;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      // Initial date when the picker opens
      firstDate: DateTime(1900),
      // Earliest selectable date
      lastDate: DateTime.now(),
      // Latest selectable date

      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.black,
            textTheme: const TextTheme(
              displayMedium:
                  TextStyle(color: Colors.black), // Change text color here
            ),
            colorScheme: const ColorScheme.light(
              primary: MyColors.primaryColor, // Change header color here
              onPrimary: Colors.white, // Change header text color here
              onSurface: Colors.black, // Change body text color here
            ),
          ),
          child: child!,
        );
      },
    );

    /* textTheme: TextTheme(
              bodyText2:
                  TextStyle(color: Colors.black), // Change text color here
            ),*/

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        print("date: $_selectedDate");
        // _dobController.text =
        //     "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}";
      });
    }
  }

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mobileController.text=widget.mobile;
    fetchCity();
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
        cityId = selectedCity.id;
        cityController.text = selectedCity.city;
      });
    }
  }
  bool showSelectedDate = false;
  void _handleDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
      dobCont.text = formattedDate();
      showSelectedDate = true;

    });
  }
  String formattedDate() {

    final String year = selectedDate.year.toString();
    final String month = selectedDate.month.toString().padLeft(2, '0');
    final String day = selectedDate.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              color: MyColors.backgroundBg,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Positioned(
                    top: 80,
                    left: 20,
                    child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        height: 200,
                        constraints: const BoxConstraints(maxHeight: 260),
                        child: Image.asset('assets/vector/sign_up_img.png')),
                  ),
                  Container(
                    //margin: EdgeInsets.only(bottom: 15),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 475,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: MyColors.roundBg,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  80)), // Adjust the radius to make it more or less rounded
                        ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 20),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Sign Up",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: MyColors.whiteBG),
                                  ),
                                ],
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Create your account",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        color: MyColors.whiteBG),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            height: 55,
                                            child: TextField(
                                              controller: nameController,
                                              enabled: true,
                                              cursorColor: Colors.white,
                                              minLines: 1,
                                              style: const TextStyle(
                                                  color: MyColors.whiteBG),
                                              decoration: InputDecoration(
                                                hintText: 'Name',
                                                hintStyle: const TextStyle(
                                                    color: Color(0xFFDDDDDD)),
                                                prefixIcon: const Icon(
                                                    Icons.person_outline,
                                                    color: MyColors.whiteBG),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  gapPadding: 0,
                                                  borderSide: const BorderSide(
                                                      color: MyColors
                                                          .primaryColor),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: MyColors.whiteBG),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 17,
                                          ),
                                          Container(
                                            height: 55,
                                            child: TextField(
                                              controller: mobileController,
                                              enabled: true,
                                              cursorColor: Colors.white,
                                              keyboardType:
                                                  TextInputType.number,
                                              //maxLength: 10,
                                              minLines: 1,
                                              style: const TextStyle(
                                                  color: MyColors.whiteBG),
                                              decoration: InputDecoration(
                                                hintText: 'Mobile Number',
                                                hintStyle: const TextStyle(
                                                    color: Color(0xFFDDDDDD)),
                                                prefixIcon: const Icon(
                                                    Icons.mobile_friendly,
                                                    color: MyColors.whiteBG),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  gapPadding: 0,
                                                  borderSide: const BorderSide(
                                                      color: MyColors
                                                          .primaryColor),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: MyColors.whiteBG),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 17,
                                          ),
                                          // Container(
                                          //   height: 55,
                                          //   child: TextField(
                                          //     controller: cityController,
                                          //     enabled: true,
                                          //     cursorColor: Colors.white,
                                          //     keyboardType: TextInputType.text,
                                          //     //maxLength: 10,
                                          //     minLines: 1,
                                          //     style: TextStyle(
                                          //         color: MyColors.whiteBG),
                                          //     decoration: InputDecoration(
                                          //       hintText: 'City',
                                          //       hintStyle: TextStyle(
                                          //           color: Color(0xFFDDDDDD)),
                                          //       prefixIcon: Icon(
                                          //           Icons.mobile_friendly,
                                          //           color: MyColors.whiteBG),
                                          //       enabledBorder:
                                          //           OutlineInputBorder(
                                          //         gapPadding: 0,
                                          //         borderSide: BorderSide(
                                          //             color: MyColors
                                          //                 .primaryColor),
                                          //         borderRadius:
                                          //             BorderRadius.circular(
                                          //                 50.0),
                                          //       ),
                                          //       focusedBorder:
                                          //           OutlineInputBorder(
                                          //         borderSide: BorderSide(
                                          //             color: MyColors.whiteBG),
                                          //         borderRadius:
                                          //             BorderRadius.circular(
                                          //                 50.0),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                          DobWidget(
                                            controller: dobCont,
                                            initialDate: selectedDate,
                                            onDateSelected: _handleDateSelected,
                                          ),
                                          // Container(
                                          //   height: 55,
                                          //   child: TextField(
                                          //     controller: mobileController,
                                          //     enabled: true,
                                          //     cursorColor: Colors.white,
                                          //     keyboardType:
                                          //     TextInputType.number,
                                          //     //maxLength: 10,
                                          //     minLines: 1,
                                          //     style: const TextStyle(
                                          //         color: MyColors.whiteBG),
                                          //     decoration: InputDecoration(
                                          //       hintText: 'Date Of Birth',
                                          //       hintStyle: const TextStyle(
                                          //           color: Color(0xFFDDDDDD)),
                                          //       prefixIcon: const Icon(
                                          //           Icons.cal,
                                          //           color: MyColors.whiteBG),
                                          //       enabledBorder:
                                          //       OutlineInputBorder(
                                          //         gapPadding: 0,
                                          //         borderSide: const BorderSide(
                                          //             color: MyColors
                                          //                 .primaryColor),
                                          //         borderRadius:
                                          //         BorderRadius.circular(
                                          //             50.0),
                                          //       ),
                                          //       focusedBorder:
                                          //       OutlineInputBorder(
                                          //         borderSide: const BorderSide(
                                          //             color: MyColors.whiteBG),
                                          //         borderRadius:
                                          //         BorderRadius.circular(
                                          //             50.0),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                          const SizedBox(
                                            height: 17,
                                          ),
                                          GestureDetector(
                                            onTap: _showCityDialog,
                                            child: AbsorbPointer(
                                              child: Container(
                                                height: 55,
                                                child: TextField(
                                                  controller: cityController,
                                                  enabled: true,
                                                  cursorColor: Colors.white,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  minLines: 1,
                                                  style: const TextStyle(
                                                      color: MyColors.whiteBG),
                                                  decoration: InputDecoration(
                                                    hintText: 'City',
                                                    hintStyle: const TextStyle(
                                                        color:
                                                            Color(0xFFDDDDDD)),
                                                    prefixIcon: const Icon(
                                                        Icons.location_city,
                                                        color:
                                                            MyColors.whiteBG),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      gapPadding: 0,
                                                      borderSide: const BorderSide(
                                                          color: MyColors
                                                              .primaryColor),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color:
                                                              MyColors.whiteBG),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

                                          const SizedBox(
                                            height: 17,
                                          ),
                                          // Container(
                                          //   height: 55,
                                          //   child: TextField(
                                          //     controller: _dobController,
                                          //     //readOnly: true, // Make TextField readonly
                                          //     // onTap: () {
                                          //     //   _selectDate(context); // Open date picker when tapping on TextField
                                          //     //
                                          //     // },
                                          //     cursorColor: Colors.white,
                                          //     keyboardType:
                                          //         TextInputType.datetime,
                                          //     minLines: 1,
                                          //     inputFormatters: [
                                          //       DateInputFormatter()
                                          //     ],
                                          //     style: TextStyle(
                                          //         color: Colors.white),
                                          //     decoration: InputDecoration(
                                          //       hintText: 'DOB',
                                          //       hintStyle: TextStyle(
                                          //           color: Color(0xFFDDDDDD)),
                                          //       prefixIcon: Icon(
                                          //           Icons.calendar_today,
                                          //           color: Colors.white),
                                          //       enabledBorder:
                                          //           OutlineInputBorder(
                                          //         gapPadding: 0,
                                          //         borderSide: BorderSide(
                                          //             color: MyColors
                                          //                 .primaryColor),
                                          //         borderRadius:
                                          //             BorderRadius.circular(
                                          //                 50.0),
                                          //       ),
                                          //       focusedBorder:
                                          //           OutlineInputBorder(
                                          //         borderSide: BorderSide(
                                          //             color: MyColors.whiteBG),
                                          //         borderRadius:
                                          //             BorderRadius.circular(
                                          //                 50.0),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                          // SizedBox(
                                          //   height: 17,
                                          // ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              final name = nameController.text;
                                              final mobile =
                                                  mobileController.text;
                                              final city = "$cityId";
                                              // final dob = _dobController.text;
                                              final dob = dobCont.text;
                                              String token = await SharedPref.getToken();
                                              user_signup(name, mobile, city,
                                                  dob);
                                            },
                                            child: const Text(
                                              "Sign Up",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.white),
                                            ),
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      MyColors.btnBgColor),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Show a loading indicator if _isLoading is true
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    MyColors.primaryColor,
                  ),
                  // Change the color
                  strokeWidth: 4,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> user_signup(
      String name, String mobile, String city, String dob) async {
    if (name.isEmpty) {
      showErrorMessage(context, message: 'Please fill name');
      return;
    } else if (mobile.isEmpty) {
      showErrorMessage(context, message: 'Please fill mobile number');
      return;
    } else if (mobile.length != 10) {
      showErrorMessage(context,
          message: 'Please fill only 10 digit mobile number');
      return;
    } else if (dob.isEmpty) {
      showErrorMessage(context, message: 'Please fill Date of birth');
      return;
    }
    else if (city == "0") {
      showErrorMessage(context, message: 'Please fill city');
      return;
    }


    try {
      setState(() {
        isLoading = true;
      });
      final body = {
        "name": name,
        "mobile": mobile,
        "current_location": city,
        "dob": dob,
      };
      final response = await ApiServices.user_signup(context, body);

      // Check if the response is null or doesn't contain the expected data
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final data = response['data'];
        // Ensure that the response data is in the expected format
        if (data != null && data is Map<String, dynamic>) {
          //print('user_signup data: $data');
          final user = UserModel.fromMap(data);

          if (user != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OtpScreen(
                          mobile: mobile,

                        )));
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
      //print('user_signup error: $e');
      // Handle error
      showErrorMessage(context, message: 'An error occurred: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    // _dobController.dispose();
    super.dispose();
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
}

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText =
        newValue.text.replaceAll('/', ''); // Remove existing slashes

    // Limit the length of input to 8 characters (DDMMYYYY)
    if (newText.length > 8) {
      newText = newText.substring(0, 8);
    }

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    StringBuffer buffer = StringBuffer();
    int selectionIndex = newText.length;

    for (int i = 0; i < newText.length; i++) {
      buffer.write(newText[i]);
      if (i == 1 || i == 3) {
        buffer.write('/');
        if (i < selectionIndex) {
          selectionIndex++;
        }
      }
    }

    String formattedText = buffer.toString();
    if (formattedText.length > 10) {
      formattedText = formattedText.substring(0, 10);
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(
          offset: selectionIndex > 10 ? 10 : selectionIndex),
    );
  }
}
