import 'package:flutter/material.dart';

Color stringToColor(String colorName) {
  switch (colorName.toLowerCase()) {
    case 'red':
      return Colors.red;
    case 'green':
      return Colors.green;
    case 'blue':
      return Colors.blue;
    case 'yellow':
      return Colors.yellow;
    case 'orange':
      return Colors.orange;
    case 'purple':
      return Colors.purple;
    default:
      return Colors.transparent; // Default color if not found
  }
}

List<ColorItem> colorItems = [
  ColorItem(color: Colors.red, show: true, col: "Red"),
  ColorItem(color: Colors.green, show: true, col: "Green"),
  ColorItem(color: Colors.blue, show: true, col: "Blue"),
  ColorItem(color: Colors.yellow, show: true, col: "Yellow"),
  ColorItem(color: Colors.orange, show: true, col: "Orange"),
  ColorItem(color: Colors.purple, show: true, col: "Purple"),
];

class ColorItem {
  final Color color;
  final String col;
  bool show;

  ColorItem({required this.color, required this.show, required this.col});
}