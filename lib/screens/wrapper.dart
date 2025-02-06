import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:passwordmanager/screens/home/home.dart';
import 'package:passwordmanager/screens/welcomePage/welcomePage.dart';

import '../sharedFiles/NavigatorObserer.dart';
import 'authenticate/authenticate.dart';
import 'authenticate/registeration.dart';
import 'authenticate/sign_in.dart';
import 'home/firestoreCollections/gmailFirestoreCollections.dart';
import 'home/settings/profileSettings/profileSetting.dart';
import 'home/settings/securitySettings/changePassword.dart';
import 'home/settings/settings.dart';
import 'home/viewPassword.dart';
class wrapper extends StatelessWidget {
  const wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final  List<String> activities = [];
    //here is what determins what is returned either home or auth, but for now let use home
    return  MaterialApp(
        debugShowCheckedModeBanner: false,
      navigatorObservers: [MyNavigatorObserver(activities)],
      routes: {
        "/": (context) => WelcomePage(),
        "/sign_in": (context) => const SignIn(),
        "/home": (context) => const Home(),
        "/Registration": (context) => const Registration(),
        "/authenticate": (context) => const authenticate(),
        "/gmailFirestoreCollection": (context) => const gmailFirestoreCollection(),
        "/ViewPassword": (context) => const ViewPassword(),
        "/settings": (context) => const Setting(),
        "/changePassword": (context) => const changePassword(),
      },
        onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => const SignIn(), // Handle unknown routes
            );
          },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const SignIn(), // Handle unknown routes
        );
      },

    );
  }
}
