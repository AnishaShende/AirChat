import 'package:chat_app/components/my_button.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_polygon_clipper/flutter_polygon_clipper.dart';
import 'package:neumorphic_ui/neumorphic_ui.dart';

class ViewProfile extends StatefulWidget {
  const ViewProfile({super.key});

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  String imageUrl = "";
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicColors.darkBackground,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.1,
            ),
            Container(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.4,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: FlutterPolygonBorder(
                      sides: 5,
                      borderRadius: 10.0,
                    ),
                    side: BorderSide(
                      color: NeumorphicColors.background,
                      width: 2,
                    ),
                  ),
                  onPressed: () {},
                  child: FlutterClipPolygon(
                    sides: 5,
                    borderRadius: 10.0,
                    child: Image.network(
                      'https://static01.nyt.com/images/2023/05/28/multimedia/28CILLIAN-MURPHY-01-tzqm/28CILLIAN-MURPHY-01-tzqm-superJumbo.jpg',
                      fit: BoxFit
                          .cover, // Use BoxFit.contain to fit the image inside the pentagon without cropping
                      // ),
                    ),
                  ),
                ),
              ),
            ),
            // SizedBox(
            //   height: MediaQuery.of(context).size.height * .2,
            // ),
            Column(
              children: [
                Text(
                  "Anisha Shende",
                  style: TextStyle(
                      color: NeumorphicColors.background,
                      fontSize: 25,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Text(
                  "+91-9420853261",
                  style: TextStyle(
                      color: NeumorphicColors.background,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ClipOval(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.16,
                        height: MediaQuery.of(context).size.height * 0.1,
                        color: NeumorphicColors.background,
                        child: Icon(
                          Icons.call_sharp,
                          color: NeumorphicColors.darkBackground,
                        ),
                      ),
                    ),
                    ClipOval(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.16,
                        height: MediaQuery.of(context).size.height * 0.1,
                        color: NeumorphicColors.background,
                        child: Icon(
                          Icons.videocam_rounded,
                          color: NeumorphicColors.darkBackground,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                MyButton(
                  onTap: () {
                    // Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => ChatPage(
                    //           receiverUserEmail: data['email'],
                    //           receiverUserName: data['name'],
                    //           receiverUserID: data['uid'],
                    //         ),
                    //       )
                    // );
                  },
                  text: "Chat",
                  color: NeumorphicColors.background,
                  textColor: NeumorphicColors.darkBackground,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

//  Container(
//   height: 50,
//   width: 50,
// child: ElevatedButton(
//   style: ElevatedButton.styleFrom(
//     shape: FlutterPolygonBorder(
//       sides: 5,
//       borderRadius: 10.0, // Defaults to 0.0 degrees
//       // rotate: 30.0, // Defaults to 0.0 degrees
//       side: BorderSide(
//           color: Colors.red, width: 2.0), // Defaults to BorderSide.none
//     ),
//   ),
//   onPressed: () {},
//     child: Image.network(
//       'https://static01.nyt.com/images/2023/05/28/multimedia/28CILLIAN-MURPHY-01-tzqm/28CILLIAN-MURPHY-01-tzqm-superJumbo.jpg', // Replace with your image URL
//       width: 100,
//       height: 100,
//     ),
//   ),
// );
// import 'dart:math';
// import 'dart:ui' as ui;
// // import 'package:flutter/material.dart';
// import 'package:neumorphic_ui/neumorphic_ui.dart';

// class ViewProfile extends StatefulWidget {
//   const ViewProfile({super.key});

//   @override
//   State<ViewProfile> createState() => _ViewProfileState();
// }

// class _ViewProfileState extends State<ViewProfile> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('View Profile'),
//         backgroundColor: NeumorphicColors.darkBackground,
//       ),
//       body: Center(
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             SizedBox(
//               width: 200,
//               height: 200,
//               child: CustomPaint(
//                 painter: PentagonPainter(),
//               ),
//             ),
//             Positioned.fill(
//               // top: 50,
// child: Image.network(
//   'https://static01.nyt.com/images/2023/05/28/multimedia/28CILLIAN-MURPHY-01-tzqm/28CILLIAN-MURPHY-01-tzqm-superJumbo.jpg', // Replace with your image URL
//   width: 100,
//   height: 100,
// ),
//             ),
//           ],
//         ),
//       ),
//       // ),
//       //Center(
//       // child: GestureDetector(
//       //   onTap: () {
//       //     // Open a larger photo view here
//       //   },
//       //   child: ClipRRect(
//       //     borderRadius: BorderRadius.circular(16.0),
//       //     child: Container(
//       //       width: 120,
//       //       height: 120,
//       //       color: Colors.grey, // Placeholder color
//       //       child: Stack(
//       //         children: [
//       //           Positioned.fill(
//       //             child: CustomPaint(
//       //               painter: PentagonPainter(),
//       //             ),
//       //           ),
//       //           Center(
//       //             child: CircleAvatar(
//       //               radius: 48.0,
//       //               backgroundImage: NetworkImage(
//       //                   'https://static01.nyt.com/images/2023/05/28/multimedia/28CILLIAN-MURPHY-01-tzqm/28CILLIAN-MURPHY-01-tzqm-superJumbo.jpg'),
//       //             ),
//       //           ),
//       //         ],
//       //       ),
//       //     ),
//       //   ),
//       // ),
//       //   child: ClipPath(
//       //     clipper: PentagonClipper(),
//       //     child: GestureDetector(
//       //       onTap: () {
//       //         // Open a larger photo view here
//       //       },
//       //       child: Container(
//       //         width: 120,
//       //         height: 120,
//       //         color: Colors.grey, // Placeholder color
//       //         child: CircleAvatar(
//       //           radius: 48.0,
//       //           backgroundImage: NetworkImage(
//       //               'https://static01.nyt.com/images/2023/05/28/multimedia/28CILLIAN-MURPHY-01-tzqm/28CILLIAN-MURPHY-01-tzqm-superJumbo.jpg'),
//       //         ),
//       //       ),
//       //     ),
//       //   ),
//       // ),
//     );
//   }
// }

// class PentagonPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final double centerX = size.width / 2;
//     final double centerY = size.height / 2;

//     final double radius = size.width / 2;
//     final double degreesPerSide = 360 / 5;

//     final path = Path();
//     for (int i = 0; i < 5; i++) {
//       double x = centerX + radius * cos(_degreesToRadians(i * degreesPerSide));
//       double y = centerY + radius * sin(_degreesToRadians(i * degreesPerSide));
//       if (i == 0) {
//         path.moveTo(x, y);
//       } else {
//         path.lineTo(x, y);
//       }
//     }
//     path.close();

//     // final paint = Paint()..color = Colors.blue;
//     // canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }

//   double _degreesToRadians(double degrees) {
//     return degrees * (pi / 180);
//   }
// }

// // class RPSCustomPainter extends CustomPainter {
// //   @override
// //   void paint(Canvas canvas, Size size) {
// //     // Pentagon

// //     Paint paint_stroke_0 = Paint()
// //       ..color = const Color.fromARGB(138, 33, 150, 243)
// //       ..style = PaintingStyle.stroke
// //       ..strokeWidth = 0
// //       ..strokeCap = StrokeCap.round
// //       ..strokeJoin = StrokeJoin.bevel;
// //     paint_stroke_0.shader = ui.Gradient.linear(
// //         Offset(0, size.height * 0.07),
// //         Offset(size.width * 0.08, size.height * 0.07),
// //         [Color(0xff000000), Color(0xff000000)],
// //         [0.00, 1.00]);

// //     Path path_0 = Path();
// //     path_0.moveTo(0, size.height * 0.0500000);
// //     path_0.lineTo(size.width * 0.0416667, 0);
// //     path_0.lineTo(size.width * 0.0833333, size.height * 0.0500000);
// //     path_0.lineTo(size.width * 0.0666667, size.height * 0.1357143);
// //     path_0.lineTo(size.width * 0.0166667, size.height * 0.1357143);
// //     path_0.lineTo(0, size.height * 0.0500000);
// //     path_0.close();

// //     canvas.drawPath(path_0, paint_stroke_0);
// //   }

// //   @override
// //   bool shouldRepaint(covariant CustomPainter oldDelegate) {
// //     return true;
// //   }
// // }

// // class PentagonClipper extends CustomClipper<Path> {
// //   @override
// //   Path getClip(Size size) {
// //     final path = Path();
// //     final angle = 360 / 5;
// //     final radius = size.width / 2;

// //     path.moveTo(size.width / 2, 0);
// //     for (int i = 1; i <= 5; i++) {
// //       double x = radius * (1 + cos(_degreesToRadians(angle * i)));
// //       double y = radius * (1 + sin(_degreesToRadians(angle * i)));
// //       path.lineTo(x, y);
// //     }
// //     path.close();
// //     return path;
// //   }

// //   @override
// //   bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
// //     return false;
// //   }

//   // double _degreesToRadians(double degrees) {
//   //   return degrees * (pi / 180);
//   // }
// // }
// // // class PentagonPainter extends CustomPainter {
// //   @override
// //   void paint(Canvas canvas, Size size) {
// //     final paint = Paint()
// //       ..color = Colors.white
// //       ..style = PaintingStyle.fill;

// //     final path = Path();
// //     final angle = 360 / 5;
// //     final radius = size.width / 2;

// //     path.moveTo(size.width / 2, 0);
// //     for (int i = 1; i <= 5; i++) {
// //       double x = radius * (1 + cos(_degreesToRadians(angle * i)));
// //       double y = radius * (1 + sin(_degreesToRadians(angle * i)));
// //       path.lineTo(x, y);
// //     }
// //     path.close();

// //     canvas.drawPath(path, paint);
// //   }

// //   @override
// //   bool shouldRepaint(covariant CustomPainter oldDelegate) {
// //     return false;
// //   }

// //   double _degreesToRadians(double degrees) {
// //     return degrees * (pi / 180);
// //   }
// // }
