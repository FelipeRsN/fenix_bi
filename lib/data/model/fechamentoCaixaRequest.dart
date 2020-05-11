import 'dart:convert';

FechamentoCaixaRequest fechamentoCaixaRequestFromJson(String str) => FechamentoCaixaRequest.fromJson(json.decode(str));

String fechamentoCaixaRequestToJson(FechamentoCaixaRequest data) => json.encode(data.toJson());

class FechamentoCaixaRequest {
    String database;
    String datainicial;
    String datafinal;
    String lojas;

    FechamentoCaixaRequest({
        this.database,
        this.datainicial,
        this.datafinal,
        this.lojas,
    });

    factory FechamentoCaixaRequest.fromJson(Map<String, dynamic> json) => FechamentoCaixaRequest(
        database: json["database"],
        datainicial: json["datainicial"],
        datafinal: json["datafinal"],
        lojas: json["lojas"],
    );

    Map<String, dynamic> toJson() => {
        "database": database,
        "datainicial": datainicial,
        "datafinal": datafinal,
        "lojas": lojas,
    };
}
