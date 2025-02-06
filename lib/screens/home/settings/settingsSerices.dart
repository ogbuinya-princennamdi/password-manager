// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class UserService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
//
//   Future<void> _editName( String selectedItem, String newName) async {
//     final User? currentUser = _auth.currentUser;
//
//     // Check if the user is logged in
//     if (currentUser == null) {
//       _showOverlayMessage(context, 'No user logged in');
//       return;
//     }
//
//     String userId = currentUser.uid;
//
//     try {
//       // Create reference to the Firestore collection
//       DocumentReference userDocumentRef = _firebaseFirestore.collection('users').doc(userId);
//
//       // Retrieve the document for the current user
//       final DocumentSnapshot docSnapshot = await userDocumentRef.get();
//
//       if (!docSnapshot.exists) {
//         _showOverlayMessage(context, 'No user document found');
//         return;
//       }
//
//       final Map<String, dynamic> userData = docSnapshot.data() as Map<String, dynamic>;
//
//       // Check if the current name matches the selected item
//       if (userData['name'] != selectedItem) {
//         _showOverlayMessage(context, 'Selected name does not match');
//         return;
//       }
//
//       // Update the name field
//       await userDocumentRef.update({'name': newName});
//
//       _showOverlayMessage(context, 'Name updated successfully');
//     } catch (e) {
//       // Log the error for debugging
//       print('Error updating name: $e');
//       _showOverlayMessage(context, 'Error updating name');
//     }
//   }
//
//   void _showOverlayMessage(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }
// }
