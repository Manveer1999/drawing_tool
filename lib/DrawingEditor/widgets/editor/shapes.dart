import 'package:drawing_board/DrawingTool/controllers/controllers.dart';
import 'package:drawing_board/commons/drawing_tool_editor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'editor_icon.dart';

class DrawingToolShapesEditor extends StatelessWidget {

  const DrawingToolShapesEditor({
    Key? key,
    required this.data,
    this.editShapeOnly = false,
  }) : super(key: key);

  final DrawingToolEditorModel data;

  final bool editShapeOnly;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if(data.shapes != null && !editShapeOnly)
          ...data.shapes!.entries.map((e) {
            return DrawingToolEditorIcon(
              title: e.value,
              icon: getShapeIcon(e.key),
              onTap: () {
                data.onSelectingShape!(e.key);
              },
            );
          }),

        if(editShapeOnly)
          DrawingToolEditorIcon(
            title: 'Delete'.capitalize!,
            icon: Icons.delete_outline,
            onTap: data.onTapDelete,
          ),

        DrawingToolEditorIcon(
          title: 'Color',
          icon: Icons.color_lens_outlined,
          onTap: data.onTapColor,
        ),

        DrawingToolEditorIcon(
          title: 'Stroke',
          value: '${data.strokeValue}pt',
          onTap: data.onTapStroke,
          isActive: data.isStrokeActive,
        ),

      ],
    );
  }

  static IconData getShapeIcon(ShapeFactory? shapeFactory) {
    if (shapeFactory is LineFactory) return Icons.show_chart;
    if (shapeFactory is ArrowFactory) return Icons.arrow_forward;
    if (shapeFactory is DoubleArrowFactory) return Icons.open_in_full;
    if (shapeFactory is RectangleFactory) return Icons.crop_square;
    if (shapeFactory is OvalFactory) return Icons.radio_button_unchecked;
    return Icons.interests_outlined;
  }

}
