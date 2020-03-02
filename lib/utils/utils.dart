import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

class Utils {
  static void changeNavigationAndStatusBarColor(Color navigationBarColor, Color statusBarColor) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: navigationBarColor, // navigation bar color
      statusBarColor: statusBarColor, // status bar color
    ));
  }
}
