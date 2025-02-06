import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:passwordmanager/screens/home/settings/profileSettings/profileImage.dart';
import 'package:passwordmanager/services/auth.dart';
import 'package:passwordmanager/sharedFiles/loading.dart';
import 'package:passwordmanager/sharedFiles/logo.dart';
import 'package:passwordmanager/sharedFiles/transitionEffect.dart';
import 'package:passwordmanager/screens/home/manageEmailPasswords.dart';
import 'package:passwordmanager/screens/home/manageBankPassword.dart';
import 'package:passwordmanager/screens/home/manageOtherDetails.dart';
import 'package:passwordmanager/screens/home/socialMediaPassword.dart';
import 'package:passwordmanager/screens/Notifications/viewNotification.dart';
import 'package:passwordmanager/screens/home/viewPassword.dart';
import 'package:passwordmanager/screens/home/settings/settings.dart';
import 'package:passwordmanager/screens/home/cryptoWalletToken.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:passwordmanager/sharedFiles/optGenerator.dart';


import '../../home.dart';


class Contactus extends StatefulWidget {
  const Contactus({Key? key}) : super(key: key);

  @override
  State<Contactus> createState() => _ContactusState();
}

class _ContactusState extends State<Contactus> {
  bool _isLoading = false;
  final picker = ImagePicker();
  final Authservices _auth = Authservices();
  int _selectedIndex = 1;
  var support ="support@litmaclimited.com";
  var customerService= "cservice@litmaclimited.com";
  var supportRequest=" Support Request";
  var phoneNumber= "+2348155452046";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const loading()
        : DefaultTabController(
      initialIndex: _selectedIndex,
      length: 4,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(75),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color.fromARGB(255, 24, 146, 154),
            actions: [
            // leading back button
              IconButton(
                  onPressed: (){
                    Navigator.push(context,transitionEffect(page: Setting()));
                  },

                  icon: Icon(Icons.arrow_back, size: 40,color: Colors.white,)
              ),
              const Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Contact us',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Poppins-Regular',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: PopupMenuButton(
                  position: PopupMenuPosition.under,
                  iconColor: Colors.white,
                  iconSize: 40,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context, transitionEffect(page: Setting()),
                          );
                        },
                        child: const Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Poppins-Regular',
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 24, 146, 154),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: Column(
            children: [
              Container(
                height: 250,
                color: Color.fromARGB(255, 24, 146, 154),
                child: const DrawerHeader(
                  margin: EdgeInsets.zero,
                  child: ProfileImage(),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text('Manage Emails'),
                      onTap: () {
                        Navigator.push(
                          context, transitionEffect(page: ManageEmailPassword()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.lock),
                      title: const Text('Manage Bank Password'),
                      onTap: () {
                        Navigator.push(
                          context, transitionEffect(page: ManageBankPassword()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.camera),
                      title: const Text('Manage Social Media'),
                      onTap: () {
                        Navigator.push(
                          context, transitionEffect(page: ManageSocialMediaPassword()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.wallet),
                      title: const Text('Manage Crypto Wallet'),
                      onTap: () {
                        Navigator.push(
                          context, transitionEffect(page: ManageCryptoPassword()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.details),
                      title: const Text('Other Details'),
                      onTap: () {
                        Navigator.push(
                          context, transitionEffect(page: manageOtherDetails()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() => _isLoading = true);
                    try {
                      await _auth.signOut();
                      Navigator.of(context).pushReplacementNamed('sign_in');
                    } catch (e) {
                      print('Error signing out: $e');
                    } finally {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 24, 146, 154)),
                  ),
                  child: const Text(
                    'Sign Out',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Poppins-Regular',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body:  SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(top: 10),
                width: 450,
                height: 50,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 24, 146, 154),
                ),
                child: const Text("Litmac Technical support",
                  style: TextStyle(

                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'Poppins-Regular',
                    fontWeight: FontWeight.bold,
                  ),),
              ),

              Container(
                width: 450,
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color:Color.fromARGB(255, 24, 146, 154), ),
                ),
                child:  Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 15,),
                        Icon(
                          Icons.person, size: 40, color: Color.fromARGB(255, 24, 146, 154),
                        ),
                        SizedBox(width: 15,),
                        Text(
                          'Ogbuinya Prince Nnamdi',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Poppins-Regular',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15,),
                    Row(
                      children: [
                        SizedBox(width: 15,),
                        Icon(
                          Icons.mail, size: 40, color: Color.fromARGB(255, 24, 146, 154),
                        ),
                        SizedBox(width: 15,),
                        Text(
                          support,
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Poppins-Regular',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 15,),
                        Container(

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                              color:Color.fromARGB(255, 24, 146, 154) ,
                          ),
                          child: IconButton(
                              onPressed: (){sendEmail(support, supportRequest);},
                              icon: Icon(Icons.send, color:Colors.white)),
                        )
                      ],
                    ),
                    SizedBox(height: 15,),
                    Row(
                      children: [
                        SizedBox(width: 15,),
                        Icon(
                          Icons.call, size: 40, color: Color.fromARGB(255, 24, 146, 154),
                        ),
                        SizedBox(width: 15,),
                        Text(
                          "+2348155452046",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Poppins-Regular',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 110,),
                        Container(

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color:Color.fromARGB(255, 24, 146, 154) ,
                          ),
                          child: IconButton(
                              onPressed: (){CallSupport(phoneNumber);},
                              icon: Icon(Icons.call_made_outlined, color: Colors.white,)),
                        )
                      ],
                    ),

                    SizedBox(height: 15,),
                    Row(
                      children: [
                        SizedBox(width: 15,),
                        Icon(
                          Icons.location_on_rounded, size: 40, color: Color.fromARGB(255, 24, 146, 154),
                        ),
                        SizedBox(width: 15,),
                        Text(
                          "Abuja, Nigeria",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Poppins-Regular',
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      ],
                    ),


                  ],

                ),
              ),

              SizedBox(height: 30,),
              Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(top: 10),
                width: 450,
                height: 50,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 24, 146, 154),
                ),
                child: const Text("Litmac Customer Service",
                  style: TextStyle(

                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'Poppins-Regular',
                    fontWeight: FontWeight.bold,
                  ),),
              ),
              Container(
                width: 450,
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color:Color.fromARGB(255, 24, 146, 154), ),
                ),
                child:  Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 15,),
                        Icon(
                          Icons.person, size: 40, color: Color.fromARGB(255, 24, 146, 154),
                        ),
                        SizedBox(width: 15,),
                        Text(
                          'Omonua Gladys',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Poppins-Regular',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15,),
                    Row(
                      children: [
                        SizedBox(width: 15,),
                        Icon(
                          Icons.mail, size: 40, color: Color.fromARGB(255, 24, 146, 154),
                        ),
                        SizedBox(width: 15,),
                        Text(
                          customerService,
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Poppins-Regular',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 15,),
                        Container(

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color:Color.fromARGB(255, 24, 146, 154) ,
                          ),
                          child: IconButton(
                              onPressed: (){sendEmail(support, supportRequest);},
                              icon: Icon(Icons.send, color:Colors.white)),
                        )
                      ],
                    ),
                    SizedBox(height: 15,),
                    Row(
                      children: [
                        SizedBox(width: 15,),
                        Icon(
                          Icons.call, size: 40, color: Color.fromARGB(255, 24, 146, 154),
                        ),
                        SizedBox(width: 15,),
                        Text(
                          "+2349135040128",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Poppins-Regular',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 110,),
                        Container(

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color:Color.fromARGB(255, 24, 146, 154) ,
                          ),
                          child: IconButton(
                              onPressed: (){CallSupport(phoneNumber);},
                              icon: Icon(Icons.call_made_outlined, color: Colors.white,)),
                        )
                      ],
                    ),

                    SizedBox(height: 15,),
                    Row(
                      children: [
                        SizedBox(width: 15,),
                        Icon(
                          Icons.location_on_rounded, size: 40, color: Color.fromARGB(255, 24, 146, 154),
                        ),
                        SizedBox(width: 15,),
                        Text(
                          "Abuja, Nigeria",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Poppins-Regular',
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      ],
                    ),


                  ],

                ),
              ),
              SizedBox(height: 100,),
              Logo(),

              SizedBox(height: 20),

            ],
          ),
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
  //send email function
Future<void> sendEmail(String to, String subject) async{
    final Uri emailLauncheri =Uri(
      scheme: "mailto",
      path: to,
      query: Uri.encodeQueryComponent("subject= $subject")
    );
if(await canLaunchUrl(emailLauncheri)){
  await launchUrl(emailLauncheri);
}else{
  throw "could not launch $emailLauncheri";
}

  }

  // function to call

Future<void> CallSupport(String phoneNumber ) async{
    final Uri dialUri= Uri(
      scheme: "tel",
      path: phoneNumber,
    );

    if(await canLaunchUrl(dialUri)){
      await launchUrl(dialUri);
    }else{
      throw "unable to call $dialUri";
    }
}
}
