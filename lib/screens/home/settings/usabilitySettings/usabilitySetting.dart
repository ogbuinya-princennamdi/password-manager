import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

// Import your custom loading widget
import '../../../../sharedFiles/loading.dart';
import '../../OverlayMessage.dart';

class UsabilitySetting extends StatefulWidget {
  const UsabilitySetting({super.key});

  @override
  State<UsabilitySetting> createState() => _UsabilitySettingState();
}

class _UsabilitySettingState extends State<UsabilitySetting> {
  bool _isUtility = false;
  bool _isBackUp = false;
  Color _profileSettingsColor = Colors.grey.withOpacity(0.5);
  Color _editProfileColor = Colors.grey.withOpacity(0.5);

  @override
  Widget build(BuildContext context) {
    double screenWidthSizes= MediaQuery.of(context).size.width;
    double screenHeightSizes= MediaQuery.of(context).size.height;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Column(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  _isUtility = !_isUtility;
                  _profileSettingsColor = _isUtility
                      ? Color.fromARGB(255, 24, 146, 154).withOpacity(0.5)  // Active color for Profile Settings
                      : Colors.grey.withOpacity(0.5);
                });
              },
              icon: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.backup,
                      size: 40,
                      color: _isUtility
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
                          'Usability settings',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: _isUtility ? _profileSettingsColor : null,
                          ),
                        ),
                        Text(
                          ' Auto fill, backup and sync',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 19,
                            color: _isUtility ? _profileSettingsColor : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_isUtility) ...[
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
                      onPressed: () {
                        setState(() {
                          _isBackUp = !_isBackUp;
                          _editProfileColor = _isBackUp
                              ? Color.fromARGB(255, 24, 146, 154).withOpacity(0.5)  // Active color for Edit Profile
                              : Colors.grey.withOpacity(0.5);
                        });
                        _showBackingProcess();
                        saveFirestoreDataToCSV();
                      },
                      icon: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.backup_outlined,
                              size: 30,
                              color: _editProfileColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Backup data',
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

  Future<void> _showBackingProcess() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return const SingleChildScrollView(
              child: AlertDialog(
                content: Center(
                  child: Row(
                    children: [
                      loading(),
                      Text('Please wait a moment'),
                    ],
                  ),
                ),
              ),
            );
          },
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
    // try {
    //   print('CSV Data: $csvData');  // Log CSV data for debugging
    //   final String? filePath = await platform.invokeMethod('saveCSV', {'data': csvData});
    //   return filePath;
    // } on PlatformException catch (e) {
    //   print("Failed to save CSV data: '${e.message}'.");
    //   return null;
    // }
    try{
      final directory= await Directory.systemTemp.createTemp();
      final file =File('${directory.path}/data.csv');
      await file.writeAsString(csvData);
      return file.path;
    }
        catch(e){
      print('fail to save CSV data $e');
      return null;
        }
  }


  Future<void> saveFirestoreDataToCSV() async {
    try {
      // Fetch data from Firestore
      final data = await fetchDataFromFirestore();

      // Convert data to CSV
      final csvData = convertToCsv(data);

      // Save CSV data to a file
      final filePath = await saveCsvData(csvData);
      _showOverlayMessage(context, "Backedup data saved at $filePath");

      if (filePath != null) {
        print('CSV file saved at: $filePath');
      } else {
        print('Failed to save CSV file.');
      }
    } catch (e) {
      print('Error saving data to CSV: $e');
    } finally {
      // Close the loading dialog
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  static const platform = MethodChannel('com.litmaclimited.passwordmanager/csv');
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
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

}
