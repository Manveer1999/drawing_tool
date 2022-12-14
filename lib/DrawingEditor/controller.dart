import 'dart:io';
import 'dart:typed_data';

import 'package:drawing_board/ColorPicker/index.dart';
import 'package:drawing_board/Commons/service.dart';
import 'package:drawing_board/DrawingTool/controllers/controllers.dart';
import 'package:drawing_board/DrawingTool/extensions/extensions.dart';
import 'package:drawing_board/DrawingTool/views/widgets/flutter_painter.dart';
import 'package:drawing_board/commons/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;

class ImageEditorController extends GetxController
    with GetTickerProviderStateMixin {

  ImageEditorController(this.filePath, this.onSave);

  /// filePath should be local file path, don't add network url
  final String filePath;

  /// onSave will return edited image to process further
  final Function(Uint8List savedPath) onSave;

  DrawingToolController drawingToolController = DrawingToolController(); // helps is controlling drawing elements

  ui.Image? backgroundImage; // used to display background image

  bool isShapeActive = false; // used to show/hide shapes editor (circle, rectangle etc.)
  bool isStrokeActive = false; // used to show/hide stroke editor
  bool isSelectedDrawableIsText = false; // helps in differentiating text and other elements
  bool isInDrawableSelectionMode = false; // used to enable/disable drawable selection
  bool isToolBarVisible = true; // used to hide/show tool bar
  bool isEditorVisible = false; // used to hide/show editor
  bool isSaving = false;

  DrawingToolType selectedToolType = DrawingToolType.none; // helps in tools selection
  TextAlign selectedTextAlign = TextAlign.start; // used to set text alignment
  FontWeight selectedTextFontWeight = FontWeight.normal; // used to set text font weight
  FontStyle selectedTextFontStyle = FontStyle.normal; // used to set font style
  TextDecoration selectedTextDecoration = TextDecoration.none; // used to set text decoration

  final objectWidgetKey = GlobalKey<ObjectWidgetState>();

  Map<ShapeFactory, String> shapes = {
    LineFactory(): 'Line',
    OvalFactory(): 'Circle',
    RectangleFactory(): 'Rectangle',
    ArrowFactory(): 'Arrow',
    DoubleArrowFactory(): 'D. Arrow',
  }; // list of shapes to select from

  Paint shapePaint = Paint()
    ..strokeWidth = 2
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round; // default drawable style

  late String backgroundUrl;

  DrawingToolEditorType editorType = DrawingToolEditorType.addShape;

  @override
  void onInit() {
    backgroundUrl = filePath;
    setUpDrawingController();
    selectUnselectTool(DrawingToolType.shape);
    super.onInit();
  }

  // setUpBgImage() : will load image from network
  void setUpBgImage() async {
    ui.Image image = await FileImage(
        File(backgroundUrl),
    ).image;
    backgroundImage = image;

    // creating a canvas background
    drawingToolController.background = image.backgroundDrawable;
    update();
  }

  // setUpDrawingController() : will initialize drawing controller
  void setUpDrawingController() {
    drawingToolController = DrawingToolController(
      settings: DrawingToolController.defaultPainterSettings(shapePaint),
    );
    // setting up bg image for canvas
    setUpBgImage();
  }

  // selectUnselectTool() : helps in selecting and unselecting drawing tool
  void selectUnselectTool(DrawingToolType drawingToolType) {

    isInDrawableSelectionMode = false;

    if(selectedToolType == drawingToolType) return;

    isSelectedDrawableIsText = false;
    drawingToolController.freeStyleStrokeWidth = 10;

    switch (drawingToolType) {
      case DrawingToolType.none:
        toggleStrokeSelection();
        break;
      case DrawingToolType.eraser:
        toggleEraser();
        break;
      case DrawingToolType.pencil:
        toggleBrush();
        break;
      case DrawingToolType.text:
        toggleText();
        break;
      case DrawingToolType.shape:
        toggleShapes();
        break;
    }

    selectedToolType = selectedToolType == drawingToolType
        ? DrawingToolType.none
        : drawingToolType;

    isStrokeActive = selectedToolType == DrawingToolType.eraser;

    editorType = getEditorType();

    update();
  }

  // toggleEraser() : will toggle eraser selection
  void toggleEraser() {
    isSelectedDrawableIsText = false;
    drawingToolController.shapeFactory = null;
    drawingToolController.freeStyleMode =
    drawingToolController.freeStyleMode != FreeStyleMode.erase
        ? FreeStyleMode.erase
        : FreeStyleMode.none;
  }

  // toggleBrush() : will toggle brush selection
  void toggleBrush() {
    isSelectedDrawableIsText = false;
    drawingToolController.shapeFactory = null;
    drawingToolController.freeStyleMode =
    drawingToolController.freeStyleMode != FreeStyleMode.draw
        ? FreeStyleMode.draw
        : FreeStyleMode.none;
  }


  // addText() : will open up text dialog to add text
  void addText() {
    // unselecting other tools
    drawingToolController.freeStyleMode = FreeStyleMode.none;
    isStrokeActive = false;
    drawingToolController.shapeFactory = null;
    drawingToolController.textSettings = drawingToolController.textSettings.copyWith(
      textStyle: drawingToolController.textSettings.textStyle.copyWith(
        fontSize: drawingToolController.textSettings.textStyle.fontSize,
        color: drawingToolController.freeStyleColor,
        fontStyle: selectedTextFontStyle,
        fontWeight: selectedTextFontWeight,
        decoration: selectedTextDecoration,
      ),
    );
    drawingToolController.addText(); // will display text dialog and add text
    update();
  }

  // selectShape() : helps is selecting shape from [shapes] map
  void selectShape(ShapeFactory? factory) {
    isShapeActive = false; // will hide shape selector
    drawingToolController.shapeFactory = factory;
    update();
  }

  // toggleText() : helps is toggling text selector
  void toggleText() {
    isSelectedDrawableIsText = true;
    drawingToolController.freeStyleMode = FreeStyleMode.none;
    drawingToolController.textSettings = drawingToolController.textSettings.copyWith(
      textStyle: drawingToolController.textSettings.textStyle.copyWith(
          fontSize: 12
      ),
    );
    if (drawingToolController.shapeFactory != null) {
      drawingToolController.shapeFactory = null;
      isStrokeActive = false; // closing stroke editor
    }
  }

  // toggleShapes() : helps is toggling shapes selector
  void toggleShapes() {
    isSelectedDrawableIsText = false;
    drawingToolController.freeStyleMode = FreeStyleMode.none;
    if (drawingToolController.shapeFactory != null) {
      drawingToolController.shapeFactory = null;
      isStrokeActive = false; // closing stroke editor
    }
  }

  // removeSelectedDrawable() : will delete/remove selected drawable
  void removeSelectedDrawable() {
    final selectedDrawable = drawingToolController.selectedObjectDrawable;
    if (selectedDrawable != null) {
      drawingToolController.removeDrawable(selectedDrawable);
    }
    isStrokeActive = false; // closing editor after removing item
    isSelectedDrawableIsText = false; // managing state for text editor
    update();
    selectLastAddedObjectDrawable();
  }

  // redo() : will redo is any other displays a message
  void redo() {
    if (!drawingToolController.canRedo) {
      return;
    }
    drawingToolController.redo();
    update();
  }

  void undo() {
    if (!drawingToolController.canUndo) {
      return;
    }
    drawingToolController.undo();
    update();
  }

  // toggleDrawableSelectionMode() : will help is enabling/disabling user interaction with drawables
  void toggleDrawableSelectionMode() {

    if(isInDrawableSelectionMode) return;

    isInDrawableSelectionMode = true;
    isStrokeActive = false;
    // unselecting all tools
    drawingToolController.freeStyleMode = FreeStyleMode.none;
    drawingToolController.shapeFactory = null;
    selectedToolType = DrawingToolType.none;
    selectLastAddedObjectDrawable();

    update();
  }

  Future<void> onTapEditText() async {
    objectWidgetKey.currentState?.tapDrawable(drawingToolController.selectedObjectDrawable!, openEditor: true);
  }

  void selectLastAddedObjectDrawable() {

    try {
      if (drawingToolController.drawables.isNotEmpty) {
        final drawable = drawingToolController.drawables.reversed.firstWhere((
            element) => element is ObjectDrawable);

        isSelectedDrawableIsText = drawable is TextDrawable;

        drawingToolController.selectObjectDrawable(drawable as ObjectDrawable);
        editorType = getEditorType(drawable: drawable);
        setSelectedItemStyle(drawable, false);
      } else {
        isEditorVisible = false;
      }
    } catch (e) {
      drawingToolController.selectObjectDrawable(null);
      editorType = getEditorType();
    }
  }

  // toggleStrokeSelection() : used to show/hide stroke editor
  void toggleStrokeSelection() {
    isStrokeActive = !isStrokeActive;
    editorType = getEditorType(drawable: isInDrawableSelectionMode
        ? drawingToolController.selectedObjectDrawable
        : null);
    update();
  }

  // showColorPicker() : will display color picker to choose color from
  void showColorPicker() async {

    Get.bottomSheet(
      MyColorPicker(
        initialColor: drawingToolController.freeStyleColor,
        onColorApplied: (color) {
          setDrawableColor(color ?? Colors.black);
        },
      ),
      isScrollControlled: true,
    );
    update();
  }

  // updateDrawnDrawable() : helps in editing already drawn drawables
  void updateDrawnDrawable() {
    // getting properties of currently selected drawable
    final selectedDrawable = drawingToolController.selectedObjectDrawable;

    if (selectedDrawable == null) return;

    ObjectDrawable newDrawable;

    // in case it is text updating accordingly
    if (isSelectedDrawableIsText) {
      newDrawable = TextDrawable(
          text: (selectedDrawable.textPainter!.text as TextSpan).text.toString(),
          style: TextStyle(
            color: drawingToolController.freeStyleColor,
            fontSize: drawingToolController.textSettings.textStyle.fontSize,
            fontWeight: selectedTextFontWeight,
            fontStyle: selectedTextFontStyle,
            decoration: selectedTextDecoration,
          ),
          position: selectedDrawable.position,
          scale: selectedDrawable.scale,
          textAlign: selectedTextAlign);
    } else {
      // in case it is shape update accordingly
      newDrawable = selectedDrawable.copyWith(
          paint: Paint()
            ..color = drawingToolController.freeStyleColor
            ..strokeWidth = drawingToolController.freeStyleStrokeWidth
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke,
          rotation: selectedDrawable.rotationAngle
      );
    }

    drawingToolController.replaceDrawable(selectedDrawable, newDrawable, newAction: false);
  }

  // setDrawableStrokeWidth() : is used to set stroke width of drawable
  void setDrawableStrokeWidth(double value) {
    drawingToolController.shapePaint = shapePaint.copyWith(
        strokeWidth: value > 20 ? 2 : value,
        color: drawingToolController.freeStyleColor);

    drawingToolController.freeStyleStrokeWidth = value > 20 ? 2 : value;

    drawingToolController.textSettings = drawingToolController.textSettings.copyWith(
        textStyle: drawingToolController.textSettings.textStyle.copyWith(fontSize: value));

    if (isInDrawableSelectionMode) {
      updateDrawnDrawable();
    }
    update();
  }

  // setDrawableColor() : will set drawable color
  void setDrawableColor(Color color) {
    drawingToolController.shapePaint = shapePaint.copyWith(color: color, strokeWidth: getStrokeWidth());

    drawingToolController.freeStyleColor = color;

    if (isInDrawableSelectionMode) {
      updateDrawnDrawable();
    }

    update();
  }

  // setDrawableColor() : set editor as per selected item (eg. color, stroke etc.)
  Future<void> setSelectedItemStyle(Drawable? drawable, bool isEditingText) async {

    if(drawable == null) {
      isSelectedDrawableIsText = false;
      toggleIsToolBarVisible(!isToolBarVisible);
    } else {
      toggleIsToolBarVisible(true);
    }

    editorType = getEditorType(drawable : drawable);

    await Future<void>.delayed(const Duration(milliseconds: 200));

    // getting selected item
    final selectedDrawable = drawingToolController.selectedObjectDrawable;

    // on unselecting drawables resetting editor
    if (selectedDrawable == null) {
      // isStrokeActive = selectedToolType == DrawingToolType.eraser;
      selectedTextFontWeight = FontWeight.normal;
      selectedTextFontStyle = FontStyle.normal;
      selectedTextDecoration = TextDecoration.none;
      if(isInDrawableSelectionMode) {
        isStrokeActive = selectedToolType == DrawingToolType.eraser;
      }
    } else {
      isStrokeActive = isInDrawableSelectionMode ? isStrokeActive : true; // displaying stroke editor
      isSelectedDrawableIsText = selectedDrawable is TextDrawable;

      if (isSelectedDrawableIsText) {
        selectedTextAlign = selectedDrawable.textPainter!.textAlign;
        selectedTextFontWeight = (selectedDrawable as TextDrawable).style.fontWeight ?? FontWeight.normal;
        selectedTextFontStyle = selectedDrawable.style.fontStyle ?? FontStyle.normal;
        selectedTextDecoration = selectedDrawable.style.decoration ?? TextDecoration.none;

        TextPainter textPainter = selectedDrawable.textPainter;

        drawingToolController.textSettings = drawingToolController.textSettings.copyWith(
          textStyle: drawingToolController.textSettings.textStyle.copyWith(
            fontSize: textPainter.text!.style!.fontSize,
            color: textPainter.text!.style!.color!,
            fontStyle: textPainter.text!.style!.fontStyle ?? selectedTextFontStyle,
            fontWeight: textPainter.text!.style!.fontWeight ?? selectedTextFontWeight,
            decoration: textPainter.text!.style!.decoration ?? selectedTextDecoration,
          ),
        );

      } else {
        Paint paint = selectedDrawable.objectPaint ?? Paint();
        setDrawableColor(paint.color);
        setDrawableStrokeWidth(paint.strokeWidth);
      }
    }

    update();
  }

  // getStrokeWidth(): will return font size/stroke width
  double getStrokeWidth() {
    if (drawingToolController.shapeFactory != null) {
      return drawingToolController.shapePaint?.strokeWidth ?? 1;
    } else if (isSelectedDrawableIsText || selectedToolType == DrawingToolType.text) {
      return drawingToolController.textStyle.fontSize ?? 1;
    } else {
      return drawingToolController.freeStyleStrokeWidth > 20
          ? 2
          : drawingToolController.freeStyleStrokeWidth;
    }
  }

  // updateSelectedTextAlign() : will set selected text alignment
  void updateSelectedTextAlign(TextAlign textAlign) {
    selectedTextAlign = textAlign;
    updateDrawnDrawable();
    update();
  }

  // toggleSelectedTextFontWeight() : will toggle between normal and bold font weight
  void toggleSelectedTextFontWeight() {
    selectedTextFontWeight = selectedTextFontWeight == FontWeight.bold
        ? FontWeight.normal
        : FontWeight.bold;
    updateDrawnDrawable();
    update();
  }

  // toggleSelectedTextFontStyle() : will toggle between normal and italic font style
  void toggleSelectedTextFontStyle() {
    selectedTextFontStyle = selectedTextFontStyle == FontStyle.italic
        ? FontStyle.normal
        : FontStyle.italic;
    updateDrawnDrawable();
    update();
  }

  // toggleSelectedTextDecoration() : will toggle between none and underline decoration
  void toggleSelectedTextDecoration() {
    selectedTextDecoration = selectedTextDecoration == TextDecoration.underline
        ? TextDecoration.none
        : TextDecoration.underline;
    updateDrawnDrawable();
    update();
  }

  // selectAddedTextDrawable() : will auto select text on adding one
  Future<void> selectAddedTextDrawable(TextDrawable? drawable) async {

    if(drawable == null) return;

    await Future<void>.delayed(const Duration(milliseconds: 200));

    drawingToolController.selectObjectDrawable(drawable);

    toggleDrawableSelectionMode();

    setSelectedItemStyle(drawable, false);

    editorType = getEditorType(drawable: drawable);
  }

  void toggleIsToolBarVisible(bool val) {

    if(!isInDrawableSelectionMode && selectedToolType != DrawingToolType.none) return;

    isToolBarVisible = val;
    update();
  }

  void rotateCanvas() {
    drawingToolController.rotateCanvas(
        Size(backgroundImage!.width + 0.0, backgroundImage!.height + 0.0)
    );
  }

  void showSaveOptions() async {
    isSaving = true;
    update();

    final list = await DrawingToolService.saveImage(backgroundImage, drawingToolController);

    isSaving = false;
    update();

    onSave(list);
  }

  // updateForFirstDrawable() : is used to update state of undo/redo button when first drawable is drawn
  void updateForFirstDrawable() {
    if(drawingToolController.drawables.length == 1) {
      update();
    }
  }

  DrawingToolEditorType getEditorType({Drawable? drawable}) {

    isEditorVisible = chkIsEditorVisible(drawable: drawable);
    bool isShapeDrawable = chkIsShapeDrawable(drawable: drawable);

    if(selectedToolType == DrawingToolType.shape) {
      return DrawingToolEditorType.addShape;
    } else if(selectedToolType == DrawingToolType.pencil) {
      return DrawingToolEditorType.addBrush;
    } else if(isShapeDrawable) {
      return DrawingToolEditorType.editShape;
    } else if(drawable is TextDrawable || selectedToolType == DrawingToolType.text) {
      return DrawingToolEditorType.editText;
    } else {
      return editorType;
    }
  }

  bool chkIsEditorVisible({Drawable? drawable}) {
    return (drawable != null
        || selectedToolType == DrawingToolType.shape
        || selectedToolType == DrawingToolType.pencil
        || selectedToolType == DrawingToolType.text
        || isSelectedDrawableIsText)
        && selectedToolType != DrawingToolType.eraser
        && !isStrokeActive;
  }

  bool chkIsShapeDrawable({Drawable? drawable}) {
    return drawable is LineDrawable
        || drawable is RectangleDrawable
        || drawable is OvalDrawable
        || drawable is ArrowDrawable
        || drawable is DoubleArrowDrawable;
  }

}