import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:passwordmanager/screens/home/settings/securitySettings/securitySetting.dart';
import 'package:passwordmanager/sharedFiles/transitionEffect.dart';

import '../../../../sharedFiles/loading.dart';
import '../../OverlayMessage.dart';
import '../../home.dart';
import '../../../Notifications/viewNotification.dart';
import '../../viewPassword.dart';
import '../settings.dart';
class changePassword extends StatefulWidget {
  const changePassword({super.key});

  @override
  State<changePassword> createState() => _changePasswordState();
}

class _changePasswordState extends State<changePassword> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalKey<FormState> _formKey= GlobalKey<FormState>();
  TextEditingController oldPassworldController =TextEditingController();
  TextEditingController newPassworldController= TextEditingController();
  TextEditingController confirmePasswordController=TextEditingController();

  String ? oldPassword;
  bool _obsecurePassword =false;
  int _selectedIndex= 1;
  bool _loading =false;
  String? oldPasswordValidation(String? newValue){
    if(newValue!.isEmpty){
      return 'old password can not be empty';

    }
    return null;
  }
  String? newPasswordValidator(String? value)=> value!.isEmpty ?'password can not be empty' : null;
  String? confirmnewPasswordValidator(String? value)=> value!.isEmpty ?'password can not be empty' : null;

  //password visibility
  void togglePasswordVisibilty(){
    setState(() {
      _obsecurePassword =! _obsecurePassword;
    });
  }
  void _oldTogglePasswordVisibility(){
    setState(() {
      _obsecurePassword =! _obsecurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth= MediaQuery.of(context).size.width;
    final itemWidth= screenWidth * 0.9;
    final itemHeight = 70.0;
    return  Scaffold(
     appBar:  _buildAppBar(),
     body: _buildBody(itemWidth, itemHeight),
     bottomNavigationBar: _buildBottomBar(),

    );
  }
  PreferredSizeWidget _buildAppBar(){
    return PreferredSize(
      preferredSize: Size.fromHeight(75),
      child: AppBar(
        backgroundColor:Color.fromARGB(255, 24, 146, 154),

        title: Center(
          child: Text('Change Password', style: TextStyle(fontSize: 24, color:
          Colors.white,fontWeight: FontWeight.bold),),
        ),
        leading: IconButton(
          onPressed: (){
            Navigator.push(context, transitionEffect(page: Setting()));
          },
          icon: Icon(Icons.arrow_back, size: 40,color: Colors.white,),
        ),
      ),
    );

  }

  Widget _buildBody( double itemWidth, double itemHeight ){
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           SizedBox(height: 16,),
           const Padding(
             padding: EdgeInsets.only(left: 25.0),
             child: Text('Confirm Old Password', style: TextStyle(
               fontSize: 23,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Regular',
             ),),
           ),
           _buildTextFormField(
             controller:oldPassworldController,
             validator: oldPasswordValidation,
             isPasswordVisible: _obsecurePassword,
             toggleVisibility: _oldTogglePasswordVisibility,
             height: itemHeight,
             width: itemWidth,


           ),
           //new password
           SizedBox(height: 16,),
           const Padding(
             padding: EdgeInsets.only(left: 25.0),
             child: Text('Enter new password', style: TextStyle(
               fontSize: 23,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Regular',
             ),),
           ),
           _buildTextFormField(
             controller:newPassworldController,
             validator: newPasswordValidator,
             isPasswordVisible: _obsecurePassword,
             toggleVisibility: togglePasswordVisibilty,
               height: itemHeight,
               width: itemWidth,
           ),

           //confirm New password
           SizedBox(height: 16,),
           const Padding(
             padding: EdgeInsets.only(left: 25.0),
             child: Text('Confirm new password', style: TextStyle(
               fontSize: 23,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Regular',
             ),),
           ),
           _buildTextFormField(
             controller:confirmePasswordController,
             validator: confirmnewPasswordValidator,
             isPasswordVisible: _obsecurePassword,
             toggleVisibility: togglePasswordVisibilty,
             height: itemHeight,
             width: itemWidth,
           ),
           SizedBox(height: 50,),
           _loading
           ?Center(child: loading())
           :

           Padding(
             padding: const EdgeInsets.only(left: 150.0),
             child: ElevatedButton(
               style: ButtonStyle(
                 backgroundColor: WidgetStateProperty.all(Color.fromARGB(255, 24, 146, 154)),
               ),

                 child: Padding(
                   padding: const EdgeInsets.all(18.0),
                   child: Text('Update', style: TextStyle(fontSize: 20, color: Colors.white),),
                 ),

               onPressed: (){
                 if(_formKey.currentState!.validate()){
                   _changePassword();
                   oldPassworldController.clear();
                   newPassworldController.clear();
                   confirmePasswordController.clear();
                 }
               },

             ),
           ),
         ],
        ),
      ),
    );
  }
  //buildTextFormField
Widget _buildTextFormField({

    required TextEditingController controller,
  required String? Function(String?) validator,
  void Function()? toggleVisibility,
  required bool isPasswordVisible,
  required double width,
  required double height,


}){
    return Padding(
      padding: const EdgeInsets.only(left: 25.0,),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,

          border: Border.all(
            width: 2,
            color: const Color.fromARGB(255, 24, 146, 154),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextFormField(
            keyboardType: TextInputType.text,
            validator: validator,
            controller: controller,
            obscureText: !isPasswordVisible,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
              errorStyle: const TextStyle(
                fontSize: 14,
                color: Colors.red,
              ),

              labelStyle: const TextStyle(
                fontSize: 20,
                fontFamily: 'Poppins-Regular',
                fontWeight: FontWeight.bold,
              ),
              hintStyle: const TextStyle(
                fontSize: 18,
                fontFamily: 'Poppins-Regular',
                color: Colors.grey,
              ),
              suffixIcon: toggleVisibility != null
                  ? IconButton(
                  onPressed: toggleVisibility,
                  icon: Icon(
                      isPasswordVisible ?Icons.visibility : Icons.visibility_off,
                    color: isPasswordVisible ? Colors.grey :Color.fromARGB(255, 24, 146, 154) ,
                  ),
              ):null,
            ),
          ),
        ),
      ),
    );
}

//bottom Naviagtion

Widget _buildBottomBar(){
  return Container(
    height: MediaQuery.of(context).size.height * 0.09, // Set height relative to screen size
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
          icon: Icon(Icons.lock, size: 35.0),
          label: 'Passwords',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 35.0),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notification_add, size: 35.0),
          label: 'Notifications',
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
      Widget page;
      switch (index) {
        case 0:
          page = ViewPassword();
          break;
        case 1:
          page = Home();
          break;
        case 2:
          page = ViewNotification();
          break;
        default:
          page = Home();
      }
      Navigator.push(
        context,
        transitionEffect(page: page),
      );
    });
  }

  //chanzge password
Future<void> _changePassword() async{
    //check if the user exist
  final currentUser= _auth.currentUser;
  //validate current user
  if(currentUser==null){
    _showOverlayMessage(context, 'no user logged in');
    return;
  }

  final oldPassword= oldPassworldController.text;
  final newPassword= newPassworldController.text;
  final confrimPassword=confirmePasswordController.text;

  if(confrimPassword != newPassword){
    _showOverlayMessage(context, 'password do not match');
    return;
  }
  setState(() {
    _loading=true;
  });
//get credential user
try{
  final email= currentUser.email;
  if(email==null){
    throw Exception('user email is not availiable');
  }
  final crendential = EmailAuthProvider.credential(
    email: email,
    password: oldPassword,
  );
  //reauthenticate user

  await currentUser.reauthenticateWithCredential(crendential);
  await currentUser.updatePassword(newPassword);
  _showOverlayMessage(context, 'password changed siccesfully');

} catch(e){
_showOverlayMessage(context, 'Error: changing password');
    } finally{
  setState(() {
    _loading=false;
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
