import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:passwordmanager/screens/home/settings/settings.dart';
import 'package:passwordmanager/screens/Notifications/viewNotification.dart';
import 'package:passwordmanager/services/auth.dart';
import 'package:passwordmanager/sharedFiles/loading.dart';
import '../../sharedFiles/transitionEffect.dart';
import '../passwordPage/DatabaaseGet.dart';
import '../passwordPage/getBankCollection.dart';
import '../passwordPage/getCryptoCollection.dart';
import '../passwordPage/getSocialMediaCollections.dart';
import 'home.dart';
import 'package:passwordmanager/screens/home/settings/profileSettings/profileImage.dart';

class ViewPassword extends StatefulWidget {
  const ViewPassword({Key? key}) : super(key: key);

  @override
  State<ViewPassword> createState() => _ViewPasswordState();
}

class _ViewPasswordState extends State<ViewPassword> {
  File? _imageFile;
  String? _profileImageUrl;
  bool _loading = false;
  final picker = ImagePicker();
  final Authservices _auth = Authservices();
  Query? _searchQuery;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _searchQuery = FirebaseFirestore.instance.collection('users');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
      if (_imageFile != null) {
        await _uploadImage(_imageFile!);
      }
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

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

  void _search(String keyword) {
    setState(() {
      if (keyword.isNotEmpty) {
        _searchQuery = FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: keyword);
      } else {
        _searchQuery = FirebaseFirestore.instance.collection('users');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 600;
    final textSize = isWideScreen ? 28.0 : 24.0;

    return _loading
        ? const loading()
        : DefaultTabController(
      initialIndex: 1,
      length: 4,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(75),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color.fromARGB(255, 24, 146, 154),
            actions: [
              Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(Icons.menu, size: 40, color: Colors.white),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                  );
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (text) {
                      setState(() => _searchText = text);
                      _search(text);
                    },
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                      labelText: 'Search for saved passwords',
                      prefixIcon: Icon(Icons.search, size: 24, color: Color.fromARGB(255, 24, 146, 154)),
                    ),
                  ),
                ),
              ),
              PopupMenuButton(
                position: PopupMenuPosition.under,
                iconColor: Colors.white,
                iconSize: 40,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context, transitionEffect(page: Setting()),
                        );
                      },
                      child: const Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Poppins-Regular',
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 24, 146, 154),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: Column(
            children: [
              Container(
                height: 250,
                color: Color.fromARGB(255, 24, 146, 154),
                child: const DrawerHeader(
                  margin: EdgeInsets.zero,
                  child: ProfileImage(),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text('Manage Emails'),
                      onTap: () {
                        Navigator.push(
                          context, transitionEffect(page: getEmailCollections()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.lock),
                      title: const Text('Manage Bank Password'),
                      onTap: () {
                        Navigator.push(
                          context, transitionEffect(page: GetBankCollections()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.camera),
                      title: const Text('Manage Social Media'),
                      onTap: () {
                        Navigator.push(
                          context, transitionEffect(page: GetSocialMediaCollections()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.wallet),
                      title: const Text('Manage Crypto Wallet'),
                      onTap: () {
                        Navigator.push(
                          context, transitionEffect(page: GetCryptoCollections()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.details),
                      title: const Text('Other Details'),
                      onTap: () {
                        Navigator.push(
                          context, transitionEffect(page: Home()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() => _loading = true);
                    try {
                      await _auth.signOut();
                      Navigator.of(context).pushReplacementNamed('sign_in');
                    } catch (e) {
                      print('Error signing out: $e');
                    } finally {
                      setState(() {
                        _loading = false;
                      });
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 24, 146, 154)),
                  ),
                  child: const Text(
                    'Sign Out',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins-Regular',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Explore your saved passwords',
                  style: TextStyle(
                    fontSize: textSize,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins-Regular',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Wrap in a `SingleChildScrollView` if the content might overflow
              const SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    getEmailCollections(),
                    GetBankCollections(),
                    GetSocialMediaCollections(),
                    GetCryptoCollections(),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 24, 146, 154),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.lock, size: 30),
                label: 'Passwords',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 30),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.workspaces_filled, size: 30),
                label: 'Notifications',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.transparent,
            selectedFontSize: 14,
            unselectedFontSize: 14,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Navigator.push(
          context, transitionEffect(page: ViewPassword()),
        );
      } else if (index == 1) {
        Navigator.push(
          context, transitionEffect(page: Home()),
        );
      } else if (index == 2) {
        Navigator.push(
          context, transitionEffect(page: const ViewNotification()),
        );
      }
    });
  }
}
