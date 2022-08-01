import 'dart:ui';

/// Abstract class to define a drawable object.
abstract class Drawable {
  /// Whether the drawable is hidden or not.
  final bool hidden;

  /// Default constructor.
  const Drawable({this.hidden = false});

  /// Draws the drawable on the provided [canvas] of size [size].
  void draw(Canvas canvas, Size size);

  bool get isHidden => hidden;

  bool get isNotHidden => !hidden;

}
