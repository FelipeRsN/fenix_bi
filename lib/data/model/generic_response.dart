import 'dart:convert';

GenericResponse genericResponseFromJson(String str) =>
    GenericResponse.fromJson(json.decode(str));

String genericResponseToJson(GenericResponse data) =>
    json.encode(data.toJson());

class GenericResponse {
  List<List<GenericData>> result;

  GenericResponse({
    this.result,
  });

  factory GenericResponse.fromJson(Map<String, dynamic> json) =>
      GenericResponse(
        result: List<List<GenericData>>.from(json["result"].map((x) =>
            List<GenericData>.from(x.map((x) => GenericData.fromJson(x))))),
      );

  Map<String, dynamic> toJson() => {
        "result": List<dynamic>.from(
            result.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
      };
}

GenericData genericDataFromJson(String str) =>
    GenericData.fromJson(json.decode(str));

String genericDataToJson(GenericData data) => json.encode(data.toJson());

class GenericData {
  String motivo;
  bool sucess;
  int idSucess;

  GenericData({
    this.motivo,
    this.sucess,
    this.idSucess,
  });

  factory GenericData.fromJson(Map<String, dynamic> json) => GenericData(
        motivo: json["motivo"],
        sucess: json["sucess"],
        idSucess: json["id_sucess"],
      );

  Map<String, dynamic> toJson() => {
        "motivo": motivo,
        "sucess": sucess,
        "id_sucess": idSucess,
      };
}
