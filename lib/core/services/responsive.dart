import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Responsive {
  static late double screenWidth;
  static late double screenHeight;
  static late double scaleFactor;
  static double screenWidthUI = 375;
  static double screenHeightUI = 812;

  static void init(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    screenWidth = mediaQuery.size.width /screenWidthUI;
    screenHeight = mediaQuery.size.height / screenHeightUI;
    scaleFactor = (screenWidth + screenHeight) / 2;
  }
  static double getScaleFactor() {
    return scaleFactor;
  }

  static double getWidth(double designWidth) {
    return designWidth * screenWidth;
  }

  static double getHeight(double designHeight) {
    return designHeight * screenHeight;
  }

  static double getFontSize(double designFontSize) {
    return designFontSize * scaleFactor;
  }

  static double getRadius(double designRadius) {
    return designRadius * scaleFactor;
  }
  static double getEqualSize(double designRadius) {
    return designRadius * scaleFactor;
  }
  static EdgeInsets getPadding(double padding) {
    double scaledPadding = padding * getScaleFactor();
    return EdgeInsets.all(scaledPadding);
  }


}
extension IntSizeExtension on int {
  double get w => Responsive.getWidth(toDouble());
  double get h => Responsive.getHeight(toDouble());
  double get f => Responsive.getFontSize(toDouble());
  double get r => Responsive.getRadius(toDouble());
  double get e => Responsive.getEqualSize(toDouble());
}

extension SizeExtension on double {
  double get w => Responsive.getWidth(this);
  double get h => Responsive.getHeight(this);
  double get f => Responsive.getFontSize(this);
  double get r => Responsive.getRadius(this);
  double get e => Responsive.getEqualSize(this);
}

extension PaddingExtension on double {
  EdgeInsets get p => Responsive.getPadding(this);
}
extension IntPaddingExtension on int {
  EdgeInsets get p => Responsive.getPadding(toDouble());
}
