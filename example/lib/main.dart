import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graffiti/widget/graffiti_page.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: '涂鸦板演示demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Uint8List? bytes;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final pickerImages = await picker.pickImage(source: ImageSource.gallery);
    if (pickerImages != null) {
      var file = File(pickerImages.path);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GraffitiPage(file: file)),
      ).then((value) => setState(() {
            bytes = value;
          }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: bytes != null ? Image.memory(bytes!) : const Text('暂无图片'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Text('选择\n图片'),
        onPressed: () => pickImage(),
      ),
    );
  }
}
