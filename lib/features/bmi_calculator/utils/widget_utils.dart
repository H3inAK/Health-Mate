import 'package:flutter/material.dart';

const double baseHeight = 650.0;

double screenAwareSize(double size, BuildContext context) {
  double drawingHeight =
      MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
  return size * drawingHeight / baseHeight;
}

double appBarHeight(BuildContext context) {
  return screenAwareSize(50.0, context) + MediaQuery.of(context).padding.top;
}
