import 'dart:convert';
import 'dart:developer';

import 'package:fenix_bi/data/model/reportStoreInformation.dart';
import 'package:fenix_bi/data/model/sale_per_day.dart';

FechamentoCaixaResponse fechamentoCaixaResponseFromJson(String str) =>
    FechamentoCaixaResponse.fromJson(json.decode(str));

String fechamentoCaixaResponseToJson(FechamentoCaixaResponse data) =>
    json.encode(data.toJson());

class FechamentoCaixaResponse {
  List<List<ReportStoreInformation>> result;
  DateTime filterStartDate;
  DateTime filterEndDate;
  int numberOfStoreSelected;

  FechamentoCaixaResponse({
    this.result,
  });

  factory FechamentoCaixaResponse.fromJson(Map<String, dynamic> json) =>
      FechamentoCaixaResponse(
        result: List<List<ReportStoreInformation>>.from(json["result"].map(
            (x) => List<ReportStoreInformation>.from(
                x.map((x) => ReportStoreInformation.fromJson(x))))),
      );

  Map<String, dynamic> toJson() => {
        "result": List<dynamic>.from(
            result.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
      };

  int provideNumberOfStores() {
    var list = result[0];
    var totalOfStores = 0;

    var currentStore = [];
    for (var item in list) {
      if (!currentStore.contains(item.nMFantasia)) {
        totalOfStores++;
        currentStore.add(item.nMFantasia);
      }
    }

    return totalOfStores;
  }

  double provideTotalLiquido() {
    var list = result[0];
    var totalLiquido = 0.0;

    for (var item in list) {
      try {
        var totDouble = double.parse(item.vLTotalGeral.replaceAll(",", "."));
        totalLiquido = totalLiquido + totDouble;
      } catch (error) {
        log(error);
      }
    }

    return totalLiquido;
  }

  List<SalesPerDay> provideSalesPerDayList() {
    var list = result[0];
    var salesPerDayList = List<SalesPerDay>();

    var currentDay = "";
    SalesPerDay currentItem;
    var endOfTheLastCycle = false;
    for (var item in list) {
      endOfTheLastCycle = false;
      try {
        //create storeItem
        var storeItem = ReportStoreInformation();
        storeItem.nMFantasia = item.nMFantasia;
        storeItem.totGeral =
            double.parse(item.vLTotalGeral.replaceAll(",", "."));
        storeItem.totCartaoDebito =
            double.parse(item.vLCartaoDebito.replaceAll(",", "."));
        storeItem.totTrocoContraVale =
            double.parse(item.vLTrocoContraVale.replaceAll(",", "."));
        storeItem.totTicket = double.parse(item.vLTicket.replaceAll(",", "."));
        storeItem.totDin = double.parse(item.vLDin.replaceAll(",", "."));
        storeItem.totCartao = double.parse(item.vLCartao.replaceAll(",", "."));
        storeItem.totContraVale =
            double.parse(item.vLContraVale.replaceAll(",", "."));
        storeItem.totCheque = double.parse(item.vLCheque.replaceAll(",", "."));
        storeItem.totConvenio =
            double.parse(item.vLConvenio.replaceAll(",", "."));
        storeItem.totDesconto =
            double.parse(item.vLDesconto.replaceAll(",", "."));
        storeItem.totAcrescimo =
            double.parse(item.vLAcrescimo.replaceAll(",", "."));
        storeItem.totCartaoCredito =
            double.parse(item.vLCartaoCredito.replaceAll(",", "."));
        storeItem.totRepique =
            double.parse(item.vLRepique.replaceAll(",", "."));

        if (currentItem == null || currentDay != item.dTAbertura) {
          currentItem = SalesPerDay();
          currentDay = item.dTAbertura;
          currentItem.currentDay = currentDay;
          endOfTheLastCycle = true;
        }

        currentItem.storeList.add(storeItem);
        if(endOfTheLastCycle) salesPerDayList.add(currentItem);

      } catch (error) {
        log(error.toString());
      }
    }

    for (var item in salesPerDayList) {
      if (item.storeList.isNotEmpty) {
        item.storeList.sort((a, b) => b.totGeral.compareTo(a.totGeral));
      }

      if (item.storeList.length > 1) {
        item.storeList.last.isPoorValue = true;
        item.storeList.first.isBetterValue = true;
      }
    }

    return salesPerDayList;
  }

  List<ReportStoreInformation> provideChartList() {
    var list = result[0];
    var chartDataList = List<ReportStoreInformation>();

    var currentStoreName = "";
    var currentItem = ReportStoreInformation();
    for (var item in list) {
      try {
        if (item.nMFantasia != currentStoreName) {
          currentItem = ReportStoreInformation();
          currentStoreName = item.nMFantasia;
          currentItem.nMFantasia = currentStoreName;
          currentItem.totGeral = provideTotalGeralByStore(currentStoreName);
          chartDataList.add(currentItem);
        }
      } catch (error) {
        log(error);
      }
    }

    return chartDataList;
  }

  List<ReportStoreInformation> provideFormatedList() {
    var list = result[0];
    var chartDataList = List<ReportStoreInformation>();

    var currentStore = [];
    var currentItem = ReportStoreInformation();
    for (var item in list) {
      try {
        if (!currentStore.contains(item.nMFantasia)) {
          currentItem = ReportStoreInformation();
          currentStore.add(item.nMFantasia);
          currentItem.nMFantasia = item.nMFantasia;
          currentItem.totGeral = provideTotalGeralByStore(item.nMFantasia);
          currentItem.totCartaoDebito =
              provideCartaoDebitoByStore(item.nMFantasia);
          currentItem.totTrocoContraVale =
              provideTrocoContraValeByStore(item.nMFantasia);
          currentItem.totTicket = provideTicketByStore(item.nMFantasia);
          currentItem.totDin = provideDinByStore(item.nMFantasia);
          currentItem.totCartao = provideCartaoByStore(item.nMFantasia);
          currentItem.totContraVale = provideContraValeByStore(item.nMFantasia);
          currentItem.totCheque = provideChequeByStore(item.nMFantasia);
          currentItem.totConvenio = provideConvenioByStore(item.nMFantasia);
          currentItem.totDesconto = provideDescontoByStore(item.nMFantasia);
          currentItem.totAcrescimo = provideAcrescimoByStore(item.nMFantasia);
          currentItem.totCartaoCredito =
              provideCartaoCreditoByStore(item.nMFantasia);
          currentItem.totRepique = provideRepiqueByStore(item.nMFantasia);
          chartDataList.add(currentItem);
        }
      } catch (error) {
        log(error);
      }
    }

    return chartDataList;
  }

  double provideTotalGeralByStore(String store) {
    var list = result[0];
    var totalLiquido = 0.0;

    for (var item in list) {
      try {
        if (item.nMFantasia == store) {
          var totDouble = double.parse(item.vLTotalGeral.replaceAll(",", "."));
          totalLiquido = totalLiquido + totDouble;
        }
      } catch (error) {
        log(error);
      }
    }

    return totalLiquido;
  }

  double provideCartaoDebitoByStore(String store) {
    var list = result[0];
    var totalLiquido = 0.0;

    for (var item in list) {
      try {
        if (item.nMFantasia == store) {
          var totDouble =
              double.parse(item.vLCartaoDebito.replaceAll(",", "."));
          totalLiquido = totalLiquido + totDouble;
        }
      } catch (error) {
        log(error);
      }
    }

    return totalLiquido;
  }

  double provideTrocoContraValeByStore(String store) {
    var list = result[0];
    var totalLiquido = 0.0;

    for (var item in list) {
      try {
        if (item.nMFantasia == store) {
          var totDouble =
              double.parse(item.vLTrocoContraVale.replaceAll(",", "."));
          totalLiquido = totalLiquido + totDouble;
        }
      } catch (error) {
        log(error);
      }
    }

    return totalLiquido;
  }

  double provideTicketByStore(String store) {
    var list = result[0];
    var totalLiquido = 0.0;

    for (var item in list) {
      try {
        if (item.nMFantasia == store) {
          var totDouble = double.parse(item.vLTicket.replaceAll(",", "."));
          totalLiquido = totalLiquido + totDouble;
        }
      } catch (error) {
        log(error);
      }
    }

    return totalLiquido;
  }

  double provideDinByStore(String store) {
    var list = result[0];
    var totalLiquido = 0.0;

    for (var item in list) {
      try {
        if (item.nMFantasia == store) {
          var totDouble = double.parse(item.vLDin.replaceAll(",", "."));
          totalLiquido = totalLiquido + totDouble;
        }
      } catch (error) {
        log(error);
      }
    }

    return totalLiquido;
  }

  double provideCartaoByStore(String store) {
    var list = result[0];
    var totalLiquido = 0.0;

    for (var item in list) {
      try {
        if (item.nMFantasia == store) {
          var totDouble = double.parse(item.vLCartao.replaceAll(",", "."));
          totalLiquido = totalLiquido + totDouble;
        }
      } catch (error) {
        log(error);
      }
    }

    return totalLiquido;
  }

  double provideContraValeByStore(String store) {
    var list = result[0];
    var totalLiquido = 0.0;

    for (var item in list) {
      try {
        if (item.nMFantasia == store) {
          var totDouble = double.parse(item.vLContraVale.replaceAll(",", "."));
          totalLiquido = totalLiquido + totDouble;
        }
      } catch (error) {
        log(error);
      }
    }

    return totalLiquido;
  }

  double provideChequeByStore(String store) {
    var list = result[0];
    var totalLiquido = 0.0;

    for (var item in list) {
      try {
        if (item.nMFantasia == store) {
          var totDouble = double.parse(item.vLCheque.replaceAll(",", "."));
          totalLiquido = totalLiquido + totDouble;
        }
      } catch (error) {
        log(error);
      }
    }

    return totalLiquido;
  }

  double provideConvenioByStore(String store) {
    var list = result[0];
    var totalLiquido = 0.0;

    for (var item in list) {
      try {
        if (item.nMFantasia == store) {
          var totDouble = double.parse(item.vLConvenio.replaceAll(",", "."));
          totalLiquido = totalLiquido + totDouble;
        }
      } catch (error) {
        log(error);
      }
    }

    return totalLiquido;
  }

  double provideDescontoByStore(String store) {
    var list = result[0];
    var totalLiquido = 0.0;

    for (var item in list) {
      try {
        if (item.nMFantasia == store) {
          var totDouble = double.parse(item.vLDesconto.replaceAll(",", "."));
          totalLiquido = totalLiquido + totDouble;
        }
      } catch (error) {
        log(error);
      }
    }

    return totalLiquido;
  }

  double provideAcrescimoByStore(String store) {
    var list = result[0];
    var totalLiquido = 0.0;

    for (var item in list) {
      try {
        if (item.nMFantasia == store) {
          var totDouble = double.parse(item.vLAcrescimo.replaceAll(",", "."));
          totalLiquido = totalLiquido + totDouble;
        }
      } catch (error) {
        log(error);
      }
    }

    return totalLiquido;
  }

  double provideCartaoCreditoByStore(String store) {
    var list = result[0];
    var totalLiquido = 0.0;

    for (var item in list) {
      try {
        if (item.nMFantasia == store) {
          var totDouble =
              double.parse(item.vLCartaoCredito.replaceAll(",", "."));
          totalLiquido = totalLiquido + totDouble;
        }
      } catch (error) {
        log(error);
      }
    }

    return totalLiquido;
  }

  double provideRepiqueByStore(String store) {
    var list = result[0];
    var totalLiquido = 0.0;

    for (var item in list) {
      try {
        if (item.nMFantasia == store) {
          var totDouble = double.parse(item.vLRepique.replaceAll(",", "."));
          totalLiquido = totalLiquido + totDouble;
        }
      } catch (error) {
        log(error);
      }
    }

    return totalLiquido;
  }
}
