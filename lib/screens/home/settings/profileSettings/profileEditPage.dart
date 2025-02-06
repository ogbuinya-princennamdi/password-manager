import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:passwordmanager/sharedFiles/loading.dart';
import '../../OverlayMessage.dart';
import '../../home.dart';
import '../../../Notifications/viewNotification.dart';
import '../../viewPassword.dart';
import '../settings.dart';
import '../settingsSerices.dart';
import '../../../../services/auth.dart';
import '../../../../sharedFiles/transitionEffect.dart';
import 'profileImage.dart';  // Ensure this path is correct

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _updateFirstNameController = TextEditingController();
  final TextEditingController _updateLastNameController = TextEditingController();
  final TextEditingController _updatePhoneController = TextEditingController();
  final TextEditingController _updateEmailController = TextEditingController();
  bool _loading = false;
  bool _isNameSelected = false;
  bool _isPhoneNumberSelected = false;
  bool _isEmailSelected = false;
  int _selectedIndex = 1;

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
        foregroundColor: Colors.white,
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30),
          onPressed: () {
            Navigator.push(context, transitionEffect(page: Setting()));
          },
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          FutureBuilder<Map<String, dynamic>>(
            future: _getUserData(),
            builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: loading());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return Center(child: Text('No data available'));
              } else {
                final userData = snapshot.data!;
                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromARGB(255, 24, 146, 154),
                          width: 2,
                        ),
                        color: Color.fromARGB(255, 24, 146, 154),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: ProfileImage(),  // Ensure ProfileImage widget is defined correctly
                          ),
                        ],
                      ),
                    ),
                    _buildProfileField(
                      'First Name',
                      userData['First name'],
                          () {
                        _showEditDialog('First name', userData['Last name'], _updateFirstNameController, (newValue) {
                          _updateFirstName(newValue);
                        });
                      },
                    ),
                    _buildProfileField(
                      'Last Name',
                      userData['Last name'],
                          () {
                        _showEditDialog('Last Name', userData['Last name'], _updateLastNameController, (newValue) {
                          _updateLastName(newValue);
                        });
                      },
                    ),
                    _buildProfileField(
                      'Phone Number',
                      userData['phone number'],
                          () {
                        _showEditDialog('Phone Number', userData['phone number'], _updatePhoneController, (newValue) {
                          _updatePhone(newValue);
                        });
                      },
                    ),
                    _buildProfileField(
                      'Email Address',
                      userData['email'],
                          () {
                        _showEditDialog('Email Address', userData['email'], _updateEmailController, (newValue) {
                          _updateEmail(newValue);
                        });
                      },
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileField(String label, String? value, VoidCallback onEdit) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 18.0),
            child: Text(
              '$label',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Container(
              width: 400,
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
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      value ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.normal,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.edit, size: 30, color: Color.fromARGB(255, 24, 146, 154)),
                    onPressed: onEdit,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(String label, String currentValue, TextEditingController controller, Function(String) onUpdate) {
    controller.text = currentValue;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Change $label',
            style: TextStyle(color: Color.fromARGB(255, 24, 146, 154)),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (_loading)
                    const Center(
                      child: loading(),
                    )
                  else
                    _buildTextField(
                      controller: controller,
                      validator: (value) => value?.isEmpty == true ? 'Enter new $label' : null,
                      obscureText: false,
                      label: 'Enter new $label',

                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.clear();
              },
              child: Text('Cancel', style: TextStyle(fontSize: 20)),
            ),
            TextButton(
              onPressed: () async {
                if (_loading) return; // Prevent action while loading

                if (controller.text.isEmpty) {
                  _showOverlayMessage('Please enter a new $label.');
                  return;
                }

                setState(() => _loading = true); // Show loading indicator

                try {
                  await onUpdate(controller.text);
                  _showOverlayMessage('$label updated successfully');
                } catch (e) {
                  _showOverlayMessage('Error updating $label');
                  print('Error updating $label: $e');
                } finally {
                  setState(() => _loading = false); // Hide loading indicator
                }

                Navigator.of(context).pop();
                controller.clear();
              },
              child: Text('Update', style: TextStyle(fontSize: 20)),
            ),
          ],
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

  Widget _buildBottomBar() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.09,
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
            icon: Icon(Icons.lock, size: 30),
            label: 'Passwords',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notification_add, size: 30),
            label: 'Notification',
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
      if (index == 0) {
        Navigator.push(context, transitionEffect(page: ViewPassword()));
      } else if (index == 1) {
        Navigator.push(context, transitionEffect(page: Home()));
      } else if (index == 2) {
        Navigator.push(context, transitionEffect(page: ViewNotification()));
      }
    });
  }

  Future<Map<String, dynamic>> _getUserData() async {
    final User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      throw Exception('No user logged in');
    }

    final userId = currentUser.uid;
    final userDocumentRef = _firebaseFirestore.collection('users').doc(userId);
    final DocumentSnapshot snapshot = await userDocumentRef.get();

    if (!snapshot.exists) {
      throw Exception('No document available');
    }

    final Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;

    return {
      'First name': userData['First name'] ?? 'Unknown',
      'Last name': userData['Last name'] ?? 'Unknown',
      'phone number': userData['phone number'] ?? 'Unknown',
      'email': currentUser.email ?? 'Unknown',
    };
  }

  Future<void> _updateFirstName(String newName) async {
    final User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      _showOverlayMessage('No user logged in');
      return;
    }

    String userId = currentUser.uid;
    final DocumentReference userDocumentRef = _firebaseFirestore.collection('users').doc(userId);

    try {
      await userDocumentRef.update({'First name': newName});
    } catch (e) {
      _showOverlayMessage('Error updating name');
      print('Error updating name: $e');
    }
  }
  // function for last name
  Future<void> _updateLastName( String newName) async{
    final User? currentUser= _auth.currentUser;
    if(currentUser==null){
      _showOverlayMessage('no user logged in');
      return ;
    }
    String userId= currentUser.uid;
    DocumentReference documentReference=_firebaseFirestore.collection('users')
    .doc(userId);
    try{
      await documentReference.update({'Last name': newName});
    }
        catch(e){
      _showOverlayMessage('error updating Last name');
      print('error updatimg last  name $e');
        }

  }

  Future<void> _updatePhone(String newPhone) async {
    final User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      _showOverlayMessage('No user logged in');
      return;
    }

    String userId = currentUser.uid;
    final DocumentReference userDocumentRef = _firebaseFirestore.collection('users').doc(userId);

    try {
      await userDocumentRef.update({'phone number': newPhone});
    } catch (e) {
      _showOverlayMessage('Error updating phone number');
      print('Error updating phone number: $e');
    }
  }

  Future<void> _updateEmail(String newEmail) async {
    final User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      _showOverlayMessage('No user logged in');
      return;
    }

    String userId = currentUser.uid;
    final DocumentReference userDocumentRef = _firebaseFirestore.collection('users').doc(userId);

    try {
      await currentUser.verifyBeforeUpdateEmail(newEmail);
      await userDocumentRef.update({'email': newEmail});
    } catch (e) {
      _showOverlayMessage('Error updating email');
      print('Error updating email: $e');
    }
  }

  void _showOverlayMessage(String message) {
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
