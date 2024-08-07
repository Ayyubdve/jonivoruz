import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hayvonimuz/asosiy.dart';
import 'package:hayvonimuz/login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  dynamic id;
  dynamic nick;
  dynamic stafid;
  File? _image;
  final picker = ImagePicker();
  bool _imageSelected = false;
  TextEditingController _controller_idlarim = TextEditingController();
  List<Map<String, dynamic>> data = [];
  String ismi = "";
  String familya = "";
  dynamic tellefon = "";
  int idlarimm = 0;

  void getSessionData() async {
    try {
      nick = await SessionManager().get("usernick");
      id = await SessionManager().get("idlar");
      stafid = await SessionManager().get("usersid");
      setState(() {
        // Update UI with session data
      });
    } catch (e) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData(_controller_idlarim);
    getUserInfo();
    getSessionData();
  }

  Future<void> fetchData(TextEditingController controller_idlarim) async {
    var id = await SessionManager().get("idlar");
    final response = await http
        .get(Uri.parse('https://dash.vips.uz/api/13/953/17330?userid=$id'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        print("useridbor");
        data = List<Map<String, dynamic>>.from(jsonData);
      });
    } else {
      throw Exception('Failed to load data from the API');
    }
  }

  void getUserInfo() async {
    ismi = await SessionManager().get("usernick") ?? "";
    familya = await SessionManager().get("ssurname") ?? "";
    tellefon = await SessionManager().get("tel") ?? "";
    idlarimm = await SessionManager().get("usersid") ?? 0;
    setState(() {});
  }

  Future<void> logout() async {
    // Clear all user information including the profile image
    await SessionManager().destroy();
    setState(() {
      _imageSelected = false;
    });
    // Navigate to the asosiypage and remove all previous routes
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => asosiy()),
      (Route<dynamic> route) =>
          false, // This will remove all the previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: stafid != null
          ? RefreshIndicator(
              onRefresh: () => fetchData(_controller_idlarim),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      color: Colors.blue,
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: <Widget>[
                          _imageSelected
                              ? CircleAvatar(
                                  radius: 50,
                                  backgroundImage: FileImage(_image!),
                                )
                              : CircleAvatar(
                                  radius: 50,
                                  child: Lottie.asset(
                                    'rasmlar/beaer.json',
                                  ),
                                ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$ismi',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                '$familya',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '$tellefon',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Username'),
                      subtitle: Text('$ismi'),
                    ),
                    ListTile(
                      leading: Icon(Icons.edit_document),
                      title: Text('ism&Familyangiz'),
                      subtitle: Text('$familya'),
                    ),
                    ListTile(
                      leading: Icon(Icons.phone),
                      title: Text('Phone'),
                      subtitle: Text('$tellefon'),
                    ),
                    ListTile(
                      leading: Icon(Icons.link),
                      title: Text('Sup Link'),
                      subtitle: Text("${familya}${ismi}"),
                    ),
                    SizedBox(height: 20),
                    stafid != null
                        ? IconButton(
                            onPressed: logout, // Call the logout function
                            icon: Icon(CupertinoIcons.tray_arrow_up_fill),
                          )
                        : IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => loginpage()));
                            },
                            icon: Icon(CupertinoIcons.tray_arrow_down_fill)),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                Spacer(),
                Center(
                  child: Text(
                    "Ro'yxadan O'tmagansiz !",
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  ),
                ),
                Spacer(),
                CircleAvatar(
                  radius: 100,
                  child: Lottie.asset(
                    'rasmlar/no.json',
                  ),
                ),
                Spacer(),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => loginpage()));
                    },
                    icon: Icon(CupertinoIcons.tray_arrow_down_fill)),
              ],
            ),
    );
  }
}
