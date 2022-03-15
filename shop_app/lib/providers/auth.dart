import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class Auth extends ChangeNotifier {
  late String token;
  late DateTime expiryTimeToken;
  late String userId;

  Future<void> signup(String email, String password) async {
    /// * Read this [https://firebase.google.com/docs/reference/rest/auth/] for more auth process
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDcJsVc6gFxZo9lg7BuOaKmjXEquepoMC4');
    final response = await http.post(url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
          /// To know how many args to pass read the link attached
        }));
    logger.d(response);
  }
}
