import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/components/my_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? image;
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            // Spacer(),
            image != null
                ? ClipOval(
                    child: Image.network(
                      image!,
                      height: 160,
                      width: 160,
                      fit: BoxFit.cover,
                    ),
                    // NetworkImage(image!),
                    //   child: Image.file(
                    //   image!,
                    //   height: 160,
                    //   width: 160,
                    //   fit: BoxFit.cover,
                    // )
                  )
                : FlutterLogo(
                    size: 160,
                  ), // ClipOval(child: Image.file(image!, height: 160, width: 160, fit: BoxFit.cover,))
            SizedBox(
              height: 48,
            ),
            ElevatedButton(
              onPressed: () async {
                pickFile();
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(56),
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  textStyle: TextStyle(fontSize: 20)),
              child: Row(
                children: [
                  Icon(
                    Icons.photo,
                    size: 28,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Text('Select from Gallery'),
                ],
              ),
            ),
            SizedBox(
              height: 24,
            ),
            // ElevatedButton(
            //   onPressed: () async {
            //     pickFile();
            //   },
            //   style: ElevatedButton.styleFrom(
            //       minimumSize: Size.fromHeight(56),
            //       primary: Colors.white,
            //       onPrimary: Colors.black,
            //       textStyle: TextStyle(fontSize: 20)),
            //   child: Row(
            //     children: [
            //       Icon(
            //         Icons.photo,
            //         size: 28,
            //       ),
            //       SizedBox(
            //         width: 16,
            //       ),
            //       Text('Select from Camera'),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
//     final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
//     // File _pickedImage;
//     String url;

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

//           return Column(
//             children: [
//               SizedBox(width: mq.width, height: mq.height * .03),
//               //local image
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(mq.height * .1),
//                 child: Image.network(profile),
//                 // width: mq.height * .2,
//                 // height: mq.height * .2,
//                 // fit: BoxFit.cover
//                 // )
//               ),

//               //image from server
//               // ClipRRect(
//               //     borderRadius: BorderRadius.circular(mq.height * .1),
//               //     child: CachedNetworkImage(
//               //       width: mq.height * .2,
//               //       height: mq.height * .2,
//               //       fit: BoxFit.cover,
//               //       imageUrl: widget.user.image,
//               //       errorWidget: (context, url, error) =>
//               //           const CircleAvatar(child: Icon(Icons.person)),
//               //     ),
//               //   ),

//               ElevatedButton(
//                   onPressed: uploadImage, child: Text('Upload image'))
//             ],
//           );
//         }
//         return Text('Not found!');
    //   },
    // );
  }

  pickFile() async {
  FilePickerResult? results;

  if (kIsWeb) {
    results = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'heic'],
    );
  } else {
    results = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'heic'],
    );
  }

  if (results == null || results.files.isEmpty) {
    MyDialog.mySnackBar(context, 'No file selected!');
    return;
  }

  final path = kIsWeb ? null : results.files.single.path;
  final filename = results.files.single.name;

  if (kIsWeb && results.files.first.bytes != null) {
    // If on web platform, use bytes property to handle the file content
    final fileBytes = results.files.first.bytes;
    uploadFileWeb(fileBytes!, filename).then((value) => print('Done'));
  } else if (!kIsWeb && path != null) {
    // For non-web platforms, use the local file path
    uploadFile(path, filename).then((value) => print('Done'));
  }
}

  Future<void> uploadFile(String path, String filename) async {
    File file = File(path);

    try {
      final UploadTask uploadTask =
          storage.ref('AirChat/$filename').putFile(file);
      final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      final String fileURL = await snapshot.ref.getDownloadURL();
      image = fileURL;
      setState(() {});
      // final String fileURL = file.getDownloadURL();
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .update({
        // 'name': me.name,
        // 'about': me.about,
        'imageURL': fileURL,
      });

      // final image = await ImagePicker().pickImage(source: source);
      // if (image == null) {
      //   MyDialog.mySnackBar(context, 'No file selected!');
      //   return null;
      // }
      // // final path = ;
      // // final filename = ;
      // final imageTemporary = File(image!.path);
      // setState(() {
      //   this.image = imageTemporary;
      // });
    } on FirebaseException catch (e) {
      print(e);
    }
  }


  Future<void> uploadFileWeb(Uint8List fileBytes, String filename) async {
  try {
    final Reference ref = storage.ref('AirChat/$filename');

    // Upload the file to Cloud Storage using putData method for web
    final TaskSnapshot snapshot = await ref.putData(fileBytes);

    // Get the download URL of the uploaded file
    final String fileURL = await snapshot.ref.getDownloadURL();

    // Update the imageURL field in Firestore
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(currentUserId).update({
      'imageURL': fileURL,
    });

    // Update the image variable and trigger a rebuild
    image = fileURL;
    setState(() {});

    print('File uploaded successfully!');
  } catch (e) {
    print('Error uploading file: $e');
  }
}

//   void uploadImage() {}
//   // void _pickImageGallery() async {
//   //   final picker = ImagePicker();
//   //   final pickedImage = await picker.getImage(source: ImageSource.gallery);
//   //   final pickedImageFile = File(pickedImage.path);
//   //   setState(() {
//   //     _pickedImage = pickedImageFile;
//   //   });
//   //   Navigator.pop(context);
//   // }
}
