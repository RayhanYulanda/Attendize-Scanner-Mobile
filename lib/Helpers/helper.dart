import 'package:flutter/material.dart';

const PRIMARY_COLOR = Color(0xff850f1a);
const SECONDARY_COLOR = Color(0xffc41021);
const ACCENT_COLOR = Color(0xffdb4050);

const ALT_PRIMARY_COLOR = Color(0xff144c80);

const THEME_COLOR = Colors.red;

const APP_URL = 'https://YOUR_URL.com/api/';
const APP_TOKEN = 'YOUR_APP_TOKEN';

bool isNullOrEmpty(String value) => value == '' || value == null;
Color parseColor(String color) {
  String hex = color.replaceAll("#", "");
  if (hex.isEmpty) hex = "ffffff";
  if (hex.length == 3) {
    hex =
    '${hex.substring(0, 1)}${hex.substring(0, 1)}${hex.substring(1, 2)}${hex.substring(1, 2)}${hex.substring(2, 3)}${hex.substring(2, 3)}';
  }
  Color col = Color(int.parse(hex, radix: 16)).withOpacity(1.0);
  return col;
}
