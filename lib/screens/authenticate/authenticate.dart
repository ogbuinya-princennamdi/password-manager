import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:passwordmanager/screens/authenticate/sign_in.dart';
import 'package:passwordmanager/screens/home/home.dart';

import '../../model/User.dart';

class authenticate extends StatefulWidget {
  const authenticate({super.key});

  @override
  State<authenticate> createState() => _authenticateState();
}

class _authenticateState extends State<authenticate> {
  @override
  Widget build(BuildContext context) {
    final user=Provider.of<myUser?>(context);

    if (user ==null){
      return const SignIn();
    }
    else{
      return const Home();
    }
  }
}
