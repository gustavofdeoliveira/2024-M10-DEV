import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:mobile/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final String url = 'http://10.0.2.2:8000';
  final Logger _logger = Logger('UserRepository');

  UserRepository() {
    _setupLogging();
  }

  void _setupLogging() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord record) {
      // ignore: avoid_print
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
  }

  Future<User> fetchLogin(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$url/auth/sign-in'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email__eq': email,
          'password': password,
        }),
      );
      if (response.statusCode == 200) {
        final userResponse = User.fromJson(json.decode(response.body));
        if (userResponse.accessToken != null) {
          Future<SharedPreferences> prefs = SharedPreferences.getInstance();
          prefs.then((pref) {
            pref.setString('token', userResponse.accessToken ?? '');
            pref.setString('userToken', userResponse.userInfo?.userToken ?? '');
          });
          return userResponse;
        }
      }
      return User();
    } catch (e) {
      _logger.severe('Error in fetchLogin: $e');
      return User();
    }
  }
}
