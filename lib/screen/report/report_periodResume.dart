import 'dart:developer';

import 'package:fenix_bi/data/model/fechamentoCaixaResponse.dart';
import 'package:fenix_bi/data/model/reportStoreInformation.dart';
import 'package:fenix_bi/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

class PeriodResumeReport extends StatelessWidget {
  final FechamentoCaixaResponse reportData;
  PeriodResumeReport({Key key, @required this.reportData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log("PeriodResume screen created by build method");
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            "Exibe o resumo das lojas selecionadas com base no período escolhido.",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
        ),
        _buildTotalOfSalesContainer(),
        _buildComparativeChart(),
      ],
    );
  }

  Widget _buildTotalOfSalesContainer() {
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "De.: ${DateFormat('dd/MM/yyyy').format(reportData.filterStartDate)}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      reportData.numberOfStoreSelected == 1
                          ? "1 loja selecionada"
                          : "${reportData.numberOfStoreSelected} lojas selecionadas",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Até: ${DateFormat('dd/MM/yyyy').format(reportData.filterEndDate)}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      "${reportData.provideNumberOfStores()} lojas com resultado",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              //divider
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Divider(),
              ),
              //total liquido
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Total líquido no período",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      NumberFormat.currency(locale: "pt_BR", symbol: "R\$")
                          .format(reportData.provideTotalLiquido()),
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.colorTextPositive,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComparativeChart() {
    var data = reportData.provideChartList();
    var series = [
      new charts.Series(
          id: 'VendasPorLoja',
          domainFn: (ReportStoreInformation item, _) => item.nMFantasia,
          measureFn: (ReportStoreInformation item, _) => item.totGeral,
          colorFn: (ReportStoreInformation item, _) => item.provideChartColor(),
          data: data,
          labelAccessorFn: (ReportStoreInformation item, _) =>
              '${item.nMFantasia}: ${NumberFormat.currency(locale: "pt_BR", symbol: "R\$").format(item.totGeral)}'),
    ];

    var height = 400.0;
    switch (reportData.provideNumberOfStores()) {
      case 1:
        height = 115.0;
        break;
      case 2:
        height = 170.0;
        break;
      case 3:
        height = 220.0;
        break;
      case 4:
        height = 280.0;
        break;
      case 5:
        height = 350.0;
        break;
      default:
        height = 450.0;
        break;
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(8, 0, 8, 40),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Theme(
          data: ThemeData(
              unselectedWidgetColor: Colors.black, accentColor: Colors.black),
          child: ExpansionTile(
            initiallyExpanded: true,
            title: Text(
              "Gráfico comparativo",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 12, 16),
                width: double.infinity,
                height: height,
                child: charts.BarChart(
                  series,
                  animate: true,
                  vertical: false,
                  barRendererDecorator: new charts.BarLabelDecorator<String>(),
                  domainAxis: new charts.OrdinalAxisSpec(
                      renderSpec: new charts.NoneRenderSpec()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
