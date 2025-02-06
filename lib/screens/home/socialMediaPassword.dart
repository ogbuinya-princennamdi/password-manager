import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../services/auth.dart';
import 'OverlayMessage.dart';

class ManageSocialMediaPassword extends StatefulWidget {
  const ManageSocialMediaPassword({super.key});

  @override
  State<ManageSocialMediaPassword> createState() => _ManageSocialMediaPasswordState();
}

final Authservices _auth = Authservices();

class _ManageSocialMediaPasswordState extends State<ManageSocialMediaPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedItem;
  bool _obsecurePassword = true;
  String _error = '';
  bool _isFacebookselected = false;

  // Validator methods
  String? _emailUsernamePhoneValidator(String? value)=>value?.isEmpty == true ? 'email field can not be empty':null;
  String? _facebookNameValidator (String? value)=> value?.isEmpty==true ?'name field can not be empty':null;
  String? _passwordValidator (String? value)=> value?.isEmpty==true ?'name field can not be empty':null;
  String? _passToggleVisibility (String? value)=> value?.isEmpty==true ?'name field can not be empty':null;




  // List of dropdown items with image paths
  final List<Map<String, String>> _dropdownItems = [
    {'label': 'Facebook', 'image': 'assest/facebook.png'},
    {'label': 'Tiktok', 'image': 'assest/tik-tok.png'},
    {'label': 'Instagram', 'image': 'assest/instagram.png'},
    {'label': 'Twitter', 'image': 'assest/twitter.png'},

  ];

  // TextEditingControllers for input fields
  final TextEditingController _emailUsernamePhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _facebookController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),
        InkWell(
          highlightColor: Colors.blueGrey,
          onTap: () {
            _showDropdownDialog(context);
          },
          child: Container(
            width: 420,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromARGB(255, 24, 146, 154),
              border: Border.all(
                width: 2,
                color: const Color.fromARGB(255, 24, 146, 154),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Image.asset(
                  'assest/social-media.png',
                  width: 60,
                  height: 60,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Secure your social media logins details',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Poppins-Regular',
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showDropdownDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return  Stack(
              children: [
                Positioned(
                  bottom: 160,
                  left: 20,
                  right: 20,
                  child: Form(
                    key: _formKey,
                    child: AlertDialog(
                      title: const Text(
                        'Enter Details',
                        style: TextStyle(
                          color: Color.fromARGB(255, 24, 146, 154),
                        ),
                      ),
                      content: SizedBox(
                        width: 500,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              DropdownButton<String>(
                                hint: const Text('Select an option'),
                                isExpanded: true,
                                value: _selectedItem,
                                items: _dropdownItems.map((item) {
                                  return DropdownMenuItem<String>(
                                    alignment: AlignmentDirectional.centerStart,
                                    value: item['label'],
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          item['image']!,
                                          height: 40,
                                          width: 40,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(item['label']!),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _isFacebookselected =
                                        newValue == 'Facebook';
                                    _selectedItem = newValue;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              if (!_isFacebookselected) ...[
                                _buildTextField(
                                  controller: _emailUsernamePhoneController,
                                  validator: _emailUsernamePhoneValidator,
                                  obsecureText: false,
                                  label: 'Username/email/phone number',
                                  isVisible: true,

                                ),

                              ] else
                                ...[
                                  _buildTextField(
                                      controller: _facebookController,
                                      validator: _facebookNameValidator,
                                      obsecureText: false,
                                      label: 'Email/phone number',
                                      isVisible: true,
                                      toggleVisibility: () {
                                        setState(() {
                                          _obsecurePassword =
                                          !_obsecurePassword;
                                        });
                                      }),

                                ],
                              _buildTextField(
                                  controller: _passwordController,
                                  validator: _passwordValidator,
                                  obsecureText: _obsecurePassword,
                                  label: 'Password',
                                  isVisible: true,
                                  toggleVisibility: () {
                                    setState(() {
                                      _obsecurePassword = !_obsecurePassword;
                                    });
                                  }),
                              if (_error.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Text(
                                    _error,
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 18),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            _passwordController.clear();
                            _emailUsernamePhoneController.clear();
                            _facebookController.clear();
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                                color: Color.fromARGB(255, 24, 146, 154)),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            setState(() {
                              _error = '';
                            });

                            if (_formKey.currentState != null &&
                                _formKey.currentState!.validate()) {
                              await _saveData();
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text(
                            'Save',
                            style: TextStyle(
                                color: Color.fromARGB(255, 24, 146, 154)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );

          }
        );
      },
    );
  }
  //textform field
  Widget _buildTextField({
    required TextEditingController controller,
    required FormFieldValidator <String >validator,
    required bool obsecureText,
    VoidCallback? toggleVisibility,
    required String label,
    required bool isVisible,


  }){
    if(!isVisible) return SizedBox.shrink();
    return TextFormField(
      obscureText:  obsecureText,
      controller: controller,
      validator: validator,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        suffixIcon: toggleVisibility != null ? IconButton(
          icon: Icon(
            obsecureText ? Icons.visibility : Icons.visibility_off,
            color: _obsecurePassword ? Colors.grey : Color.fromARGB(255, 24, 146, 154),
          ),
          onPressed: toggleVisibility,

        )
            :null,
        labelText: label,
        labelStyle: TextStyle(color: Color.fromARGB(255, 24, 146, 154), fontSize: 20),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 24, 146, 154), width: 2),

        ),
      ),


    );
  }
  //savedata button

  Future _saveData() async{

    final selectedItem = _selectedItem;
    final emailUsernamePhone = _emailUsernamePhoneController.text.trim();
    final emailPhone = _facebookController.text.trim();
    final password = _passwordController.text.trim();

    if ((emailPhone.isNotEmpty && password.isNotEmpty && selectedItem != null) ||
        (emailUsernamePhone.isNotEmpty && password.isNotEmpty && selectedItem != null)) {

      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final collectionPath = !_isFacebookselected ? 'x_insta_tik' : 'Facebook';

        final documentData = !_isFacebookselected
            ? {
          'general': emailUsernamePhone,
          'Password': password,
          'SelectedItem': selectedItem,
        }
            : {
          'email/phone': emailPhone,
          'Password': password,
          'SelectedItem': selectedItem,
        };

        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection(collectionPath)
              .add(documentData);
          _showOverlayMessage(context, 'Data saved successfully');
        } catch (e) {
          print('Error adding document: $e');
          setState(() {
            _error = 'Error adding document: $e';
          });
        }
      } else {
        print('No user is currently signed in.');
        setState(() {
          _error = 'No user is currently signed in.';
        });
      }

      _passwordController.clear();
      _emailUsernamePhoneController.clear();
      _facebookController.clear();
      Navigator.of(context).pop();
    } else {
      setState(() {
        _error = 'Please fill all fields';
      });
    }
  }
//overlay message
  void _showOverlayMessage(BuildContext context, String message) {
    final overlay = Overlay.of(context);

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 50.0,
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
