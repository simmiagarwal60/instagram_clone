import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/auth_methods.dart';

class userProvider with ChangeNotifier{
  final AuthMethods _authMethods = AuthMethods();
  user? _user;

  user get getUser => _user!;
  Future<void> refreshUser() async{
    user users = await _authMethods.getUserDetails();
    _user = users;
    notifyListeners();
  }
}

