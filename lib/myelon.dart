import 'dart:convert';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_session_manager/flutter_session_manager.dart';

void main() {
  runApp(MaterialApp(
    home: myelon(),
  ));
}

class myelon extends StatefulWidget {
  const myelon({super.key});

  @override
  State<myelon> createState() => _myelonState();
}

class _myelonState extends State<myelon> {
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

  @override
  void initState() {
    super.initState();
    getSessionData();

    Future.delayed(
      Duration(milliseconds: 500),
      () {
        if (stafid != null) {
          fetchData();
        } else {
          setState(() {
            hasError = true;
            errorMessage = "Xozircha ma'lumot yo'q";
          });
        }
      },
    );
  }

  Future<void> fetchData() async {
    setState(() {
      isDataLoading = true;
    });

    try {
      final response = await http.get(
          Uri.parse('https://dash.vips.uz/api/13/2838/39388?userid=$stafid'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          data = List<Map<String, dynamic>>.from(jsonData);
          hasError = false; // Reset error state
        });
      } else {
        throw Exception('Failed to load data from the API');
      }
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = 'Error fetching data from API: $e';
      });
    } finally {
      setState(() {
        isDataLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mening E'lonlarim"),
      ),
      body: isDataLoading
          ? Center(child: CircularProgressIndicator())
          : hasError
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Card(
                        child: Column(
                          children: [
                            Text(data[index]["hayvonnomi"]),
                            Text(data[index]["yoshi"]),
                            Text(data[index]["soglik"]),
                            Text(data[index]["narxi"]),
                            Text(data[index]["manzil"]),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
