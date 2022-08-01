import 'package:drawing_board/DrawingEditor/controller.dart';
import 'package:flutter/material.dart';

import '../bottom_icon.dart';

class DrawingToolSecondaryHeader extends StatelessWidget {
  const DrawingToolSecondaryHeader({
    Key? key,
    required this.controller
  }) : super(key: key);

  final ImageEditorController controller;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16
        ),
        child: Row(
          children: [

            DrawingToolBottomIcon(
              icon: Icons.undo_outlined,
              onTap: controller.undo,
            ),

            const SizedBox(
              width: 5,
            ),


            DrawingToolBottomIcon(
              icon: Icons.redo_outlined,
              onTap: controller.redo,
            ),

            const Spacer(),


            DrawingToolBottomIcon(
              icon: Icons.rotate_right,
              onTap: controller.rotateCanvas,
            ),

            const SizedBox(
              width: 5,
            ),

            DrawingToolBottomIcon(
              icon: Icons.save_outlined,
              onTap: () {
                controller.showSaveOptions();
              },
            ),

            // const SizedBox(
            //   width: 5,
            // ),
            //
            // DrawingToolBottomIcon(
            //   icon: Icons.restart_alt,
            //   onTap: controller.showResetConfirmation,
            // ),

          ],
        ),
      ),
    );
  }
}
