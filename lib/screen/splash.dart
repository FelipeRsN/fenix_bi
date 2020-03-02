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

  final Widget logo = SvgPicture.asset("assets/images/fenix_bi_logo.svg",
      semanticsLabel: 'FenixBI Logo');

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
    Utils.changeNavigationAndStatusBarColor(
        AppColors.colorPrimary, AppColors.colorPrimary);

    return SafeArea(
      child: Container(
        color: AppColors.colorPrimary,
        alignment: Alignment.center,
        child: SizedBox(
          height: 180,
          width: 180,
          child: logo,
        ),
      ),
    );
  }

  void _executeAfterBuild() {
    //validate everything before proceed to login
    new Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, AppRoutes.route_login);
    });
  }
}
