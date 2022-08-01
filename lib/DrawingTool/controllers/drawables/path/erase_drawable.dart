import 'package:flutter/material.dart';
import 'path_drawable.dart';

/// Free-style Erase Drawable .
class EraseDrawable extends PathDrawable {
  /// Creates a [EraseDrawable] to erase [path].
  ///
  /// The path will be erased with the passed [strokeWidth] if provided.
  EraseDrawable({
    required List<Offset> path,
    double strokeWidth = 1,
    bool hidden = false,
  }) : super(path: path, strokeWidth: strokeWidth, hidden: hidden);

  /// Creates a copy of this but with the given fields replaced with the new values.
  @override
  EraseDrawable copyWith({
    bool? hidden,
    List<Offset>? path,
    double? strokeWidth,
  }) {
    return EraseDrawable(
      path: path ?? this.path,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      hidden: hidden ?? this.hidden,
    );
  }

  @protected
  @override
  Paint get paint => Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..blendMode = BlendMode.clear
    ..strokeWidth = strokeWidth;

}
