
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'DrawingEditor/page.dart';

class DrawingTool extends StatelessWidget {
  const DrawingTool({
    Key? key,
    required this.filePath,
    required this.onSave
  }) : super(key: key);

  /// filePath should be local file path, don't add network url
  final String filePath;

  /// onSave will return path of edited image to process further
  final Function(Uint8List savedPath) onSave;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: ImageEditor(
        filePath: filePath,
        onSave: onSave,
      ),
      theme: Theme.of(context),
    );
  }
}
