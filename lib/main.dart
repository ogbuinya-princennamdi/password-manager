import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:passwordmanager/screens/Notifications/notificationService.dart';
import 'package:passwordmanager/screens/authenticate/authenticate.dart';
import 'package:passwordmanager/screens/authenticate/registeration.dart';
import 'package:passwordmanager/screens/authenticate/sign_in.dart';
import 'package:passwordmanager/screens/home/firestoreCollections/gmailFirestoreCollections.dart';
import 'package:passwordmanager/screens/home/home.dart';
import 'package:passwordmanager/screens/home/settings/securitySettings/changePassword.dart';
import 'package:passwordmanager/screens/home/settings/settings.dart';
import 'package:passwordmanager/screens/home/viewPassword.dart';
import 'package:passwordmanager/screens/welcomePage/welcomePage.dart';
import 'package:passwordmanager/sharedFiles/NavigatorObserer.dart';
import 'package:play_integrity_flutter/models/play_integrity_model.dart';
import 'package:provider/provider.dart';
import 'package:passwordmanager/model/User.dart';
import 'package:passwordmanager/screens/wrapper.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:passwordmanager/services/auth.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();


  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyC1gbSeLLIBYVV0WMWkJQjBOIvldOPzWkY",
          appId: "1:17005816137:android:8593ef7ada6776d9325298",
          messagingSenderId: "17005816137",
          projectId:  "password-manager-with-2fa",
        storageBucket: "password-manager-with-2fa.appspot.com",

      ),
    );

    print('after web initialization');
    runApp(const passwordmanager());

  }
  else {
    await Firebase.initializeApp(
        options:  const FirebaseOptions(
            apiKey: "AIzaSyC1gbSeLLIBYVV0WMWkJQjBOIvldOPzWkY",
            appId: "1:17005816137:android:8593ef7ada6776d9325298",
            messagingSenderId: "17005816137",
            projectId: "password-manager-with-2fa",
      storageBucket: "password-manager-with-2fa.appspot.com",),
    );
    if (!kIsWeb) {
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.debug, // For production use PlayIntegrityProvider
        appleProvider: AppleProvider.appAttest,
      );
      print('App check initialization');
    }

    print('after initialization');
    runApp(const passwordmanager());
  }
}
class passwordmanager extends StatelessWidget {
  const passwordmanager({super.key});



  // This widget is the root of your application.
  @override

  Widget build(BuildContext context) {
    NotificationService notificationService= NotificationService();
    notificationService.init(context);
    return  StreamProvider<myUser?>.value(
       value: Authservices().user,
      initialData:null,
      child:   MaterialApp(

          debugShowCheckedModeBanner: false,
        home: wrapper(),
        routes: {

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

      ),
    );

  }

}
