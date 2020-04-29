import 'dart:developer';

import 'package:fenix_bi/data/model/loginRequest.dart';
import 'package:fenix_bi/data/model/loginResponse.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConnectionUtils {
  static const BASE_URL = "http://3.21.163.77:211/datasnap/rest/TSM";

  static Future<LoginResponse> loginAccount(LoginRequest data) async {
    final response =
        await http.post('$BASE_URL/LoginBI', body: loginRequestToJson(data));
    log(json.decode(response.body).toString());
    return LoginResponse.fromJson(json.decode(response.body));
  }
}
