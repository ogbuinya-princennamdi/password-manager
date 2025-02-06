import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../sharedFiles/transitionEffect.dart';
import '../../OverlayMessage.dart';
import '../../home.dart';
import '../../../Notifications/viewNotification.dart';
import '../../viewPassword.dart';
import '../settings.dart';

class AddFingerprint extends StatefulWidget {
  const AddFingerprint({Key? key}) : super(key: key);

  @override
  State<AddFingerprint> createState() => _AddFingerprintState();
}

class _AddFingerprintState extends State<AddFingerprint> {
  final LocalAuthentication _localAuth= LocalAuthentication();
  int _selectedIndex = 1;
  bool _isFingerPrintEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _checkBiometrics();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isFingerPrintEnabled = prefs.getBool('fingerprints_enabled') ?? false;
    });
  }

  Future<void> _updateSettings(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isFingerPrintEnabled = value;
      prefs.setBool('fingerprint_enabled', value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(75),
      child: AppBar(
        backgroundColor: Color.fromARGB(255, 24, 146, 154),
        title: Center(
          child: Text(
            'Fingerprints',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, transitionEffect(page: Setting()));
          },
          icon: Icon(Icons.arrow_back, size: 40, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildFingerprintOption(
            title: 'Add fingerprints',
            icon: Icons.add,
            onTap: () {},
          ),
          const SizedBox(height: 10),
          _buildFingerprintOption(
            title: 'Check added fingerprints',
            icon: Icons.check,
            onTap: () {},
          ),
          const SizedBox(height: 10),
          _buildFingerprintOption(
            title: 'Fingerprint unlock',
            widget: Switch(
              value: _isFingerPrintEnabled,
              onChanged: (value) {
                _updateSettings(value);
              },
              activeTrackColor: _isFingerPrintEnabled
                  ? const Color.fromARGB(255, 24, 146, 154)
                  : Colors.grey,
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildFingerprintOption({
    required String title,
    IconData? icon,
    required VoidCallback onTap,
    Widget? widget,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 2,
              color: Color.fromARGB(255, 24, 146, 154),
            ),
          ),
        ),
        padding: const EdgeInsets.all(18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20),
            ),
            if (icon != null)
              Icon(
                icon,
                size: 40,
                color: Color.fromARGB(255, 24, 146, 154),
              )
            else if (widget != null) widget,
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.09, // Set height relative to screen size
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 24, 146, 154),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.lock, size: 35.0),
            label: 'Passwords',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 35.0),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notification_add, size: 35.0),
            label: 'Notifications',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.transparent,
        selectedFontSize: 18,
        unselectedFontSize: 18,
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
          size: 35.0,
        ),
        unselectedIconTheme: const IconThemeData(
          color: Colors.grey,
          size: 35.0,
        ),
        onTap: _onItemTapped,
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


  //finger prints functions
Future<void> _checkBiometrics() async{
    bool canCheckBiometric= await _localAuth.canCheckBiometrics;
    if(canCheckBiometric){
      List<BiometricType> availiableBiometrics= await _localAuth.getAvailableBiometrics();
      setState(() {
        _isFingerPrintEnabled=availiableBiometrics.contains(BiometricType.fingerprint);
      });
    }
}

//authenticate
Future<void> _authenticate() async{
    try{
      bool authenticate= await _localAuth.authenticate(
          localizedReason: 'authenticate to proceed',
      options: AuthenticationOptions(
        biometricOnly: true,
        useErrorDialogs: true
      ),
      );
      if(authenticate){
        _showOverlayMessage(context, 'fingerprint added successfully');
      }
    }
        
        catch(e){
      _showOverlayMessage(context, 'authentication failed $e');
        }
}

  void _showOverlayMessage(BuildContext context, String message) {
    final overlay = Overlay.of(context);

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 200.0,
        left: MediaQuery.of(context).size.width * 0.1,
        right: MediaQuery.of(context).size.width * 0.1,

        child: OverlayMessage(message: message),
      ),
    );

    overlay.insert(overlayEntry);

    // Remove the overlay after a delay
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}
