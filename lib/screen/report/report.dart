import 'package:fenix_bi/data/connection/connection.dart';
import 'package:fenix_bi/data/model/fechamentoCaixaRequest.dart';
import 'package:fenix_bi/data/model/fechamentoCaixaResponse.dart';
import 'package:fenix_bi/data/model/selectedFilter.dart';
import 'package:fenix_bi/res/colors.dart';
import 'package:fenix_bi/screen/report/report_periodResume.dart';
import 'package:fenix_bi/screen/report/report_salePerDay.dart';
import 'package:fenix_bi/screen/report/report_saleStatistic.dart';
import 'package:fenix_bi/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen>
    with TickerProviderStateMixin {
  var _selectedFilter = SelectedFilter.createEmpty();
  var reportData = FechamentoCaixaResponse();

  var _dataLoaded = false;
  var _errorMessage = "";

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

  @override
  void initState() {
    _tabs = _provideTabList(_tabTitleList.length);
    _tabController = _provideTabController();
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

  @override
  Widget build(BuildContext context) {
    //get selected filter by argument
    _selectedFilter = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: _buildReportAppbar(),
      body: _dataLoaded ? _buildReportBody() : _buildLoadingScreen(),
    );
  }

  Widget _buildReportAppbar() {
    return AppBar(
      backgroundColor: AppColors.colorPrimary,
      elevation: 5,
      title: Text(
        "Relatórios",
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      actions: <Widget>[
        InkWell(
          onTap: () {
            Navigator.pushReplacementNamed(context, AppRoutes.route_filter,
                arguments: _selectedFilter);
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
      bottom: _dataLoaded
          ? PreferredSize(
              preferredSize: Size.fromHeight(58.0),
              child: Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: TabBar(
                  labelColor: AppColors.colorPrimary,
                  labelPadding: EdgeInsets.only(left: 8, right: 8),
                  labelStyle:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
            )
          : null,
    );
  }

  Widget _buildLoadingScreen() {
    if (_errorMessage.isEmpty) _loadReports();

    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _errorMessage.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.colorPrimary),
                  ),
                )
              : Container(),
          _errorMessage.isNotEmpty
              ? Text(
                  "Problema ao carregar os relatórios",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : Text(
                  "Carregando Relatórios...",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
          _errorMessage.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                )
              : Container(),
        ],
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

  _loadReports() async {
    try {
      var response = await ConnectionUtils.provideFechamentoCaixa(
          FechamentoCaixaRequest(
              database: _selectedFilter.database,
              datainicial:
                  DateFormat('dd/MM/yyyy').format(_selectedFilter.startDate),
              datafinal:
                  DateFormat('dd/MM/yyyy').format(_selectedFilter.finishDate),
              lojas: _selectedFilter.convertStoreListToString()));

      response.filterStartDate = _selectedFilter.startDate;
      response.filterEndDate = _selectedFilter.finishDate;

      var numberOfSelectedStores = 0;
      for(var store in _selectedFilter.selectedStores){
        if(store.isSelected) numberOfSelectedStores++;
      }

      response.numberOfStoreSelected = numberOfSelectedStores;

      var result = response.result[0][0];
      if (result.sucess == null || result.sucess != false) {
        setState(() {
          reportData = response;
          _dataLoaded = true;
          _errorMessage = "";
        });
      } else {
        var reason = result.apiErrorReason;
        if (reason == null || reason.isEmpty)
          reason = "Nenhum resultado encontrado no filtro selecionado.";
        setState(() {
          _dataLoaded = false;
          _errorMessage = reason;
        });
      }
    } catch (_) {
      var reason = "Verifique sua internet e tente novamente.";
      setState(() {
        _dataLoaded = false;
        _errorMessage = reason;
      });
    }

    // //check api response
    // if (response.result != null && response.result.isNotEmpty) {
    //   //find something
    // var result = response.result[0][0];
    // if (result.sucess == null || result.sucess != false) {
    //     //result ok. login
    //     log("voltou o retorno");

    // response.filterStartDate = _selectedFilter.startDate;
    // response.filterEndDate = _selectedFilter.finishDate;
    // response.numberOfStoreSelected =
    //     _selectedFilter.selectedStores.length;

    //     //close Dialog
    //     pr.hide();

    //     setState(() {
    //       _dataLoaded = true;
    //       reportData = response;
    //     });
    //   } else {
    //     //error, show message
    // var reason = result.apiErrorReason;
    // if (reason == null || reason.isEmpty)
    //   reason = "Problema ao carregar os dados.";

    //     //close Dialog
    //     pr.hide();

    //     _scaffoldKey.currentState.hideCurrentSnackBar();
    //     _scaffoldKey.currentState.showSnackBar(
    //       SnackBar(
    //         content: Text(reason),
    //       ),
    //     );
    //   }
    // } else {
    // var reason =
    //     "Problema ao conectar-se. Verifique sua internet e tente novamente.";

    //   //close Dialog
    //   pr.hide();

    //   _scaffoldKey.currentState.hideCurrentSnackBar();
    //   _scaffoldKey.currentState.showSnackBar(
    //     SnackBar(
    //       content: Text(reason),
    //     ),
    //   );
    // }
    //} catch (error) {
    //log(error.toString());

    //error processing information
    // _scaffoldKey.currentState.hideCurrentSnackBar();
    // _scaffoldKey.currentState.showSnackBar(
    //   SnackBar(
    //     content: Text(
    //         "Tivemos um problema ao conectar-se. Verifique sua internet e tente novamente."),
    //   ),
    // );
    //}
  }
}
