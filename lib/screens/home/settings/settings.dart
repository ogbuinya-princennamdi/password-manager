import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:passwordmanager/screens/home/settings/AdvanceSetting.dart';
import 'package:passwordmanager/screens/home/settings/TutorialAndGuild.dart';
import 'package:passwordmanager/screens/home/settings/PrivacySettings/privacySetting.dart';
import 'package:passwordmanager/screens/home/settings/profileSettings/profileImage.dart';
import 'package:passwordmanager/screens/home/settings/profileSettings/profileSetting.dart';
import 'package:passwordmanager/screens/home/settings/securitySettings/securitySetting.dart';
import 'package:passwordmanager/screens/home/settings/SupportandHelpSettings/supportSettings.dart';
import 'package:passwordmanager/screens/home/settings/usabilitySettings/usabilitySetting.dart';
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

import '../../../sharedFiles/logo.dart';
import '../home.dart';


class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool _isLoading = false;
  final picker = ImagePicker();
  final Authservices _auth = Authservices();
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
  }
  final List<String> activities = [];

  @override
  Widget build(BuildContext context) {
    // Get screen size
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return _isLoading
        ? const loading()
        : DefaultTabController(
      initialIndex: _selectedIndex,
      length: 4,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight * 0.1), // 10% of screen height
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
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04), // Dynamic padding
                    child: Text(
                      'Password Manager',
                      style: TextStyle(
                        fontSize: screenWidth * 0.06, // Responsive font size
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
                padding: EdgeInsets.only(right: screenWidth * 0.05),
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
                        child: Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045, // Responsive font size
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
                height: screenHeight * 0.3, // 30% of screen height
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
                      Navigator.of(context).pushReplacementNamed('sign_in');
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
                  child: Text(
                    'Sign Out',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045, // Dynamic font size
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
        body: _buildBody(screenWidth, screenHeight), // Pass screen size to _buildBody


        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 24, 146, 154),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(screenWidth * 0.05), // Responsive border radius
              topRight: Radius.circular(screenWidth * 0.05),
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
                icon: Icon(Icons.notification_add, size: 30.0),
                label: 'Notifications',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.transparent,
            selectedFontSize: screenWidth * 0.035, // Dynamic font size
            unselectedFontSize: screenWidth * 0.035, // Dynamic font size
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

  Widget _buildBody(double screenWidth, double screenHeight) {
    return SingleChildScrollView(
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            children: [
              SizedBox(height: screenHeight * 0.02), // Dynamic spacing
              const profileSetting(),
              SecuritySetting(),
              UsabilitySetting(),
              Privacysetting(activities: activities),
              Supportsettings(),
              Tutorialandguild(),
              SizedBox(height: screenHeight * 0.1), // Dynamic spacing for Logo
              Logo(),
            ],
          );
        },
      ),
    );
  }
}
