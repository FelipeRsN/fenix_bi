import 'dart:developer';

import 'package:fenix_bi/data/model/fechamentoCaixaDetalhadoResponse.dart';
import 'package:fenix_bi/data/model/fechamentoCaixaRequest.dart';
import 'package:fenix_bi/data/model/fechamentoCaixaResponse.dart';
import 'package:fenix_bi/data/model/generic_response.dart';
import 'package:fenix_bi/data/model/loginRequest.dart';
import 'package:fenix_bi/data/model/loginResponse.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConnectionUtils {
  static const BASE_URL = "http://fenixbi.dyndns.org:211/datasnap/rest/TSM";

  static Future<LoginResponse> loginAccount(LoginRequest data) async {
    final response =
        await http.post(Uri.parse('$BASE_URL/LoginBI'), body: loginRequestToJson(data));
    log(json.decode(response.body).toString());
    return LoginResponse.fromJson(json.decode(response.body));
  }

  static Future<GenericResponse> validatePinCode(LoginRequest data) async {
    final response = await http.post(Uri.parse('$BASE_URL/ValidaLoginBI'),
        body: loginRequestToJson(data));
    log(json.decode(response.body).toString());
    return GenericResponse.fromJson(json.decode(response.body));
  }

  static Future<FechamentoCaixaResponse> provideFechamentoCaixa(
      FechamentoCaixaRequest data) async {
    final response = await http.post(Uri.parse('$BASE_URL/BuscarFechaCX'),
        body: fechamentoCaixaRequestToJson(data));
    log(json.decode(response.body).toString());
    return FechamentoCaixaResponse.fromJson(json.decode(response.body));
  }

  static Future<FechamentoCaixaDetalhadoResponse>
      provideFechamentoCaixaDetalhado(FechamentoCaixaRequest data) async {
    final response = await http.post(Uri.parse('$BASE_URL/BuscarFechaDetCX'),
        body: fechamentoCaixaRequestToJson(data));
    log(json.decode(response.body).toString());
    return FechamentoCaixaDetalhadoResponse.fromJson(
        json.decode(response.body));
  }
}
