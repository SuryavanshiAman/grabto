import 'package:discount_deals/helper/shared_pref.dart';
import 'package:discount_deals/model/user_model.dart';
import 'package:discount_deals/services/api_services.dart';
import 'package:discount_deals/utils/snackbar_helper.dart';
import 'package:discount_deals/widget/icon_text_widget.dart';
import 'package:flutter/material.dart';

import '../theme/theme.dart';

import 'package:flutter/material.dart';

class DeleteScreen extends StatefulWidget {
  @override
  _DeleteScreenState createState() => _DeleteScreenState();
}

class _DeleteScreenState extends State<DeleteScreen> {
  final TextEditingController _controller = TextEditingController();

  bool isLoading = false;
  int user_id = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundBg,
      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios, color: MyColors.whiteBG),
        ),
        centerTitle: true,
        title: Text(
          "Delete Account",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MyColors.whiteBG),
        ),
      ),
      body: Stack(children: [
        Container(
          color: MyColors.backgroundBg,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  Container(
                    width: 200,
                    height: 200,
                    child: Image.asset(
                      "assets/images/delete_vect.png",
                      fit: BoxFit
                          .scaleDown, // Adjust fit as per your requirement
                    ),
                  ),
                  Text(
                    'Delete your account...',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: MyColors.textColor),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'By deleting your account, all your data will be permanently erased and cannot be recovered.',
                    style: TextStyle(fontSize: 16, color: MyColors.textColor),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Type your reason...',
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 30.0),
                      textStyle: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () {
                      String txt=_controller.text;
                      if(txt.isNotEmpty){
                        _showConfirmationDialog(context);
                      }else{
                        showErrorMessage(context, message: "Please provide your reason!");
                      }

                    },
                    child: Text(
                      'Delete Account',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            // Adjust opacity as needed
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  MyColors.primaryColor,
                ),
                // Change the color
                strokeWidth: 4,
              ),
            ),
          ),
      ]),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: MyColors.dialogBg,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning, color: MyColors.primary, size: 50),
                SizedBox(height: 20),
                Text(
                  'Are you sure?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: MyColors.dialogTextColor,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'If you delete your account, you won’t be able to login with it anymore. Are you sure you want to continue?',
                  style: TextStyle(
                    fontSize: 14,
                    color: MyColors.dialogTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 30.0,
                          ),
                          textStyle: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () {
                          // Optionally handle cancellation action here
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(width: 10), // Spacer between buttons
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 30.0,
                          ),
                          textStyle: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () {
                          // Add your account deletion logic here
                          Navigator.of(context).pop();
                          String msg = _controller.text;
                          disable_account("$user_id", "$msg");
                        },
                        child: Text(
                          'Continue',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> getUserDetails() async {
    // SharedPref sharedPref=new SharedPref();
    // userName = (await SharedPref.getUser()).name;
    UserModel n = await SharedPref.getUser();
    print("getUserDetails: " + n.name);
    setState(() {
      user_id = n.id;
    });
  }

  Future<void> disable_account(String user_id, String reason) async {
    setState(() {
      isLoading = true;
    });
    try {
      print("disable_account: " + "user_id: "+user_id+", reason: "+reason);
      final body = {
        "user_id": "$user_id",
        "reason": "$reason",
      };
      final response = await ApiServices.disable_account(context, body);

      // Check if the response is null or doesn't contain the expected data
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        String msg = response['msg'];
        // deleteUser(msg);



        print("disable_account: " + "msg: "+msg);
      } else if (response != null) {
        String msg = response['msg'];
        print("disable_account: " + "msg: "+msg);
        showErrorMessage(context, message: msg);
      }
    } catch (e) {
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void deleteUser(String msg) {
    SharedPref.logout(context);
    showSuccessMessage(context, message: msg);
  }
}
