

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:local_auth/local_auth.dart';
import 'package:passwordmanager/sharedFiles/loading.dart';

import '../../../services/auth.dart';
import '../../../services/firestore_services.dart';
import '../../../sharedFiles/loadingLogo.dart';
import '../../../sharedFiles/transitionEffect.dart';
import '../OverlayMessage.dart';
import '../home.dart';
import '../../Notifications/viewNotification.dart';
import '../viewPassword.dart';

class gmailFirestoreCollection extends StatefulWidget {
  const gmailFirestoreCollection({Key? key}) : super(key: key);

  @override
  _gmailFirestoreCollectionState createState() => _gmailFirestoreCollectionState();
}

class _gmailFirestoreCollectionState extends State<gmailFirestoreCollection> {
  final firestoreServices _firestoreServices = firestoreServices();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _otpVerificationController = TextEditingController();
  final TextEditingController _updatePasswordController= TextEditingController();
  final TextEditingController _verifyWithPasswordController = TextEditingController();
  final LocalAuthentication _localAuth = LocalAuthentication();

  String _authorized = "Not Authorized";
  Color _authIconColor = Colors.grey;


  bool _obscureText = true;
  bool _loading = false;
  String _errorMessage = '';
  String? _verificationId;
  bool _isContentVisible = false;
  bool _isVerifyWithPasswordSelected = false;
  bool _isVerifyWithFingerPrintSelected = false;
  bool _isOtpSelected = false;
  int _selectedIndex = 0;
  bool _isUserAuthenticated = false;
int? _expandIndex; //track the index of selected


Map<String, dynamic>? _selectedEmailPassword;
  String? get email => FirebaseAuth.instance.currentUser?.email;
//container colors
  final List<Color> containerColor =[
    Color.fromARGB(255, 24, 146, 154).withOpacity(0.1),
    Colors.grey.withOpacity(0.1),

  ];
  //functin for refresh
  Future<void> _refresh()async{
    await Future.delayed(Duration(seconds: 2));
    setState(() {

    });
  }
  @override
  void initState() {
    super.initState();
    _checkBiometrics();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: AppBar(
          backgroundColor: Color.fromARGB(255, 24, 146, 154),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, 'ViewPassword'),
          ),
          title: const Text('Click your email to see password', style: TextStyle(color: Colors.white, fontSize: 24)),
        ),
      ),
      body:StreamBuilder<List<Map<String, dynamic>>>(
        stream: _firestoreServices.retrieveUserData('Gmail'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: loading());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          List<Map<String, dynamic>> emailPasswords = snapshot.data!;

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              itemCount: emailPasswords.length,
              itemBuilder: (context, index) {
                var emailPassword = emailPasswords[index];
                Color containerColors = containerColor[index % containerColor.length];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (_isUserAuthenticated || _expandIndex == index) {
                          _isContentVisible = !_isContentVisible;
                          _expandIndex = _expandIndex == index ? null : index;
                          _selectedEmailPassword = _isContentVisible ? emailPassword : null;
                        } else {
                          _authenticate();
                          _showVerificationDialog();
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: containerColors,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: IconButton(
                              icon: Icon(
                                _isContentVisible ? Icons.lock_open : Icons.lock,
                                size: 30,
                                color: Colors.teal,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isContentVisible = !_isContentVisible;
                                  _selectedEmailPassword = _isContentVisible ? emailPassword : null;
                                });
                              },
                            ),
                            title: Text(
                              emailPassword['email'] ?? 'No email',
                              style: TextStyle(fontSize: 18),
                            ),
                            subtitle: _isContentVisible && _selectedEmailPassword == emailPassword
                                ? Text(
                              'File: ${emailPassword['password'] ?? 'No password'}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 16),
                            )
                                : null,
                          ),
                          if (_isContentVisible && _isUserAuthenticated && _expandIndex == index) ...[
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.teal),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      emailPassword['password'] ?? 'No password',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => _copyPassword(emailPassword['password']),
                                    icon: Icon(Icons.copy, color: Colors.blue, size: 24),
                                  ),
                                  IconButton(
                                    onPressed: _showEditPassword,
                                    icon: Icon(Icons.edit, size: 24, color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
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
              icon: Icon(Icons.notification_add, size: 30.0),
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

    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          Navigator.push(context, transitionEffect(page: ViewPassword()));
          break;
        case 1:
          Navigator.push(context, transitionEffect(page: Home()));
          break;
        case 2:
          Navigator.push(context, transitionEffect(page: ViewNotification()));
          break;
      }
    });
  }
  // Show edit password dialog
  void _showEditPassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Form(
              child: AlertDialog(
                title: Text(
                  'Change Password',
                  style: TextStyle(
                    color: Color.fromARGB(255, 24, 146, 154),
                    fontSize: MediaQuery.of(context).size.width * 0.05, // Responsive font size
                  ),
                ),
                content: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8, // Responsive width
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Adjusts to fit the content
                      children: [
                        if (_loading)
                          const Center(
                            child: loading(), // Use CircularProgressIndicator for loading
                          )
                        else
                          _buildTextField(
                            controller: _updatePasswordController,
                            validator: _verificationValidator,
                            obscureText: _obscureText,
                            label: 'Enter new password',
                            toggleVisibility: () => setState(() => _obscureText = !_obscureText),
                          ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04), // Responsive font size
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (_loading) return; // Prevent action while loading

                      if (_selectedEmailPassword != null) {
                        if (_updatePasswordController.text.isEmpty) {
                          _showOverlayMessage(context, 'Please enter a new password.');
                          return;
                        }

                        setState(() => _loading = true); // Show loading indicator

                        try {
                          await _editPassword(
                            _selectedEmailPassword!['password'],
                            _updatePasswordController.text,
                          );
                          // Optionally show a success message
                          _showOverlayMessage(context, 'Update successful');
                        } catch (e) {
                          // Show a user-friendly error message
                          _showOverlayMessage(context, 'Error updating password');
                          // Optionally log the error for debugging
                          print('Error updating password: $e');
                        } finally {
                          setState(() => _loading = false); // Hide loading indicator
                        }
                        Navigator.of(context).pop();
                      } else {
                        _showOverlayMessage(context, 'No password selected for update');
                      }
                    },
                    child: Text(
                      'Update',
                      style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04), // Responsive font size
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  void _showVerificationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Form(
              key: _formKey,
              child: AlertDialog(
                title: const Text(
                  'Verify Identity',
                  style: TextStyle(color: Color.fromARGB(255, 24, 146, 154)),
                ),
                content: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9, // Responsive width
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Adjusts to fit the content
                    children: [
                      if (!_isOtpSelected && !_isVerifyWithPasswordSelected) ...[
                        // Display fingerprint icon initially
                        Center(
                          child: IconButton(
                            onPressed:_authenticate,
                            icon: Icon(
                              Icons.fingerprint,
                              size: MediaQuery.of(context).size.width * 0.15, // Responsive icon size
                            ),
                            color: _authIconColor,
                          ),
                        ),

                      ] else ...[
                        // Display the options menu for OTP or Password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // OTP Button
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isOtpSelected = true;
                                  _isVerifyWithPasswordSelected = false;
                                  _isVerifyWithFingerPrintSelected = false;
                                  _otpVerificationController.clear();
                                });
                              },
                              child: Text(
                                'OTP',
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width * 0.04, // Responsive font size
                                  color: _isOtpSelected
                                      ? Color.fromARGB(255, 24, 146, 154)
                                      : Colors.black,
                                ),
                              ),
                            ),
                            // Password Button
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isOtpSelected = false;
                                  _isVerifyWithPasswordSelected = true;
                                  _isVerifyWithFingerPrintSelected = false;
                                });
                              },
                              child: Text(
                                'Password',
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width * 0.04, // Responsive font size
                                  color: _isVerifyWithPasswordSelected
                                      ? Color.fromARGB(255, 24, 146, 154)
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_isOtpSelected) ...[
                          _buildTextField(
                            controller: _otpVerificationController,
                            validator: _verificationValidator,
                            obscureText: _obscureText,
                            label: 'Enter OTP',
                            toggleVisibility: () => setState(() => _obscureText = !_obscureText),
                          ),
                        ] else if (_isVerifyWithPasswordSelected) ...[
                          _buildTextField(
                            controller: _verifyWithPasswordController,
                            validator: _verificationValidator,
                            obscureText: _obscureText,
                            label: 'Enter login password',
                            toggleVisibility: () => setState(() => _obscureText = !_obscureText),
                          ),
                        ],
                        if (_loading) ...[
                          const Center(
                            child: loading(),
                          ),
                        ] else if (_errorMessage.isNotEmpty) ...[
                          Text(
                            _errorMessage,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: MediaQuery.of(context).size.width * 0.04, // Responsive font size
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),

                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isVerifyWithFingerPrintSelected = false;
                        _isVerifyWithPasswordSelected = false;
                        _isOtpSelected = true;
                      });
                      _otpVerificationController.clear();
                    },
                    child: Text(
                      'OTP',
                      style: TextStyle(fontSize: changeFontSize(), color: Color.fromARGB(255, 24, 146, 154)),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isOtpSelected = false;
                        _isVerifyWithPasswordSelected = true;
                        _isVerifyWithFingerPrintSelected = false;
                      });
                    },
                    child: Text(
                      'Password',
                      style: TextStyle(fontSize: changeFontSize()),
                    ),
                  ),
                  if (!_loading) ...[
                    TextButton(
                      onPressed: () {
                        _authenticate();
                        setState(() {
                          _isVerifyWithFingerPrintSelected = true;
                          _isVerifyWithPasswordSelected = false;
                          _isOtpSelected = false;
                        });
                      },
                      child: Icon(Icons.fingerprint, size: changeIconSize()),
                    ),
                  ],
                  if (_isOtpSelected || _isVerifyWithPasswordSelected) ...[
                    TextButton(
                      onPressed: () async {
                        if (_isOtpSelected && _verificationId != null && _otpVerificationController.text.isNotEmpty) {
                          setState(() => _loading = true); // Show loading indicator

                          try {
                            bool success = await _verifyOTP(_verificationId!, _otpVerificationController.text.trim());
                            if (success) {
                              Navigator.of(context).pop();
                              setState(() { _isUserAuthenticated = true; });
                              _showOverlayMessage(context, 'Verified');
                            }
                          } catch (e) {
                            _showOverlayMessage(context, 'Verification failed: $e');
                          } finally {
                            setState(() => _loading = false); // Hide loading indicator
                          }
                        } else if (_isVerifyWithPasswordSelected && _formKey.currentState!.validate()) {
                          setState(() => _loading = true); // Show loading indicator

                          try {
                            final password = _verifyWithPasswordController.text.trim();
                            if (email != null && password.isNotEmpty) {
                              bool isReauthenticated = await _reauthenticateWithPassword(email!, password);
                              if (isReauthenticated) {
                                Navigator.of(context).pop(); // Close dialog
                                setState(() { _isUserAuthenticated = true; });
                                _showOverlayMessage(context, 'Verified');
                              }
                            } else {
                              _showOverlayMessage(context, 'Please enter your password');
                            }
                          } catch (e) {
                            _showOverlayMessage(context, 'Reauthentication failed: $e');
                          } finally {
                            setState(() => _loading = false); // Hide loading indicator
                          }
                        } else {
                          _showOverlayMessage(context, 'Verification ID or SMS Code is missing');
                        }
                      },
                      child: const Text('Verify', style: TextStyle(color: Color.fromARGB(255, 24, 146, 154))),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }


  Widget _buildTextField({
    required TextEditingController controller,
    required FormFieldValidator<String> validator,
    required bool obscureText,
    required String label,
    TextInputType keyboard = TextInputType.text,
    VoidCallback? toggleVisibility,
  }) {
    return TextFormField(
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      decoration: InputDecoration(
        suffixIcon: toggleVisibility != null
            ? IconButton(
          icon: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
            color: obscureText ? Colors.grey : Color.fromARGB(255, 24, 146, 154),
          ),
          onPressed: toggleVisibility,
        )
            : null,
        labelText: label,
        labelStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(width: 2, color: Color.fromARGB(255, 24, 146, 154)),
        ),
      ),
    );
  }
//change fontsize when otp,password and bio is selected
  double  changeFontSize(){
   return _isVerifyWithFingerPrintSelected ||_isVerifyWithPasswordSelected||_isOtpSelected
        ? 15 :22;
  }

  double  changeIconSize(){
    return _isVerifyWithFingerPrintSelected ||_isVerifyWithPasswordSelected||_isOtpSelected
        ? 50 :50;
  }
  // Function to copy password
  void _copyPassword(String? password) {
    if (password != null) {
      Clipboard.setData(ClipboardData(text: password));
      _showOverlayMessage(context, 'Password copied');
    } else {
      _showOverlayMessage(context, 'No password to copy');
    }
  }

  // Function to verify OTP
  Future<bool> _verifyOTP(String verificationId, String otp) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otp);
      await FirebaseAuth.instance.signInWithCredential(credential);
      return true;
    } catch (e) {
      _showOverlayMessage(context, 'Failed to verify OTP');
      return false;
    }
  }

  // Check if biometrics are available
  Future<bool> _checkBiometrics() async {
    try {
      final bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final List<BiometricType> biometricTypes = await _localAuth.getAvailableBiometrics();
      setState(() {
        _authorized = canCheckBiometrics && biometricTypes.isNotEmpty
            ? "Biometrics available: ${biometricTypes.join(', ')}"
            : "No biometrics available";
      });
      return canCheckBiometrics && biometricTypes.isNotEmpty;
    } catch (e) {
      setState(() {
        _authorized = "Error checking biometrics: ${e.toString()}";
      });
      return false;
    }
  }

  // Function to authenticate with fingerprint
  Future<void> _authenticate() async {
    final bool isAvailable = await _checkBiometrics();
    if (!isAvailable) {
      setState(() {
        _authIconColor = Colors.red;
        _showOverlayMessage(context, 'no biometric enabled');
      });
      return;
    }
    try {
      final bool authenticated = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to proceed',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      setState(() {
        _authorized = authenticated ? "Authorized" : "Not Authorized";
        if (authenticated) {
          _authIconColor = Colors.green;
          _isUserAuthenticated = true;
        } else {
          _showOverlayMessage(context, 'Authentication failed');
          _authIconColor = Colors.red;
        }
      });
    } catch (e) {
      setState(() {
        _authorized = "Error during authentication: ${e.toString()}";
        _authIconColor = Colors.red;
      });
    }
  }

  // Function for user password reauthentication
  Future<bool> _reauthenticateWithPassword(String email, String password) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
      await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(credential);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw Exception('The password is incorrect.');
      }  else {
        throw Exception('wrong password');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
//show edit password service
  Future<void> _editPassword(String selectedItem, String newPassword) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    // Check if the user is logged in
    if (currentUser == null) {
      _showOverlayMessage(context, 'No user logged in');
      return;
    }
    String userId = currentUser.uid;

    try {
      // Create reference to the Firestore collection
      CollectionReference emailPasswordRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('emailPasswords');


      // Retrieve document that matches the filtered value
      final querySnapshot = await emailPasswordRef
          .where('password', isEqualTo: selectedItem)
          .get();

      if (querySnapshot.docs.isEmpty) {
        _showOverlayMessage(context, 'No matching document found');
        return;
      }

      // Get ID of the first matching document
      DocumentSnapshot doc = querySnapshot.docs.first;
      String docId =doc.id;

      // Update password field
      await emailPasswordRef
          .doc(docId)
          .update({'password': newPassword});

      _showOverlayMessage(context, 'Password updated successfully');
    } catch (e) {
      // Log the error for debugging
      print('Error updating password: $e');
      _showOverlayMessage(context, 'Error updating password');
    }
  }





  // Function to show overlay message
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

  String? _verificationValidator(String? value) => value?.isEmpty == true ? 'Enter a verification code' : null;
}
