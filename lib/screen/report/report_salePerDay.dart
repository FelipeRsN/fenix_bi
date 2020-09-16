import 'dart:developer';

import 'package:fenix_bi/data/model/fechamentoCaixaResponse.dart';
import 'package:fenix_bi/data/model/reportStoreInformation.dart';
import 'package:fenix_bi/data/model/sale_per_day.dart';
import 'package:fenix_bi/screen/report/salesPerDay_listItem.dart';
import 'package:fenix_bi/utils/utils.dart';
import 'package:flutter/material.dart';

class SalePerDayReport extends StatelessWidget {
  final FechamentoCaixaResponse reportData;

  SalePerDayReport({Key key, @required this.reportData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log("SalePerDay screen created by build method");

    _checkLoginEligibility(context);
    var list = reportData.provideSalesPerDayList();

    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            "Exibe um comparativo do total vendido nas lojas selecionadas por dia",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 12,
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

  _checkLoginEligibility(BuildContext context) async {
    await Utils.checkifLoginIsValid(context);
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
              return _buildReportListTile(
                  data.storeList[index], data.currentDay);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReportListTile(ReportStoreInformation data, String currentDay) {
    return SalesPerDayListItem(
      data: data,
      connectionDatabase: reportData.storeDatabase,
      currentDay: currentDay,
    );
  }
}
