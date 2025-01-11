import 'dart:developer';

import 'package:discount_deals/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HowItWorksScreen extends StatefulWidget {
  @override
  State<HowItWorksScreen> createState() => _HowItWorksScreenState();
}

class _HowItWorksScreenState extends State<HowItWorksScreen> {
  late YoutubePlayerController _controller;

  late TextEditingController _idController;

  late PlayerState _playerState;

  late YoutubeMetaData _videoMetaData;

  double _volume = 100;

  bool _muted = false;

  bool _isPlayerReady = false;

  final String _videoId = 'eDStSQHbz0g';

  // Set your desired video ID here
  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: _videoId,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    super.dispose();
  }
  late InAppWebViewController _webViewController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How It Works'),
      ),
      body:  Container(
        margin: EdgeInsets.all(18),
        // height: 500,

        child:InAppWebView(
          initialUrlRequest: URLRequest(
            url: Uri.parse("https://www.youtube.com/shorts/6tmXzaV9qgQ"), // YouTube embed URL
          ),
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              javaScriptEnabled: true, // Enable JavaScript
              useOnLoadResource: true,
              disableHorizontalScroll: true, // Disable horizontal scroll
              disableVerticalScroll: true,   // Disable vertical scroll
            ),
          ),
          onWebViewCreated: (controller) {
            _webViewController = controller;
          },
          // onPageFinished: (url) {
          //   // Optionally, you can inject CSS to make sure scrolling is disabled.
          //   _webViewController.injectJavaScript("""
          //     document.body.style.overflow = 'hidden';
          //     document.documentElement.style.overflow = 'hidden';
          //   """);
          // },
        ),
        // child: InAppWebView(
        //   initialUrlRequest: URLRequest(
        //     url: Uri.parse("https://www.youtube.com/shorts/6tmXzaV9qgQ"), // YouTube embed URL
        //   ),
        //   initialOptions: InAppWebViewGroupOptions(
        //     crossPlatform: InAppWebViewOptions(
        //       javaScriptEnabled: true, // Enable JavaScript
        //     ),
        //   ),
        //   onWebViewCreated: (controller) {
        //     _webViewController = controller;
        //   },
        // ),
      ),
      // SingleChildScrollView(
      //   padding: EdgeInsets.all(20.0),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       // Text(
      //       //   'How It Works',
      //       //   style: TextStyle(
      //       //     fontSize: 24.0,
      //       //     fontWeight: FontWeight.bold,
      //       //   ),
      //       // ),
      //       // SizedBox(height: 20.0),
      //
      //       Container(
      //         height: 180,
      //         child: YoutubePlayerBuilder(
      //           onExitFullScreen: () {
      //             // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
      //             SystemChrome.setPreferredOrientations(
      //                 DeviceOrientation.values);
      //           },
      //           player: YoutubePlayer(
      //             controller: _controller,
      //             showVideoProgressIndicator: true,
      //             progressIndicatorColor: Colors.blueAccent,
      //             topActions: <Widget>[
      //               const SizedBox(width: 8.0),
      //               Expanded(
      //                 child: Text(
      //                   _controller.metadata.title,
      //                   style: const TextStyle(
      //                     color: Colors.white,
      //                     fontSize: 18.0,
      //                   ),
      //                   overflow: TextOverflow.ellipsis,
      //                   maxLines: 1,
      //                 ),
      //               ),
      //               IconButton(
      //                 icon: const Icon(
      //                   Icons.settings,
      //                   color: Colors.white,
      //                   size: 25.0,
      //                 ),
      //                 onPressed: () {
      //                   log('Settings Tapped!');
      //                 },
      //               ),
      //             ],
      //             onReady: () {
      //               _isPlayerReady = true;
      //             },
      //             onEnded: (data) {
      //               _controller.load(_videoId);
      //               _showSnackBar('Video Ended!');
      //             },
      //           ),
      //           builder: (context, player) => Scaffold(
      //             appBar: AppBar(
      //               leading: Padding(
      //                 padding: const EdgeInsets.only(left: 12.0),
      //                 child: Image.asset(
      //                   'assets/ypf.png',
      //                   fit: BoxFit.fitWidth,
      //                 ),
      //               ),
      //               title: const Text(
      //                 'Youtube Player Flutter',
      //                 style: TextStyle(color: Colors.white),
      //               ),
      //             ),
      //             body: ListView(
      //               children: [
      //                 player,
      //                 Padding(
      //                   padding: const EdgeInsets.all(8.0),
      //                   child: Column(
      //                     crossAxisAlignment: CrossAxisAlignment.stretch,
      //                     children: [
      //                       _space,
      //                       _text('Title', _videoMetaData.title),
      //                       _space,
      //                       _text('Channel', _videoMetaData.author),
      //                       _space,
      //                       _text('Video Id', _videoMetaData.videoId),
      //                       _space,
      //                       Row(
      //                         children: [
      //                           _text(
      //                             'Playback Quality',
      //                             _controller.value.playbackQuality ?? '',
      //                           ),
      //                           const Spacer(),
      //                           _text(
      //                             'Playback Rate',
      //                             '${_controller.value.playbackRate}x  ',
      //                           ),
      //                         ],
      //                       ),
      //                       _space,
      //                       TextField(
      //                         enabled: _isPlayerReady,
      //                         controller: _idController,
      //                         decoration: InputDecoration(
      //                           border: InputBorder.none,
      //                           hintText: 'Enter youtube <video id> or <link>',
      //                           fillColor: Colors.blueAccent.withAlpha(20),
      //                           filled: true,
      //                           hintStyle: const TextStyle(
      //                             fontWeight: FontWeight.w300,
      //                             color: Colors.blueAccent,
      //                           ),
      //                           suffixIcon: IconButton(
      //                             icon: const Icon(Icons.clear),
      //                             onPressed: () => _idController.clear(),
      //                           ),
      //                         ),
      //                       ),
      //                       _space,
      //                       Row(
      //                         children: [
      //                           _loadCueButton('LOAD'),
      //                           const SizedBox(width: 10.0),
      //                           _loadCueButton('CUE'),
      //                         ],
      //                       ),
      //                       _space,
      //                       Row(
      //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                         children: [
      //                           IconButton(
      //                             icon: Icon(
      //                               _controller.value.isPlaying
      //                                   ? Icons.pause
      //                                   : Icons.play_arrow,
      //                             ),
      //                             onPressed: _isPlayerReady
      //                                 ? () {
      //                                     _controller.value.isPlaying
      //                                         ? _controller.pause()
      //                                         : _controller.play();
      //                                     setState(() {});
      //                                   }
      //                                 : null,
      //                           ),
      //                           IconButton(
      //                             icon: Icon(_muted
      //                                 ? Icons.volume_off
      //                                 : Icons.volume_up),
      //                             onPressed: _isPlayerReady
      //                                 ? () {
      //                                     _muted
      //                                         ? _controller.unMute()
      //                                         : _controller.mute();
      //                                     setState(() {
      //                                       _muted = !_muted;
      //                                     });
      //                                   }
      //                                 : null,
      //                           ),
      //                           FullScreenButton(
      //                             controller: _controller,
      //                             color: Colors.blueAccent,
      //                           ),
      //                         ],
      //                       ),
      //                       _space,
      //                       Row(
      //                         children: <Widget>[
      //                           const Text(
      //                             "Volume",
      //                             style: TextStyle(fontWeight: FontWeight.w300),
      //                           ),
      //                           Expanded(
      //                             child: Slider(
      //                               inactiveColor: Colors.transparent,
      //                               value: _volume,
      //                               min: 0.0,
      //                               max: 100.0,
      //                               divisions: 10,
      //                               label: '${(_volume).round()}',
      //                               onChanged: _isPlayerReady
      //                                   ? (value) {
      //                                       setState(() {
      //                                         _volume = value;
      //                                       });
      //                                       _controller
      //                                           .setVolume(_volume.round());
      //                                     }
      //                                   : null,
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                       _space,
      //                       AnimatedContainer(
      //                         duration: const Duration(milliseconds: 800),
      //                         decoration: BoxDecoration(
      //                           borderRadius: BorderRadius.circular(20.0),
      //                           color: _getStateColor(_playerState),
      //                         ),
      //                         padding: const EdgeInsets.all(8.0),
      //                         child: Text(
      //                           _playerState.toString(),
      //                           style: const TextStyle(
      //                             fontWeight: FontWeight.w300,
      //                             color: Colors.white,
      //                           ),
      //                           textAlign: TextAlign.center,
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ),
      //
      //       SizedBox(
      //         height: 30,
      //       ),
      //
      //       Container(
      //         decoration: BoxDecoration(
      //           border: Border.all(
      //             color: Colors.black38, // Set the border color
      //             width: 1.0, // Set the border width
      //           ),
      //           borderRadius: BorderRadius.circular(11.0),
      //         ),
      //         child: Column(
      //           children: [
      //             Container(
      //               decoration: BoxDecoration(
      //                 color: MyColors.blueBG,
      //                 borderRadius: BorderRadius.only(
      //                     topLeft: Radius.circular(10),
      //                     topRight: Radius.circular(
      //                         10)), // Change this value to adjust the roundness
      //               ),
      //               padding: EdgeInsets.all(12.0), // Adjust padding as needed
      //               child: Center(
      //                 child: Text(
      //                   "How to avail Deal",
      //                   style: TextStyle(
      //                     color: Colors.white,
      //                     fontWeight: FontWeight.bold,
      //                     fontSize: 20.0, // Adjust font size as needed
      //                   ),
      //                 ),
      //               ),
      //             ),
      //             SizedBox(
      //               height: 20,
      //             ),
      //             Container(
      //               margin: EdgeInsets.symmetric(horizontal: 5),
      //               child: Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Expanded(
      //                     child: _buildIconWithText(
      //                         Icons.search,
      //                         Colors.orangeAccent.shade100,
      //                         "Select a Deal \nand visit\noutlet"),
      //                   ),
      //                   Expanded(
      //                     child: _buildIconWithText(Icons.verified, Colors.green,
      //                         "Pay bill \nusing Redeem Coupon"),
      //                   ),
      //                   Expanded(
      //                     child: _buildIconWithText(Icons.discount, Colors.blue,
      //                         "Save\nup to 50% \non the bill"),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //             SizedBox(
      //               height: 20,
      //             ),
      //           ],
      //         ),
      //       ),
      //
      //       SizedBox(
      //         height: 30,
      //       ),
      //       Container(
      //         padding: EdgeInsets.all(10),
      //         decoration: BoxDecoration(
      //           border: Border.all(
      //             color: Colors.black38, // Set the border color
      //             width: 1.0, // Set the border width
      //           ),
      //           borderRadius: BorderRadius.circular(10.0),
      //         ),
      //         child: Column(
      //           children: [
      //             _buildStep(
      //               title: 'Sign Up & Profile Setup',
      //               description:
      //                   'Sign up in the app and create your profile to get started.',
      //             ),
      //             _buildStep(
      //               title: 'Get Prime Membership',
      //               description:
      //                   'Get prime membership to avail all offers and deals.',
      //             ),
      //             _buildStep(
      //               title: 'Select Store',
      //               description:
      //                   'Choose the store of your choice from the available options.',
      //             ),
      //             _buildStep(
      //               title: 'Visit Store',
      //               description:
      //                   'Visit the selected store and inform the manager about your coupon.',
      //             ),
      //             _buildStep(
      //               title: 'Redeem Coupon',
      //               description:
      //                   'Ask the manager for the barcode or outlet pin number to redeem your coupon.',
      //             ),
      //             _buildStep(
      //               title: 'Enjoy Your Offer',
      //               description:
      //                   'Once the coupon is redeemed, enjoy the offer at the store.',
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  // Widget _buildIconWithText(IconData icon, Color color, String text) {
  //   return Column(
  //     //mainAxisAlignment: MainAxisAlignment.start,
  //     children: [
  //       Material(
  //         elevation: 5.0, // Adjust elevation
  //         shape: CircleBorder(),
  //         color: Colors.white,
  //         child: Padding(
  //           padding: EdgeInsets.all(10.0), // Adjust padding for circle size
  //           child: Icon(
  //             icon,
  //             color: color,
  //             size: 35.0, // Adjust icon size
  //           ),
  //         ),
  //       ),
  //       SizedBox(height: 8.0), // Space between icon and text
  //       Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //         child: RichText(
  //           textAlign: TextAlign.center, // Center the text
  //           text: TextSpan(
  //             style: TextStyle(
  //               fontSize: 13.0, // Adjust text size
  //               color: Colors.black, // Adjust text color if needed
  //             ),
  //             children: _buildTextSpans(text),
  //           ),
  //           softWrap: true, // Allow text to wrap to the next line
  //         ),
  //       ),
  //     ],
  //   );
  // }
  //
  // List<TextSpan> _buildTextSpans(String text) {
  //   List<TextSpan> spans = [];
  //   List<String> words = text.split(' ');
  //
  //   for (String word in words) {
  //     if (word == "Select" ||
  //         word == "a" ||
  //         word == "Pay" ||
  //         word == "bill" ||
  //         word == "30%") {
  //       spans.add(TextSpan(
  //         text: "$word ",
  //         style: TextStyle(fontWeight: FontWeight.bold),
  //       ));
  //     } else {
  //       spans.add(TextSpan(text: "$word "));
  //     }
  //   }
  //
  //   return spans;
  // }
  //
  // Widget _buildStep({String? title, String? description}) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Row(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Icon(
  //             Icons.circle,
  //             size: 15.0,
  //             color: MyColors.primaryColor,
  //           ),
  //           SizedBox(width: 10.0), // Adding space between icon and text
  //           Expanded(
  //             child: Text(
  //               title!,
  //               style: TextStyle(
  //                 fontSize: 17.0,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //       SizedBox(height: 10.0),
  //       Text(
  //         description!,
  //         style: TextStyle(fontSize: 15.0),
  //       ),
  //       SizedBox(height: 20.0),
  //     ],
  //   );
  // }
  //
  // Widget _text(String title, String value) {
  //   return RichText(
  //     text: TextSpan(
  //       text: '$title : ',
  //       style: const TextStyle(
  //         color: Colors.blueAccent,
  //         fontWeight: FontWeight.bold,
  //       ),
  //       children: [
  //         TextSpan(
  //           text: value,
  //           style: const TextStyle(
  //             color: Colors.blueAccent,
  //             fontWeight: FontWeight.w300,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // Color _getStateColor(PlayerState state) {
  //   switch (state) {
  //     case PlayerState.unknown:
  //       return Colors.grey[700]!;
  //     case PlayerState.unStarted:
  //       return Colors.pink;
  //     case PlayerState.ended:
  //       return Colors.red;
  //     case PlayerState.playing:
  //       return Colors.blueAccent;
  //     case PlayerState.paused:
  //       return Colors.orange;
  //     case PlayerState.buffering:
  //       return Colors.yellow;
  //     case PlayerState.cued:
  //       return Colors.blue[900]!;
  //     default:
  //       return Colors.blue;
  //   }
  // }
  //
  // Widget get _space => const SizedBox(height: 10);
  //
  // _loadCueButton(String action) {
  //   return Expanded(
  //     child: MaterialButton(
  //       color: Colors.blueAccent,
  //       onPressed: _isPlayerReady
  //           ? () {
  //               if (_idController.text.isNotEmpty) {
  //                 var id = YoutubePlayer.convertUrlToId(
  //                       _idController.text,
  //                     ) ??
  //                     '';
  //                 if (action == 'LOAD') _controller.load(id);
  //                 if (action == 'CUE') _controller.cue(id);
  //                 FocusScope.of(context).requestFocus(FocusNode());
  //               } else {
  //                 _showSnackBar('Source can\'t be empty!');
  //               }
  //             }
  //           : null,
  //       disabledColor: Colors.grey,
  //       disabledTextColor: Colors.black,
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 14.0),
  //         child: Text(
  //           action,
  //           style: const TextStyle(
  //             fontSize: 18.0,
  //             color: Colors.white,
  //             fontWeight: FontWeight.w300,
  //           ),
  //           textAlign: TextAlign.center,
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // void _showSnackBar(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(
  //         message,
  //         textAlign: TextAlign.center,
  //         style: const TextStyle(
  //           fontWeight: FontWeight.w300,
  //           fontSize: 16.0,
  //         ),
  //       ),
  //       backgroundColor: Colors.blueAccent,
  //       behavior: SnackBarBehavior.floating,
  //       elevation: 1.0,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(50.0),
  //       ),
  //     ),
  //   );
  // }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: YouTubePlayerScreen(),
//     );
//   }
// }
//
// class YouTubePlayerScreen extends StatefulWidget {
//   @override
//   _YouTubePlayerScreenState createState() => _YouTubePlayerScreenState();
// }
//
// class _YouTubePlayerScreenState extends State<YouTubePlayerScreen> {
//   late InAppWebViewController _webViewController;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("YouTube Video Embed"),
//       ),
//       body: InAppWebView(
//         initialUrlRequest: URLRequest(
//           url: Uri.parse("https://www.youtube.com/embed/dQw4w9WgXcQ"), // YouTube embed URL
//         ),
//         initialOptions: InAppWebViewGroupOptions(
//           crossPlatform: InAppWebViewOptions(
//             javaScriptEnabled: true, // Enable JavaScript
//           ),
//         ),
//         onWebViewCreated: (controller) {
//           _webViewController = controller;
//         },
//       ),
//     );
//   }
// }
