import 'dart:ui';
import 'package:flutter/material.dart';

import 'dart:ui';
import 'package:flutter/material.dart';

import 'dart:ui';
import 'package:flutter/material.dart';

class TicketWidget extends StatefulWidget {
  const TicketWidget({
    Key? key,
    required this.width,
    required this.height,
    required this.child,
    this.padding,
    this.margin,
    this.color = Colors.white,
    this.isCornerRounded = false,
    this.shadow,
    this.backgroundImage,
    this.blurIntensity = 0,
    this.borderColor, // New parameter for border color
    this.borderWidth = 0, // New parameter for border width
  }) : super(key: key);

  final double width;
  final double height;
  final Widget child;
  final Color color;
  final bool isCornerRounded;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final List<BoxShadow>? shadow;
  final ImageProvider? backgroundImage;
  final int blurIntensity; // New parameter for blur intensity
  final Color? borderColor; // New parameter for border color
  final double borderWidth; // New parameter for border width

  @override
  _TicketWidgetState createState() => _TicketWidgetState();
}

class _TicketWidgetState extends State<TicketWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TicketClipper(),
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        width: widget.width,
        height: widget.height,
        padding: widget.padding,
        margin: widget.margin,
        decoration: BoxDecoration(
          boxShadow: widget.shadow,
          color: widget.backgroundImage == null
              ? widget.color
              : Colors.transparent,
          borderRadius: widget.isCornerRounded
              ? BorderRadius.circular(20.0)
              : BorderRadius.circular(0.0),
          image: widget.backgroundImage != null
              ? DecorationImage(
            image: widget.backgroundImage!,
            fit: BoxFit.cover,
          )
              : null,
          border: widget.borderColor != null && widget.borderWidth > 0
              ? Border.all(color: widget.borderColor!, width: widget.borderWidth)
              : null,
        ),
        child: Stack(
          children: [
            if (widget.blurIntensity > 0) // Apply blur based on intensity
              ClipRRect(
                borderRadius: widget.isCornerRounded
                    ? BorderRadius.circular(20.0)
                    : BorderRadius.zero,
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: double.parse(widget.blurIntensity.toString()),
                    sigmaY: double.parse(widget.blurIntensity.toString()),
                  ),
                  child: Container(
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
              ),
            widget.child,
          ],
        ),
      ),
    );
  }
}


class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Define the ticket shape
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    // Add the circular cutouts on the left and right sides
    path.addOval(Rect.fromCircle(center: Offset(0.0, size.height / 1.4), radius: 20.0));
    path.addOval(Rect.fromCircle(center: Offset(size.width, size.height / 1.4), radius: 20.0));

    return path;
  }

  Path getOutline(Size size) {
    Path path = Path();
    // Define the outline path (you can adjust the outline shape as needed)
    path.addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height));
    path.addOval(Rect.fromCircle(center: Offset(0.0, size.height / 1.4), radius: 20.0));
    path.addOval(Rect.fromCircle(center: Offset(size.width, size.height / 1.4), radius: 20.0));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TicketOutlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black // Outline color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2; // Outline thickness

    // Draw the outline
    TicketClipper clipper = TicketClipper();
    canvas.drawPath(clipper.getOutline(size), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TicketData extends StatelessWidget {
  const TicketData({
    Key? key,
    required this.eventTitle,
    required this.eventDecreption,
    required this.eventManagerContactNo,
    required this.eventAddress,
    required this.eventDate,
  }) : super(key: key);

  final String eventTitle;
  final String eventDecreption;
  final String eventManagerContactNo;
  final String eventAddress;
  final String eventDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 120.0,
                height: 25.0,
                child: const Center(
                  child: Text(
                    'Ticket Number:',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Row(
                children: [
                  Text(
                    '0123456789',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Text(
              eventTitle,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ticketDetailsWidget(
                  context, 'Name', 'Tarun Kumar Sahani', 'Date', eventDate),
              const SizedBox(height: 10),
              ticketDetailsWidget(
                  context, 'Address', eventAddress, 'Gate', '66B'),
              const SizedBox(height: 10),
              ticketDetailsWidget(context, 'Class', 'Business', 'Seat', '21B'),
            ],
          ),
          SizedBox(height: 20),
          ticketDetailsWidget(context, 'Descreption', eventDecreption, "", ""),
          Spacer(),
          Container(
            width: MediaQuery.of(context).size.width - 75,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/QRCode.png'),
                              fit: BoxFit.cover)),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 180,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Event Manager Contact No: $eventManagerContactNo",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Event Manager Name: Tarun',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget ticketDetailsWidget(BuildContext context, String firstTitle,
    String firstDesc, String secondTitle, String secondDesc) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "$firstTitle:",
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.9,
            child: Text(
              firstDesc,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            child: Text(
              secondTitle == "" ? '' : "$secondTitle:",
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.9,
            child: Text(
              secondDesc,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white),
            ),
          )
        ],
      )
    ],
  );
}





// class TicketWidget extends StatefulWidget {
//   const TicketWidget({
//     Key? key,
//     required this.width,
//     required this.height,
//     required this.child,
//     this.padding,
//     this.margin,
//     this.color = Colors.white,
//     this.isCornerRounded = false,
//     this.shadow,
//     this.backgroundImage,
//     this.blurIntensity = 0,
//   }) : super(key: key);
//
//   final double width;
//   final double height;
//   final Widget child;
//   final Color color;
//   final bool isCornerRounded;
//   final EdgeInsetsGeometry? padding;
//   final EdgeInsetsGeometry? margin;
//   final List<BoxShadow>? shadow;
//   final ImageProvider? backgroundImage;
//   final int blurIntensity; // New parameter for blur intensity
//
//   @override
//   _TicketWidgetState createState() => _TicketWidgetState();
// }
//
// class _TicketWidgetState extends State<TicketWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return ClipPath(
//       clipper: TicketClipper(),
//       child: AnimatedContainer(
//         duration: const Duration(seconds: 1),
//         width: widget.width,
//         height: widget.height,
//         padding: widget.padding,
//         margin: widget.margin,
//         decoration: BoxDecoration(
//           boxShadow: widget.shadow,
//           color: widget.backgroundImage == null
//               ? widget.color
//               : Colors.transparent,
//           borderRadius: widget.isCornerRounded
//               ? BorderRadius.circular(20.0)
//               : BorderRadius.circular(0.0),
//           image: widget.backgroundImage != null
//               ? DecorationImage(
//             image: widget.backgroundImage!,
//             fit: BoxFit.cover,
//           )
//               : null,
//         ),
//         child: Stack(
//           children: [
//             if (widget.blurIntensity > 0) // Apply blur based on intensity
//               ClipRRect(
//                 borderRadius: widget.isCornerRounded
//                     ? BorderRadius.circular(20.0)
//                     : BorderRadius.zero,
//                 child: BackdropFilter(
//                   filter: ImageFilter.blur(
//                     sigmaX: double.parse(widget.blurIntensity.toString()),
//                     sigmaY: double.parse(widget.blurIntensity.toString()),
//                   ),
//                   child: Container(
//                     color: Colors.black.withOpacity(0.2),
//                   ),
//                 ),
//               ),
//             widget.child,
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class TicketClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     Path path = Path();
//
//     // Define the ticket shape
//     path.lineTo(0.0, size.height);
//     path.lineTo(size.width, size.height);
//     path.lineTo(size.width, 0.0);
//
//     // Add the circular cutouts on the left and right sides
//     path.addOval(
//         Rect.fromCircle(center: Offset(0.0, size.height / 1.4), radius: 20.0));
//
//     path.addOval(Rect.fromCircle(
//         center: Offset(size.width, size.height / 1.4), radius: 20.0));
//
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }
//
// class TicketData extends StatelessWidget {
//   const TicketData({
//     Key? key,
//     required this.eventTitle,
//     required this.eventDecreption,
//     required this.eventManagerContactNo,
//     required this.eventAddress,
//     required this.eventDate,
//   }) : super(key: key);
//
//   final String eventTitle;
//   final String eventDecreption;
//   final String eventManagerContactNo;
//   final String eventAddress;
//   final String eventDate;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Container(
//                 width: 120.0,
//                 height: 25.0,
//                 child: const Center(
//                   child: Text(
//                     'Ticket  Number:',
//                     style: TextStyle(
//                         color: Colors.white, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//               const Row(
//                 children: [
//                   Text(
//                     '0123456789',
//                     style: TextStyle(
//                         color: Colors.white, fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               )
//             ],
//           ),
//           Padding(
//             padding: EdgeInsets.only(top: 20.0),
//             child: Text(
//               eventTitle,
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 20.0,
//                   fontWeight: FontWeight.bold),
//             ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ticketDetailsWidget(
//                   context, 'Name', 'Tarun Kumar Sahani', 'Date', eventDate),
//               const SizedBox(height: 10),
//               ticketDetailsWidget(
//                   context, 'Address', eventAddress, 'Gate', '66B'),
//               const SizedBox(height: 10),
//               ticketDetailsWidget(context, 'Class', 'Business', 'Seat', '21B'),
//             ],
//           ),
//           SizedBox(height: 20),
//           ticketDetailsWidget(context, 'Descreption', eventDecreption, "", ""),
//           Spacer(),
//           Container(
//             width: MediaQuery.of(context).size.width - 75,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       width: 100.0,
//                       height: 100.0,
//                       decoration: const BoxDecoration(
//                           image: DecorationImage(
//                               image: AssetImage('assets/images/QRCode.png'),
//                               fit: BoxFit.cover)),
//                     ),
//                     const SizedBox(width: 10),
//                     SizedBox(
//                       width: 180,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Text(
//                             "Event Manager Contect No: $eventManagerContactNo",
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: Colors.white,
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           const Text(
//                             'Event Manager Name: Tarun',
//                             textAlign: TextAlign.center,
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// Widget ticketDetailsWidget(BuildContext context, String firstTitle,
//     String firstDesc, String secondTitle, String secondDesc) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Text(
//             "$firstTitle:",
//             style: const TextStyle(
//                 color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(
//             width: MediaQuery.of(context).size.width / 1.9,
//             child: Text(
//               firstDesc,
//               maxLines: 4,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(color: Colors.white),
//             ),
//           )
//         ],
//       ),
//       Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           SizedBox(
//             child: Text(
//               secondTitle == "" ? '' : "$secondTitle:",
//               style: const TextStyle(
//                   color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//           ),
//           SizedBox(
//             width: MediaQuery.of(context).size.width / 1.9,
//             child: Text(
//               secondDesc,
//               maxLines: 4,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(color: Colors.white),
//             ),
//           )
//         ],
//       )
//     ],
//   );
// }