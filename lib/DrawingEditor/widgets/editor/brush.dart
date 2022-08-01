import 'package:drawing_board/commons/drawing_tool_editor.dart';
import 'package:flutter/material.dart';
import 'editor_icon.dart';

class DrawingToolBrushEditor extends StatelessWidget {

  const DrawingToolBrushEditor({
    Key? key,
    required this.data,
  }) : super(key: key);

  final DrawingToolEditorModel data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
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

}
