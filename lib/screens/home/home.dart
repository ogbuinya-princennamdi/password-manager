import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:passwordmanager/screens/home/settings/profileSettings/profileImage.dart';
import 'package:passwordmanager/services/auth.dart';
import 'package:passwordmanager/sharedFiles/loading.dart';
import 'package:passwordmanager/sharedFiles/transitionEffect.dart';
import 'package:passwordmanager/screens/home/manageEmailPasswords.dart';
import 'package:passwordmanager/screens/home/manageBankPassword.dart';
import 'package:passwordmanager/screens/home/manageOtherDetails.dart';
import 'package:passwordmanager/screens/home/socialMediaPassword.dart';
import 'package:passwordmanager/screens/Notifications/viewNotification.dart';
import 'package:passwordmanager/screens/home/viewPassword.dart';
import 'package:passwordmanager/screens/home/settings/settings.dart';
import 'package:passwordmanager/screens/home/cryptoWalletToken.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isLoading = false;
  final picker = ImagePicker();
  final Authservices _auth = Authservices();
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const loading()
        : DefaultTabController(
      initialIndex: _selectedIndex,
      length: 4,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(75),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color.fromARGB(255, 24, 146, 154),
            actions: [
              Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(Icons.menu, size: 40, color: Colors.white),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                  );
                },
              ),
              const Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Password Manager',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Poppins-Regular',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: PopupMenuButton(
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
                          context, transitionEffect(page: ManageEmailPassword()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.lock),
                      title: const Text('Manage Bank Password'),
                      onTap: () {
                        Navigator.push(
                          context, transitionEffect(page: ManageBankPassword()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.camera),
                      title: const Text('Manage Social Media'),
                      onTap: () {
                        Navigator.push(
                          context, transitionEffect(page: ManageSocialMediaPassword()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.wallet),
                      title: const Text('Manage Crypto Wallet'),
                      onTap: () {
                        Navigator.push(
                          context, transitionEffect(page: ManageCryptoPassword()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.details),
                      title: const Text('Other Details'),
                      onTap: () {
                        Navigator.push(
                          context, transitionEffect(page: manageOtherDetails()),
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
                    setState(() => _isLoading = true);
                    try {
                      await _auth.signOut();
                      Navigator.of(context).pushReplacementNamed('/sign_in');
                    } catch (e) {
                      print('Error signing out: $e');
                    } finally {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 24, 146, 154)),
                  ),
                  child: const Text(
                    'Sign Out',
                    style: TextStyle(
                      fontSize: 18,
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
        body: const SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 12),
              Center(
                child: Icon(
                  Icons.lock,
                  size: 80,
                  color: Color.fromARGB(255, 24, 146, 154),
                ),
              ),
              Text(
                'Safety Password Management',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins-Regular',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Safety in Privacy',
                style: TextStyle(
                  letterSpacing: 2,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 20),
              ManageEmailPassword(),
              ManageBankPassword(),
              ManageSocialMediaPassword(),
              ManageCryptoPassword(),
              manageOtherDetails(),
              SizedBox(height: 20),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 24, 146, 154),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.lock, size: 30.0),
                label: 'Passwords',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 30.0),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.workspaces_filled, size: 30.0),
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
      Widget page;
      switch (index) {
        case 0:
          page = ViewPassword();
          break;
        case 1:
          page = Home();
          break;
        case 2:
          page = ViewNotification();
          break;
        default:
          page = Home();
      }
      Navigator.push(
        context,
        transitionEffect(page: page),
      );
    });
  }
}
