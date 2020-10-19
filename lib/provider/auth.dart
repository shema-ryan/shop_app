import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;
import 'dart:convert';
import '../Exception/httpExcept.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return _token != null;
  }

  String get token {
    if (_token != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _expiryDate != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    if (_userId != null) {
      return _userId;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlAddition) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlAddition?key= AIzaSyBeRpO9pEfabn9b7RgiWqRlORsnq-wOkSQ';
    try {
      final response = await Http.post(url,
          body: jsonEncode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      if (jsonDecode(response.body)['error'] != null) {
        throw HttpExcept(jsonDecode(response.body)['error']['message']);
      }
      _token = jsonDecode(response.body)['idToken'];
      _userId = jsonDecode(response.body)['localId'];
      _expiryDate = DateTime.now().add(
          Duration(seconds: int.parse(jsonDecode(response.body)['expiresIn'])));
    } catch (error) {
      throw error;
    }
    final prefs = await SharedPreferences.getInstance();
    var userDate = jsonEncode({
      'expiryDate': _expiryDate.toIso8601String(),
      'token': _token,
      'userId': _userId,
    });
    prefs.setString('userData', userDate);
    _autoLogOut();
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    final _prefs = await SharedPreferences.getInstance();
    if (!_prefs.containsKey('userData')) {
      return false;
    }
    final _extracted =
        jsonDecode(_prefs.getString('userData')) as Map<String, Object>;
    final timeToTry = DateTime.parse(_extracted['expiryDate']);
    if (timeToTry.isBefore(DateTime.now())) {
      return false;
    }
    _token = _extracted['token'];
    _userId = _extracted['userId'];
    _expiryDate = timeToTry;
    _autoLogOut();
    notifyListeners();
    return true;
  }

  Future<void> signUp({String email, String password}) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn({String email, String password}) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logOut() async {
    _userId = null;
    _expiryDate = null;
    _token = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogOut() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    var _expiryTime = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: _expiryTime), logOut);
  }
}
