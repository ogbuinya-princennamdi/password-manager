import 'package:flutter/material.dart';
import 'package:passwordmanager/screens/home/settings/profileSettings/profileEditPage.dart';
import '../../../../sharedFiles/transitionEffect.dart';

class profileSetting extends StatefulWidget {
  const profileSetting({super.key});

  @override
  State<profileSetting> createState() => _profileSettingState();
}

class _profileSettingState extends State<profileSetting> {
  bool _isProfile = false;
  bool _isEditProfile = false;
  Color _profileSettingsColor = Colors.grey.withOpacity(0.5);
  Color _editProfileColor = Colors.grey.withOpacity(0.5);

  @override
  Widget build(BuildContext context) {
    // Get screen size
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Column(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  _isProfile = !_isProfile;
                  _profileSettingsColor = _isProfile
                      ? Color.fromARGB(255, 24, 146, 154).withOpacity(0.5) // Active color for Profile Settings
                      : Colors.grey.withOpacity(0.5);
                });
              },
              icon: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.02), // Dynamic padding
                    child: Icon(
                      Icons.person,
                      size: screenWidth * 0.08, // Dynamic icon size
                      color: _isProfile ? _profileSettingsColor : Color.fromARGB(255, 24, 146, 154),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.02), // Dynamic padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profile settings',
                          style: TextStyle(
                            fontSize: screenWidth * 0.06, // Responsive font size
                            fontWeight: FontWeight.bold,
                            color: _isProfile ? _profileSettingsColor : null,
                          ),
                        ),
                        Text(
                          'change email, phone number, username',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: screenWidth * 0.045, // Responsive font size
                            color: _isProfile ? _profileSettingsColor : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_isProfile) ...[
              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.06), // Dynamic left padding
                child: Container(
                  width: screenWidth *0.9,
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
                    padding: EdgeInsets.only(left: screenWidth * 0.1), // Dynamic padding
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          Navigator.push(
                            context, transitionEffect(page: ProfileEditPage()),
                          );

                          _isEditProfile = !_isEditProfile;
                          _editProfileColor = _isEditProfile
                              ? Color.fromARGB(255, 24, 146, 154).withOpacity(0.5) // Active color for Edit Profile
                              : Colors.grey.withOpacity(0.5);
                        });
                      },
                      icon: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(screenWidth * 0.02), // Dynamic padding
                            child: Icon(
                              Icons.edit,
                              size: screenWidth * 0.07, // Dynamic icon size
                              color: _editProfileColor,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(screenWidth * 0.02), // Dynamic padding
                            child: Text(
                              'Edit profile',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.05, // Responsive font size
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
}
