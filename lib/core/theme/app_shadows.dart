import 'package:flutter/material.dart';

class AppShadows {
  static const List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Color(0x33000000),
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  static const List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Color(0x4D000000),
      offset: Offset(0, 4),
      blurRadius: 8,
    ),
  ];

  static const List<BoxShadow> shadowLg = [
    BoxShadow(
      color: Color(0x66000000),
      offset: Offset(0, 8),
      blurRadius: 16,
    ),
  ];

  static const List<BoxShadow> shadowXl = [
    BoxShadow(
      color: Color(0x80000000),
      offset: Offset(0, 16),
      blurRadius: 32,
    ),
  ];
}
