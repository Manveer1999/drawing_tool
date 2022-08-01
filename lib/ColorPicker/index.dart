import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyColorPicker extends StatefulWidget {

  const MyColorPicker({
    Key? key,
    this.initialColor,
    required this.onColorApplied
  }) : super(key: key);


  /// selectedColor is used to display initially selected color
  final Color? initialColor;

  /// onColorApplied is used to return selected color
  final Function(Color? color) onColorApplied;

  @override
  State<MyColorPicker> createState() => _MyColorPickerState();
}

class _MyColorPickerState extends State<MyColorPicker> {
  @override
  Widget build(BuildContext context) {
    Color? pickColor = widget.initialColor;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8
        ),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      const Text(
                        'PICK COLOR',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        color: Colors.black,
                        icon: const Icon(Icons.clear),
                        iconSize: 24,
                      ),

                    ],
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  ColorPicker(
                    color: pickColor ?? Colors.black,
                    subheading: const Divider(
                      color: Colors.grey,
                    ),
                    onColorChanged: (Color value) {
                      pickColor = value;
                    },
                    pickersEnabled: const {
                      ColorPickerType.primary : false,
                      ColorPickerType.accent : false,
                      ColorPickerType.both : true,
                    },

                    padding: EdgeInsets.zero,
                    runSpacing: 5,
                    spacing: 5,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                      top: 16
                    ),
                    child: SizedBox(
                      height: 40,
                      child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                                child: Material(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(30),
                                  child: InkWell(
                                    onTap: () {
                                      pickColor = null;
                                      setState(() {});
                                    },
                                    borderRadius: BorderRadius.circular(30),
                                    child: const Center(
                                      child: Text(
                                        'RESET',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              flex: 1,
                              child: Material(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(30),
                                child: InkWell(
                                  onTap: () {
                                    widget.onColorApplied(pickColor);
                                    Get.back();
                                  },
                                  borderRadius: BorderRadius.circular(30),
                                  child: const Center(
                                    child: Text(
                                      'APPLY',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}