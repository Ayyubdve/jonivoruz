import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hayvonimuz/elonjoylash.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelectionPage extends StatefulWidget {
  @override
  _ImageSelectionPageState createState() => _ImageSelectionPageState();
}

class _ImageSelectionPageState extends State<ImageSelectionPage> {
  File? _imageFile; // To store the picked image
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _submit() {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select an image'),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      // Handle the image submission here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image selected successfully'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("E'lon Joylash"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageFile == null
                ? Text('No image selected.')
                : Image.file(
                    _imageFile!,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
            SizedBox(height: 16),
            OutlinedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submit,
              child: Text('Submit'),
            ),
            OutlinedButton(
              onPressed: () {
                if (_imageFile != null) {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => ikki(imageUrl: _imageFile!.path),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please select an image first'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
              child: Text("ikkiga otish"),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ImageSelectionPage(),
  ));
}
