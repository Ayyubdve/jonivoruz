import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: yangilik(),
    ));

class yangilik extends StatefulWidget {
  const yangilik({super.key});

  @override
  State<yangilik> createState() => _yangilikState();
}

class _yangilikState extends State<yangilik> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yangiliklar"),
      ),
      body: Text("Yangiliklar"),
    );
  }
}
