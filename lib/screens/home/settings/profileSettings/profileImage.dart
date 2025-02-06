import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class ProfileImage extends StatefulWidget {
  const ProfileImage({super.key});

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  FirebaseAuth _auth =FirebaseAuth.instance;
  File? _imageFile;
  String? _profileImageUrl;
  bool _isLoading = false;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        setState(() {
          _profileImageUrl = doc.data()?['profileImageUrl'];
        });
      }
    }
  }

  Future<void> _imagePicker() async {
    final pickImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickImage != null) {
      setState(() {
        _imageFile = File(pickImage.path);
      });
      await _uploadImage(_imageFile!);
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return; // User must be signed in

      final storageRef = FirebaseStorage.instance.ref();
      final fileRef = storageRef.child('profile_images/${user.uid}/${DateTime.now().microsecondsSinceEpoch}.jpg');

      await fileRef.putFile(imageFile);

      final imageUrl = await fileRef.getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'profileImageUrl': imageUrl,
      });

      setState(() {
        _profileImageUrl = imageUrl;
      });

      print('Image uploaded successfully: $imageUrl');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [

            GestureDetector(
              onTap: _imagePicker,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: _profileImageUrl != null
                    ? NetworkImage(_profileImageUrl!)
                    : const AssetImage('assest/defaultImageProfile.jpg') as ImageProvider,
              ),
            ),

            //button
            //edit profile
            SizedBox(width: 20,),

            Container(
              alignment: Alignment.topRight,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromARGB(255, 24, 146, 154),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
              ),
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed: _imagePicker,
              ),
            ),
          ],
        ),

        FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading...');
            }
            if (snapshot.hasData && snapshot.data?.exists == true) {
              final data =snapshot.data?.data() as Map<String, dynamic>?;
              final userName =data?['First name'] ?? 'name';
              return Text('Hi !, $userName',
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: 'Poppins-Regular',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            }
            return const Text(
              'User Name',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Poppins-Regular',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          },
        ),

      ],
    );
  }
}
