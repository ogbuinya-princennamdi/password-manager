
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'OverlayMessage.dart';
class manageOtherDetails extends StatefulWidget {
  const manageOtherDetails({super.key});

  @override
  State<manageOtherDetails> createState() => _manageOtherDetailsState();
}

class _manageOtherDetailsState extends State<manageOtherDetails> {
  final GlobalKey<FormState> _formKey= GlobalKey<FormState>();
  TextEditingController _emailController =TextEditingController();
  TextEditingController _nameController= TextEditingController();
  TextEditingController _passwordController=TextEditingController();
  TextEditingController _pinController=TextEditingController();

  // validator
  String? _nameValidator(String? value)=> value?.isEmpty==true ?' name can not be empty'  : null;
  String? _passwordValidator (String? value)=> value?.isEmpty==true ? 'password field can not be empty': null;
  String? _pinValidator (String? value)=> value?.isEmpty==true ? 'pin can not be empty' : null;
  String? _emailValidator(String? value) {
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return value == null || !emailRegex.hasMatch(value) ? 'Enter a valid email' : null;
  }
// check box
  bool _isCheckboxSelected= false;
  // obsecure
  bool _obsecurePassword =true;
  String _error='';

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        const SizedBox(height: 50),
        InkWell(
          highlightColor: Colors.blueGrey,
          onTap: () => _showDropdownDialog(context),
          child: Container(
            width: 420,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromARGB(255, 24, 146, 154),
              border: Border.all(width: 2, color: const Color.fromARGB(255, 24, 146, 154)),
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
                Image.asset('assest/menu.png', width: 60, height: 60),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Secure your website and other accounts details',
                    style: TextStyle(fontSize: 20, fontFamily: 'Poppins-Regular', color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  // ALERTDIALOG OPTION


  void _showDropdownDialog(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState){
                return  Stack(
                  children: [
                    Positioned(
                      bottom: 160,
                      left: 20,
                      right: 20,

                      child: Form(
                        key: _formKey,
                        child: AlertDialog(
                          title: Text('Secure  other crediential info ',
                           style: TextStyle(   color: Color.fromARGB(255, 24, 146,154)
                           )
                           ),
                        content:  SizedBox(
                          width: 500,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                //TextformField for name,email and password
                                //Name///////////////////////////////////////////////////////////////
                                _buildTextField(
                                  controller:_nameController,
                                    validator: _nameValidator,
                                    isVisible: true,
                                    label: 'Name',
                                    obsecureText: false,

                                ),
                                const SizedBox(height: 16),


                                //email//////////////////////////////////////////////////////////////
                                _buildTextField(
                                    controller: _emailController,
                                    label: 'Email',
                                    validator: _emailValidator,
                                    obsecureText: false,
                                    isVisible: true,

                                ),
                                _isCheckboxSelected
                                ?
                                //pin /////////////////////////////////////////////////////////////////////////
                                _buildTextField(
                                  controller: _pinController,
                                  label: 'Pin',
                                  validator: _pinValidator,
                                  obsecureText: _obsecurePassword,
                                  isVisible: true,
                                    keyboardType: TextInputType.number,
                                    toggleVisibilty: (){
                                      setState((){
                                        _obsecurePassword = !_obsecurePassword;

                                      });
                                    }

                                )

                                    :
                                //password////////////////////////////////////////////////////////////
                                _buildTextField(
                                  controller: _passwordController,
                                  label: 'password',
                                  validator: _passwordValidator,
                                  obsecureText: _obsecurePassword,
                                  isVisible: true,
                                    toggleVisibilty: (){
                                      setState((){
                                        _obsecurePassword = !_obsecurePassword;

                                      });
                                    }
                                ),


                                Row(
                                  children: [
                                    Checkbox(
                                      // fillColor: WidgetStateProperty.all(Color.fromARGB(255, 24, 146,154)),
                                        value: _isCheckboxSelected,
                                        onChanged: ( bool? value){
                                          setState((){
                                            _isCheckboxSelected = value ?? false;
                                          });

                                        }

                                    ),
                                    Text(' click to save account Pin ',
                                    style: TextStyle(fontSize: 16,),),
                                  ],
                                ),

                              ],

                            ),
                          ),
                        ),







                          //action button for save and cancel widget

                          actions: [
                            TextButton(
                                onPressed:(){
                                  Navigator.of(context).pop();
                                },
                                child:
                            const Text('Cancel',
                          style: TextStyle(color: Color.fromARGB(255, 24, 146,154),
                                        ),

                            ),),
                            SizedBox(width: 12,),

                            //save
                            TextButton(
                              onPressed: () async{
                                if(_formKey.currentState!.validate()){
                               await   _savedData();
                               Navigator.of(context).pop();



                                }

                              },
                              child: const Text('Save',
                                style: TextStyle(color: Color.fromARGB(255, 24, 146,154),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }

          );
        }
    );
  }

Widget _buildTextField({
    required TextEditingController controller,
  required String label,
  required FormFieldValidator <String> validator,
  required bool obsecureText,
  required bool isVisible,
  TextInputType keyboardType=TextInputType.text,
   VoidCallback? toggleVisibilty
}){
    if(!isVisible)return const SizedBox.shrink();
  return  TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obsecureText,
    keyboardType: keyboardType,
    style: TextStyle(fontSize: 20),
    decoration: InputDecoration(
      suffixIcon:toggleVisibilty !=null ? IconButton(
        icon: Icon(
        obsecureText ? Icons.visibility : Icons.visibility_off,
        color:  obsecureText ? Colors.grey : const Color.fromARGB(255, 24, 146, 154),),
        onPressed: toggleVisibilty,
      ):null,
      labelStyle: const TextStyle(color: Color.fromARGB(255, 24, 146, 154), fontSize: 20),
      labelText: label,
        focusedBorder: const UnderlineInputBorder(
    borderSide: BorderSide(width: 2, color: Color.fromARGB(255, 24, 146, 154)),
  ),
    ),
    );

}
//save function

Future _savedData()async{
    final Pin =_pinController.text.trim();
    final Password=_passwordController.text.trim();
    final email=_emailController.text.trim();
    final name=_nameController.text.trim();
    //firebase instance to get the current user
    User? user=FirebaseAuth.instance.currentUser;
    //display error messgae if no user
  if(user== null){
    _error= 'no user is currently signed in';
  }
  //define collectionPath for storing collected datas

  final collectionPath =!_isCheckboxSelected ? 'password' : 'pin';
  final documentData= !_isCheckboxSelected
    ?  {
  'Name': name,
  'Email': email,
  'Password': Password,
      }

      :{
    'Name': name,
    'Email': email,
    'Pin': Pin,
  };
      try{
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .collection(collectionPath)
            .add(documentData);
        // Show overlay message
        _showOverlayMessage(context, 'Data saved successfully');
      }
          catch(e){
        print('adding document error $e');
        setState(() {
          _error="adding document error";
        });
          }
          //clear afer successful
  _nameController.clear();
  _emailController.clear();
  _passwordController.clear();
  _pinController.clear();
}

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
    Future.delayed(const Duration(seconds: 3), () => overlayEntry.remove());
  }
}
