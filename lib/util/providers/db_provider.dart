import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import './auth_provider.dart';

class DBProvider with ChangeNotifier{
  Map _userDetails = {};
  final Map<String, String> _userInterests = {};

  Future<Map> getUserDetails(BuildContext context) async {
    if (_userDetails.isEmpty) await _getCurrentUserDetails(context);
    return _userDetails;
  }

  Future<Map<String, String>> getUserInterests(BuildContext context) async {
    if (_userDetails.isEmpty) await _getCurrentUserDetails(context);
    if (_userInterests.isEmpty) await _fetchInterest();
    return _userInterests;
  }

  Future<void> _getCurrentUserDetails(BuildContext context) async {
    var currentUserGoogle =
        Provider.of<AuthProvider>(context, listen: false).getCurrentUser;
    var currentUserEmail = Provider.of<AuthProvider>(context, listen: false)
        .getCurrentUserLoggedInWithEmail;

    await FirebaseFirestore.instance
        .collection('user_details')
        .where('email',
        isEqualTo: currentUserGoogle?.email ?? currentUserEmail?.email)
        .limit(1)
        .get()
        .then((result) {
        _userDetails = result.docs.first.data();
    });
  }

  Future<void> _fetchInterest() async {
    if (_userDetails.isEmpty) {
      if (kDebugMode) {
        print('no user details');
      }
      return;
    }
    for (String id in _userDetails['interests']) {
      await FirebaseFirestore.instance
          .collection('topics')
          .where(
        'id',
        isEqualTo: int.parse(id),
      )
          .limit(1)
          .get()
          .then((result) {
        if (kDebugMode) {
          print('interest - ${result.docs.first.data()['name']}');
        }
          _userInterests[id.toString()] = result.docs.first.data()['name'];
      });
    }
  }
}