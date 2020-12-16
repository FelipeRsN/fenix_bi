import 'dart:convert';
import 'dart:developer';

import 'package:fenix_bi/data/model/reportStoreInformation.dart';
import 'package:fenix_bi/data/model/sale_per_day.dart';
import 'package:fenix_bi/data/model/sales_per_month.dart';
import 'package:fenix_bi/utils/utils.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';

FechamentoCaixaResponse fechamentoCaixaResponseFromJson(String str) =>
    FechamentoCaixaResponse.fromJson(json.decode(str));

String fechamentoCaixaResponseToJson(FechamentoCaixaResponse data) =>
    json.encode(data.toJson());

class FechamentoCaixaResponse {
  List<List<ReportStoreInformation>> result;
  String storeDatabase;
  DateTime filterStartDate;
  DateTime filterEndDate;
  int numberOfStoreSelected;
  List<List<ReportStoreInformation>> resultAnually;

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

  double provideTotalLiquidoAnual() {
    var list = resultAnually[0];
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
        storeItem.cNpj = item.cNpj;
        storeItem.dTAbertura = item.dTAbertura;
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
        storeItem.totalClients = int.parse(item.tTClientes);
        storeItem.totTicketCancelation =
            double.parse(item.vLTtCancel.replaceAll(",", "."));
        storeItem.totAveragePerClient =
            storeItem.totGeral / storeItem.totalClients;

        if (currentItem == null || currentDay != item.dTAbertura) {
          currentItem = SalesPerDay();
          currentDay = item.dTAbertura;
          currentItem.currentDay = currentDay;
          endOfTheLastCycle = true;
        }

        currentItem.storeList.add(storeItem);
        if (endOfTheLastCycle) salesPerDayList.add(currentItem);
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

    return salesPerDayList.reversed.toList();
  }

  List<SalesPerMonth> provideMonthList() {
    var list = resultAnually[0];
    var chartDataList = List<SalesPerMonth>();

    var currentMonth = "";
    var currentValue = 0.0;
    var currentItem = SalesPerMonth();
    for (var item in list) {
      try {
        String itemDate = item.dTAbertura;
        var date = DateFormat('dd/MM/yyyy').parse(itemDate);
        var month = Utils.capsWord(DateFormat.MMM('pt_BR').format(date));

        if (month != currentMonth) {
          if (currentMonth != "") {
            currentItem.totalValue = currentValue;
            chartDataList.add(currentItem);
          }

          currentItem = SalesPerMonth();
          currentItem.monthName = month;
          currentMonth = month;
          currentValue = 0.0;
        }

        item.totGeral = double.parse(item.vLTotalGeral.replaceAll(",", "."));
        currentValue = currentValue + item.totGeral;
      } catch (error) {
        log(error);
      }
    }

    //add last item to list
    currentItem.totalValue = currentValue;
    chartDataList.add(currentItem);

    return chartDataList;
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
          currentItem.totalClients =
              provideTotalClientsByStore(item.nMFantasia);
          currentItem.totTicketCancelation =
              provideCancelamentosByStore(item.nMFantasia);
          currentItem.totAveragePerClient =
              currentItem.totGeral / currentItem.totalClients;
          chartDataList.add(currentItem);
        }
      } catch (error) {
        log(error);
      }
    }

    chartDataList.sort((a, b) => a.nMFantasia.compareTo(b.nMFantasia));

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

  double provideCancelamentosByStore(String store) {
    var list = result[0];
    var totalLiquido = 0.0;

    for (var item in list) {
      try {
        if (item.nMFantasia == store) {
          var totDouble = double.parse(item.vLTtCancel.replaceAll(",", "."));
          totalLiquido = totalLiquido + totDouble;
        }
      } catch (error) {
        log(error);
      }
    }

    return totalLiquido;
  }

  int provideTotalClientsByStore(String store) {
    var list = result[0];
    var totalLiquido = 0;

    for (var item in list) {
      try {
        if (item.nMFantasia == store) {
          var totDouble = int.parse(item.tTClientes);
          totalLiquido = totalLiquido + totDouble;
        }
      } catch (error) {
        log(error);
      }
    }

    return totalLiquido;
  }
}
