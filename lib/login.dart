import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hayvonimuz/asosiy.dart';
import 'package:hayvonimuz/signup.dart';
import 'package:http/http.dart' as http;
import 'package:bcrypt/bcrypt.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

Future main() async {
// Initialize FFI
  sqfliteFfiInit();

  databaseFactory = databaseFactoryFfi;
  runApp(loginpage());
}

class loginpage extends StatefulWidget {
  const loginpage({super.key});

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  bool isLoading = false;

  void _startLoading() {
    setState(() {
      isLoading = true;
    });

    // Simulate a network request delay
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
      _showSnackbar();
    });
  }

  void _showSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kirish Muvaffaqiyatli!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  bool fonn = true;

  final still = TextStyle(fontSize: 12, color: Colors.orange);
  List<Map<String, dynamic>> data = [];
  dynamic parol = '';
  dynamic idddlar = 0;
  var ssurname = "";
  var user = "";
  var name = "";
  var nick = "";
  void login(user) async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(
        Uri.parse('https://dash.vips.uz/api/13/2838/40539?usersname=$user'));

    if (correctPassword == true) {
      var pr = Text("${data[idddlar]}");

      print(pr);
    }

    if (response.statusCode == 200) {
      // Parse the JSON data
      final List<dynamic> jsonData = jsonDecode(response.body);

      final datalength = jsonData.length;

      if (datalength > 0) {
        print('ifga kirdi');
        print(jsonData);
        databaseFactory = databaseFactoryFfi;
        // Assuming the API response is a list of Maps
        // Add the data to the 'data' list
        for (var item in jsonData) {
          data.add(Map<String, dynamic>.from(item));

          parol = (item["userspassword"]);
          name = (item["usersname"]);
          ssurname = (item["userfullname"]);
          await SessionManager().set("usersid", (item["id"]));

          await SessionManager().set("tel", (item["usersphone"]));
          await SessionManager().set("usernick", (item["usersname"]));
          await SessionManager().set("ssurname", (item["userfullname"]));

          // ignore: unused_local_variable
          final bool checkPassword = BCrypt.checkpw("userspassword", parol);
        }
        user = _usernameController.text;
        correctPassword = BCrypt.checkpw(_passwordController.text, parol);
        setState(() {
          if (correctPassword == true) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => asosiy()),
              (Route<dynamic> route) =>
                  false, // This will remove all the previous routes
            );
          } else {
            setState(() {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Login yoki parol hato"),
                backgroundColor: Colors.blue,
              ));
            });
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Foydalanuvchi topilmadi"),
          backgroundColor: Colors.amber,
        ));
      }
    } else {
      print('notogri');
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login yoki parol hato")));
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool fon = true;
  bool correctPassword = false;
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Login")),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.blue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.person,
                  size: 100,
                  color: Colors.white,
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            icon: Icon(Icons.email),
                            hintText: 'Username',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            icon: Icon(Icons.lock),
                            hintText: 'Parol',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => SignUpPage()));
                    },
                    child: Text(
                      "Ro'yxatdan o'tish",
                      style: TextStyle(color: Colors.white),
                    )),
                SizedBox(height: 20),
                FittedBox(
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            setState(() {
                              login(_usernameController.text);
                              // _startLoading();
                            });
                          },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(105, 5, 105, 5),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: isLoading
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : Text("Login"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
