import 'dart:convert';
import 'package:fenix_bi/data/model/pdvList.dart';
import 'package:fenix_bi/data/model/reportStoreInformation.dart';

FechamentoCaixaDetalhadoResponse fechamentoCaixaDetalhadoResponseFromJson(
        String str) =>
    FechamentoCaixaDetalhadoResponse.fromJson(json.decode(str));

String fechamentoCaixaDetalhadoResponseToJson(
        FechamentoCaixaDetalhadoResponse data) =>
    json.encode(data.toJson());

class FechamentoCaixaDetalhadoResponse {
  List<List<ReportStoreInformation>> result;
  DateTime filterStartDate;
  DateTime filterEndDate;
  int numberOfStoreSelected;
  List<List<ReportStoreInformation>> resultAnually;

  FechamentoCaixaDetalhadoResponse({
    this.result,
  });

  factory FechamentoCaixaDetalhadoResponse.fromJson(
          Map<String, dynamic> json) =>
      FechamentoCaixaDetalhadoResponse(
        result: List<List<ReportStoreInformation>>.from(json["result"].map(
            (x) => List<ReportStoreInformation>.from(
                x.map((x) => ReportStoreInformation.fromJson(x))))),
      );

  Map<String, dynamic> toJson() => {
        "result": List<dynamic>.from(
            result.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
      };

  bool alreadyHasItemOnPdvList(List<PdvList> list, String value) {
    var contain = false;
    for (var item in list) {
      if (item.pdvName == value) {
        contain = true;
        break;
      }
    }
    return contain;
  }

  List<PdvList> providePDVList() {
    var list = result[0];
    var pdvList = List<PdvList>();

    for (var item in list) {
      if (!alreadyHasItemOnPdvList(pdvList, item.nMPdv)) {
        var currentItem = PdvList();
        currentItem.pdvName = item.nMPdv;
        for (var item in list) {
          if (item.nMPdv == currentItem.pdvName) {
            item.formatItemToCalculableValues();
            currentItem.itens.add(item);
          }
        }
        pdvList.add(currentItem);
      }
    }

    for (var item in pdvList) {
      if (item.itens.isNotEmpty) {
        item.itens.sort((a, b) => b.nrSeqInt.compareTo(a.nrSeqInt));
        item.itens = item.itens.reversed.toList();
      }
    }

    return pdvList;
  }
}
