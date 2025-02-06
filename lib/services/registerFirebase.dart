import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:passwordmanager/services/auth.dart';

class registerationFirebaseService{
  final FirebaseAuth  _registerService = FirebaseAuth.instance;
  final Authservices _auth = Authservices();

  Future<User?> firebaseRegisteration(String email, String password, String name, String adminKey) async {
    try {
      //  Creating user with email and password
      UserCredential userCredential = await _registerService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      //  Accessing the User object
      User? user = userCredential.user;

      // Storing additional user information to Firestore
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'name': name,
        'adminKey': adminKey,
      });
      return user;

    } catch (e) {
      print('Registration failed: $e');
      return null;
    }
  }
  //
  // Future signingUser ( String email, String password) async {
  //   DocumentSnapshot snapshot = await _firestore.collection('users').doc(email).get();
  //   if (snapshot.exists) {
  //     Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
  //     String storedPassword = data['password'];
  //     // Compare passwords
  //     if (password == storedPassword) {
  //       try{
  //         UserCredential userCredential =await _auth.signInWithEmailAndPassword(
  //             email: email, password: password);
  //         return _userFromFirebase(userCredential as User);
  //       }
  //       catch(e){
  //
  //         print(  'Error signing in: $e');
  //       }
  //     }
  //     else {
  //       // Passwords do not match
  //       print(  'Error signing in, wrong password');
  //     }
  //   } else {
  //     // User does not exist in database
  //     print(  'Error signing in, user does not exist');
  //   }
  // }

}

////////////////////////////////////////////////////////////////
