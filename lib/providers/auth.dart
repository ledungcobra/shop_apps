import 'package:flutter/foundation.dart';
import 'package:flutter_complete_guide/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  bool get isAuth {
    return token!=null;

  }
  String get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())
        ) {
          return _token;
        }else{
          return null;
        }
  }
  String get userId{
    return _userId;
    
  }
  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    String url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCw58SHw3GhGuJUltbTvzcHlcnhRC7Z6OE';

    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
     
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.tryParse(responseData['expiresIn'])));
      notifyListeners();

    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }
}
