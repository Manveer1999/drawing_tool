import 'dart:async';
import 'dart:math';

import 'package:drawing_board/DrawingTool/controllers/controllers.dart';
import 'package:drawing_board/DrawingTool/dotted_decoration/index.dart';
import 'package:drawing_board/DrawingTool/extensions/painter_controller_helper_extension.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../controllers/events/selected_object_drawable_removed_event.dart';
import '../../controllers/notifications/notifications.dart';
import '../../controllers/drawables/sized1ddrawable.dart';
import '../../controllers/drawables/sized2ddrawable.dart';
import '../../controllers/events/events.dart';
import '../painters/painter.dart';
import 'painter_controller_widget.dart';
import 'dart:math' as math;

part 'free_style_widget.dart';
part 'text_widget.dart';
part 'object_widget.dart';
part 'shape_widget.dart';

typedef DrawableCreatedCallback = Function(Drawable drawable);

typedef DrawableDeletedCallback = Function(Drawable drawable);

/// Defines the builder used with [FlutterPainter.builder] constructor.
typedef FlutterPainterBuilderCallback = Widget Function(
    BuildContext context, Widget painter);

/// Widget that allows user to draw on it
class DrawingTool extends StatelessWidget {
  /// The controller for this painter.
  final DrawingToolController controller;

  /// Callback when a [Drawable] is created internally in [DrawingTool].
  final DrawableCreatedCallback? onDrawableCreated;

  /// Callback when a [Drawable] is deleted internally in [DrawingTool].
  final DrawableDeletedCallback? onDrawableDeleted;

  /// Callback when the selected [ObjectDrawable] changes.
  final ValueChanged<ObjectDrawable?>? onSelectedObjectDrawableChanged;

  /// Callback when the [PainterSettings] of [DrawingToolController] are updated internally.
  final ValueChanged<PainterSettings>? onPainterSettingsChanged;

  /// The builder used to build this widget.
  ///
  /// Using the default constructor, it will default to returning the [_FlutterPainterWidget].
  ///
  /// Using the [FlutterPainter.builder] constructor, the user can define their own builder and build their own
  /// UI around [_FlutterPainterWidget], which gets re-built automatically when necessary.
  final FlutterPainterBuilderCallback _builder;

  final Function(Drawable? drawable, bool isEditingText) onItemTap;

  final bool isInteractionEnabled;

  final VoidCallback? onTapDelete;

  final double backgroundAspectRatio;

  final Function(TextDrawable? drawable) onTextDrawableCreated;

  final Key objectWidgetKey;

  /// Creates a [DrawingTool] with the given [controller] and optional callbacks.
  const DrawingTool(
      {Key? key,
      required this.controller,
      this.onDrawableCreated,
      this.onDrawableDeleted,
      this.onSelectedObjectDrawableChanged,
      this.onPainterSettingsChanged,
      required this.onItemTap,
      this.isInteractionEnabled = true,
      this.onTapDelete,
      this.backgroundAspectRatio = 1,
      required this.onTextDrawableCreated,
      required this.objectWidgetKey
      })
      : _builder = _defaultBuilder,
        super(key: key);

  /// Creates a [DrawingTool] with the given [controller], [builder] and optional callbacks.
  ///
  /// Using this constructor, the [builder] will be called any time the [controller] updates.
  /// It is useful if you want to build UI that automatically rebuilds on updates from [controller].
  const DrawingTool.builder(
      {Key? key,
      required this.controller,
      required FlutterPainterBuilderCallback builder,
      this.onDrawableCreated,
      this.onDrawableDeleted,
      this.onSelectedObjectDrawableChanged,
      this.onPainterSettingsChanged,
      required this.onItemTap,
      this.isInteractionEnabled = true,
      this.onTapDelete,
      this.backgroundAspectRatio = 1,
      required this.onTextDrawableCreated,
      required this.objectWidgetKey
      })
      : _builder = builder,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return PainterControllerWidget(
      controller: controller,
      child: ValueListenableBuilder<PainterControllerValue>(
          valueListenable: controller,
          builder: (context, value, child) {
            return _builder(
                context,
                _FlutterPainterWidget(
                  objectWidgetKey: objectWidgetKey,
                  backgroundAspectRatio: backgroundAspectRatio,
                  onTapDelete: onTapDelete,
                  onTextDrawableCreated: onTextDrawableCreated,
                  onItemTap: onItemTap,
                  controller: controller,
                  isInteractionEnabled: isInteractionEnabled,
                  onDrawableCreated: onDrawableCreated,
                  onDrawableDeleted: onDrawableDeleted,
                  onPainterSettingsChanged: onPainterSettingsChanged,
                  onSelectedObjectDrawableChanged:
                      onSelectedObjectDrawableChanged,
                ));
          }),
    );
  }

  /// The default builder that is used when the default [DrawingTool] constructor is used.
  static Widget _defaultBuilder(BuildContext context, Widget painter) {
    return painter;
  }
}

/// The actual widget that displays and allows control for all drawables.
class _FlutterPainterWidget extends StatefulWidget {
  /// The controller for this painter.
  final DrawingToolController controller;

  /// Callback when a [Drawable] is created internally in [DrawingTool].
  final DrawableCreatedCallback? onDrawableCreated;

  /// Callback when a [Drawable] is deleted internally in [DrawingTool].
  final DrawableDeletedCallback? onDrawableDeleted;

  /// Callback when the selected [ObjectDrawable] changes.
  final ValueChanged<ObjectDrawable?>? onSelectedObjectDrawableChanged;

  /// Callback when the [PainterSettings] of [DrawingToolController] are updated internally.
  final ValueChanged<PainterSettings>? onPainterSettingsChanged;

  final Function(Drawable? drawable, bool isEditingText) onItemTap;

  /// Creates a [_FlutterPainterWidget] with the given [controller] and optional callbacks.

  final bool isInteractionEnabled;

  final VoidCallback? onTapDelete;

  final double backgroundAspectRatio;

  final Function(TextDrawable? drawable) onTextDrawableCreated;

  final Key objectWidgetKey;

  const _FlutterPainterWidget({
    Key? key,
    required this.onTextDrawableCreated,
    this.onTapDelete,
    required this.controller,
    this.onDrawableCreated,
    this.onDrawableDeleted,
    this.onSelectedObjectDrawableChanged,
    this.onPainterSettingsChanged,
    required this.onItemTap,
    this.isInteractionEnabled = true,
    this.backgroundAspectRatio = 1,
    required this.objectWidgetKey
  }) : super(key: key);

  @override
  State<_FlutterPainterWidget> createState() => _FlutterPainterWidgetState();
}

class _FlutterPainterWidgetState extends State<_FlutterPainterWidget> {

  Size? canvasSize;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    calculateMaxHeightWidth();
    return Navigator(
        onGenerateRoute: (settings) => PageRouteBuilder(
            settings: settings,
            opaque: false,
            pageBuilder: (context, animation, secondaryAnimation) {
              final controller = DrawingToolController.of(context);
              return NotificationListener<FlutterPainterNotification>(
                onNotification: onNotification,
                child: InteractiveViewer(
                  transformationController: controller.transformationController,
                  minScale: controller.settings.scale.enabled
                      ? controller.settings.scale.minScale
                      : 0.5,
                  maxScale: controller.settings.scale.enabled
                      ? controller.settings.scale.maxScale
                      : 1,
                  panEnabled: controller.settings.scale.enabled &&
                      (controller.freeStyleSettings.mode == FreeStyleMode.none),
                  scaleEnabled: controller.settings.scale.enabled,
                  child: Center(
                    child: Transform.scale(
                      scale: controller.rotationScale,
                      child: Transform.rotate(
                        angle: controller.angle,
                        child: AspectRatio(
                          key: controller.painterKey,
                          aspectRatio: widget.backgroundAspectRatio,
                          child: ClipRect(
                            child: _FreeStyleWidget(
                                child: _TextWidget(
                              onTextDrawableCreated: widget.onTextDrawableCreated,
                              child: _ShapeWidget(
                                child: ObjectWidget(
                                  key: widget.objectWidgetKey,
                                  canvasSize: canvasSize ?? Size.zero,
                                  onTapDelete: widget.onTapDelete,
                                  onItemTap: widget.onItemTap,
                                  isInteractionEnabled: widget.isInteractionEnabled,
                                  quarterTurns: controller.quarterTurns,
                                  rotationScale: 1/controller.rotationScale,
                                  child: CustomPaint(
                                    painter: Painter(
                                      drawables: controller.value.drawables,
                                      background: controller.value.background,
                                    ),
                                  ),
                                ),
                              ),
                            )),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }));
  }

  void calculateMaxHeightWidth() {

    if(canvasSize != null) return;

    final width = MediaQuery.of(context).size.width;
    final height = width / widget.backgroundAspectRatio;

    canvasSize = Size(width, height);

  }

  /// Handles all notifications that might be dispatched from children.
  bool onNotification(FlutterPainterNotification notification) {
    if (notification is DrawableCreatedNotification) {
      widget.onDrawableCreated?.call(notification.drawable);
    } else if (notification is DrawableDeletedNotification) {
      widget.onDrawableDeleted?.call(notification.drawable);
    } else if (notification is SelectedObjectDrawableUpdatedNotification) {
      widget.onSelectedObjectDrawableChanged?.call(notification.drawable);
    } else if (notification is SettingsUpdatedNotification) {
      widget.onPainterSettingsChanged?.call(notification.settings);
    }
    return true;
  }

}
