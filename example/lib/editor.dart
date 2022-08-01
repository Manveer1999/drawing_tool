
import 'dart:typed_data';

import 'package:drawing_board/drawing_tool.dart';
import 'package:flutter/material.dart';

class Editor extends StatelessWidget {
  const Editor({
    Key? key,
    required this.path
  }) : super(key: key);

  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Drawing Tool'),
      ),
      body: DrawingTool(
        filePath: path,
        onSave: (Uint8List editedImage) {
          Navigator.pop(context);
        },
      ),
    );
  }
}
