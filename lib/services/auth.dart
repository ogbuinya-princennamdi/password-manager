// import 'dart:async';
// import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:passwordmanager/model/User.dart';
// import 'package:passwordmanager/screens/authenticate/NetworkException.dart';
//
// import '../screens/home/OverlayMessage.dart';
//
//
//
// class Authservices{
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final String _errorMessage = '';
//
//   BuildContext? get context => null;
//
// //method for customer user accessing firbase user property
//   myUser? _userFromFirebase(User? user){
//     return user !=null ? myUser(uid:user.uid): null;
//
//   }
//   // Stream to listen to authentication state changes
//
//   Stream<myUser?> get user {
//     return _auth.authStateChanges().map((User? user) => _userFromFirebase(user));
//   }
//
//   //siging in anom
//   Future<myUser?> signInAnonymously() async {
//     try {
//       UserCredential userCredential = await _auth.signInAnonymously();
//       return _userFromFirebase(userCredential.user);
//     } catch (e) {
//       print(e.toString());
//       return null;
//     }
//   }
//
// //register
//   Future<myUser?> firebaseRegisteration(String email, String password, String FirstName,String LastName,  String phoneNumber) async {
//     try {
//       //  Creating user with email and password
//       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       //  Accessing the User object
//       User? user = userCredential.user;
//
//       // Storing additional user information to Firestore
//       if(user != null) {
//         await FirebaseFirestore.instance.collection('users').doc(user!.uid).set(
//             {
//               'First name': FirstName,
//               'Last name': LastName,
//               'phone number': phoneNumber,
//             });
//         return _userFromFirebase(user);
//
//       }else
//         {return null;
//         }
//
//     } on FirebaseAuthException catch(e){
//       throw NetworkException('firebase error:${e.message}');
//     }on SocketException{
//       throw NetworkException('Network error: please check your internet connection');
//     } catch(e){
//       throw Exception('Unexpected error: $e');
//     }
//   }
//
//
//
//
// //SIGNING IN//////////////////////////////////////////////////////////////////////////////////////
//
//   Future<myUser?> sigingUser(String email, String password) async{
//     //create sign in sercies
//     try{
//       UserCredential userCredential =await _auth.signInWithEmailAndPassword(
//           email: email,
//           password: password);
//       final User? user = userCredential.user;
//
//       // Check if user is not null and not verified
//       if (user != null && !user.emailVerified) {
//         await user.sendEmailVerification();
//       }
//
//       // return user;
//
//       // // Extract user from userCredential
//       return _userFromFirebase(userCredential.user);
//
//     } on FirebaseAuthException catch(e){
//       throw NetworkException('firebase error:${e.message}');
//     }on SocketException{
//       throw NetworkException('Network error: please check your internet connection');
//     } catch(e){
//       throw Exception('Unexpected error: $e');
//     }
//   }
//
// //auth opt///////////////////////////////////////////////////////////
// //
// //   Future<void> sendEmailOtp(email)async{
// //     try{
// //       await _auth.sendPasswordResetEmail(email: email);
// //     }
// //         catch(e){
// //           throw Exception('Failed to send OTP');
// //         }
// //   }
//   Future<void> sendVerificationEmail(User user) async {
//     try {
//       await user.sendEmailVerification();
//     } catch (e) {
//       print('Failed to send verification email: $e');
//       throw Exception('Failed to send verification email.');
//     }
//   }
//   //method for sign out////////////////////////////////////////////////////////////////////
// Future <void>signOut() async{
//     try {
//       return await _auth.signOut();
//
//     }catch(e){
//       throw Exception('Failed to sign out');
//
//     }
//
// }
// //verifyOTP
//
// // Future<User?> VeriftyEmailOtp( String code) async{
// //     try{
// //       await _auth.confirmPasswordReset(code: code,
// //           newPassword: 'temporalPassword');
// //       return _auth.currentUser;
// //     }
// //         catch(e){
// //       throw Exception('verification Failed');
// //         }
// //
// // }
//
//   Future<User?> verifyEmailOtp(String code) async {
//     try {
//       // Use Firebase's applyActionCode method to verify email
//       await _auth.applyActionCode(code);
//       User? user = _auth.currentUser;
//
//       // If email verification is successful, return the current user
//       return user;
//     } catch (e) {
//       print('Verification failed: $e'); // Log the error for debugging
//       throw Exception('Verification failed. Please check the OTP and try again.');
//     }
//   }
//
// }
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:passwordmanager/model/User.dart';
import 'package:passwordmanager/screens/authenticate/NetworkException.dart';

import '../screens/home/OverlayMessage.dart';



class Authservices{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _errorMessage = '';

  BuildContext? get context => null;

//method for customer user accessing firbase user property
  myUser? _userFromFirebase(User? user){
    return user !=null ? myUser(uid:user.uid): null;

  }
  // Stream to listen to authentication state changes

  Stream<myUser?> get user {
    return _auth.authStateChanges().map((User? user) => _userFromFirebase(user));
  }

  //siging in anom
  Future<myUser?> signInAnonymously() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      return _userFromFirebase(userCredential.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  Future<myUser?> firebaseRegisteration(String email, String password, String FirstName,String LastName,  String phoneNumber, String notification) async {
    try {
      //  Creating user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      //  Accessing the User object
      User? user = userCredential.user;

      // Storing additional user information to Firestore
      if(user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
            {
              'First name': FirstName,
              'Last name': LastName,
              'phone number': phoneNumber,
              'notification': notification

            });
        return _userFromFirebase(user);

      }else
        {return null;
        }

    } on FirebaseAuthException catch(e){
      throw NetworkException('firebase error:${e.message}');
    }on SocketException{
      throw NetworkException('Network error: please check your internet connection: $e');
    } catch(e){
      throw Exception('Unexpected error: $e');
    }
  }



//SIGNING IN//////////////////////////////////////////////////////////////////////////////////////

  Future<myUser?> sigingUser(String email, String password) async{
    //create sign in sercies
    try{
      UserCredential userCredential =await _auth.signInWithEmailAndPassword(
          email: email,
          password: password);
      // Extract user from userCredential
      return _userFromFirebase(userCredential.user);

    } on FirebaseAuthException catch(e){
      throw NetworkException('firebase error:${e.message}');
    }on SocketException{
      throw NetworkException('Network error: please check your internet connection');
    } catch(e){
      throw Exception('Unexpected error: $e');
    }
  }



  //method for sign out////////////////////////////////////////////////////////////////////
  Future <void>signOut() async{
    try {
      return await _auth.signOut();

    }catch(e){
      print(e.toString());
      return null;
    }

  }

}