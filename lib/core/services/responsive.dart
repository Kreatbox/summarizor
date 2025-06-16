import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
  }
}

extension SizeExtension on num {
  double get w => (this * SizeConfig.screenWidth) / 375.0;
  double get h => (this * SizeConfig.screenHeight) / 812.0;
  double get f => (this * SizeConfig.screenWidth) / 375.0;
  double get r => (this * SizeConfig.screenWidth) / 375.0;
}

extension PaddingExtension on num {
  EdgeInsets get p => EdgeInsets.all((this * SizeConfig.screenWidth) / 375.0);
}
