import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final url = 'http://10.0.2.2:8000';

  Future<User> fetchLogin(email, password) async {
    try {
      final response = await http.post(
        Uri.parse('${url}/auth/sign-in'), // Corrected endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email__eq': email, // Corrected field name
          'password': password,
        }),
      );
      if (response.statusCode == 200) {
        final userResponse = User.fromJson(json.decode(response.body));
        if (userResponse.accessToken != null) {
          Future<SharedPreferences> prefs = SharedPreferences.getInstance();
          prefs.then((pref) {
            pref.setString('token', userResponse.accessToken ?? '');
          });
          fetchTokenUser(userResponse.accessToken);
          return userResponse;
        }
      }
      return User();
    } catch (e) {
      print(e);
      return User();
    }
  }

  Future<UserInfo> fetchTokenUser(token) async {
    try {
      final response = await http.get(
        Uri.parse('$url/auth/me'), // Corrected endpoint
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      if (response.statusCode == 200) {
        final userResponse = UserInfo.fromJson(json.decode(response.body));
        if (userResponse.userToken != null) {
          Future<SharedPreferences> prefs = SharedPreferences.getInstance();
          prefs.then((pref) {
            pref.setString('UserToken', userResponse.userToken ?? '');
          });
          return userResponse;
        }
      }
      return UserInfo();
    } catch (e) {
      print(e);
      return UserInfo();
    }
  }
}
