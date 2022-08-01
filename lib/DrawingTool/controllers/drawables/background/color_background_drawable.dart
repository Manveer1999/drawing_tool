
import 'package:flutter/cupertino.dart';

import 'background_drawable.dart';

/// Drawable to use a color as a background.
@immutable
class ColorBackgroundDrawable extends BackgroundDrawable {
  /// The color to be used as a background.
  final Color color;

  /// Creates a [ColorBackgroundDrawable] to use a color as a background.
  const ColorBackgroundDrawable({required this.color});

  /// Draws the background on the provided [canvas] of size [size].
  @override
  void draw(Canvas canvas, Size size) {
    // Draw the color onto the canvas
    canvas.drawColor(color, BlendMode.src);
  }
}

/// An extension on Color to create a background drawable easily.
extension ColorBackgroundDrawableGetter on Color {
  /// Returns an [ColorBackgroundDrawable] of the current [Color].
  ColorBackgroundDrawable get backgroundDrawable =>
      ColorBackgroundDrawable(color: this);
}
