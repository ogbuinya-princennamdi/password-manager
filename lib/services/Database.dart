import 'package:cloud_firestore/cloud_firestore.dart';
class DatabaseServices {
final String uid;
DatabaseServices({required this.uid});
  final CollectionReference UsersRefrenceCollections = FirebaseFirestore.instance.collection('authManager');

  Future updateUserData( int HEN, int gul) async {
    return UsersRefrenceCollections.doc(uid).set(

      {
        'hen': 0,
        'gul': 0,
      }
    );
  }
}
