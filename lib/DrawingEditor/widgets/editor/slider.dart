import 'package:flutter/material.dart';

class DrawingToolEditorSlider extends StatelessWidget {
  const DrawingToolEditorSlider({
    Key? key,
    required this.value,
    required this.title,
    required this.displayValue,
    required this.displayUnit,
    required this.onChanged,
    required this.divisions,
    this.maxValue,
    this.minValue,
    required this.isVisible,
    this.onTapBack,
    this.isBackButtonVisible = true
  }) : super(key: key);

  final double value;

  final String title;

  final String displayValue;

  final String displayUnit;

  final int divisions;

  final Function(double value) onChanged;

  final double? minValue;

  final double? maxValue;

  final bool isVisible;

  final bool isBackButtonVisible;

  final VoidCallback? onTapBack;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          if(isBackButtonVisible)...{
            IconButton(
              icon: const Icon(Icons.chevron_left),
              color: Colors.white,
              onPressed: onTapBack,
              iconSize: 22,
            ),

            const SizedBox(
              width: 5,
            ),
          } else...{
            const SizedBox(
              width: 25,
            ),
          },

          Expanded(
            child: Material(
              color: Colors.black,
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 10
                ),
                child: Row(
                  children: [
                  Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 10
                  ),
                ),
                    const SizedBox(
                      width: 2,
                    ),
                    Expanded(
                      child: slider(
                        value: value,
                        divisions: divisions,
                        onChanged: onChanged,
                        context: context
                      ),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Text(
                      displayValue,
                      style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                          fontSize: 10
                      ),
                    ),
                    Text(
                      displayUnit,
                      style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                          fontSize: 10
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(
            width: 25,
          ),
        ],
      ),
    );
  }

  Widget slider({
    double value = 0.0,
    int divisions = 0,
    required Function(double val) onChanged,
    required BuildContext context
  }) {
    return SliderTheme(
      data: SliderThemeData(
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
        trackHeight: 2,
        overlayShape: SliderComponentShape.noOverlay,
        inactiveTrackColor: Colors.grey.shade100,
        thumbColor: Theme.of(context).primaryColor,
        activeTickMarkColor: Theme.of(context).primaryColor,
        inactiveTickMarkColor: Colors.grey.shade100,
        activeTrackColor: Theme.of(context).primaryColor,
      ),
      child: Slider(
        value: value,
        min: minValue ?? 0,
        max: maxValue ?? 1,
        divisions: divisions,
        onChanged: onChanged,
      ),
    );
  }
}

