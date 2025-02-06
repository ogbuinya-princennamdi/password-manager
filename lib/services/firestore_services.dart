import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class firestoreServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth =FirebaseAuth.instance;

  // Service to get all documents from a specific collection
  Stream<List<Map<String, dynamic>>> getCollectionsData(String collectionName) {
    return _db.collection(collectionName).snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>)
            .toList());
  }

//retriving data from user collections of the cureent user////////////////////////
  Stream<List<Map<String, dynamic>>> retrieveUserData(String filterValue) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if(currentUser==null){
      throw Exception('no user is currently logged in');

    }
    String userId=currentUser.uid;
    // Create a reference to the Firestore collection
    CollectionReference emailPasswordsRef = _db
        .collection('users')
        .doc(userId)
        .collection('emailPasswords');

    // Return a stream of the emailPasswords collection documents
    return emailPasswordsRef
    .where('selectedItem', isEqualTo: filterValue)
    .snapshots()
    .map((snapshot){
      // Convert the snapshot documents to a list of maps
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }
// service to get phone number///////////////////////////////////////////////////////
//   Future<String?> getPhoneNumberFromFirestore() async {
//     final currentUser = FirebaseAuth.instance.currentUser;
//     String? userId=currentUser?.uid;
//     try {
//       // Reference to the Firestore collection and document
//       CollectionReference emailPasswordsRef = FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .collection('emailPasswords');
//
//       // Get all documents in the emailPasswords collection
//       QuerySnapshot querySnapshot = await emailPasswordsRef.get();
//
//       if (querySnapshot.docs.isNotEmpty) {
//         // Assuming there's only one document or you need the first document
//         DocumentSnapshot doc = querySnapshot.docs.first;
//
//         // Safely cast the document data to a Map<String, dynamic>
//         Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
//
//         // Access the phone number from the map
//         return data?['phone number'] as String?;
//       }
//     } catch (e) {
//       print("Failed to get phone number from Firestore: $e");
//     }
//     return null;
//   }
// Retriving a single data////////////////////////////////
  Future<String?> getPhoneNumberFromFirestore() async {
    User? user = _auth.currentUser;
    if (user == null) {
      print('No user logged in');
      return null;
    }

    try {
      // Use the user ID to get the document reference
      DocumentSnapshot doc = await _db.collection('users').doc(user.uid).get();

      if (doc.exists) {
        // Safely cast the document data to a Map<String, dynamic>
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        return data?['phone number'] as String?;
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print("Failed to get phone number from Firestore: $e");
    }
    return null;
  }


  //service to send otp
  Future<void> sendOTP() async {
    String? phoneNumber = await getPhoneNumberFromFirestore();

    if (phoneNumber == null) {
      print('Phone number not found in Firestore.');
      return;
    }
    print('Attempting to send OTP to: $phoneNumber');
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Automatically sign in the user
        await FirebaseAuth.instance.signInWithCredential(credential);
        print('Phone number automatically verified and user signed in.');
      },
      verificationFailed: (FirebaseAuthException e) {
       print('Verification failed: ${e.message}');
       if (e.code == 'invalid-phone-number') {
        print('The provided phone number is not valid.');
        } else if (e.code == 'quota-exceeded') {
        print('Quota for SMS has been exceeded.');
            }
       },
      codeSent: (String verificationId, int? resendToken) {
        print('OTP sent. Verification ID: $verificationId');
        // Store the verification ID and prompt user to enter the OTP
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('Auto-retrieval timeout. Verification ID: $verificationId');

      },

    );


  }

  //s


}

