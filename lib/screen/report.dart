import 'package:fenix_bi/data/model/selectedFilter.dart';
import 'package:fenix_bi/res/colors.dart';
import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  var currentFilter = SelectedFilter.createEmpty();

  var _currentReportAvailable = [
    "Fechamento de caixa",
    "Estatísticas de venda",
    "Relatório 3",
    "Relatório 4",
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentFilter = ModalRoute.of(context).settings.arguments;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.colorBackground,
        appBar: _buildAppBar(),
        body: _buildScreenBody(),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.colorPrimary,
      elevation: 5,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          "Relatórios",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      actions: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 12),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: SizedBox(
              height: double.infinity,
              child: Container(
                padding: EdgeInsets.only(right: 12, left: 12),
                alignment: Alignment.centerRight,
                child: Text(
                  'Alterar filtro',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(58.0),
        child: Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: TabBar(
            labelColor: AppColors.colorPrimary,
            labelPadding: EdgeInsets.only(left: 8, right: 8),
            labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            unselectedLabelColor: Colors.white,
            unselectedLabelStyle:
                TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            indicatorSize: TabBarIndicatorSize.label,
            isScrollable: true,
            indicatorWeight: 0,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            tabs: _currentReportAvailable
                .map((value) => Tab(
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Text(value),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildScreenBody() {
    return TabBarView(
      children: [
        _buildReportPosition0(),
        _buildReportPosition1(),
        _buildReportPosition2(),
        _buildReportPosition3(),
      ],
    );
  }

  var firstBoxExpanded = false;

  //Fechamento de caixa
  Widget _buildReportPosition0() {
    return ListView(
      padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 24),
      children: <Widget>[
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          child: Theme(
            data: ThemeData(unselectedWidgetColor: Colors.black, accentColor: Colors.black),
            child: ExpansionTile(
              initiallyExpanded: false,
              title: Text(
                "Caixa 398",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 300,
                )
              ],
            ),
          ),
        ),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          child: Theme(
            data: ThemeData(unselectedWidgetColor: Colors.black, accentColor: Colors.black),
            child: ExpansionTile(
              initiallyExpanded: false,
              title: Text(
                "Caixa 398",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 300,
                )
              ],
            ),
          ),
        ),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          child: Theme(
            data: ThemeData(unselectedWidgetColor: Colors.black, accentColor: Colors.black),
            child: ExpansionTile(
              initiallyExpanded: false,
              title: Text(
                "Caixa 398",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 300,
                )
              ],
            ),
          ),
        ),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          child: Theme(
            data: ThemeData(unselectedWidgetColor: Colors.black, accentColor: Colors.black),
            child: ExpansionTile(
              initiallyExpanded: false,
              title: Text(
                "Caixa 398",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 300,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  //Estatísticas de venda
  Widget _buildReportPosition1() {
    return ListView(
      padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 24),
    );
  }

  //Relatorio 3
  Widget _buildReportPosition2() {
    return Icon(Icons.table_chart);
  }

  //Relatorio 4
  Widget _buildReportPosition3() {
    return Icon(Icons.show_chart);
  }
}
