import 'package:flutter/material.dart';

class Twl {
  static navigateTo(BuildContext context, page) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  static navigateBack(BuildContext context) async {
    Navigator.pop(context);
  }

  static forceNavigateTo(BuildContext context, page) async {
    Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) => page));
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => page),
    // );
  }
}
