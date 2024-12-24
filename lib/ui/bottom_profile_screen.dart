import 'package:cached_network_image/cached_network_image.dart';
import 'package:discount_deals/helper/shared_pref.dart';
import 'package:discount_deals/helper/user_provider.dart';
import 'package:discount_deals/model/user_model.dart';
import 'package:discount_deals/services/api.dart';
import 'package:discount_deals/theme/theme.dart';
import 'package:discount_deals/ui/edit_profiel_Screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileBottomScreen extends StatefulWidget {
  @override
  State<ProfileBottomScreen> createState() => _ProfileBottomScreenState();
}

class _ProfileBottomScreenState extends State<ProfileBottomScreen> {
  String userName = '';
  String userEmail = '';
  String  userMobile='';
  String userImage = '';
  String  userLocation='';
  String  userDob='';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

      getUserDetails();


  }

  @override
  Widget build(BuildContext context) {
   return Consumer<UserProvider>(
     builder: (context, userProvider, child) {
       final user = userProvider.user;
        return Container(
         color: MyColors.backgroundBg,
         child: Container(
           padding: EdgeInsets.only(left: 16, top: 25, right: 16),
           child: GestureDetector(
             onTap: () {
               //FocusScope.of(context).unfocus();
             },
             child: ListView(
               children: [
                 SizedBox(
                   height: 15,
                 ),
                 Center(
                   child: Stack(
                     children: [
                       Container(
                         width: 110,
                         height: 110,
                         decoration: BoxDecoration(
                           border: Border.all(
                               width: 4,
                               color: Theme.of(context).scaffoldBackgroundColor),
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
                           child: CachedNetworkImage(
                             imageUrl: userImage.isNotEmpty
                                 ? userImage
                                 : image,
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
                           // child: Image.network(
                           //   userImage.isNotEmpty
                           //       ? userImage
                           //       : image,
                           //   loadingBuilder: (BuildContext context,
                           //       Widget child,
                           //       ImageChunkEvent? loadingProgress) {
                           //     if (loadingProgress == null) {
                           //       return child;
                           //     }
                           //     else {
                           //       return Center(
                           //         child: CircularProgressIndicator(
                           //           value:
                           //           loadingProgress.expectedTotalBytes !=
                           //               null
                           //               ? loadingProgress
                           //               .cumulativeBytesLoaded /
                           //               (loadingProgress
                           //                   .expectedTotalBytes ??
                           //                   1)
                           //               : null,
                           //         ),
                           //       );
                           //     }
                           //   },
                           //   errorBuilder: (BuildContext context, Object error,
                           //       StackTrace? stackTrace) {
                           //     return Icon(Icons
                           //         .person); // Placeholder icon for error case
                           //   },
                           ),
                         ),

                       // Positioned(
                       //     bottom: 0,
                       //     right: 0,
                       //     child: Container(
                       //       height: 40,
                       //       width: 40,
                       //       decoration: BoxDecoration(
                       //         shape: BoxShape.circle,
                       //         border: Border.all(
                       //           width: 4,
                       //           color: Theme.of(context).scaffoldBackgroundColor,
                       //         ),
                       //         color: MyColors.primaryColor,
                       //       ),
                       //       child: Icon(
                       //         Icons.edit,
                       //         color: Colors.white,
                       //       ),
                       //     )),
                     ],
                   ),
                 ),
                 SizedBox(
                   height: 35,
                 ),
                 buildText("Name", userName.isNotEmpty
                     ? userName
                     : "Update your Name"),
                 buildText("Mobile", userMobile.isNotEmpty
                     ? userMobile
                     : "Update your Mobile"),
                 buildText("Email", userEmail.isNotEmpty
                     ? userEmail
                     : "Update your email"),
                 // buildText("Dath of Birth", userDob.isNotEmpty
                 //     ? userDob
                 //     : "Update your Dob"),
                 buildText("City", userLocation.isNotEmpty
                     ? userLocation
                     : "Update your city"),
                 SizedBox(
                   height: 35,
                 ),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     ElevatedButton(
                       style: ButtonStyle(
                         side: MaterialStateProperty.all<BorderSide>(
                           BorderSide(
                               color:
                               MyColors.primaryColor), // Change the color here
                         ),
                         backgroundColor: MaterialStateProperty.all<Color>(
                             MyColors.primaryColor),
                       ),
                       onPressed: () {
                         // Navigator.push(context,
                         //     MaterialPageRoute(builder: (context) {
                         //       return EditProfileScreen();
                         //     }));
                         navigateToEditProfileScreen();
                       },
                       child: Text("Edit",
                           style: TextStyle(
                               fontSize: 14,
                               letterSpacing: 2.2,
                               color: Colors.white)),
                     ),
                   ],
                 )
               ],
             ),
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
    print("getUserDetails: " + n.dob);
    setState(() {
      userName = n.name;
      userEmail = n.email;
      userMobile = n.mobile;
      userImage = n.image;
      userLocation = n.current_location;
      userDob = n.dob;
    });
  }

  // void navigateToEditProfileScreen() async {
  //   // Navigate to the edit profile screen and wait for result
  //   final Map<String, dynamic>? result = await Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => EditProfileScreen()),
  //   );
  //   // Check if the result is not null and contains updated user details
  //   if (result != null) {
  //     // Update user details based on the received data
  //     setState(() {
  //       userName = result['name'] ?? userName;
  //       userEmail = result['email'] ?? userEmail;
  //       userLocation = result['location'] ?? userLocation;
  //       userDob = result['dob'] ?? userDob;
  //       // Update other user details as needed
  //     });
  //   }
  // }


  void navigateToEditProfileScreen() async {
    // Navigate to the edit profile screen and wait for result
    final Map<String, dynamic>? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfileScreen()),
    );
    // Check if the result is not null and contains updated user details
    if (result != null) {
      // Update user details based on the received data
      setState(() {
        userName = result['name'] ?? userName;
        userEmail = result['email'] ?? userEmail;
        userLocation = result['location'] ?? userLocation;
        userDob = result['dob'] ?? userDob;
      });
      await getUserDetails();

    }
  }



  Widget buildText(String labelText, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 5),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "" + labelText,
                style: TextStyle(
                  color: MyColors.primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                "" + text,
                style: TextStyle(
                  color: MyColors.txtTitleColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}