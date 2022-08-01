import 'package:drawing_board/commons/drawing_tool_editor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller.dart';
import 'editor_icon.dart';

class DrawingToolEditorText extends StatelessWidget {

  const DrawingToolEditorText({
    Key? key,
    required this.controller,
    required this.data
  }) : super(key: key);

  final ImageEditorController controller;

  final DrawingToolEditorModel data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        if(!controller.isInDrawableSelectionMode)...{
          DrawingToolEditorIcon(
            title: 'add'.tr.capitalize!,
            icon: Icons.add,
            onTap: controller.addText,
          ),
        } else...{
          DrawingToolEditorIcon(
            title: 'edit'.tr.capitalize!,
            icon: Icons.edit_outlined,
            onTap: controller.onTapEditText,
          ),
          DrawingToolEditorIcon(
            title: 'delete'.tr.capitalize!,
            icon: Icons.delete_outline,
            onTap: data.onTapDelete,
          ),
        },

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

        DrawingToolEditorIcon(
          title: 'Bold',
          icon: Icons.format_bold,
          onTap: controller.toggleSelectedTextFontWeight,
          isActive: controller.selectedTextFontWeight == FontWeight.bold,
        ),

        DrawingToolEditorIcon(
          title: 'Italic',
          icon: Icons.format_italic,
          onTap: controller.toggleSelectedTextFontStyle,
          isActive: controller.selectedTextFontStyle == FontStyle.italic,
        ),

        DrawingToolEditorIcon(
          title: 'Underline',
          icon: Icons.format_underlined,
          onTap: controller.toggleSelectedTextDecoration,
          isActive: controller.selectedTextDecoration == TextDecoration.underline,
        ),

        DrawingToolEditorIcon(
          title: 'Left',
          icon: Icons.format_align_left,
          onTap: () {
            controller.updateSelectedTextAlign(TextAlign.start);
          },
          isActive: controller.selectedTextAlign == TextAlign.start,
        ),

        DrawingToolEditorIcon(
          title: 'Center',
          icon: Icons.format_align_center,
          onTap: () {
            controller.updateSelectedTextAlign(TextAlign.center);
          },
          isActive: controller.selectedTextAlign == TextAlign.center,
        ),

        DrawingToolEditorIcon(
          title: 'Right',
          icon: Icons.format_align_right,
          onTap: () {
            controller.updateSelectedTextAlign(TextAlign.end);
          },
          isActive: controller.selectedTextAlign == TextAlign.end,
        ),

        DrawingToolEditorIcon(
          title: 'Justify',
          icon: Icons.format_align_justify,
          onTap: () {
            controller.updateSelectedTextAlign(TextAlign.justify);
          },
          isActive: controller.selectedTextAlign == TextAlign.justify,
        ),

      ],
    );
  }
}
