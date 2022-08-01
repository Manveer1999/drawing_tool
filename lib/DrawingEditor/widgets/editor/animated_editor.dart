import 'dart:async';
import 'package:drawing_board/DrawingEditor/controller.dart';
import 'package:drawing_board/DrawingEditor/widgets/editor/shapes.dart';
import 'package:drawing_board/commons/drawing_tool_editor.dart';
import 'package:drawing_board/commons/index.dart';
import 'package:flutter/material.dart';

import 'brush.dart';
import 'text.dart';

class DrawingToolAnimatedEditor extends StatefulWidget {

  const DrawingToolAnimatedEditor({
    Key? key,
    required this.data,
    required this.controller
  }) : super(key: key);

  final DrawingToolEditorModel data;

  final ImageEditorController controller;

  @override
  State<DrawingToolAnimatedEditor> createState() => _DrawingToolAnimatedEditorState();
}

class _DrawingToolAnimatedEditorState extends State<DrawingToolAnimatedEditor> {

  late ScrollController scrollController;
  double maxScrollExtent = 0.0;
  ValueNotifier<bool> isExpandable = ValueNotifier(true);

  @override
  void initState() {
    initializeScrollController();
    super.initState();
  }

  void initializeScrollController() {
    scrollController = ScrollController();
    scrollController.addListener(() {
      isExpandable.value = scrollController.offset >= scrollController.position.maxScrollExtent - 30;
    });
  }

  @override
  void didUpdateWidget(DrawingToolAnimatedEditor oldWidget) {

    Timer(const Duration(microseconds: 10), () {
      isExpandable.value = scrollController.offset >= scrollController.position.maxScrollExtent - 30;
    });

    if(oldWidget.data.type != widget.data.type) {
      scrollController.jumpTo(0);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.controller.isEditorVisible ? 45 : 0,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 5
                    ),
                    child: typeToEditor(),
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: isExpandable,
                  builder: (_, bool isExpandable, child) {
                    return !isExpandable ? child! : const SizedBox();
                  },
                  child: IconButton(
                    icon: const Icon(Icons.chevron_right),
                    color: Colors.white,
                    iconSize: 20,
                    onPressed: showHiddenItems,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget typeToEditor() {
    switch(widget.data.type) {
      case DrawingToolEditorType.addShape:
        return DrawingToolShapesEditor(data: widget.data);

      case DrawingToolEditorType.addBrush:
        return DrawingToolBrushEditor(data: widget.data);

      case DrawingToolEditorType.editText:
        return DrawingToolEditorText(
            controller: widget.controller,
            data: widget.data,
        );
      case DrawingToolEditorType.editShape:
        return DrawingToolShapesEditor(data: widget.data, editShapeOnly: true,);

    }
  }

  void showHiddenItems() {
    maxScrollExtent = scrollController.position.maxScrollExtent;
    scrollController.animateTo(
        maxScrollExtent - 30,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
    );
  }
}
