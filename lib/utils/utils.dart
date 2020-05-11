import 'dart:developer';

import 'package:fenix_bi/data/model/filterData.dart';
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

  static saveLoginInformationInSharedPreferences(FilterData information) async {
    log("saving user data");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        SHARED_PREFERENCES_STOREOWNER_NAME, information.connectedName);
    await prefs.setString(
        SHARED_PREFERENCES_STOREOWNER_DATABASE, information.connectedDatabase);

    var listOfStoreConvertedToString = List<String>();
    for (var store in information.storeList) {
      listOfStoreConvertedToString.add(storeToJson(store));
    }

    await prefs.setStringList(
        SHARED_PREFERENCES_STOREOWNER_STORE_LIST, listOfStoreConvertedToString);
    log("data stored.");
  }

  static Future<bool> hasUserConnected() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var hasItemStored = prefs.containsKey(SHARED_PREFERENCES_STOREOWNER_NAME);
    return hasItemStored;
  }

  static Future<FilterData> getConnectedUserInformation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = FilterData();
    data.connectedName = prefs.getString(SHARED_PREFERENCES_STOREOWNER_NAME);
    data.connectedDatabase =
        prefs.getString(SHARED_PREFERENCES_STOREOWNER_DATABASE);
    var storeList =
        prefs.getStringList(SHARED_PREFERENCES_STOREOWNER_STORE_LIST);

    var listOfStores = List<Store>();
    for (var item in storeList) {
      listOfStores.add(storeFromJson(item));
    }

    data.storeList = listOfStores;
    return data;
  }

  static removeConnectedUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
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

  static String capsWord(String value) {
    return value.toLowerCase().split(' ').map((word) {
      String leftText = (word.length > 1) ? word.substring(1, word.length) : '';
      return word[0].toUpperCase() + leftText;
    }).join(' ');
  }
}
