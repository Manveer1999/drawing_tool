import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:drawing_board/DrawingTool/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:jpeg_encode/jpeg_encode.dart';

class DrawingToolService {
  static Future<Uint8List> saveImage(dynamic backgroundImage, DrawingToolController drawingToolController) async {

    final backgroundImageSize = Size(
        backgroundImage!.width.toDouble(),
        backgroundImage!.height.toDouble());

    final image = await drawingToolController
        .renderImage(backgroundImageSize);


    final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    final jpg = JpegEncoder().compress(data!.buffer.asUint8List(), image.width, image.height, 90);

    return jpg;

  }
}