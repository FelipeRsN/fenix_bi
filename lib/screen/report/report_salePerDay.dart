import 'dart:developer';

import 'package:fenix_bi/data/model/fechamentoCaixaResponse.dart';
import 'package:fenix_bi/data/model/reportStoreInformation.dart';
import 'package:fenix_bi/data/model/sale_per_day.dart';
import 'package:fenix_bi/res/colors.dart';
import 'package:fenix_bi/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalePerDayReport extends StatelessWidget {
  final FechamentoCaixaResponse reportData;

  SalePerDayReport({Key key, @required this.reportData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log("SalePerDay screen created by build method");

    var list = reportData.provideSalesPerDayList();

    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            "Exibe um comparativo do total vendido nas lojas selecionadas por dia",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 40),
          child: ListView.builder(
            itemCount: list.length,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemBuilder: (context, index) {
              return _buildDateTitleListTile(list[index]);
            },
          ),
        )
      ],
    );
  }

  Widget _buildDateTitleListTile(SalesPerDay data) {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Text(
              data.currentDay,
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            color: Colors.black54,
          ),
          ListView.builder(
            itemCount: data.storeList.length,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemBuilder: (context, index) {
              return _buildReportListTile(data.storeList[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReportListTile(ReportStoreInformation data) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Theme(
          data: ThemeData(
              unselectedWidgetColor: Colors.black, accentColor: Colors.black),
          child: ExpansionTile(
            initiallyExpanded: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  Utils.capsWord(data.nMFantasia),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Text(
                  NumberFormat.currency(locale: "pt_BR", symbol: "R\$")
                      .format(data.totGeral),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    //total liquido
                    Padding(
                      padding: const EdgeInsets.all(0.0),
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
                            NumberFormat.currency(
                                    locale: "pt_BR", symbol: "R\$")
                                .format(data.totGeral),
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.colorTextPositive,
                              fontWeight: FontWeight.bold,
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
                    //dinheiro
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "+   Dinheiro",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Text(
                            NumberFormat.currency(
                                    locale: "pt_BR", symbol: "R\$")
                                .format(data.totDin),
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.colorTextPositive,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    //cheque
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "+   Cheque",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Text(
                            NumberFormat.currency(
                                    locale: "pt_BR", symbol: "R\$")
                                .format(data.totCheque),
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.colorTextPositive,
                              fontWeight: FontWeight.bold,
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
                    //Credito
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "+   C. Crédito",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Text(
                            NumberFormat.currency(
                                    locale: "pt_BR", symbol: "R\$")
                                .format(data.totCartaoCredito),
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.colorTextPositive,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Debito
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "+   C. Débito",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Text(
                            NumberFormat.currency(
                                    locale: "pt_BR", symbol: "R\$")
                                .format(data.totCartaoDebito),
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.colorTextPositive,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Total Cartao
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "=   Total Cartão",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.colorTextNeutral,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Text(
                            NumberFormat.currency(
                                    locale: "pt_BR", symbol: "R\$")
                                .format(data.totCartao),
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.colorTextNeutral,
                              fontWeight: FontWeight.bold,
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
                    //Ticket
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "+   Ticket",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Text(
                            NumberFormat.currency(
                                    locale: "pt_BR", symbol: "R\$")
                                .format(data.totTicket),
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.colorTextPositive,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    //C. vale
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "+   C-vale",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Text(
                            NumberFormat.currency(
                                    locale: "pt_BR", symbol: "R\$")
                                .format(data.totContraVale),
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.colorTextPositive,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Troco c. vale
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "-   Troco C-vale",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.colorTextNegative,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Text(
                            NumberFormat.currency(
                                    locale: "pt_BR", symbol: "R\$")
                                .format(data.totTrocoContraVale),
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.colorTextNegative,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Convenio
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "+   Convênio",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Text(
                            NumberFormat.currency(
                                    locale: "pt_BR", symbol: "R\$")
                                .format(data.totConvenio),
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.colorTextPositive,
                              fontWeight: FontWeight.bold,
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
                    //Desconto
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "=   Desconto",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.colorTextNeutral,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Text(
                            NumberFormat.currency(
                                    locale: "pt_BR", symbol: "R\$")
                                .format(data.totDesconto),
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.colorTextNeutral,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Acrescimo
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "=   Acréscimo",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.colorTextNeutral,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Text(
                            NumberFormat.currency(
                                    locale: "pt_BR", symbol: "R\$")
                                .format(data.totAcrescimo),
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.colorTextNeutral,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildReportListTile(SalesPerDay data) {
  //   return Container(
  //     margin: EdgeInsets.only(bottom: 8),
  //     child: Card(
  //       elevation: 4,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //       child: Theme(
  //         data: ThemeData(
  //             unselectedWidgetColor: Colors.black, accentColor: Colors.black),
  //         child: ExpansionTile(
  //           initiallyExpanded: false,
  //           title: Text(
  //             data.currentDay,
  //             style: TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.black),
  //           ),
  //           children: <Widget>[
  //             Container(
  //               padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
  //               width: double.infinity,
  //               child: ListView.builder(
  //                 itemCount: data.storeList.length,
  //                 shrinkWrap: true,
  //                 physics: ScrollPhysics(),
  //                 itemBuilder: (context, index) {
  //                   return _buildStoreComparisonListTile(data.storeList[index]);
  //                 },
  //               ),
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildStoreComparisonListTile(ReportStoreInformation data) {
  //   var valueColor = AppColors.colorTextPositive;
  //   if (data.isBetterValue)
  //     valueColor = AppColors.colorTextNeutral;
  //   else if (data.isPoorValue) valueColor = AppColors.colorTextNegative;

  //   return Container(
  //     margin: EdgeInsets.only(bottom: 8),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: <Widget>[
  //         Text(
  //           data.nMFantasia,
  //           style: TextStyle(
  //             fontSize: 14,
  //             color: Colors.black,
  //             fontWeight: FontWeight.normal,
  //           ),
  //         ),
  //         Text(
  //           NumberFormat.currency(locale: "pt_BR", symbol: "R\$")
  //               .format(data.totGeral),
  //           style: TextStyle(
  //             fontSize: 14,
  //             color: valueColor,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
