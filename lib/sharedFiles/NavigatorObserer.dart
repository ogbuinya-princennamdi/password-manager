import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'activityLogServic.dart';


class MyNavigatorObserver extends NavigatorObserver {
  final List<String> activities;
  MyNavigatorObserver(this.activities);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final activityLogService _logService = activityLogService();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    print('Pushed Route: ${route.settings.name}');
    activities.add('Pushed Route: ${route.settings.name}');
    _logActivity('Navigated to ${route.settings.name}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    print('Popped Route: ${route.settings.name}');
    activities.add('Popped Route: ${route.settings.name}');
    _logActivity('Navigated back from ${route.settings.name}');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    print('Replaced route: ${oldRoute?.settings.name} with ${newRoute?.settings.name}');
    activities.add('Replaced route: ${oldRoute?.settings.name} with ${newRoute?.settings.name}');
  }


  Future<void> _logActivity(String description) async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      await _logService.logUsersActivity( description);
    } else {
      print('User not logged in. Activity not logged.');
    }
  }
}
