import 'package:flutter/material.dart';

class heightBox extends StatelessWidget {
  double height;
  heightBox(this.height);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}

class widthBox extends StatelessWidget {
  double width;
  widthBox(this.width);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
    );
  }
}