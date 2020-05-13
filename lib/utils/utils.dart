import 'dart:developer';

import 'package:fenix_bi/data/model/filterData.dart';
import 'package:fenix_bi/data/model/selectedFilter.dart';
import 'package:fenix_bi/data/model/store.dart';
import 'package:fenix_bi/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'const.dart';

class Utils {
  static void changeNavigationAndStatusBarColor(
      Color navigationBarColor, Color statusBarColor) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: navigationBarColor, // navigation bar color
      statusBarColor: statusBarColor, // status bar color
    ));
  }

  static ProgressDialog provideProgressDialog(
      BuildContext context, String message) {
    var pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(
      message: message,
      borderRadius: 12.0,
      progressWidget: Padding(
        padding:
            const EdgeInsets.only(left: 12, top: 12, bottom: 12, right: 12),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.colorPrimary),
        ),
      ),
      insetAnimCurve: Curves.elasticInOut,
    );

    return pr;
  }

  static saveLastLoginTyped(String login) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(SHARED_PREFERENCES_LAST_LOGIN_USED);
    await prefs.setString(SHARED_PREFERENCES_LAST_LOGIN_USED, login);
  }

  static Future<String> getLastLoginTyped() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var login = prefs.getString(SHARED_PREFERENCES_LAST_LOGIN_USED);
    return login;
  }

  static saveBiometricLoginDecision(String selectedLogin,
      String selectedPassword, bool enableBiometricLogin) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String completeValue =
        "$selectedLogin|$selectedPassword|$enableBiometricLogin";
    log("Saving $completeValue");
    await prefs.remove(SHARED_PREFERENCES_USE_BIOMETRIC_LOGIN);
    await prefs.setString(
        SHARED_PREFERENCES_USE_BIOMETRIC_LOGIN, completeValue);
  }

  static removeBiometricLoginDecision() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    log("removing data");
    await prefs.remove(SHARED_PREFERENCES_USE_BIOMETRIC_LOGIN);
  }

  static Future<String> getSavedBiometricPassword(String login) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = prefs.getString(SHARED_PREFERENCES_USE_BIOMETRIC_LOGIN);
    if (value != null && value.isNotEmpty) {
      log("achou um dado: $value");
      var split = value.split("|");
      var savedLogin = split[0];
      var password = split[1];
      log("Login salvo: $login");
      var sameLogin = login == savedLogin;
      if (sameLogin) {
        return password;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<bool> hasBiometricDecisionWithThisLogin(String login) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = prefs.getString(SHARED_PREFERENCES_USE_BIOMETRIC_LOGIN);
    if (value != null && value.isNotEmpty) {
      log("achou um dado: $value");
      var split = value.split("|");
      var savedLogin = split[0];
      var decision = split[2];
      log("Login salvo: $login");
      var sameLogin = login == savedLogin;
      if (sameLogin) {
        if (decision == "true") {
          log("decision true");
          return true;
        } else {
          log("decision false");
          return false;
        }
      } else {
        log("n é mesmo login");
        return null;
      }
    } else {
      log("n achou nada");
      return null;
    }
  }

  // static Future<bool> getBiometricLoginDecision() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var login = prefs.getString(SHARED_PREFERENCES_LAST_LOGIN_USED);
  //   return login;
  // }

  static String capsWord(String value) {
    return value.toLowerCase().split(' ').map((word) {
      String leftText = (word.length > 1) ? word.substring(1, word.length) : '';
      return word[0].toUpperCase() + leftText;
    }).join(' ');
  }
}
