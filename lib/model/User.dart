
import 'package:firebase_auth/firebase_auth.dart';

class myUser{
  final String uid;
  myUser({required this.uid});

  get email => FirebaseAuth.instance.currentUser?.email;
}

