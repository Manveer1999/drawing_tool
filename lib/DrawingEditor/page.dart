import 'dart:typed_data';

import 'package:drawing_board/DrawingEditor/widgets/bottom_icon.dart';
import 'package:drawing_board/DrawingEditor/widgets/editor/index.dart';
import 'package:drawing_board/DrawingEditor/widgets/editor/shapes.dart';
import 'package:drawing_board/DrawingEditor/widgets/secondary_header/index.dart';
import 'package:drawing_board/DrawingTool/extensions/extensions.dart';
import 'package:drawing_board/DrawingTool/views/widgets/flutter_painter.dart';
import 'package:drawing_board/commons/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';

class ImageEditor extends StatelessWidget {
  const ImageEditor({
    Key? key,
    required this.filePath,
    required this.onSave
  }) : super(key: key);

  /// filePath should be local file path, don't add network url
  final String filePath;

  /// onSave will return edited image to process further
  final Function(Uint8List savedPath) onSave;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImageEditorController>(
      init: ImageEditorController(filePath, onSave),
      global: false,
      builder: (controller) {
        return Material(
          color: Colors.grey.shade800,
          child: Stack(
            children: [
              controller.backgroundImage == null
                  ?  const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ) : Column(
                children: [
                  /// secondary header
                  DrawingToolSecondaryHeader(
                    controller: controller,
                  ),
                  /// canvas
                  Expanded(
                    child: Container(
                      color: Colors.black,
                      child: Center(
                        child: DrawingTool(
                          objectWidgetKey: controller.objectWidgetKey,
                          backgroundAspectRatio: controller.backgroundImage!.width / controller.backgroundImage!.height,
                          isInteractionEnabled: controller.isInDrawableSelectionMode,
                          controller: controller.drawingToolController,
                          onItemTap: controller.setSelectedItemStyle,
                          onTextDrawableCreated: controller.selectAddedTextDrawable,
                          onDrawableCreated: (drawable) {
                            controller.updateForFirstDrawable();
                          },
                        ),
                      ),
                    ),
                  ),


                  /// editor
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // editor
                      SizedBox(
                        height: 80,
                        child: DrawingToolEditor(
                          controller: controller,
                        ),
                      ),

                      const Divider(
                        height: 1.5,
                        thickness: 1.5,
                        color: Colors.black,
                      ),

                      // tools
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // brush tool
                            DrawingToolBottomIcon(
                              icon: Icons.draw_outlined,
                              onTap: () => controller.selectUnselectTool(DrawingToolType.pencil),
                              isActive: controller.selectedToolType == DrawingToolType.pencil,
                            ),
                            const SizedBox(
                              width: 25,
                            ),
                            // text tool
                            DrawingToolBottomIcon(
                              icon: Icons.text_fields_outlined,
                              onTap: () => controller.selectUnselectTool(DrawingToolType.text),
                              isActive: controller.selectedToolType == DrawingToolType.text,
                            ),
                            const SizedBox(
                              width: 25,
                            ),
                            // shapes tool
                            DrawingToolBottomIcon(
                                icon: DrawingToolShapesEditor.getShapeIcon(controller.drawingToolController.shapeFactory),
                                onTap: () => controller.selectUnselectTool(DrawingToolType.shape),
                                isActive: controller.selectedToolType == DrawingToolType.shape || controller.drawingToolController.shapeFactory != null),

                            const SizedBox(
                              width: 25,
                            ),
                            // eraser tool
                            DrawingToolBottomIcon(
                                icon: Icons.crop_portrait,
                                onTap: () => controller.selectUnselectTool(DrawingToolType.eraser),
                                isActive: controller.selectedToolType == DrawingToolType.eraser),
                            const SizedBox(
                              width: 25,
                            ),
                            // user interaction handler
                            DrawingToolBottomIcon(
                              icon: Icons.touch_app_outlined,
                              onTap: () => controller.toggleDrawableSelectionMode(),
                              isActive: controller.isInDrawableSelectionMode,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                ],
              ),

              if(controller.isSaving)
                Container(
                  color: Colors.black26,
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                )

            ],
          ),
        );
      },
    );
  }
}
