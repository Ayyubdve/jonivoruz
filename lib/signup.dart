import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bcrypt/bcrypt.dart';

void main() {
  runApp(MaterialApp(
    home: SignUpPage(),
  ));
}

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isLoading11 = false;
  List<String> usersnames = [];
  bool isDataLoading = false;
  String _errorMessage1 = '';
  String hashedPassword = "";
  TextEditingController telefonController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController _controller_userssurname = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isDataLoading = true;
    });

    try {
      final response = await http.get(
          Uri.parse('https://dash.vips.uz/api/13/2838/40539?orderby=id:d'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        List<String> fetchedUsersnames =
            jsonData.map((item) => item['usersname'] as String).toList();
        setState(() {
          usersnames = fetchedUsersnames;
        });
      } else {
        throw Exception('Failed to load data from the API');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isDataLoading = false;
      });
    }
  }

  void _handleButtonPress() {
    String textNomi = telefonController.text.trim();
    String textManzili = usernameController.text.trim();
    String textSumma = passwordController.text.trim();
    String textLoyihanomi = _controller_userssurname.text.trim();

    bool isValid = true;
    bool usernameExists = false;

    // Check if username is empty
    if (textNomi.isEmpty ||
        textManzili.isEmpty ||
        textSumma.isEmpty ||
        textLoyihanomi.isEmpty) {
      setState(() {
        _errorMessage1 = "Barcha maydonlarni to'ldiring!";
      });
      isValid = false;
    } else {
      setState(() {
        _errorMessage1 = "";
      });
    }

    // Check if username already exists
    if (usersnames.contains(textManzili)) {
      setState(() {
        _errorMessage1 = "Bu nom band, boshqa nom kiriting!";
        usernameExists = true;
      });
      isValid = false;
    }

    if (isValid) {
      setState(() {
        _isLoading11 = true; // Show loading indicator
      });

      _postInformationToApi(textNomi, textManzili, textSumma, textLoyihanomi);
    } else {
      // Scroll to the top to show error message
      Scrollable.ensureVisible(context);
    }
  }

  Future<void> _postInformationToApi(String textNomi, String textManzili,
      String textSumma, String textLoyihanomi) async {
    await postData();

    // After posting the data, start the loading process
    _startLoading();
  }

  void _startLoading() {
    setState(() {
      // isLoading = true;
    });

    // Simulate a network request delay
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        // isLoading = false;
        telefonController.clear();
        usernameController.clear();
        passwordController.clear();
        _controller_userssurname.clear();
      });
      Navigator.of(context).pop(); // Navigate back to the previous screen
      _showSnackbar();
    });
  }

  void _showSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saqlandi!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> postData() async {
    final String apiUrl = "https://dash.vips.uz/api-in/13/2838/40539";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'apipassword': '1111',
          'userspassword': hashedPassword,
          'usersphone': telefonController.text,
          'usersname': usernameController.text,
          "userfullname": _controller_userssurname.text,
        },
      );

      if (response.statusCode == 200) {
        print("bom bosh");
      } else {
        print("Registration failed. Status code: ${response.statusCode}");
        print("Response Body: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          SizedBox(height: 20),
          if (isDataLoading)
            Center(child: CircularProgressIndicator())
          else if (usersnames.isNotEmpty)
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: usersnames.map((name) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      'usersname: $name',
                      style: TextStyle(fontSize: 0, color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
        title: Center(child: Text("Ro'yxatdan o'tish")),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ro'yxatdan o'tish orqali dasturdan erkin foydalanish mumkin!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: telefonController,
              decoration: InputDecoration(
                hintText: 'Telefon Raqam',
                fillColor: Colors.grey[200],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                hintText: 'Username',
                fillColor: Colors.grey[200],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _controller_userssurname,
              decoration: InputDecoration(
                hintText: "Ism&Familya",
                fillColor: Colors.grey[200],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                hintText: 'Parol',
                fillColor: Colors.grey[200],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            if (_errorMessage1.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  _errorMessage1,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading11
                    ? null
                    : () async {
                        hashedPassword = await BCrypt.hashpw(
                            passwordController.text, BCrypt.gensalt());
                        _handleButtonPress();
                      },
                child: Text("Ro'yxatdan o'tish"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Profil bormi? ',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Kirish!',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
