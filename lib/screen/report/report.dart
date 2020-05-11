import 'dart:developer';

import 'package:fenix_bi/data/model/fechamentoCaixaResponse.dart';
import 'package:fenix_bi/res/colors.dart';
import 'package:fenix_bi/screen/report/report_periodResume.dart';
import 'package:fenix_bi/screen/report/report_salePerDay.dart';
import 'package:fenix_bi/screen/report/report_saleStatistic.dart';
import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen>
    with TickerProviderStateMixin {
  var reportData = FechamentoCaixaResponse();

  //title of the tabs
  var _tabTitleList = [
    "Resumo do período",
    "Estatística de vendas",
    "Vendas por dia",
  ];

  //list of tabs and widgets
  List<Tab> _tabs = List<Tab>();
  List<Widget> _tabScreenList = List<Widget>();

  //tab controller
  TabController _tabController;

  //current tab
  var _currentTabIndex = 0;

  @override
  void initState() {
    _tabs = _provideTabList(_tabTitleList.length);
    _tabController = _provideTabController();
    //_tabController.addListener(_handleTabChangeListener);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  //provide tab list
  List<Tab> _provideTabList(int numberOfTabs) {
    _tabs.clear();
    for (int i = 0; i < numberOfTabs; i++) {
      _tabs.add(_generateTab(_tabTitleList[i]));
    }
    return _tabs;
  }

  //generate new tab formatted and using the list of tab titles
  Tab _generateTab(String title) {
    return Tab(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Text(title),
      ),
    );
  }

  //provide tab controller
  TabController _provideTabController() {
    return TabController(length: _tabs.length, vsync: this, initialIndex: 0);
  }

  //detect tab index changes and notify variable
  void _handleTabChangeListener() {
    if (_currentTabIndex != _tabController.index) {
      log("Mudou de tab para: ${_tabController.index}");
      _currentTabIndex = _tabController.index;
      // switch (_currentTabIndex) {
      //   case 0:
      //     (_tabScreenList[0] as PeriodResumeReport).isVisible(currentFilter);
      //     break;
      //   case 1:
      //     (_tabScreenList[1] as SaleStatisticReport).isVisible(currentFilter);
      //     break;
      //   case 2:
      //     (_tabScreenList[2] as SalePerDayReport).isVisible(currentFilter);
      //     break;
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    //get selected filter by argument
    reportData = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: _buildReportAppbar(),
      body: _buildReportBody(),
    );
  }

  Widget _buildReportAppbar() {
    return AppBar(
      backgroundColor: AppColors.colorPrimary,
      elevation: 5,
      leading: Align(
        alignment: Alignment.centerLeft,
        child: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        "Relatórios",
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      actions: <Widget>[
        InkWell(
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
            controller: _tabController,
            tabs: _tabs,
          ),
        ),
      ),
    );
  }

  Widget _buildReportBody() {
    return TabBarView(
      controller: _tabController,
      children: _provideTabScreenList(),
    );
  }

  List<Widget> _provideTabScreenList() {
    _tabScreenList.clear();
    _tabScreenList.add(PeriodResumeReport(reportData: reportData));
    _tabScreenList.add(SaleStatisticReport(reportData: reportData));
    _tabScreenList.add(SalePerDayReport(reportData: reportData));
    return _tabScreenList;
  }
}
