import 'dart:async';
import 'dart:io';
import 'package:discount_deals/generated/assets.dart';
import 'package:discount_deals/helper/InAppScreen.dart';
import 'package:discount_deals/helper/user_provider.dart';
import 'package:discount_deals/theme/theme.dart';
import 'package:discount_deals/ui/splash_screen.dart';
import 'package:discount_deals/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:rxdart/rxdart.dart';

final _messageStreamController = BehaviorSubject<RemoteMessage>();

// TODO: Define the background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification?.title}');
    print('Message notification: ${message.notification?.body}');
  }
}

//For network resolution
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final messaging = FirebaseMessaging.instance;

  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (kDebugMode) {
    print('Permission granted: ${settings.authorizationStatus}');
  }

  // It requests a registration token for sending messages to users from your App server or other trusted server environment.
  String? token = await messaging.getToken();

  if (kDebugMode) {
    print('Registration Token= $token');
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (kDebugMode) {
      print('Handling a foreground message: ${message.messageId}');
      print('Message data: ${message.data}');
      print('Message notification: ${message.notification?.title}');
      print('Message notification: ${message.notification?.body}');
    }

    _messageStreamController.sink.add(message);
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp(token));
}

class MyApp extends StatefulWidget {
  final String? token;

  const MyApp(this.token, {super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    checkForUpdate();
  }

  AppUpdateInfo? _updateInfo;
  Future<void> checkForUpdate() async {
    try {
      final info = await InAppUpdate.checkForUpdate();
      setState(() {
        _updateInfo = info;
      });

      if (_updateInfo?.updateAvailability ==
          UpdateAvailability.updateAvailable) {
        showUpdatePopup();
      }
    } catch (e) {
      print("Error checking for updates: $e");
    }
  }

  void showUpdatePopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
          alignment: Alignment.center,
          backgroundColor: MyColors.redBG,
          content: Container(
            padding: const EdgeInsets.all(15),
            height: heights*0.27,
            child: Column(
              children: [
                const Text("Update your app!",style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: MyColors.whiteBG),),
                Image.asset(Assets.imagesGrabtoLogoWithText,height: heights*0.13,),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: heights*0.05,
                      width: widths*0.25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: MyColors.whiteBG,
                      ),
                      child:  const Text("Later",style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: MyColors.blackBG),),),

                    InkWell(
                        onTap: (){
                          Navigator.of(context).pop();
                          // startImmediateUpdate();
                        },
                        child: Container(
                            alignment: Alignment.center,
                            height: heights*0.05,
                            width: widths*0.25,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: MyColors.whiteBG,
                            ),

                            child: const Text("Update",style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: MyColors.blackBG),)))
                  ],
                )
              ],
            ),
          )
      ),
    );
  }
  Future<void> startImmediateUpdate() async {
    try {
      await InAppUpdate.performImmediateUpdate();
    } catch (e) {
      showErrorMessage(context,message: '$e');
      print("Error performing update: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    heights=MediaQuery.of(context).size.height;
    widths=MediaQuery.of(context).size.width;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PurchaseProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()), // Add UserProvider here

      ],
      child: MaterialApp(
        title: 'Grabto',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          fontFamily: 'ubuntu',
          useMaterial3: true,
        ),
        home: SplashScreen(
          token: widget.token,
        ),
        // home:DemoPage(),
      ),
    );
  }
}
double heights=0.0;
double widths=0.0;