import 'dart:developer';

import 'package:fenix_bi/data/model/fechamentoCaixaResponse.dart';
import 'package:fenix_bi/data/model/reportStoreInformation.dart';
import 'package:fenix_bi/data/model/sales_per_month.dart';
import 'package:fenix_bi/data/model/selectedFilter.dart';
import 'package:fenix_bi/res/colors.dart';
import 'package:fenix_bi/utils/routes.dart';
import 'package:fenix_bi/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

class PeriodResumeReport extends StatelessWidget {
  final FechamentoCaixaResponse reportData;
  final SelectedFilter selectedFilter;
  PeriodResumeReport({Key key, @required this.reportData, this.selectedFilter})
      : super(key: key);

  final _chartLastItemHeight = 60.0;
  final _chartFirstItemHeight = 115.0;

  @override
  Widget build(BuildContext context) {
    log("PeriodResume screen created by build method");
    _checkLoginEligibility(context);
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
        _buildTotalOfSalesContainer(context),
        _buildComparativeChart(),
        _buildComparativeMonthlyChart(),
      ],
    );
  }

  _checkLoginEligibility(BuildContext context) async {
    await Utils.checkifLoginIsValid(context);
  }

  Widget _buildTotalOfSalesContainer(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            Navigator.pushReplacementNamed(context, AppRoutes.route_filter,
                arguments: selectedFilter);
          },
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

    var height = _chartFirstItemHeight +
        (_chartLastItemHeight * (reportData.provideNumberOfStores() - 1));

    return Padding(
      padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
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
              "Comparativo resumo do período",
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

  Widget _buildComparativeMonthlyChart() {
    var data = reportData.provideMonthList();
    var series = [
      new charts.Series(
          id: 'SalesMonth',
          domainFn: (SalesPerMonth item, _) => item.monthName,
          measureFn: (SalesPerMonth item, _) => item.totalValue,
          colorFn: (SalesPerMonth item, _) => item.provideChartColor(),
          labelAccessorFn: (SalesPerMonth item, _) =>
              '${item.monthName.toUpperCase()}: ${NumberFormat.currency(locale: "pt_BR", symbol: "R\$").format(item.totalValue)}',
          data: data)
    ];

    var height =
        _chartFirstItemHeight + (_chartLastItemHeight * (data.length - 1));

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
              "Comparativo de venda mensal",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            children: <Widget>[
              Column(
                children: <Widget>[
                  //total liquido
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Total líquido",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          NumberFormat.currency(locale: "pt_BR", symbol: "R\$")
                              .format(reportData.provideTotalLiquidoAnual()),
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.colorTextPositive,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 12, 16),
                    width: double.infinity,
                    height: height,
                    child: charts.BarChart(
                      series,
                      animate: true,
                      vertical: false,
                      barRendererDecorator:
                          new charts.BarLabelDecorator<String>(),
                      domainAxis: new charts.OrdinalAxisSpec(
                          renderSpec: new charts.NoneRenderSpec()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
