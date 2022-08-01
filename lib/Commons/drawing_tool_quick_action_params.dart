
import 'dart:ui';

import 'package:drawing_board/DrawingTool/controllers/painter_controller.dart';

class DrawingToolQuickActionParams {

  final int id;
  final Image? backgroundImage;
  final DrawingToolController drawingToolController;
  String? base64String;
  String? title;
  int? jobId;

  DrawingToolQuickActionParams({
    required this.id,
    this.backgroundImage,
    required this.drawingToolController,
    this.base64String,
    this.title,
    this.jobId
  });



}