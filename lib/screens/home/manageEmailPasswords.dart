import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../services/auth.dart';
import 'OverlayMessage.dart';

class ManageEmailPassword extends StatefulWidget {
  const ManageEmailPassword({super.key});

  @override
  State<ManageEmailPassword> createState() => _ManageEmailPasswordState();
}
final Authservices _auth = Authservices();

class _ManageEmailPasswordState extends State<ManageEmailPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedItem;
  bool _obsecurePassword = true;
  String _error='';
  String saved=' data saved successfully';

  //email validator
  String? _emailValidator( String? value){
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regex = RegExp(pattern);
    if(!regex.hasMatch(value!)){
      return 'enter  a valide email';
    }

    return null;
  }
  //password validator
  String? _passwordValidator( String? value){
    if (value!.isEmpty){
      return 'password can not be empty';
    }
    return null;
  }

  void _passToggleVisibility() {
    setState(() {
      _obsecurePassword = !_obsecurePassword;
    });
  }

  // List of dropdown items with image paths
  final List<Map<String, String>> _dropdownItems = [
    {'label': 'Gmail', 'image': 'assest/gmail.png'},
    {'label': 'Outlook mail', 'image': 'assest/outlook.png'},
    {'label': 'Yahoo mail', 'image': 'assest/yahoo.png'},
    {'label': 'ProtonMail', 'image': 'assest/protomail.png'},
    {'label': 'Zoho mail', 'image': 'assest/zoho.png'},
    {'label': 'Aol  mail', 'image': 'assest/aol.png'},
  ];

  // TextEditingControllers for input fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        const SizedBox(height: 50),

        // Email security
        InkWell(
          highlightColor: Colors.cyanAccent,
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
            child:  Row(
              children: [
                Image.asset('assest/exchange.png',
                  width: 60,
                  height: 60,),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    textAlign: TextAlign.start,
                    'Save your different email password accounts',
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
          builder: (BuildContext context, StateSetter setState) {
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
                        'Enter Email Details',
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
                                  setState(() => _selectedItem = newValue);

                                },
                              ),
                              const SizedBox(height: 16),
                              // Email Input Field
                              _buildFieldText(
                                  controller: _emailController,
                                  validator: _emailValidator,
                                  obsecureText: false,
                                  isVisible: true,
                                  label: 'Email address',
                                keyboardType: TextInputType.emailAddress,

                              ),

                              const SizedBox(height: 16),
                              // Password Input Field
                              _buildFieldText(
                                  controller: _passwordController,
                                  validator: _passwordValidator,
                                  obsecureText: _obsecurePassword,
                                  isVisible: true,
                                  label: 'Password',
                              toggleVisibility: (){
                                    setState((){
                                      _obsecurePassword = ! _obsecurePassword;
                                    });
                              }
                              ),

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
                            style: TextStyle(
                                color: Color.fromARGB(255, 24, 146, 154)),
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


//Textfield form widget
  Widget _buildFieldText({
    required TextEditingController controller,
    required FormFieldValidator <String> validator,
    required bool obsecureText,
    required bool isVisible,
    required String label,
    TextInputType keyboardType=TextInputType.text,
    VoidCallback? toggleVisibility,

}){
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obsecureText,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        suffixIcon: toggleVisibility !=null ? IconButton(
            onPressed: toggleVisibility,
            icon: Icon(
              obsecureText ?Icons.visibility : Icons.visibility_off,
              color:  obsecureText ? Colors.grey : const Color.fromARGB(255, 24, 146, 154),
            ),

        ): null,
            labelStyle: const TextStyle(fontSize: 20, color: Color.fromARGB(255, 24, 146, 154)),

        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(width: 2, color: Color.fromARGB(255, 24, 146, 154),),
        ),
labelText: label,
      ),

    );
}
//saveData function
  Future _saveData()async{
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final selectedItem = _selectedItem;
    if (password.isNotEmpty && email.isNotEmpty && selectedItem != null) {
      try {
        // Get current user
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          // Create a new document in the 'emailPasswords' sub-collection
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('emailPasswords')
              .add({
            'email': email,
            'password': password,
            'selectedItem': selectedItem,
          });

          // Show overlay message
          _showOverlayMessage(context, 'Data saved successfully');
        } else {
          setState(() {
            _error = 'No user is signed in';
          });
        }
      } catch (e) {
        setState(() {
          _error = 'Error: $e';
        });
      } finally {
        // Clear the controllers
        _passwordController.clear();
        _emailController.clear();
        Navigator.of(context).pop(); // Close the dialog
      }
    } else {
      setState(() {
        _error = 'Please fill all fields';
      });
    }

  }
  //overlay messages
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

    // Remove the overlay after a delay
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

}
