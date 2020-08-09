import 'dart:convert';
import 'package:ShopApp/ErrorHandlers/httperroe.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expirytime;
  Timer _authtimer;
  String _userid;
  String get userid {
    return _userid;
  }

  bool get isauth {
    if (token != null) {
      return true;
    }
    return false;
  }

  String get token {
    if (_token != null &&
        _expirytime != null &&
        _expirytime.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  Future<void> signinup(Map<String, String> map, String suburl) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$suburl?key=AIzaSyDAPhP-9BUNORRRmeRmrjs7v4sn8EiPQ3U';
    try {
      var res = await http.post(url,
          body: json.encode({
            'email': map['email'],
            'password': map['password'],
            'returnSecureToken': true
          }));
      final resdata = json.decode(res.body);
      if (resdata['error'] != null) {
        throw HttpException(resdata['error']['message']);
      }
      _token = resdata['idToken'];
      _expirytime = DateTime.now()
          .add(Duration(seconds: int.tryParse(resdata['expiresIn'])));
      _userid = resdata['localId'];
      print(_userid);
      autologout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userdata = json.encode({
        'token': _token,
        'userid': _userid,
        'expiryDate': _expirytime.toIso8601String()
      });
      prefs.setString('userdata', userdata);
    } catch (err) {
      throw err;
    }
  }

  Future<void> logout() async {
    _token = null;
    _userid = null;
    _expirytime = null;
    if (_authtimer != null) {
      _authtimer.cancel();
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<void> autologout() async {
    if (_authtimer != null) {
      _authtimer.cancel();
    }
    final diff = _expirytime.difference(DateTime.now()).inSeconds;
    _authtimer = Timer(Duration(seconds: diff), () {
      logout();
    });
  }

  Future<bool> trylogging() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userdata')) {
      return false;
    }
    final extracteddata = prefs.getString('userdata');
    final data = json.decode(extracteddata);
    final expirydate = DateTime.parse(data['expiryDate']);
    if (expirydate.isBefore(DateTime.now())) {
      return false;
    }
    _token = data['token'];
    _userid = data['userid'];
    _expirytime = expirydate;
    notifyListeners();
    autologout();
    return true;
  }
}
