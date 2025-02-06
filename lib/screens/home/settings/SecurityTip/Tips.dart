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


class Tips extends StatefulWidget {
  const Tips({Key? key}) : super(key: key);

  @override
  State<Tips> createState() => _TipsState();
}

class _TipsState extends State<Tips> {
  bool _isLoading = false;
  final picker = ImagePicker();
  final Authservices _auth = Authservices();
  int _selectedIndex = 1;
  var support ="support@litmaclimited.com";
  var customerService= "cservice@litmaclimited.com";
  var supportRequest=" Support Request";
  var phoneNumber= "+2348155452046";
  bool showTips1 =true;
  bool showTips2=false;
  bool showTips3= false;
  bool showTips4 =false;
  bool showTips5=false;
  bool showTips6= false;
  bool showTips7 =false;
  bool showTips8=false;
  bool showTips9= false;
  bool showTips10 =false;
  bool showTips11=false;
  bool showTips12= false;
  bool showTips13 =false;
  bool showTips14=false;
  bool showTips15= false;



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
                      'Security Tips',
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
              Column(
                children: [

                  IconButton(
                    onPressed: (){
                      setState(() {
                        showTips1= !showTips1;
                        if(showTips1){showTips2=false;}
                      });
                    },
                    icon: Row(
                      children: [
                        Icon(Icons.add, color:Color.fromARGB(255, 24, 146, 154) ,size: 40,),
                        SizedBox(width: 15,),
                        Text(Tips1, style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Poppins-Regular',
                          fontWeight: FontWeight.bold,
                        ),),

                      ],
                    ),
                  ),
                  if(showTips1)...[

                    SizedBox(
                      width: 450,
                        child: Row(
                          children: [
                            Expanded(child:
                            Padding(
                              padding: const EdgeInsets.only(left: 50.0),
                              child: Text(Tips1sub,
                                  textAlign: TextAlign.justify,
                                style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Poppins-Regular',
                                fontWeight: FontWeight.normal,
                              ),),
                            ),
                            ),
                          ],
                        )),
                  ],
                ],

              ),

              Column(
                children: [

                  IconButton(
                    onPressed: (){
                      setState(() {

                        showTips2= !showTips2;
                        if(showTips2){
                          showTips1=false;
                        }
                      });
                    },
                    icon: Row(
                      children: [
                        Icon(Icons.add, color:Color.fromARGB(255, 24, 146, 154) ,size: 40,),
                        SizedBox(width: 15,),
                        Text(Tips2, style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Poppins-Regular',
                          fontWeight: FontWeight.bold,
                        ),),

                      ],
                    ),
                  ),
                  if(showTips2)...[
                    SizedBox(
                        width: 500,
                        child: Row(
                          children: [
                            Expanded(child:
                            Padding(
                              padding: const EdgeInsets.only(left: 50.0),
                              child: Text(Tips2sub,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Poppins-Regular',
                                  fontWeight: FontWeight.normal,
                                ),),
                            ),
                            ),
                          ],
                        )),
                  ],
                ],
              ),
              //3
              Column(
                children: [

                  IconButton(
                    onPressed: (){
                      setState(() {
                        showTips3= !showTips3;
                        if(showTips3){
                          showTips2=showTips1=false;}
                      });
                    },
                    icon: Row(
                      children: [
                        Icon(Icons.add, color:Color.fromARGB(255, 24, 146, 154) ,size: 40,),
                        SizedBox(width: 15,),
                        Text(Tips3, style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Poppins-Regular',
                          fontWeight: FontWeight.bold,
                        ),),

                      ],
                    ),
                  ),
                  if(showTips3)...[

                    SizedBox(
                        width: 450,
                        child: Row(
                          children: [
                            Expanded(child:
                            Padding(
                              padding: const EdgeInsets.only(left: 50.0),
                              child: Text(Tips3sub,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Poppins-Regular',
                                  fontWeight: FontWeight.normal,
                                ),),
                            ),
                            ),
                          ],
                        )),
                  ],
                ],

              ),
              //4
              Column(
                children: [

                  IconButton(
                    onPressed: (){
                      setState(() {
                        showTips4= !showTips4;
                        if(showTips4){
                          showTips2=showTips1=showTips3=false;}
                      });
                    },
                    icon: Row(
                      children: [
                        Icon(Icons.add, color:Color.fromARGB(255, 24, 146, 154) ,size: 40,),
                        SizedBox(width: 15,),
                        Text(Tips4, style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Poppins-Regular',
                          fontWeight: FontWeight.bold,
                        ),),

                      ],
                    ),
                  ),
                  if(showTips4)...[

                    SizedBox(
                        width: 450,
                        child: Row(
                          children: [
                            Expanded(child:
                            Padding(
                              padding: const EdgeInsets.only(left: 50.0),
                              child: Text(Tips4sub,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Poppins-Regular',
                                  fontWeight: FontWeight.normal,
                                ),),
                            ),
                            ),
                          ],
                        )),
                  ],
                ],

              ),
              Column(
                children: [

                  IconButton(
                    onPressed: (){
                      setState(() {
                        showTips5= !showTips5;
                        if(showTips5){
                          showTips2=showTips1=showTips4=showTips3=false;}
                      });
                    },
                    icon: Row(
                      children: [
                        Icon(Icons.add, color:Color.fromARGB(255, 24, 146, 154) ,size: 40,),
                        SizedBox(width: 15,),
                        Text(Tips5, style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Poppins-Regular',
                          fontWeight: FontWeight.bold,
                        ),),

                      ],
                    ),
                  ),
                  if(showTips5)...[

                    SizedBox(
                        width: 450,
                        child: Row(
                          children: [
                            Expanded(child:
                            Padding(
                              padding: const EdgeInsets.only(left: 50.0),
                              child: Text(Tips5sub,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Poppins-Regular',
                                  fontWeight: FontWeight.normal,
                                ),),
                            ),
                            ),
                          ],
                        )),
                  ],
                ],

              ),

              Column(
                children: [

                  IconButton(
                    onPressed: (){
                      setState(() {
                        showTips6= !showTips6;
                        if(showTips6){
                          showTips2=showTips1=showTips4=showTips5=showTips3=false;}
                      });
                    },
                    icon: Row(
                      children: [
                        Icon(Icons.add, color:Color.fromARGB(255, 24, 146, 154) ,size: 40,),
                        SizedBox(width: 15,),
                        Text(Tips6, style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Poppins-Regular',
                          fontWeight: FontWeight.bold,
                        ),),

                      ],
                    ),
                  ),
                  if(showTips6)...[

                    SizedBox(
                        width: 450,
                        child: Row(
                          children: [
                            Expanded(child:
                            Padding(
                              padding: const EdgeInsets.only(left: 50.0),
                              child: Text(Tips6sub,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Poppins-Regular',
                                  fontWeight: FontWeight.normal,
                                ),),
                            ),
                            ),
                          ],
                        )),
                  ],
                ],

              ),
              Column(
                children: [

                  IconButton(
                    onPressed: (){
                      setState(() {
                        showTips7= !showTips7;
                        if(showTips7){
                          showTips2=showTips1=showTips4=showTips5=showTips3=showTips6=false;}
                      });
                    },
                    icon: Row(
                      children: [
                        Icon(Icons.add, color:Color.fromARGB(255, 24, 146, 154) ,size: 40,),
                        SizedBox(width: 15,),
                        Text(Tips7, style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Poppins-Regular',
                          fontWeight: FontWeight.bold,
                        ),),

                      ],
                    ),
                  ),
                  if(showTips7)...[

                    SizedBox(
                        width: 450,
                        child: Row(
                          children: [
                            Expanded(child:
                            Padding(
                              padding: const EdgeInsets.only(left: 50.0),
                              child: Text(Tips7sub,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Poppins-Regular',
                                  fontWeight: FontWeight.normal,
                                ),),
                            ),
                            ),
                          ],
                        )),
                  ],
                ],

              ),
              Column(
                children: [

                  IconButton(
                    onPressed: (){
                      setState(() {
                        showTips8= !showTips8;
                        if(showTips8){
                          showTips2=showTips1=showTips4=showTips5=showTips3=showTips6=showTips7=false;}
                      });
                    },
                    icon: Row(
                      children: [
                        Icon(Icons.add, color:Color.fromARGB(255, 24, 146, 154) ,size: 40,),
                        SizedBox(width: 15,),
                        Text(Tips8, style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Poppins-Regular',
                          fontWeight: FontWeight.bold,
                        ),),

                      ],
                    ),
                  ),
                  if(showTips8)...[

                    SizedBox(
                        width: 450,
                        child: Row(
                          children: [
                            Expanded(child:
                            Padding(
                              padding: const EdgeInsets.only(left: 50.0),
                              child: Text(Tips8sub,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Poppins-Regular',
                                  fontWeight: FontWeight.normal,
                                ),),
                            ),
                            ),
                          ],
                        )),
                  ],
                ],

              ),
              Column(
                children: [

                  IconButton(
                    onPressed: (){
                      setState(() {
                        showTips9= !showTips9;
                        if(showTips9){
                          showTips2=showTips1=showTips4=showTips5=showTips3=showTips6=showTips7=showTips8=false;}
                      });
                    },
                    icon: Row(
                      children: [
                        Icon(Icons.add, color:Color.fromARGB(255, 24, 146, 154) ,size: 40,),
                        SizedBox(width: 15,),
                        Text(Tips9, style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Poppins-Regular',
                          fontWeight: FontWeight.bold,
                        ),),

                      ],
                    ),
                  ),
                  if(showTips9)...[

                    SizedBox(
                        width: 450,
                        child: Row(
                          children: [
                            Expanded(child:
                            Padding(
                              padding: const EdgeInsets.only(left: 50.0),
                              child: Text(Tips9sub,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Poppins-Regular',
                                  fontWeight: FontWeight.normal,
                                ),),
                            ),
                            ),
                          ],
                        )),
                  ],
                ],

              ),
              Column(
                children: [

                  IconButton(
                    onPressed: (){
                      setState(() {
                        showTips10= !showTips10;
                        if(showTips10){
                          showTips2=showTips1=showTips4=showTips5=showTips3=showTips6=showTips7=showTips8=showTips9=false;}
                      });
                    },
                    icon: Row(
                      children: [
                        Icon(Icons.add, color:Color.fromARGB(255, 24, 146, 154) ,size: 40,),
                        SizedBox(width: 15,),
                        Text(Tips10, style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Poppins-Regular',
                          fontWeight: FontWeight.bold,
                        ),),

                      ],
                    ),
                  ),
                  if(showTips10)...[

                    SizedBox(
                        width: 450,
                        child: Row(
                          children: [
                            Expanded(child:
                            Padding(
                              padding: const EdgeInsets.only(left: 50.0),
                              child: Text(Tips10sub,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Poppins-Regular',
                                  fontWeight: FontWeight.normal,
                                ),),
                            ),
                            ),
                          ],
                        )),
                  ],
                ],

              ),
              Column(
                children: [

                  IconButton(
                    onPressed: (){
                      setState(() {
                        showTips11= !showTips11;
                        if(showTips11){
                          showTips2=showTips1=showTips4=showTips5=showTips3=showTips6=showTips7=showTips8=showTips9=showTips10=false;}
                      });
                    },
                    icon: Row(
                      children: [
                        Icon(Icons.add, color:Color.fromARGB(255, 24, 146, 154) ,size: 40,),
                        SizedBox(width: 15,),
                        Text(Tips11, style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Poppins-Regular',
                          fontWeight: FontWeight.bold,
                        ),),

                      ],
                    ),
                  ),
                  if(showTips11)...[

                    SizedBox(
                        width: 450,
                        child: Row(
                          children: [
                            Expanded(child:
                            Padding(
                              padding: const EdgeInsets.only(left: 50.0),
                              child: Text(Tips11sub,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Poppins-Regular',
                                  fontWeight: FontWeight.normal,
                                ),),
                            ),
                            ),
                          ],
                        )),
                  ],
                ],

              ),
              Column(
                children: [

                  IconButton(
                    onPressed: (){
                      setState(() {
                        showTips12= !showTips12;
                        if(showTips12){
                          showTips2=showTips1=showTips4=showTips5=showTips3=showTips6=showTips7=showTips8=showTips9=showTips10=showTips11=false;}
                      });
                    },
                    icon: Row(
                      children: [
                        Icon(Icons.add, color:Color.fromARGB(255, 24, 146, 154) ,size: 40,),
                        SizedBox(width: 15,),
                        Text(Tips12, style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Poppins-Regular',
                          fontWeight: FontWeight.bold,
                        ),),

                      ],
                    ),
                  ),
                  if(showTips12)...[

                    SizedBox(
                        width: 450,
                        child: Row(
                          children: [
                            Expanded(child:
                            Padding(
                              padding: const EdgeInsets.only(left: 50.0),
                              child: Text(Tips12sub,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Poppins-Regular',
                                  fontWeight: FontWeight.normal,
                                ),),
                            ),
                            ),
                          ],
                        )),
                  ],
                ],

              ),
              Column(
                children: [

                  IconButton(
                    onPressed: (){
                      setState(() {
                        showTips13= !showTips13;
                        if(showTips13){
                          showTips2=showTips1=showTips4=showTips5=showTips3=showTips6=showTips7=showTips8=showTips9=showTips10=showTips11=showTips13=false;}
                      });
                    },
                    icon: Row(
                      children: [
                        Icon(Icons.add, color:Color.fromARGB(255, 24, 146, 154) ,size: 40,),
                        SizedBox(width: 15,),
                        Text(Tips13, style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Poppins-Regular',
                          fontWeight: FontWeight.bold,
                        ),),

                      ],
                    ),
                  ),
                  if(showTips13)...[

                    SizedBox(
                        width: 450,
                        child: Row(
                          children: [
                            Expanded(child:
                            Padding(
                              padding: const EdgeInsets.only(left: 50.0),
                              child: Text(Tips13sub,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Poppins-Regular',
                                  fontWeight: FontWeight.normal,
                                ),),
                            ),
                            ),
                          ],
                        )),
                  ],
                ],

              ),
              Column(
                children: [

                  IconButton(
                    onPressed: (){
                      setState(() {
                        showTips14= !showTips14;
                        if(showTips14){
                          showTips2=showTips1=showTips4=showTips5=showTips3=showTips6=showTips7=showTips8=showTips9=showTips10=showTips11=showTips13=showTips14=false;}
                      });
                    },
                    icon: Row(
                      children: [
                        Icon(Icons.add, color:Color.fromARGB(255, 24, 146, 154) ,size: 40,),
                        SizedBox(width: 15,),
                        Text(Tips14, style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Poppins-Regular',
                          fontWeight: FontWeight.bold,
                        ),),

                      ],
                    ),
                  ),
                  if(showTips14)...[

                    SizedBox(
                        width: 450,
                        child: Row(
                          children: [
                            Expanded(child:
                            Padding(
                              padding: const EdgeInsets.only(left: 50.0),
                              child: Text(Tips14sub,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Poppins-Regular',
                                  fontWeight: FontWeight.normal,
                                ),),
                            ),
                            ),
                          ],
                        )),
                  ],
                ],

              ),
              Column(
                children: [

                  IconButton(
                    onPressed: (){
                      setState(() {
                        showTips15= !showTips15;
                        if(showTips15){
                          showTips2=showTips1=showTips4=showTips5=showTips3=showTips6=showTips7=showTips8=showTips9=showTips10=showTips11=showTips13=showTips14=showTips15=false;}
                      });
                    },
                    icon: Row(
                      children: [
                        Icon(Icons.add, color:Color.fromARGB(255, 24, 146, 154) ,size: 40,),
                        SizedBox(width: 15,),
                        Text(Tips15, style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Poppins-Regular',
                          fontWeight: FontWeight.bold,
                        ),),

                      ],
                    ),
                  ),
                  if(showTips15)...[

                    SizedBox(
                        width: 450,
                        child: Row(
                          children: [
                            Expanded(child:
                            Padding(
                              padding: const EdgeInsets.only(left: 50.0),
                              child: Text(Tips15sub,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Poppins-Regular',
                                  fontWeight: FontWeight.normal,
                                ),),
                            ),
                            ),
                          ],
                        )),
                  ],
                ],

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
  //export function to get users details from firebase



  var Tips1= "Use Strong Passwords";
  var Tips1sub="Create complex passwords that include a mix of"
      " uppercase and lowercase letters, numbers, and special characters.";
  var Tips2="Implement Multi-Factor Auth (MFA)";
  var Tips2sub= "Enable MFA wherever possible to add an extra layer of security. This often involves something you know (password)"
      " and something you have (a mobile device or hardware token)";
  var Tips3="Regularly Update Passwords";
  var Tips3sub= "Change passwords regularly and avoid reusing old passwords. Use unique passwords for different accounts.";
  var Tips4="Use a Password Manager";
  var Tips4sub="Utilize a reputable password manager to securely store and manage passwords. "
      "This helps in creating complex passwords without the need to remember them all.";
  var Tips5="Be Wary of Phishing Attacks";
  var Tips5sub="Educate yourself and your team about phishing scams. Be cautious of unsolicited "
      "emails or messages requesting sensitive information.";
  var Tips6="Securely Store Credentials";
  var Tips6sub="Avoid storing passwords in plain text or unencrypted files. Use encrypted storage solutions for sensitive information.";
  var  Tips7="Limit Access";
  var Tips7sub="Apply the principle of least privilege, granting users only the access they need to perform their job functions. Regularly review access permissions.";
  var Tips8="Monitor Account Activity";
  var Tips8sub="Regularly review account activity for any unauthorized access or unusual behavior. Enable alerts for suspicious login attempts.";
  var Tips9="Implement Account Lockout Policies";
  var Tips9sub="Set policies that temporarily lock accounts after a certain number of failed login attempts to prevent brute-force attacks.";
  var Tips10="Use Secure Connections";
  var Tips10sub="Always use HTTPS for web applications and services. Ensure that sensitive information is transmitted over secure connections.";
  var Tips11="Educate Employees";
  var Tips11sub="Conduct regular training sessions on security best practices, including how to create strong passwords and recognize phishing attempts.";
  var Tips12="Keep Software Up to Date";
  var Tips12sub="Regularly update software, applications, and operating systems to patch vulnerabilities that could be exploited.";
  var Tips13="Be Cautious with Public Wi-Fi";
  var Tips13sub="Avoid accessing sensitive accounts or entering credentials on public Wi-Fi networks. Use a VPN for an additional layer of security.";
  var Tips14="Implement Session Timeouts";
  var Tips14sub="Configure session timeouts for applications to automatically log users out after a period of inactivity.";
  var Tips15="Backup Credentials Securely";
  var Tips15sub="Maintain secure backups of credentials in a separate, encrypted location to recover from incidents like data loss or breaches.";
  
  
  

}
