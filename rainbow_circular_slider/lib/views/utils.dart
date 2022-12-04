import 'dart:math' as math;

import 'package:flutter/material.dart';

// List<Color> colors = [
//   Colors.green,
//   Colors.blue,
//   Colors.indigo,
//   Colors.purple,
//   Colors.pink,
//   Colors.orange,
//   Colors.yellow,
//   Colors.greenAccent,
//   Colors.green,
// ];

List<Color> colors = [Color(0xFFFFFFFF),Color(0xff0D1018),Color(0xff0D1018),Color(0xff0D1018),Color(0xFFFFFFFF),Color(0xFFFFFFFF)];

const fullAngleInRadians = math.pi * 2;

double normalizeAngle(double angle) => normalize(angle, fullAngleInRadians);

Offset toPolar(Offset center, double radians, double radius) =>
    center + Offset.fromDirection(radians, radius);

double normalize(double value, double max) => (value % max + max) % max;

double toAngle(Offset position, Offset center) => (position - center).direction;

double toRadian(double value) => (value * math.pi) / 180;
