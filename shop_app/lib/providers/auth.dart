// Manages the whole authentication logic of the app
import 'dart:convert';
import 'dart:async'; // allows us to run code async, so runs the code in the future when the timer expires

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../model/https_exception.dart';

class Auth extends ChangeNotifier {
  String? _token;
  DateTime? _expiryTimeToken;
  String? _userId;
  Timer? _authTimer;

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

  String? get userId {
    return _userId;
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
      _expiryTimeToken = DateTime.now().add(Duration(
          seconds: int.parse(responseData[
              'expiresIn']))); // Firebase returns us a String of seconds in which it will expire
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
      // Once the user is treated as logged in strt the timer to autoLogout
      _autoLogout();
      notifyListeners();
      // Working with shared preference to store data(token) in the device storage
      // .getInstance returns a future so to store the value instead of future we use await to get the value
      // Everything works here in key pair
      final prefs = await SharedPreferences.getInstance();
      // as prefs only can set String, int double etc, so to store Dynamic values
      // you can use json.encode as json always works with String so whatever you pass to json it converts it to string
      final _userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryTime': _expiryTimeToken?.toIso8601String(),
        },
      );
      prefs.setString('userData', _userData);
    } catch (error) {
      rethrow;
    }
    // logger.d(response);
  }

// Returns bool based on if we are succesful in finding a valid token and based on that we will render different screens
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    // We didnt find any key so there is no data
    if (!prefs.containsKey('userData')) {
      return false;
    }
    // but if there is data we need to check if it is valid or not
    // it will return string but we need map so we decode it into map
    final extractedData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final extractedDate = DateTime.parse(extractedData['expiryTime']);

// If true we know that the token is expired
    if (extractedDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedData['token'];
    _userId = extractedData['userId'];
    _expiryTimeToken = extractedDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  void logout() {
    _userId = null;
    _token = null;
    _expiryTimeToken = null;
    if (_authTimer != null) {
      _authTimer?.cancel();
      _authTimer = null;
    }
    notifyListeners();
  }

  void _autoLogout() {
    // make sure you cancel the old timer before creating a new
    if (_authTimer != null) {
      _authTimer?.cancel();
    }
    final timeToExpiry = _expiryTimeToken?.difference(DateTime.now()).inSeconds;

    /// Takes a [Duration] sayin when it should expire
    /// also takes a [function] should be called when the timer expires
    _authTimer = Timer(Duration(seconds: timeToExpiry!), logout);
  }
}
