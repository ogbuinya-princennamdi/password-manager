import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class activityLogService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> logUsersActivity(String activityDescription) async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        // Use user.uid directly instead of userId parameter
        final String userId = user.uid;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('activityLog')
            .add({
          'activity': activityDescription,
          'time': FieldValue.serverTimestamp(),
        });
      } else {
        print('No user is logged in. Activity not logged.');
      }
    } catch (e) {
      print('Error logging activity: $e');
    }
  }
}
