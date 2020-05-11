import 'dart:async';
import 'dart:io';

import 'package:fenix_bi/res/colors.dart';
import 'package:fenix_bi/utils/routes.dart';
import 'package:fenix_bi/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _executeAfterBuild();
  }

  @override
  Widget build(BuildContext context) {
    return _buildSplashScreen();
  }

  Widget _buildSplashScreen() {
    if (Platform.isAndroid) {
      Utils.changeNavigationAndStatusBarColor(
          AppColors.colorPrimary, AppColors.colorPrimary);
    }

    return Scaffold(
      body: Container(
        color: AppColors.colorPrimary,
        alignment: Alignment.center,
        child: SizedBox(
          height: 180,
          width: 180,
          child: SvgPicture.asset("assets/images/ic_fenixbi_icon.svg"),
        ),
      ),
    );
  }

  Future<void> _executeAfterBuild() async {
    //log("check user login information");
    //ar hasUserConnected = await Utils.hasUserConnected();
    //   if (hasUserConnected) {
    //     log("has user connected, retrieving data");
    //     var data = await Utils.getConnectedUserInformation();
    //     log("data received, name: " + data.connectedName);
    //     log("data received, database: " + data.connectedDatabase);
    //     log("data received, store list: " + data.storeList.toString());
    //     log("redirecting to filter...");

    //     Timer(Duration(seconds: 1), () {
    //       Navigator.pushReplacementNamed(context, AppRoutes.route_filter,
    //           arguments: data);
    //     });
    //   } else {
    //     log("no user connected, redirecting to login");

    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, AppRoutes.route_login);
    });
  }
  // }
}
