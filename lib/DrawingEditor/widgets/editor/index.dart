import 'package:drawing_board/commons/drawing_tool_editor.dart';
import 'package:drawing_board/commons/index.dart';
import 'package:flutter/material.dart';
import '../../controller.dart';
import 'animated_editor.dart';
import 'slider.dart';

class DrawingToolEditor extends StatelessWidget {

  const DrawingToolEditor({
    Key? key,
    required this.controller
  }) : super(key: key);

  final ImageEditorController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        DrawingToolAnimatedEditor(
          data: DrawingToolEditorModel(
            type: controller.editorType,
            shapes: controller.shapes,
            onSelectingShape: controller.selectShape,
            onTapColor: controller.showColorPicker,
            strokeValue: controller.getStrokeWidth().toInt().toString(),
            onTapStroke: controller.toggleStrokeSelection,
            onTapDelete: controller.removeSelectedDrawable,
          ),
          controller: controller,
        ),

        DrawingToolEditorSlider(
          value: controller.getStrokeWidth(),
          title: controller.isSelectedDrawableIsText || controller.selectedToolType == DrawingToolType.text
              ? 'Font Size'
              : 'Stroke',
          displayValue: '${controller.getStrokeWidth().round()}',
          displayUnit: 'pt',
          onChanged: controller.setDrawableStrokeWidth,
          divisions: controller.isSelectedDrawableIsText ? 41 : 19,
          minValue: 1,
          maxValue: controller.isSelectedDrawableIsText ? 50 : 20,
          isVisible: controller.isStrokeActive,
          onTapBack: controller.toggleStrokeSelection,
          isBackButtonVisible: controller.selectedToolType != DrawingToolType.eraser && !controller.isEditorVisible,
        ),


      ],
    );
  }

}

