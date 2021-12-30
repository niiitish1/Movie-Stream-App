import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:movie_stream_app/const/colors.dart';
import 'package:movie_stream_app/screens/authentication%20screens/google_signin_provider.dart';
import 'package:movie_stream_app/screens/movie_details_screen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class TextInfo {}

class _ProfileScreenState extends State<ProfileScreen> {
  File? imageFile, videoFile;
  bool isUpload = true;

  Map<String, dynamic> post = HashMap();

  @override
  void initState() {
    super.initState();
    post = {
      "Title": '',
      "Description": '',
      "Ratings": '',
      "Generes": '',
      "AgeRestriction": '',
      "Thumbnail": '',
      "VideoLink": '',
    };
  }

  UploadTask? uploadTask;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: darkBlue,
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // CircleAvatar(
            //   backgroundImage: NetworkImage(user!.photoURL!),
            // ),
            // Text(
            //   'Name: ' + user.displayName!,
            //   style: TextStyle(color: Colors.white),
            // ),
            // Text(
            //   'Email: ' + user.email!,
            //   style: TextStyle(color: Colors.white),
            // ),
            const Text(
              'Profile',
              style: TextStyle(color: Colors.white),
            ),
            ElevatedButton(
              onPressed: () {
                // final provider =
                //     Provider.of<GoogleSignInProvider>(context, listen: false);
                // provider.logout();
                final a = FirebaseAuth.instance;
                a.signOut();
              },
              child: const Text('log out'),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Movie',
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => buildSheet(),
          ).whenComplete(() {
            isUpload = true;
          });
        },
      ),
    );
  }

  buildSheet() {
    return DraggableScrollableSheet(
      maxChildSize: 1,
      // initialChildSize: 1,
      expand: false,
      builder: (_, controller) {
        return StatefulBuilder(
          builder: (_, reCreate) {
            return Scaffold(
              body: ListView(
                controller: controller,
                children: [
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'Add Movie',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Column(
                        children: abcd(),
                      ),
                      onetwo(Icons.image, reCreate, imageFile, () async {
                        final result = await FilePicker.platform
                            .pickFiles(allowMultiple: false);
                        reCreate(() {
                          if (result != null) {
                            final path = result.files.single.path;
                            imageFile = File(path!);
                          }
                        });
                      }),
                      onetwo(Icons.video_camera_back, reCreate, videoFile,
                          () async {
                        final result = await FilePicker.platform
                            .pickFiles(allowMultiple: false);
                        reCreate(() {
                          if (result != null) {
                            final path = result.files.single.path;
                            videoFile = File(path!);
                          }
                        });
                      }),
                      Container(
                        margin: const EdgeInsets.all(16),
                        width: double.infinity,
                        child: ElevatedButton.icon(
                            onPressed: () async {
                              bool a = await uploadFile(
                                  imageFile!, 'thumbnail', 'Thumbnail');
                              bool b = await uploadFile(
                                  videoFile!, 'Movies', 'VideoLink');
                              if (a && b) {
                                print('''
                                Movie Name: ${post['Title']}\n
                                Movie description: ${post['Description']}\n
                                Movie ratings: ${post['Ratings']}\n
                                Movie generes: ${post['Generes']}\n
                                Movie ageRestriction: ${post['AgeRestriction']}\n
                                Movie thumbnail: ${post['Thumbnail']}\n
                                Movie videoLink: ${post['VideoLink']}\n
                                ''');
                                // addFinalMovieData(post);
                              }
                            },
                            icon: const Icon(Icons.upload),
                            label: const Text('Upload')),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Row onetwo(
      IconData icon, StateSetter reCreate, File? file, Function() myFunction) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
            onPressed: myFunction,
            icon: file != null ? const Icon(Icons.done) : Icon(icon),
            label: Text(file != null ? 'Done' : 'Upload')),
        Flexible(
          child: RichText(
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
                style: const TextStyle(color: Colors.black),
                text: file != null ? file.path.split("/").last : 'Select File'),
          ),
        ),
      ],
    );
  }

  addFinalMovieData(Map<String, dynamic> addData) {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("Movie");
    collectionReference.add(addData);
  }

  List<Widget> abcd() {
    return List.generate(post.length - 2, (index) {
      return buildTextField(index, post.keys.elementAt(index));
    });
  }

  Future<bool> uploadImageFile() async {
    final fileName = imageFile!.path.split("/").last;
    final firebaseDestination = "Movie/thumbnail/$fileName";
    uploadTask = FirebaseAPI.uploadFiles(firebaseDestination, imageFile!);
    // reCreate(() {});
    if (uploadTask == null) return false;
    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    // print('Download URL: $urlDownload');
    // thumbnail = urlDownload;
    return true;
  }

  Future<bool> uploadVideFile() async {
    final fileName = videoFile!.path.split("/").last;
    final firebaseDestination = "Movie/Movies/$fileName";
    uploadTask = FirebaseAPI.uploadFiles(firebaseDestination, videoFile!);
    // reCreate(() {});
    if (uploadTask == null) return false;
    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    // print('Download URL: $urlDownload');
    // videoLink = urlDownload;
    return true;
  }

  Future uploadFile(
    File file,
    String destination,
    String postData,
  ) async {
    final fileName = file.path.split("/").last;
    final firebaseDestination = 'Movie/$destination/$fileName';
    uploadTask = FirebaseAPI.uploadFiles(firebaseDestination, file);
    if (uploadTask != null) {
      final snapshot = await uploadTask!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      post[postData] = urlDownload;
      return true;
    } else {
      return false;
    }
  }

  Widget buildTextField(int index, String hintText) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: TextField(
        onChanged: (newText) {
          post[hintText] = newText;
        },
        decoration: InputDecoration(
          hintText: hintText,
        ),
      ),
    );
  }

  Widget buildStatus(UploadTask? uploadTask) => StreamBuilder<TaskSnapshot>(
        stream: uploadTask!.snapshotEvents,
        builder: (_, snapShot) {
          if (snapShot.hasData) {
            final snap = snapShot.data;
            final progress = snap!.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);
            return Text(
              '$percentage %',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          }
          return Container();
        },
      );
}

class FirebaseAPI {
  static UploadTask? uploadFiles(String firebaseDestination, File imageFile) {
    try {
      final ref = FirebaseStorage.instance.ref(firebaseDestination);
      return ref.putFile(imageFile);
    } on FirebaseException catch (e) {
      print(e);
      return null;
    }
  }
}
