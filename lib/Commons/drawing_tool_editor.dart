import 'package:drawing_board/DrawingTool/controllers/controllers.dart';
import 'package:flutter/material.dart';

import 'index.dart';

class DrawingToolEditorModel {

  final Map<ShapeFactory, String>? shapes;

  final Function(ShapeFactory? shape)? onSelectingShape;

  final VoidCallback? onTapColor;

  final VoidCallback? onTapStroke;

  final VoidCallback? onTapDelete;

  final String strokeValue;

  final bool isVisible;

  final bool isStrokeActive;

  DrawingToolEditorType type;

  DrawingToolEditorModel({
    this.shapes,
    this.onSelectingShape,
    this.onTapColor,
    this.onTapStroke,
    this.strokeValue = '0',
    this.isVisible = false,
    this.isStrokeActive = false,
    required this.type,
    this.onTapDelete,
  });

}