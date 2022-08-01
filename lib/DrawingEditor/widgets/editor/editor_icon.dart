
import 'package:flutter/material.dart';

class DrawingToolEditorIcon extends StatelessWidget {
  const DrawingToolEditorIcon({
    Key? key,
    this.isActive = false,
    required this.title,
    this.icon,
    this.onTap,
    this.value
  }) : super(key: key);

  final bool isActive;

  final String title;

  final IconData? icon;

  final VoidCallback? onTap;

  final String? value;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6
        ),
        child: Column(
          children: [
            if(value != null)
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 3
                ),
                child: Text(
                  value.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: isActive ? Colors.white : Colors.grey.shade300
                  ),
                ),
              ),

            if(icon != null)
              Icon(
                icon!,
                size: 20,
                color: isActive ? Colors.white : Colors.grey.shade300,
              ),

            const SizedBox(
              height: 3,
            ),

            Text(
              title.toString(),
              style: TextStyle(
                  fontSize: 10,
                  color: isActive ? Colors.white : Colors.grey.shade300
              ),
            )
          ],
        ),
      ),
    );
  }
}
