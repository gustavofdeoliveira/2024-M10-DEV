import 'package:flutter/material.dart';
import 'package:mobile/controller/settings_controller.dart';
import 'package:mobile/pages/login_page.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppController.instance,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.green,
            brightness: AppController.instance.isDarkTheme
                ? Brightness.dark
                : Brightness.light,
          ),
          home: LoginPage(),
        );
      },
    );
  }
}
