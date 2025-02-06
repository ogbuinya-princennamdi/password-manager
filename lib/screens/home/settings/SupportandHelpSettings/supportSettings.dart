import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:passwordmanager/services/jsonServices.dart';
import 'package:passwordmanager/sharedFiles/loading.dart'; // Ensure this is correctly imported
import '../../../../sharedFiles/transitionEffect.dart';
import '../../OverlayMessage.dart';
import 'ContactUs.dart';

class Supportsettings extends StatefulWidget {
  const Supportsettings({super.key});

  @override
  State<Supportsettings> createState() => _SupportsettingsState();
}

class _SupportsettingsState extends State<Supportsettings> {
  TextEditingController _commentController = TextEditingController();
  bool _isSupport = false;
  bool _isSupportForm = false;
  bool _isContactUs = false;
  String _email = 'Loading...';
  Color _profileSettingsColor = Colors.grey.withOpacity(0.5);
  Color _editProfileColor = Colors.grey.withOpacity(0.5);
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    getUsersEmail();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidthSizes =MediaQuery.of(context).size.width;
    return Column(
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              _isSupport = !_isSupport;
              _profileSettingsColor = _isSupport
                  ? Color.fromARGB(255, 24, 146, 154).withOpacity(0.5)
                  : Colors.grey.withOpacity(0.5);
            });
          },
          icon: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.help_outline,
                  size: 40,
                  color: _isSupport
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
                      'Support and help',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _isSupport ? _profileSettingsColor : null,
                      ),
                    ),
                    Text(
                      'Support form, contact us',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 19,
                        color: _isSupport ? _profileSettingsColor : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_isSupport) ...[
          // Support Form Button
          SizedBox(height: 10),
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
                      _showSubmitForm();
                      _isSupportForm = !_isSupportForm;
                      _editProfileColor = _isSupportForm
                          ? Color.fromARGB(255, 24, 146, 154).withOpacity(0.5)
                          : Colors.grey.withOpacity(0.5);
                    });
                  },
                  icon: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.format_align_justify_rounded,
                          size: 30,
                          color: _editProfileColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Submit form',
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
          // Contact Us Button
          SizedBox(height: 10),
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
                      _isContactUs = !_isContactUs;
                      _editProfileColor = _isContactUs
                          ? Color.fromARGB(255, 24, 146, 154).withOpacity(0.5)
                          : Colors.grey.withOpacity(0.5);
                    });
                  },
                  icon: InkWell(
                    onTap:(){
                      Navigator.push(context, transitionEffect(page:Contactus()));
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.location_on,
                            size: 30,
                            color: _editProfileColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Contact us',
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
          ),
        ],
      ],
    );
  }

  // Show Submit Form Dialog
  void _showSubmitForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Submit form', style: TextStyle(color: Color.fromARGB(255, 24, 146, 154)),),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildProfileField('Email Address', _email),
                _buildTextArea('Your comments'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 24, 146, 154))),
            ),
            SizedBox(width: 10,),
            _loading ?
              const Center(
                child: loading(), // Ensure this function/widget is properly defined
              )
            :
            TextButton(
              onPressed: () {
                setState(() {
                  _loading = true;
                });
                _submitForm();
                Navigator.of(context).pop();
                _commentController.clear();
              },
              child: Text('Submit', style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 24, 146, 154))),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            label,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 24, 146, 154),
            ),
          ),
          Container(
            width: double.infinity,
            height: 70,
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromARGB(255, 24, 146, 154),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
            child:Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    value ?? 'N/A',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.normal,
                      color: Color.fromARGB(255, 24, 146, 154),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextArea(String label) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 24, 146, 154),

            ),
          ),
          SizedBox(height: 8.0),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromARGB(255, 24, 146, 154),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
            ),
            child: TextField(
              controller: _commentController,
              maxLines: 17,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Color.fromARGB(255, 24, 146, 154)),
                border: InputBorder.none,
                hintText: 'Enter your text here...',
                contentPadding: EdgeInsets.all(8.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Retrieve user's email
  void getUsersEmail() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final getEmail = user.email;

      setState(() {
        _email = getEmail ?? 'No user email';
      });

      print('Email available: $getEmail');
    } else {
      setState(() {
        _email = 'No current user available';
      });

      print('No current user available');
    }
  }

  // Comment submission
  void _submitForm() async {
    final email = _email;
    final comments = _commentController.text;
    try {
      setState((){
        _loading=true;

      });
      APIServices.sendSupport(email, comments);
      _showOverlayMessage(context, "support sent successfully");
    }
    catch(e){
      _showOverlayMessage(context, "error sending support message: $e");
      print("error sending support message : $e");
    } finally{
      setState((){
        _loading= false;
      });
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
