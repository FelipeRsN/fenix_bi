class Store {
  String storeId = "";
  String storeDatabase = "";
  String storeName = "";
  String apiErrorReason = "";
  bool sucess = true;
  bool isSelected = false;

  Store({
    this.storeId,
    this.storeDatabase,
    this.storeName,
    this.apiErrorReason,
    this.sucess,
  });

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        storeId: json["cNPJ_LOJA"],
        storeDatabase: json["pATH_BD_LOJA"],
        storeName: json["nM_LOJA"],
        apiErrorReason: json["motivo"],
        sucess: json["sucess"],
      );

  Map<String, dynamic> toJson() => {
        "cNPJ_LOJA": storeId,
        "pATH_BD_LOJA": storeDatabase,
        "nM_LOJA": storeName,
        "motivo": apiErrorReason,
        "sucess": sucess,
      };
}