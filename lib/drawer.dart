import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:hayvonimuz/ijtarmoq.dart';
import 'package:hayvonimuz/login.dart';
import 'package:hayvonimuz/sozlamalar.dart';
import 'package:hayvonimuz/yangilik.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

class mydrawer extends StatefulWidget {
  @override
  _mydrawerState createState() => _mydrawerState();
}

class _mydrawerState extends State<mydrawer> {
  dynamic id;
  dynamic nick;
  dynamic stafid;
  bool isDataLoading = false;
  bool hasError = false;
  String errorMessage = '';

  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> savedMessages = [];

  void getSessionData() async {
    try {
      nick = await SessionManager().get("usernick");
      id = await SessionManager().get("idlar");
      stafid = await SessionManager().get("usersid");
      setState(() {
        print("Session data retrieved: $stafid");
      });
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = 'Failed to retrieve session data';
      });
    }
  }

  late List<CollapsibleItem> _items;
  late String _headline;

  @override
  void initState() {
    super.initState();
    _items = _generateItems;
    _headline = 'Home Screen';
    getSessionData();
  }

  List<CollapsibleItem> get _generateItems {
    return [
      CollapsibleItem(
        text: 'Yangiliklar',
        icon: Icons.newspaper,
        onPressed: () {
          print(stafid);
          Navigator.push(
              context, CupertinoPageRoute(builder: (context) => yangilik()));
        },
        isSelected: true,
      ),
      CollapsibleItem(
        text: 'Color & Design',
        icon: Icons.color_lens,
        onPressed: () => setState(() => _headline = 'Color & Design'),
      ),
      CollapsibleItem(
        text: 'Ijtimoiy Tarmoqlar',
        icon: CupertinoIcons.square_stack_fill,
        onPressed: () {
          Navigator.push(
              context, CupertinoPageRoute(builder: (context) => ijtarmoq()));
        },
      ),
      CollapsibleItem(
        text: 'Login Options',
        icon: Icons.login,
        onPressed: () {
          Navigator.push(
              context, CupertinoPageRoute(builder: (context) => loginpage()));
        },
      ),
      CollapsibleItem(
        text: 'Close Menu',
        icon: Icons.close,
        onPressed: () => setState(() => _headline = 'Close Menu'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CollapsibleSidebar(
          items: _items,
          title: "Jonivor.Uz",
          onTitleTap: () {},
          unselectedTextColor: Colors.black,
          backgroundColor: Colors.orange,
          selectedTextColor: Colors.white,
          textStyle: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
          titleStyle: TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
          toggleTitleStyle: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          sidebarBoxShadow: [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 10,
              spreadRadius: 0.01,
              offset: Offset(3, 3),
            ),
          ],
          body: Text(".")),
    );
  }
}
