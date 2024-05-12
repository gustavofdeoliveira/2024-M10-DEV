// ignore: file_names
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/pages/home_page.dart';
import 'package:mobile/pages/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String name = '';
  String email = '';
  String password = '';

  Future<void> fetchData() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/auth/sign-in'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email__eq': email,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      setState(() {
        var data = json.decode(response.body);
        saveUserData(data); // Save user data to SharedPreferences.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(userData: data),
          ),
        );
      });
    }
  }

  Future<void> saveUserData(dynamic userData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userData', jsonEncode(userData));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  onChanged: (text) {
                    email = text;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  onChanged: (text) {
                    password = text;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: fetchData,
                  child: const Text('Login'),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account?'),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupPage(),
                          ),
                        );
                      },
                      child: const Text('Login'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
