// import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../services/auth.dart';
import 'OverlayMessage.dart';

class ManageBankPassword extends StatefulWidget {
  const ManageBankPassword({super.key});

  @override
  State<ManageBankPassword> createState() => _ManageBankPasswordState();
}
final Authservices _auth = Authservices();

class _ManageBankPasswordState extends State<ManageBankPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedItem;
  bool _obsecurePassword = true;
  String _error = '';
  String saved = ' data saved successfully';
  bool _isATMselected = false;
  bool _obsecureATM = true;

  //email validator
  String? _BankNameValidator(String? value) {
    if (value!.isEmpty) {
      return 'bank form can not be empty';
    }
    return null;
  }

  //password validator
  String? _passwordValidator(String? value) {
    if (value!.isEmpty) {
      return 'password can not be empty';
    }
    return null;
  }

  //ATM FORM VALIDATION
  String? _AtmValidation(String? value) {
    if (value!.isEmpty) {
      return 'ATM pin field can not be empty';
    }
    return null;
  }

//PASSWORD VISIBILITY
  void _passToggleVisibility() {
    setState(() {
      _obsecurePassword = !_obsecurePassword;
    });
  }

  //ATM TOGGLE
  void _atmToggleVisibility() {
    setState(() {
      _obsecureATM = !_obsecureATM;
    });
  }

  // List of dropdown items with image paths
  final List<Map<String, String>> _dropdownItems = [
    {'label': 'ATM', 'image': 'assest/atm.jpg'},
    {'label': 'Mobile App', 'image': 'assest/mobile-banking.png'},
    {'label': 'Internet Banking', 'image': 'assest/smartphone.png'},

  ];

  // TextEditingControllers for input fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _AtmController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        const SizedBox(height: 50),

        // Email security
        InkWell(
          highlightColor: Colors.blueGrey,
          onTap: () {
            _showDropdownDialog(context);
          },
          child: Container(
            width: 420, // Use double.infinity to make it responsive
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
                  color: Colors.black.withOpacity(0.2), // Add shadow color
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // Shadow position
                ),
              ],
            ),
            child: Row(
              children: [
                Image.asset('assest/bank.png',
                  width: 60,
                  height: 60,),
                  // color: Colors.white,),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    textAlign: TextAlign.start,
                    'Secure your banks logins and transfer details',
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Poppins-Regular',
                        color: Colors.white
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

// Alertbox menu
  void _showDropdownDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
     builder: (BuildContext context, StateSetter setState)   {

          return Stack(
            children: [
              Positioned(
                bottom: 160,
                left: 20,
                right: 20,
                child: Form(
                  key: _formKey,
                  child: AlertDialog(
                    title: const Text(
                      'Enter bank Details',
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
                            // Dropdown Button
                            DropdownButton<String>(
                              hint: const Text('select an option'),
                              isExpanded: true,
                              value: _selectedItem,
                              // hint: const Text('Select an option'),
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
                                  _isATMselected = newValue == 'ATM';
                                  _selectedItem = newValue;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            // Email Input Field
                            _buildFieldText(
                                controller: _bankNameController,
                                obsecureText: false,
                                isVisible: true,
                                validator: _BankNameValidator,
                                label: 'Bank name only',
                                keyboardType: TextInputType.text
                            ),

                            const SizedBox(height: 16),
                            // Password Input Field
                            if(!_isATMselected)...[
                              _buildFieldText(
                                  controller: _passwordController,
                                  obsecureText: _obsecurePassword,
                                  isVisible: true,
                                  validator: _passwordValidator,
                                  label: 'Password',
                                  toggleVisibilty: () {
                                    setState(() {
                                      _obsecurePassword = !_obsecurePassword;
                                    });
                                  })


                            ] else
                              ...[
                                _buildFieldText(
                                    controller: _AtmController,
                                    obsecureText: _obsecureATM,
                                    isVisible: true,
                                    validator: _AtmValidation,
                                    label: 'Pin',
                                    keyboardType: const TextInputType
                                        .numberWithOptions(),
                                    toggleVisibilty: () {
                                      setState(() {
                                        _obsecureATM = !_obsecureATM;
                                      });
                                    }
                                ),

                              ],
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
                          _emailController.clear();
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Color.fromARGB(255, 24, 146,
                              154)),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          setState(() {
                            _error = '';
                          });


                          if (_formKey.currentState!.validate()) {
                            await _saveData();
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text(
                          'Save',
                          style: TextStyle(color: Color.fromARGB(255, 24, 146,
                              154)),
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

//textformfield widget
  Widget _buildFieldText({
    required TextEditingController controller,
    required bool obsecureText,
    required bool isVisible,
    required FormFieldValidator <String> validator,
    VoidCallback? toggleVisibilty,
    required String label,
    TextInputType keyboardType=TextInputType.text,

}){
    if(!isVisible) return SizedBox.shrink();
    return TextFormField(
      validator: validator,
      controller: controller,
      obscureText: obsecureText,
      decoration: InputDecoration(

        suffixIcon: toggleVisibilty != null ? IconButton(
            onPressed: toggleVisibilty,
            icon: Icon(
              obsecureText ? Icons.visibility : Icons.visibility_off,
              color: obsecureText ? Colors.grey :Color.fromARGB(255, 24, 146, 154),
            ),): null,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 24, 146, 154), width: 2),

        ),
        labelText: label,
        labelStyle: TextStyle(fontSize: 20, color: Color.fromARGB(255, 24, 146, 154),),
      ),
    );

}
//savedata function
  Future _saveData() async{
    final selectedItem = _selectedItem;
    final bankName=_bankNameController.text.trim();
    final AtmPin =_AtmController.text.trim();
    final password =_passwordController.text.trim();

    if ((bankName.isNotEmpty && AtmPin.isNotEmpty && selectedItem != null) ||
        (bankName.isNotEmpty && password.isNotEmpty && selectedItem != null)) {

      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Define collection path and document data based on the selection
        final collectionPath = !_isATMselected ? 'InternetBankingPasswords' : 'AtmPin';

        final documentData = !_isATMselected
            ? {
          'Bank name': bankName,
          'Password': password,
          'SelectedItem': selectedItem,
        }
            : {
          'Bank name': bankName,
          'Atm Pin': AtmPin,
          'SelectedItem': selectedItem,
        };

        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection(collectionPath)
              .add(documentData);
          // Show overlay message
          _showOverlayMessage(context, 'Data saved successfully');
        } catch (e) {
          // Handle errors (e.g., show a message to the user, log the error)
          print('Error adding document: $e');
          setState(() {
            _error = 'Error adding document: $e';
          });
        }
      } else {
        // Handle case where user is null
        print('No user is currently signed in.');
        setState(() {
          _error = 'No user is currently signed in.';
        });
      }

      // Clear the controllers and close the dialog
      _passwordController.clear();
      _emailController.clear();
      Navigator.of(context).pop(); // Close the dialog
    }
    else {
      setState(() {
        _error = 'Please fill all fields';
      });
    }

  }
  //overlay messages
  void _showOverlayMessage(BuildContext context, String message) {
    final overlay = Overlay.of(context);

    final overlayEntry = OverlayEntry(
      builder: (context) =>
          Positioned(
            bottom: 50.0,
            left: MediaQuery
                .of(context)
                .size
                .width * 0.1,
            right: MediaQuery
                .of(context)
                .size
                .width * 0.1,

            child: OverlayMessage(message: message),
          ),
    );

    overlay.insert(overlayEntry);

    // Remove the overlay after a delay
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
//function for Atm pin

}