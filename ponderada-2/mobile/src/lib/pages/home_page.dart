import 'package:flutter/material.dart';
import 'package:mobile/controller/settings_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final dynamic userData;

  HomePage({Key? key, required this.userData}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late final dynamic
      userData; // Declare userData with late as it's initialized in initState.
  int counter = 0;

  @override
  void initState() {
    super.initState();
    loadUserData(); // Initialize userData from the widget.
    // Add any additional initializations here if necessary.
  }

  Future<void> loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString('userData');
    setState(() {
      userData = savedData ?? "No data saved";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Contador: ${userData.name}'),
            CustomSwitcher(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  color: Colors.red,
                ),
                Container(
                  width: 50,
                  height: 50,
                  color: Colors.green,
                ),
                Container(
                  width: 50,
                  height: 50,
                  color: Colors.blue,
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          setState(() {
            counter++;
          });
        },
      ),
    );
  }
}

class CustomSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Switch(
      value: AppController.instance.isDarkTheme,
      onChanged: (value) {
        AppController.instance.changeTheme();
      },
    );
  }
}
