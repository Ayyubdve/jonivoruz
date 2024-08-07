import 'package:flutter/material.dart';
import 'package:hayvonimuz/asosiy.dart';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InvestApp(),
    ));

class InvestApp extends StatefulWidget {
  const InvestApp({super.key});

  @override
  State<InvestApp> createState() => _InvestAppState();
}

class _InvestAppState extends State<InvestApp> {
  final TextStyle fnom = TextStyle(fontSize: 50, fontFamily: 'mainfont');
  String nomstr = 'Xush Kelibsiz!';
  double _opacity = 0.0;

  void nomvoid() async {
    await Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _opacity = 1.0;
        });
      }
    });
    await Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          nomstr = 'Xush Kelibsiz!';
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5)).then((value) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          CupertinoPageRoute(builder: (context) => asosiy()),
        );
      }
    });
    nomvoid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.amber, Colors.deepOrange],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
                opacity: _opacity,
                duration: Duration(seconds: 2),
                child: Text(
                  nomstr,
                  style: fnom,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: const Color.fromARGB(255, 3, 62, 111),
                  ),
                  width: 150,
                  height: 150,
                  child: Center(
                    child: Lottie.asset(
                      'rasmlar/cat.json',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
