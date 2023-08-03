import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/components/my_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neumorphic_ui/neumorphic_ui.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? image;
  String? _currentUserName;
  final _formKey = GlobalKey<FormState>();
  final FirebaseStorage storage = FirebaseStorage.instance;
  var currentUser = FirebaseAuth.instance.currentUser;
  late String userName;

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  void fetchUserName() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      if (documentSnapshot.exists) {
        // The document exists, you can access the field value using the field name.
        setState(() {
          userName = documentSnapshot.get('name');
        });
      } else {
        Center(child: Text('Loading ...'));
        // Document does not exist, handle the case if needed.
        // print('Document does not exist!');
      }
    } catch (error) {
      Center(child: Text('Loading ...'));
      // Handle the error if any.
      // print('Error fetching document: $error');
    }
  }

// Get the document reference for the specific document you want to fetch
// DocumentReference userDocument = usersCollection.doc('document_id'); // Replace 'document_id' with the ID of the specific document you want to fetch.

// // Fetch the document using the get() method
// userDocument.get().then((DocumentSnapshot documentSnapshot) {
//   if (documentSnapshot.exists) {
//     // The document exists, you can access the field value using the field name.
//     var userName = documentSnapshot.get('userName');

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: NeumorphicColors.background,
          appBar: AppBar(
            title: Text('Edit Profile'),
            backgroundColor: NeumorphicColors.darkBackground,
          ),
          body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(width: mq.width, height: mq.height * .03),
                      // Spacer(),
                      Stack(
                        children: [
                          image != null
                              ?
                              // ClipOval(
                              //     child: Image.network(
                              //       image!,
                              //       height: 160,
                              //       width: 160,
                              //       fit: BoxFit.cover,
                              //     ),
                              ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(mq.height * .1),
                                  child: Image.network(image!,
                                      width: mq.height * .2,
                                      height: mq.height * .2,
                                      fit: BoxFit.cover))
                              // NetworkImage(image!),
                              //   child: Image.file(
                              //   image!,
                              //   height: 160,
                              //   width: 160,
                              //   fit: BoxFit.cover,
                              // )
                              // )
                              :
                              // FlutterLogo(
                              //     size: 160,
                              //   ), // ClipOval(child: Image.file(image!, height: 160, width: 160, fit: BoxFit.cover,))
                              ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(mq.height * .1),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "assets/images/person_icon.jpg", //image!,
                                    fit: BoxFit.cover,
                                    width: mq.height * .2,
                                    height: mq.height * .2,
                                    errorWidget: (context, url, error) =>
                                        CircleAvatar(child: Icon(Icons.person)),
                                  ),
                                ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: MaterialButton(
                              elevation: 1,
                              onPressed: () {
                                _showBottomSheet();
                              },
                              shape: const CircleBorder(),
                              color: NeumorphicColors.background,
                              child: const Icon(Icons.edit,
                                  color: NeumorphicColors.darkBackground),
                            ),
                          )
                        ],
                      ),

                      // for adding some space
                      SizedBox(height: mq.height * .03),

                      // user email label
                      Text(currentUser!.email!,
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 16)),

                      // for adding some space
                      SizedBox(height: mq.height * .05),

                      // name input field
                      TextFormField(
                        initialValue: userName,
                        // onSaved: (val) => currentUser.displayName = val ?? '',
                        onSaved: (val) => _currentUserName = val,
                        validator: (val) => val != null && val.isNotEmpty
                            ? null
                            : 'Required Field',
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person,
                                color: NeumorphicColors.darkBackground),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            hintText: 'eg. Anisha Shende',
                            label: const Text('Name')),
                      ),
                      // debugPrint(_currentUserName);
                      // for adding some space
                      SizedBox(height: mq.height * .02),

                      // about input field
                      // TextFormField(
                      //   initialValue: widget.user.about,
                      //   onSaved: (val) => APIs.me.about = val ?? '',
                      //   validator: (val) => val != null && val.isNotEmpty
                      //       ? null
                      //       : 'Required Field',
                      //   decoration: InputDecoration(
                      //       prefixIcon: const Icon(Icons.info_outline,
                      //           color: Colors.blue),
                      //       border: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(12)),
                      //       hintText: 'eg. Feeling Happy',
                      //       label: const Text('About')),
                      // ),

                      // for adding some space
                      SizedBox(height: mq.height * .05),
                      // print('Current user name: $_currentUserName'),

                      // update profile button
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: NeumorphicColors.darkBackground,
                            shape: const StadiumBorder(),
                            minimumSize: Size(mq.width * .5, mq.height * .06)),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            updateUserName();
                            print('_currentUserName - $_currentUserName');
                            print(
                                'current user display name - $currentUser!.displayName');
                            // updateUserInfo().then((value) {
                            MyDialog.mySnackBar(
                                context, 'Profile Updated Successfully!');
                            // });
                          }
                        },
                        icon: const Icon(
                          Icons.edit,
                          size: 28,
                          color: NeumorphicColors.background,
                        ),
                        label: const Text('Update',
                            style: TextStyle(
                                fontSize: 16,
                                color: NeumorphicColors.background)),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),

          // SizedBox(
          //   height: 48,
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     pickFile();
          //   },
          //   style: ElevatedButton.styleFrom(
          //       minimumSize: Size.fromHeight(56),
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
          //       Text('Select from Gallery'),
          //     ],
          //   ),
          // ),
          // SizedBox(
          //   height: 24,
          // ),
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
          // ],
          // ),
        ),
      ),
    );
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

  void updateUserName() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_currentUserName != null) {
        // Update the currentUser's displayName using updateProfile method
        // await FirebaseAuth.instance.currentUser!
        //     .updateDisplayName(_currentUserName!);
        // MyDialog.mySnackBar(context, 'Profile Updated Successfully!');
        FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .set({
          'name': _currentUserName,
        }, SetOptions(merge: true));
      }
    }
  }

  Future<File?> compressImage(File file) async {
    // Compress the image using flutter_image_compress
    Uint8List? compressedData = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      quality: 85,
    );
    File compressedFile = File('${file.path}.jpg');
    await compressedFile.writeAsBytes(compressedData!);
    return compressedFile;
  }

  pickFile() async {
    FilePickerResult? results = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'heic'],
    );

    if (results == null || results.files.isEmpty) {
      MyDialog.mySnackBar(context, 'No file selected!');
      return;
    }

    final path = kIsWeb ? null : results.files.single.path;
    final filename = results.files.single.name;

    if (kIsWeb && results.files.first.bytes != null) {
      final fileBytes = results.files.first.bytes;
      final fileURL = await uploadFileWeb(fileBytes!, filename);
      if (fileURL != null) {
        setState(() {
          image = fileURL;
        });
      }
    } else if (!kIsWeb && path != null) {
      final compressedFile = await compressImage(File(path));
      if (compressedFile != null) {
        final fileURL = await uploadFile(compressedFile.path, filename);
        // uploadViaCamera(compressedFile.path, filename);
        if (fileURL != null) {
          setState(() {
            image = fileURL;
          });
        }
      }
    }
  }

  uploadViaCamera(String path, String filename) async {
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
        'imageURL': fileURL,
      });
      return fileURL;
    } on FirebaseException catch (e) {
      print(e);
      return null;
    }
  }

  Future<String?> uploadFile(String path, String filename) async {
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
        'imageURL': fileURL,
      });
      return fileURL;
    } on FirebaseException catch (e) {
      print(e);
      return null;
    }
  }

  Future<String?> uploadFileWeb(Uint8List fileBytes, String filename) async {
    try {
      final Reference ref = storage.ref('AirChat/$filename');

      // Upload the file to Cloud Storage using putData method for web
      final TaskSnapshot snapshot = await ref.putData(fileBytes);

      // Get the download URL of the uploaded file
      final String fileURL = await snapshot.ref.getDownloadURL();

      // Update the imageURL field in Firestore
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .update({
        'imageURL': fileURL,
      });

      print('File uploaded successfully!');

      return fileURL; // Return the file URL
    } catch (e) {
      print('Error uploading file: $e');
      return null; // Return null in case of an error
    }
  }

  updateUserInfo() {}

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          var mq = MediaQuery.of(context).size;
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
            children: [
              //pick profile picture label
              const Text('Pick Profile Picture',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),

              //for adding some space
              SizedBox(height: mq.height * .02),

              //buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //pick from gallery button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        pickFile();
                      },
                      // () async {
                      //   final ImagePicker picker = ImagePicker();

                      //   // Pick an image
                      //   final XFile? image = await picker.pickImage(
                      //       source: ImageSource.gallery, imageQuality: 80);
                      //   if (image != null) {
                      //     log('Image Path: ${image.path}');
                      //     setState(() {
                      //       _image = image.path;
                      //     });

                      //     APIs.updateProfilePicture(File(_image!));
                      //     // for hiding bottom sheet
                      //     Navigator.pop(context);
                      //   }
                      // },
                      child: Image.asset('assets/images/add_image.png')),

                  //take picture from camera button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          uploadViaCamera(image.name, image.name);
                          // setState(() {
                          //   // image = image.path;
                          // });
                          // compressedFile.path, filename

                          // APIs.updateProfilePicture(File(_image!));
                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('assets/images/camera.png')),
                ],
              )
            ],
          );
        });
  }
}
