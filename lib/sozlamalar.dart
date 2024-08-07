import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system, // Use system theme mode by default
      home: SettingsPage(),
    );
  }
}

class SettingsController extends GetxController {
  var isDarkMode = false.obs;

  void toggleDarkMode() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}

class SettingsPage extends StatelessWidget {
  final SettingsController settingsController = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sozlamalar'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Dark Mode'),
            trailing: Obx(() => Switch(
                  value: settingsController.isDarkMode.value,
                  onChanged: (value) {
                    settingsController.toggleDarkMode();
                  },
                )),
          ),
          ListTile(
            title: Text('Option 1'),
            onTap: () {
              // Handle Option 1 tap
            },
          ),
          ListTile(
            title: Text('Option 2'),
            onTap: () {
              // Handle Option 2 tap
            },
          ),
          ListTile(
            title: Text('Option 3'),
            onTap: () {
              // Handle Option 3 tap
            },
          ),
        ],
      ),
    );
  }
}
