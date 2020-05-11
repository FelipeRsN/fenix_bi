
import 'dart:convert';

Store storeFromJson(String str) =>
    Store.fromJson(json.decode(str));

String storeToJson(Store data) => json.encode(data.toJson());

class Store {
  String storeId = "";
  String storeDatabase = "";
  String storeName = "";
  String apiErrorReason = "";
  String verificationPin = "";
  bool sucess = true;
  int firstAccess = 1;
  bool isSelected = true;
  String mailContacted = "";

  Store({
    this.storeId,
    this.storeDatabase,
    this.storeName,
    this.apiErrorReason,
    this.verificationPin,
    this.sucess,
    this.firstAccess,
    this.mailContacted,
  });

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        storeId: json["cNPJ_LOJA"],
        storeDatabase: json["pATH_BD_LOJA"],
        storeName: json["nM_LOJA"],
        apiErrorReason: json["motivo"],
        verificationPin: json["nR_PIN"],
        sucess: json["sucess"],
        firstAccess: json["fL_PRIMEIRO_ACESSO"],
        mailContacted: json["eMAIL"],
      );

  Map<String, dynamic> toJson() => {
        "cNPJ_LOJA": storeId,
        "pATH_BD_LOJA": storeDatabase,
        "nM_LOJA": storeName,
        "motivo": apiErrorReason,
        "sucess": sucess,
        "nR_PIN": verificationPin,
        "fL_PRIMEIRO_ACESSO": firstAccess,
        "eMAIL": mailContacted,
      };
}