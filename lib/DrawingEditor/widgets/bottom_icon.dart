
import 'package:flutter/material.dart';

class DrawingToolBottomIcon extends StatelessWidget {

  const DrawingToolBottomIcon({
    Key? key,
    this.icon,
    this.onTap,
    this.iconColor,
    this.value,
    this.unit,
    this.isActive = false,
  }) : super(key: key);

  /// icon used to display icon
  final IconData? icon;

  /// onTap handles tap action
  final VoidCallback? onTap;

  /// iconColor used to set icon color
  final Color? iconColor;

  /// value can be used to display text value
  final String? value;

  /// unit can be used to display value unit
  final String? unit;

  /// unit can be used to set change state of button
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isActive ? iconColor ?? Theme.of(context).primaryColor : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: onTap,
        child: SizedBox(
          height: 36,
          width: 36,
          child: value != null
              ? Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value ?? "",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isActive ? Theme.of(context).primaryColor : Colors.grey.shade600
                  ),
                ),
                if(unit != null)
                  Text(
                    unit ?? "",
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isActive ? Theme.of(context).primaryColor : Colors.grey.shade600
                    ),
                  ),

              ],
            ),
          )
              : Icon(
            icon,
            size: 24,
            color: iconColor ?? (isActive ? Colors.white : Colors.grey.shade300),
          ),
        ),
      ),
    );
  }
}
