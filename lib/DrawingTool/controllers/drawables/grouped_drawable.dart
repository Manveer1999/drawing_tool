import 'dart:ui';

import 'drawable.dart';

class GroupedDrawable extends Drawable {
  /// The list of drawables in this group.
  final List<Drawable> drawables;

  /// Creates a new [GroupedDrawable] with the list of [drawables].
  GroupedDrawable({
    required List<Drawable> drawables,
    bool hidden = false,
  })  : drawables = List.unmodifiable(drawables),
        super(hidden: hidden);

  /// Draw all the drawables in the group on [canvas] of [size].
  @override
  void draw(Canvas canvas, Size size) {
    for (final drawable in drawables) {
      drawable.draw(canvas, size);
    }
  }
}
