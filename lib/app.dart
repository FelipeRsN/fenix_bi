import 'package:fenix_bi/screen/filter.dart';
import 'package:fenix_bi/screen/login.dart';
import 'package:fenix_bi/screen/report.dart';
import 'package:flutter/material.dart';

import 'screen/splash.dart';
import 'utils/routes.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        AppRoutes.route_splash: (BuildContext context) => SplashScreen(),
        AppRoutes.route_login: (BuildContext context) => LoginScreen(),
        AppRoutes.route_filter: (BuildContext context) => FilterScreen(),
        AppRoutes.route_report: (BuildContext context) => ReportScreen(),
      },
      theme: ThemeData(unselectedWidgetColor: Colors.white),
    );
  }
}
