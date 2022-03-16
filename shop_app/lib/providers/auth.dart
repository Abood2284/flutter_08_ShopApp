import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../model/https_exception.dart';

class Auth extends ChangeNotifier {
  String? _token;
  DateTime? _expiryTimeToken;
  String? _userId;

  ///* Returns true then user is Authenticated, becuase token is not null and user is authenticated
  bool get isAuth {
    return token != null;
  }

  ///* Gets you the token only if the cond are met else it returns [null]
  String? get token {
    if (_token != null &&
        _expiryTimeToken!.isAfter(DateTime.now()) &&
        _expiryTimeToken != null) {
      return _token;
    }
    return null;
  }

  Future<void> signup(String email, String password) async {
    /// * Read this [https://firebase.google.com/docs/reference/rest/auth/] for more auth process
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDcJsVc6gFxZo9lg7BuOaKmjXEquepoMC4');
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,

            /// To know how many args to pass read the link attached
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      /// * For more returned response you can check the official docs
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryTimeToken = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn']))); // Firebase returns us a String of seconds in which it will expire
          // That means from [current time] + [the seconds returned by firebase] = expireTime
        notifyListeners();
    } catch (error) {
      rethrow;
    }
    // logger.d(response);
  }

  Future<void> login(String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDcJsVc6gFxZo9lg7BuOaKmjXEquepoMC4');
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,

            /// To know how many args to pass read the link attached
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
       _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryTimeToken = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
          notifyListeners();
    } catch (error) {
      rethrow;
    }
    // logger.d(response);
  }
}
