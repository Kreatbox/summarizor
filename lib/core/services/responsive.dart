import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Responsive {
  late double widthFactor;
  late double heightFactor;

  Responsive(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    widthFactor = mediaQuery.size.width;
    heightFactor = mediaQuery.size.height;
  }

  double getWidth(double designWidth) {
    return designWidth * widthFactor / 375;
  }

  double getHeight(double designHeight) {
    return designHeight * heightFactor / 812;
  }

  double getFontSize(double designFontSize) {
    return designFontSize * widthFactor / 375;
  }

  double getRadius(double designRadius) {
    return designRadius * widthFactor / 375;
  }

  EdgeInsets getPadding(double padding) {
    double scaledPadding = padding * widthFactor / 375;
    return EdgeInsets.all(scaledPadding);
  }
}
extension IntSizeExtension on int {
  double get w => Responsive(buildContext).getWidth(toDouble());
  double get h => Responsive(buildContext).getHeight(toDouble());
  double get f => Responsive(buildContext).getFontSize(toDouble());
  double get r => Responsive(buildContext).getRadius(toDouble());
}

extension SizeExtension on double {
  double get w => Responsive(buildContext).getWidth(this);
  double get h => Responsive(buildContext).getHeight(this);
  double get f => Responsive(buildContext).getFontSize(this);
  double get r => Responsive(buildContext).getRadius(this);
}

extension PaddingExtension on double {
  EdgeInsets get p => Responsive(buildContext).getPadding(this);
}
extension IntPaddingExtension on int {
  EdgeInsets get p => Responsive(buildContext).getPadding(toDouble());
}
late BuildContext buildContext;

class MyWidget extends StatefulWidget {
  final Widget child;
  const MyWidget({super.key, required this.child});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  void initState() {
    super.initState();
    // Assign the buildContext when the widget is built
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return widget.child;
  }
}
