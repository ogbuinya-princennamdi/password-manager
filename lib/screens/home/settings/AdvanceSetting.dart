import 'package:flutter/material.dart';
class Advancesetting extends StatefulWidget {
  const Advancesetting({super.key});

  @override
  State<Advancesetting> createState() => _AdvancesettingState();
}

class _AdvancesettingState extends State<Advancesetting> {

  bool _isImport=false;
  bool _isExport=false;
  bool _isShare=false;
  bool _isAdvance=false;
  Color _profileSettingsColor = Colors.grey.withOpacity(0.5);
  Color _editProfileColor = Colors.grey.withOpacity(0.5);
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState){
          return Column(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isAdvance = !_isAdvance;
                    _profileSettingsColor = _isAdvance
                        ? Color.fromARGB(255, 24, 146, 154).withOpacity(0.5)  // Active color for Profile Settings
                        : Colors.grey.withOpacity(0.5);
                  });
                },
                icon: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.high_quality,
                        size: 40,
                        color:_isAdvance? _profileSettingsColor :Color.fromARGB(255, 24, 146, 154),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Advance settings',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: _isAdvance ?_profileSettingsColor: null,
                            ),
                          ),
                          Text(
                            'import and export',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 19,
                              color: _isAdvance ?_profileSettingsColor: null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (_isAdvance) ...[

                // PASSWORD
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 24.0),
                  child: Container(
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
                        //call to edit profilepage goes here
                        onPressed: () {
                          setState(() {
                            _isImport = !_isImport;
                            _editProfileColor = _isImport
                                ? Color.fromARGB(255, 24, 146, 154).withOpacity(0.5)  // Active color for Edit Profile
                                : Colors.grey.withOpacity(0.5);
                          });
                        },
                        icon: Row(
                          children: [


                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.import_export,
                                size: 30,
                                color: _editProfileColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Import',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: _editProfileColor,
                                ),
                              ),
                            ),
                            //password

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                //2FA
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 24.0),
                  child: Container(
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
                        //call to edit profilepage goes here
                        onPressed: () {
                          setState(() {
                            _isExport = !_isExport;
                            _editProfileColor = _isExport
                                ? Color.fromARGB(255, 24, 146, 154).withOpacity(0.5)  // Active color for Edit Profile
                                : Colors.grey.withOpacity(0.5);
                          });
                        },
                        icon: Row(
                          children: [

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.import_export,
                                size: 30,
                                color: _editProfileColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Export password',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: _editProfileColor,
                                ),
                              ),
                            ),
                            //password

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          );
        }

    );
  }
}
