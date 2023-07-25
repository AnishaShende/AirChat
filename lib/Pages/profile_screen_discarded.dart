// import 'dart:developer';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:chat_app/components/my_dialog.dart';
// import 'package:chat_app/services/auth/auth_gate.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:image_picker/image_picker.dart';

// class ProfileScreen extends StatefulWidget {
//   ProfileScreen({super.key});

//   // final String profile;

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
//   final _formKey = GlobalKey<FormState>();
//   late String profile;

//   @override
//   Widget build(BuildContext context) {
//     // return Container();
//     // final DocumentReference<Map<String, dynamic>> userDocumentReference =
//     //     FirebaseFirestore.instance.collection('users').doc('userID');
//     final CollectionReference<Map<String, dynamic>> usersCollection =
//         FirebaseFirestore.instance.collection('users');

//     return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//       future: usersCollection.doc(currentUserId).get(),
//       // return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//       //   stream: FirebaseFirestore.instance.collection('users').snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Text("Error: ${snapshot.error}");
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator();
//         }

//         if (snapshot.hasData && snapshot.data != null) {
//           // List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
//           //     snapshot.data!.docs;

//           // Access the image URL field from the document
//           Map<String, dynamic> data =
//               snapshot.data!.data() as Map<String, dynamic>;
//           String profile = data['imageURL'];

//           // Use the imageURL as needed (e.g., display it in an Image widget)
//           // return Center(
//           //     child: Container(
//           //         child: CircleAvatar(child: Image.network(profile))));
//           var mq = MediaQuery.of(context).size;

//           return Scaffold(
//             //app bar
//             appBar: AppBar(title: const Text('Profile Screen')),

//             //floating button to log out
//             floatingActionButton: Padding(
//               padding: const EdgeInsets.only(bottom: 10),
//               child: FloatingActionButton.extended(
//                   backgroundColor: Colors.redAccent,
//                   onPressed: () async {
//                     //for showing progress dialog
//                     MyDialog.myProgressBar(context);

//                     // await APIs.updateActiveStatus(false);

//                     //sign out from app
//                     await FirebaseAuth.instance.signOut().then((value) async {
//                       await GoogleSignIn().signOut().then((value) {
//                         //for hiding progress dialog
//                         Navigator.pop(context);

//                         //for moving to home screen
//                         Navigator.pop(context);

//                         // APIs.auth = FirebaseAuth.instance;

//                         //replacing home screen with login screen
//                         Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (_) => const AuthGate()));
//                       });
//                     });
//                   },
//                   icon: const Icon(Icons.logout),
//                   label: const Text('Logout')),
//             ),

//             //body
//             body: Form(
//               key: _formKey,
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       // for adding some space
//                       SizedBox(width: mq.width, height: mq.height * .03),

//                       //user profile picture
//                       Stack(
//                         children: [
//                           //profile picture
//                           profile != null
//                               ?

//                               //local image
//                               ClipRRect(
//                                   borderRadius:
//                                       BorderRadius.circular(mq.height * .1),
//                                   child: Image.file(File(profile),
//                                       width: mq.height * .2,
//                                       height: mq.height * .2,
//                                       fit: BoxFit.cover))
//                               :

//                               //image from server
//                               ClipRRect(
//                                   borderRadius:
//                                       BorderRadius.circular(mq.height * .1),
//                                   child: CachedNetworkImage(
//                                     width: mq.height * .2,
//                                     height: mq.height * .2,
//                                     fit: BoxFit.cover,
//                                     imageUrl: profile,
//                                     errorWidget: (context, url, error) =>
//                                         const CircleAvatar(
//                                             child: Icon(Icons.person)),
//                                   ),
//                                 ),

//                           //edit image button
//                           Positioned(
//                             bottom: 0,
//                             right: 0,
//                             child: MaterialButton(
//                               elevation: 1,
//                               onPressed: () {
//                                 _showBottomSheet();
//                               },
//                               shape: const CircleBorder(),
//                               color: Colors.white,
//                               child: const Icon(Icons.edit, color: Colors.blue),
//                             ),
//                           )
//                         ],
//                       ),

//                       // for adding some space
//                       SizedBox(height: mq.height * .03),

//                       // user email label
//                       Text(data['email'],
//                           style: const TextStyle(
//                               color: Colors.black54, fontSize: 16)),

//                       // for adding some space
//                       SizedBox(height: mq.height * .05),

//                       // name input field
//                       TextFormField(
//                         initialValue: data['name'],
//                         // onSaved: (val) => APIs.me.name = val ?? '',
//                         validator: (val) => val != null && val.isNotEmpty
//                             ? null
//                             : 'Required Field',
//                         decoration: InputDecoration(
//                             prefixIcon:
//                                 const Icon(Icons.person, color: Colors.blue),
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12)),
//                             hintText: 'eg. Anisha Shende',
//                             label: const Text('Name')),
//                       ),

//                       // for adding some space
//                       SizedBox(height: mq.height * .02),

//                       // about input field
//                       // TextFormField(
//                       //   initialValue: widget.user.about,
//                       //   onSaved: (val) => APIs.me.about = val ?? '',
//                       //   validator: (val) => val != null && val.isNotEmpty
//                       //       ? null
//                       //       : 'Required Field',
//                       //   decoration: InputDecoration(
//                       //       prefixIcon: const Icon(Icons.info_outline,
//                       //           color: Colors.blue),
//                       //       border: OutlineInputBorder(
//                       //           borderRadius: BorderRadius.circular(12)),
//                       //       hintText: 'eg. Feeling Happy',
//                       //       label: const Text('About')),
//                       // ),

//                       // for adding some space
//                       SizedBox(height: mq.height * .05),

//                       // update profile button
//                       ElevatedButton.icon(
//                         style: ElevatedButton.styleFrom(
//                             shape: const StadiumBorder(),
//                             minimumSize: Size(mq.width * .5, mq.height * .06)),
//                         onPressed: () {
//                           if (_formKey.currentState!.validate()) {
//                             _formKey.currentState!.save();
//                             updateUserInfo().then((value) {
//                               MyDialog.mySnackBar(
//                                   context, 'Profile Updated Successfully!');
//                             });
//                           }
//                         },
//                         icon: const Icon(Icons.edit, size: 28),
//                         label: const Text('UPDATE',
//                             style: TextStyle(fontSize: 16)),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }

//         return Text("User document not found");
//       },
//     );
//     //  }
//     // }
//   }

//   void _showBottomSheet() {
//     showModalBottomSheet(
//         context: context,
//         shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(20), topRight: Radius.circular(20))),
//         builder: (_) {
//           var mq = MediaQuery.of(context).size;
//           return ListView(
//             shrinkWrap: true,
//             padding:
//                 EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
//             children: [
//               //pick profile picture label
//               const Text('Pick Profile Picture',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),

//               //for adding some space
//               SizedBox(height: mq.height * .02),

//               //buttons
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   //pick from gallery button
//                   ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           shape: const CircleBorder(),
//                           fixedSize: Size(mq.width * .3, mq.height * .15)),
//                       onPressed: () async {
//                         final ImagePicker picker = ImagePicker();

//                         // Pick an image
//                         final XFile? image = await picker.pickImage(
//                             source: ImageSource.gallery, imageQuality: 80);
//                         if (image != null) {
//                           log('Image Path: ${image.path}');
//                           setState(() {
//                             profile = image.path;
//                           });

//                           APIs.updateProfilePicture(File(_image!));
//                           // for hiding bottom sheet
//                           Navigator.pop(context);
//                         }
//                       },
//                       child: Image.asset('images/add_image.png')),

//                   //take picture from camera button
//                   ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           shape: const CircleBorder(),
//                           fixedSize: Size(mq.width * .3, mq.height * .15)),
//                       onPressed: () async {
//                         final ImagePicker picker = ImagePicker();

//                         // Pick an image
//                         final XFile? image = await picker.pickImage(
//                             source: ImageSource.camera, imageQuality: 80);
//                         if (image != null) {
//                           log('Image Path: ${image.path}');
//                           setState(() {
//                             profile = image.path;
//                           });

//                           APIs.updateProfilePicture(File(_image!));
//                           // for hiding bottom sheet
//                           Navigator.pop(context);
//                         }
//                       },
//                       child: Image.asset('images/camera.png')),
//                 ],
//               )
//             ],
//           );
//         });
//   }

  // Future<void> updateUserInfo() async {
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(currentUserId)
  //       .update({
  //     'name': me.name,
  //     'about': me.about,
  //   });
  // }
// }
