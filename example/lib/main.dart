import 'package:drawing_board_demo/editor.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(
    const MaterialApp(
      home: DrawingToolDemo(),
    ),
  );
}

class DrawingToolDemo extends StatefulWidget {
  const DrawingToolDemo({Key? key}) : super(key: key);

  @override
  State<DrawingToolDemo> createState() => _DrawingToolDemoState();
}

class _DrawingToolDemoState extends State<DrawingToolDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Drawing Tool'),
      ),
      body: Center(
        child: TextButton(
          onPressed: pickImage,
          child: const Text('Pick Image'),
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();

    await picker.pickImage(source: ImageSource.gallery).then((value) {

      if(value == null) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Editor(path: value.path),
        ),
      );
    });

  }
}
