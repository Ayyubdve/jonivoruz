import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: ijtarmoq(),
    ));

class ijtarmoq extends StatefulWidget {
  const ijtarmoq({super.key});

  @override
  State<ijtarmoq> createState() => _ijtarmoqState();
}

class _ijtarmoqState extends State<ijtarmoq> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ijtimoiy Tarmoq"),
      ),
      body: Text("Ijtimoiy Tarmoq"),
    );
  }
}
