import 'dart:convert';

import 'package:fenix_bi/data/model/store.dart';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  List<List<Store>> result;

  LoginResponse({
    this.result,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        result: List<List<Store>>.from(json["result"]
            .map((x) => List<Store>.from(x.map((x) => Store.fromJson(x))))),
      );

  Map<String, dynamic> toJson() => {
        "result": List<dynamic>.from(
            result.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
      };
}
