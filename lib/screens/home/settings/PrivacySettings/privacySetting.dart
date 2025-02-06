import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:passwordmanager/screens/home/settings/PrivacySettings/privacyPolicy.dart';
import 'package:passwordmanager/sharedFiles/loading.dart';
import 'package:passwordmanager/sharedFiles/transitionEffect.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:passwordmanager/sharedFiles/NavigatorObserer.dart';

import '../../OverlayMessage.dart';

class Privacysetting extends StatefulWidget {
  final List<String> activities;

   Privacysetting({super.key, required this.activities});

  @override
  State<Privacysetting> createState() => _PrivacysettingState();
}

class _PrivacysettingState extends State<Privacysetting> {
  bool _isPrivacyPolicy = false;
  bool _isDataSharing = false;
  bool _isActivityLog = false;
  bool _isPrivacy = false;
  Color _profileSettingsColor = Colors.grey.withOpacity(0.5);
  Color _editProfileColor = Colors.grey.withOpacity(0.5);
  bool _isLoggingEnabled = false;


  Future<void> setLoggingEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('logging_enabled', enabled);
  }

  Future<bool> isLoggingEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('logging_enabled') ?? false;
  }

  @override
  void initState() {
    super.initState();
    _loadLoggingPreference();
    _fetchActivities();
  }
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
  Future<void> _loadLoggingPreference() async {
    _isLoggingEnabled = await isLoggingEnabled();
    setState(() {});
  }

  Future<void> _toggleLogging(bool value) async {
    setState(() {
      _isLoggingEnabled = value;
    });
    await setLoggingEnabled(value);
  }
  List<dynamic> _activities = [];
  StreamSubscription<QuerySnapshot>? _subscription;


  @override
  Widget build(BuildContext context) {
    double screenWidthSizes =MediaQuery.of(context).size.width;
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Column(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  _isPrivacyPolicy = !_isPrivacyPolicy;
                  _profileSettingsColor = _isPrivacyPolicy
                      ? Color.fromARGB(255, 24, 146, 154).withOpacity(0.5)
                      : Colors.grey.withOpacity(0.5);
                });
              },
              icon: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.privacy_tip_outlined,
                      size: 40,
                      color: _isPrivacyPolicy
                          ? _profileSettingsColor
                          : Color.fromARGB(255, 24, 146, 154),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Privacy settings',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: _isPrivacyPolicy ? _profileSettingsColor : null,
                          ),
                        ),
                        Text(
                          ' Privacy policy, data sharing, activity log',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 19,
                            color: _isPrivacyPolicy ? _profileSettingsColor : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_isPrivacyPolicy) ...[
              Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: Container(
                  width: screenWidthSizes * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: IconButton(
                      onPressed: () async {
                        await _shareData();
                        setState(() {
                          _isDataSharing = !_isDataSharing;
                          _editProfileColor = _isDataSharing
                              ? Color.fromARGB(255, 24, 146, 154).withOpacity(0.5)
                              : Colors.grey.withOpacity(0.5);
                        });
                      },
                      icon: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.share,
                              size: 30,
                              color: _editProfileColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Data sharing',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: _editProfileColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: Container(
                  width: screenWidthSizes *0.9,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: IconButton(
                      onPressed: () {
                        setState(() {

                          _isActivityLog = !_isActivityLog;
                          _editProfileColor = _isActivityLog
                              ? Color.fromARGB(255, 24, 146, 154).withOpacity(0.5)
                              : Colors.grey.withOpacity(0.5);
                        });
                      },
                      icon: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.local_activity,
                              size: 30,
                              color: _editProfileColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Activity log',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: _editProfileColor,
                              ),
                            ),
                          ),
                          Spacer(),
                          Switch(
                            value: _isLoggingEnabled,
                            onChanged:_toggleLogging,
                            activeTrackColor: _isLoggingEnabled
                                ? const Color.fromARGB(255, 24, 146, 154)
                                : Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              if(_isLoggingEnabled)...[
                 Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: Container(
                        width: screenWidthSizes *0.9,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4.0,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: IconButton(
                            onPressed: () =>activityView(context),
                            icon: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.policy,
                                    size: 30,
                                    color: _editProfileColor,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'View your activities',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: _editProfileColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

              ],
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: Container(
                  width: screenWidthSizes *0.9,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          Navigator.push(context, transitionEffect(page: PrivacyPolicy()));
                          _isPrivacy = !_isPrivacy;
                          _editProfileColor = _isPrivacy
                              ? Color.fromARGB(255, 24, 146, 154).withOpacity(0.5)
                              : Colors.grey.withOpacity(0.5);
                        });
                      },
                      icon: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.policy,
                              size: 30,
                              color: _editProfileColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Privacy Policy',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: _editProfileColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchDataFromFirestore() async {
    final firestore = FirebaseFirestore.instance;
    final snapshot = await firestore.collection('users').get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  String convertToCsv(List<Map<String, dynamic>> data) {
    List<List<dynamic>> rows = [];
    if (data.isNotEmpty) {
      // Header
      rows.add(data[0].keys.toList());

      // Data
      for (var map in data) {
        rows.add(map.values.toList());
      }
    }
    return const ListToCsvConverter().convert(rows);
  }

  Future<String?> saveCsvData(String csvData) async {
    try {
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/data.csv');
      await file.writeAsString(csvData);
      return file.path;
    } catch (e) {
      print('Failed to save CSV data: $e');
      return null;
    }
  }

  Future<String?> saveFirestoreDataToCSV() async {
    try {
      // Fetch data from Firestore
      final data = await fetchDataFromFirestore();

      // Convert data to CSV
      final csvData = convertToCsv(data);

      // Save CSV data to a file
      final filePath = await saveCsvData(csvData);

      if (filePath != null) {
        print('CSV file saved at: $filePath');
        return filePath;
      } else {
        print('Failed to save CSV file.');
        return null;
      }
    } catch (e) {
      print('Error saving data to CSV: $e');
      return null;
    }
  }

  Future<void> _shareData() async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
             loading(),
              SizedBox(width: 20),
              Text('plase wait...'),
            ],
          ),
        );
      },
    );

    try {
      final filePath = await saveFirestoreDataToCSV();
      if (filePath != null) {
        final xFile = XFile(filePath);
        Share.shareXFiles([xFile], text: 'Here is the CSV file with your data.');
      } else {

        _showOverlayMessage(context,'Failed to generate CSV file');

      }
    } catch (e) {
      print('Error sharing data: $e');

       _showOverlayMessage(context, 'Failed to share data.');

    } finally {
      // Hide the loading dialog
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  //activities
  void activityView(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Activity Log'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: _activities.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_activities[index]),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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

Future<void> _fetchActivities()async{

   try{
     final user= FirebaseAuth.instance.currentUser;
     if(user != null){
       final activitiesQuery= FirebaseFirestore.instance
           .collection('users')
           .doc(user.uid)
           .collection('activityLog')
           .orderBy('time', descending: true)
           .snapshots();
        _subscription=   activitiesQuery.listen((snapshot){
         setState(() {
           _activities= snapshot.docs.map((doc){
             final data =doc.data() as Map<String, dynamic>;
             return data['activity']?? 'No activity description';
           }).toList();
         });
       });
     }else{
       print('User not logged in');
     }
   }

       catch(e){
         print('Error fetching activities: $e');
       }
    }


}
