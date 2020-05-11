import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screen/filter/filter.dart';
import 'screen/login/login.dart';
import 'screen/report/report.dart';
import 'screen/splash/splash.dart';
import 'utils/routes.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('pt', 'BR'),
      ],
      home: SplashScreen(),
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
