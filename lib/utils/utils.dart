import 'dart:developer';
import 'dart:io';

import 'package:fenix_bi/data/model/filterData.dart';
import 'package:fenix_bi/data/model/selectedFilter.dart';
import 'package:fenix_bi/data/model/store.dart';
import 'package:fenix_bi/res/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:intl/intl.dart';
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

  static String convertDateTimeToString(DateTime dateTime) {
    var dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    return dateFormat.format(dateTime);
  }

  static DateTime convertStringToDateTime(String value) {
    var dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    return dateFormat.parse(value);
  }

  static DateTime convertPortugueseStringToDateTime(String value) {
    var dateFormat = DateFormat("dd/MM/aaaa");
    return dateFormat.parse(value);
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

  static String capsWord(String value) {
    return value.toLowerCase().split(' ').map((word) {
      String leftText = (word.length > 1) ? word.substring(1, word.length) : '';
      return word[0].toUpperCase() + leftText;
    }).join(' ');
  }

  static saveLoginDateTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var now = DateTime.now();

    await prefs.remove(SHARED_PREFERENCES_LOGIN_DATETIME);
    await prefs.setString(
        SHARED_PREFERENCES_LOGIN_DATETIME, convertDateTimeToString(now));
  }

  static Future<bool> validateIfLoginIsValid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var now = DateTime.now();
    var lastLoginDateTime = prefs.getString(SHARED_PREFERENCES_LOGIN_DATETIME);
    var lastLoginConvertedToDateTime =
        convertStringToDateTime(lastLoginDateTime);
    var difference = now.difference(lastLoginConvertedToDateTime).inMinutes;
    log("Using app for: $difference minutes");
    return difference < 10;
  }

  static checkifLoginIsValid(BuildContext context) async {
    var canKeepLogin = await validateIfLoginIsValid();
    if (!canKeepLogin) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: Platform.isAndroid
                ? AlertDialog(
                    title: Text("Tempo de uso expirado"),
                    content: Text(
                        "Você excedeu o tempo desta sessão no aplicativo, por favor refaça login para continuar."),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(
                          "OK",
                          style: TextStyle(
                            color: AppColors.colorPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          restartApp(context);
                        },
                      ),
                    ],
                  )
                : CupertinoAlertDialog(
                    title: Text("Tempo de uso expirado"),
                    content: Text(
                        "Você excedeu o tempo desta sessão no aplicativo, por favor refaça login para continuar."),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(
                          "OK",
                          style: TextStyle(
                            color: AppColors.colorPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          restartApp(context);
                        },
                      ),
                    ],
                  ),
          );
        },
      );
    }
  }

  static restartApp(BuildContext context) async {
    Phoenix.rebirth(context);
  }
}
