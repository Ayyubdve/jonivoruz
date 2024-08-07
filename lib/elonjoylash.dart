import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

void main() => runApp(MaterialApp(
      home: ikki(
        imageUrl: "", // Ensure you pass the correct image URL here.
      ),
    ));

class ikki extends StatefulWidget {
  final String imageUrl;

  const ikki({
    required this.imageUrl,
  });

  @override
  State<ikki> createState() => _ikkiState();
}

class _ikkiState extends State<ikki> {
  TextEditingController nomi = TextEditingController();
  TextEditingController yoshi = TextEditingController();
  TextEditingController soglik = TextEditingController();
  TextEditingController narxi = TextEditingController();
  TextEditingController manzil = TextEditingController();
  TextEditingController turi = TextEditingController();
  TextEditingController userid = TextEditingController();

  Future<void> _postDataToApi() async {
    setState(() {});

    final String apiUrl = "https://dash.vips.uz/api-in/13/2838/39388";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: {
          "apipassword": "1111",
          "hayvonnomi": nomi.text,
          "yoshi": yoshi.text,
          "soglik": soglik.text,
          "rasmi": "https://imgur.com/a/KWWB66w",
          "narxi": narxi.text,
          "manzil": manzil.text,
          "turi": turi.text,
          "userid": userid.text,
        },
      );

      if (response.statusCode == 200) {
        _showSnackbar('Saqlandi!');
      } else {
        _showSnackbar('Saqlanmadi!');
      }
    } catch (e) {
      _showSnackbar("Xatolik yuz berdi, qayta urinib koring.");
    } finally {
      setState(() {});
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 5),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Removed _postDataToApi() from here as it might cause issues.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("data")),
      ),
      body: Column(
        children: [
          TextField(
            controller: nomi,
            decoration: InputDecoration(hintText: "hayvonnomi"),
          ),
          TextField(
            controller: yoshi,
            decoration: InputDecoration(hintText: "yoshi"),
          ),
          TextField(
            controller: soglik,
            decoration: InputDecoration(hintText: "soglik"),
          ),
          TextField(
            controller: narxi,
            decoration: InputDecoration(hintText: "narxi"),
          ),
          TextField(
            controller: manzil,
            decoration: InputDecoration(hintText: "manzil"),
          ),
          TextField(
            controller: turi,
            decoration: InputDecoration(hintText: "turi"),
          ),
          TextField(
            controller: userid,
            decoration: InputDecoration(hintText: "userid"),
          ),
          OutlinedButton(
            onPressed: _postDataToApi,
            child: Text("E'lonni joylash"),
          ),
          widget.imageUrl.isNotEmpty
              ? Container(
                  width: 100,
                  height: 50,
                  child: Image.file(File(widget.imageUrl)),
                )
              : Container()
        ],
      ),
    );
  }
}
