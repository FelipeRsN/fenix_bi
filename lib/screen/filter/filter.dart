import 'dart:io';
import 'package:fenix_bi/data/model/selectedFilter.dart';
import 'package:fenix_bi/data/model/store.dart';
import 'package:fenix_bi/res/colors.dart';
import 'package:fenix_bi/utils/routes.dart';
import 'package:fenix_bi/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  var _selectedAllStores = true;

  var _filterData = SelectedFilter.createEmpty();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _filterData = ModalRoute.of(context).settings.arguments;
    _selectedAllStores = _checkIfAllStoresIsSelected();
    return _buildBaseScreen();
  }

  Widget _buildBaseScreen() {
    return WillPopScope(
      onWillPop: () async {
        _moveToReport();
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.colorPrimary,
        appBar: AppBar(
          backgroundColor: AppColors.colorPrimary,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Text(
            "Filtro",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          actions: <Widget>[
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Platform.isAndroid
                        ? AlertDialog(
                            title: Text("Tem certeza que deseja sair?"),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            actions: <Widget>[
                              FlatButton(
                                child: Text(
                                  "CANCELAR",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              FlatButton(
                                child: Text(
                                  "SAIR",
                                  style: TextStyle(
                                    color: AppColors.colorPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () {
                                  _clearStorageAndRestartApp();
                                },
                              ),
                            ],
                          )
                        : CupertinoAlertDialog(
                            title: Text("Tem certeza que deseja sair?"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text(
                                  "CANCELAR",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              FlatButton(
                                child: Text(
                                  "SAIR",
                                  style: TextStyle(
                                    color: AppColors.colorPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () {
                                  _clearStorageAndRestartApp();
                                },
                              ),
                            ],
                          );
                  },
                );
              },
              child: SizedBox(
                height: double.infinity,
                width: 80,
                child: Container(
                  padding: EdgeInsets.only(right: 24),
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Sair',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: _buildScreenBody(),
      ),
    );
  }

  _clearStorageAndRestartApp() async {
    Phoenix.rebirth(context);
  }

  Widget _buildScreenBody() {
    return Column(
      children: <Widget>[
        // Container(
        //   margin: EdgeInsets.only(left: 16, right: 16, top: 24),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: <Widget>[
        //       Text(
        //         'Tipo:',
        //         style: TextStyle(
        //             fontSize: 16,
        //             fontWeight: FontWeight.bold,
        //             color: Colors.white),
        //       ),
        //       Container(
        //         width: 80,
        //         height: 30,
        //         margin: EdgeInsets.only(left: 16),
        //         child: RaisedButton(
        //           onPressed: () {
        //             setState(() {
        //               _selectedFilter.filterType = FilterType.MONTHLY;
        //             });
        //           },
        //           shape: RoundedRectangleBorder(
        //             borderRadius: new BorderRadius.circular(8.0),
        //           ),
        //           child: Text(
        //             'Mensal',
        //             style: TextStyle(
        //                 fontSize: 14,
        //                 fontWeight: FontWeight.w500,
        //                 color: _selectedFilter.filterType == FilterType.MONTHLY
        //                     ? AppColors.colorPrimary
        //                     : Colors.white),
        //           ),
        //           color: _selectedFilter.filterType == FilterType.MONTHLY
        //               ? Colors.white
        //               : AppColors.colorPrimary,
        //           elevation: 0,
        //         ),
        //       ),
        //       Container(
        //         width: 80,
        //         height: 30,
        //         margin: EdgeInsets.only(left: 8),
        //         child: RaisedButton(
        //           onPressed: () {
        //             setState(() {
        //               _selectedFilter.filterType = FilterType.ANUALY;
        //             });
        //           },
        //           shape: RoundedRectangleBorder(
        //               borderRadius: new BorderRadius.circular(8.0)),
        //           child: Text(
        //             'Anual',
        //             style: TextStyle(
        //                 fontSize: 14,
        //                 fontWeight: FontWeight.w500,
        //                 color: _selectedFilter.filterType == FilterType.ANUALY
        //                     ? AppColors.colorPrimary
        //                     : Colors.white),
        //           ),
        //           color: _selectedFilter.filterType == FilterType.ANUALY
        //               ? Colors.white
        //               : AppColors.colorPrimary,
        //           elevation: 0,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(left: 16, right: 16, top: 16),
          height: 62,
          child: Card(
            color: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'De:',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                Container(
                  width: 110,
                  height: 30,
                  margin: EdgeInsets.only(left: 8),
                  child: RaisedButton(
                    onPressed: () {
                      _selectStartDate(context);
                    },
                    color: AppColors.colorTextField,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(8.0),
                      side: BorderSide(color: AppColors.colorPrimary, width: 1),
                    ),
                    child: Text(
                      '${_filterData.startDate.day.toString().padLeft(2, '0')}/${_filterData.startDate.month.toString().padLeft(2, '0')}/${_filterData.startDate.year}',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 12),
                  child: Text(
                    'Até:',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ),
                Container(
                  width: 110,
                  height: 30,
                  margin: EdgeInsets.only(left: 8),
                  child: RaisedButton(
                    onPressed: () {
                      _selectFinishDate(context);
                    },
                    color: AppColors.colorTextField,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(8.0),
                      side: BorderSide(color: AppColors.colorPrimary, width: 1),
                    ),
                    child: Text(
                      '${_filterData.finishDate.day.toString().padLeft(2, '0')}/${_filterData.finishDate.month.toString().padLeft(2, '0')}/${_filterData.finishDate.year}',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 24),
          alignment: Alignment.center,
          child: Text(
            'Selecione as lojas:',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 8, right: 24, top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    height: 24,
                    margin: EdgeInsets.only(left: 12),
                    child: Checkbox(
                      value: _checkIfAllStoresIsSelected(),
                      onChanged: (bool value) {
                        setState(() {
                          _selectedAllStores = !_selectedAllStores;
                          _toggleAllStoresSelection(_selectedAllStores);
                        });
                      },
                      checkColor: AppColors.colorPrimary,
                      activeColor: Colors.white,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _selectedAllStores = !_selectedAllStores;
                        _toggleAllStoresSelection(_selectedAllStores);
                      });
                    },
                    child: Container(
                      height: 24,
                      padding: EdgeInsets.only(right: 16),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'TODAS',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                height: 24,
                margin: EdgeInsets.only(right: 12),
                child: FlatButton(
                  onPressed: () {
                    setState(() {
                      _selectedAllStores = false;
                      _toggleAllStoresSelection(false);
                    });
                  },
                  padding: EdgeInsets.only(left: 16, right: 0),
                  child: Text(
                    'LIMPAR SELEÇÃO',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            margin: EdgeInsets.only(left: 16, right: 16, top: 8),
            child: Card(
              color: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.builder(
                itemCount: _filterData.selectedStores.length,
                padding: EdgeInsets.only(top: 8, bottom: 8),
                itemBuilder: (context, index) {
                  return _buildStoreItem(
                      _filterData.selectedStores[index], index);
                },
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 36,
          margin: EdgeInsets.only(left: 24, right: 24, bottom: 16, top: 16),
          child: RaisedButton(
            onPressed: !_checkIfCanContinue()
                ? null
                : () {
                    _moveToReport();
                  },
            color: Colors.white,
            disabledColor: Colors.white54,
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(12.0),
            ),
            child: Text(
              'Carregar relatórios',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.colorPrimary),
            ),
          ),
        ),
      ],
    );
  }

  void _moveToReport() {
    Navigator.pushReplacementNamed(context, AppRoutes.route_report,
        arguments: _filterData);
  }

  Widget _buildStoreItem(Store item, int position) {
    return InkWell(
      onTap: () {
        setState(() {
          _filterData.selectedStores[position].isSelected =
              !_filterData.selectedStores[position].isSelected;
          _selectedAllStores = _checkIfAllStoresIsSelected();
        });
      },
      child: Container(
        height: 40,
        width: double.infinity,
        child: Row(
          children: <Widget>[
            Container(
              height: 24,
              child: Theme(
                data: Theme.of(context).copyWith(
                  unselectedWidgetColor: AppColors.colorPrimary,
                ),
                child: Checkbox(
                  value: item.isSelected,
                  onChanged: (bool value) {
                    setState(() {
                      _filterData.selectedStores[position].isSelected = value;
                      _selectedAllStores = _checkIfAllStoresIsSelected();
                    });
                  },
                  checkColor: Colors.white, // color of tick Mark
                  activeColor: AppColors.colorPrimary,
                ),
              ),
            ),
            Text(
              Utils.capsWord(item.storeName),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  bool _checkIfAllStoresIsSelected() {
    var _allStoresSelected = true;
    for (var item in _filterData.selectedStores) {
      if (!item.isSelected) {
        _allStoresSelected = false;
        break;
      }
    }
    return _allStoresSelected;
  }

  bool _checkIfCanContinue() {
    var _canContinue = false;
    for (var item in _filterData.selectedStores) {
      if (item.isSelected) {
        _canContinue = true;
        break;
      }
    }
    return _canContinue;
  }

  void _toggleAllStoresSelection(bool isSelected) {
    for (var item in _filterData.selectedStores) {
      item.isSelected = isSelected;
    }
  }

  _selectStartDate(BuildContext context) async {
    if (Platform.isAndroid) {
      DateTime picked = await showDatePicker(
        context: context,
        locale: Locale('pt', 'BR'),
        helpText: 'Data início',
        fieldLabelText: 'Digite a data',
        fieldHintText: 'dd/mm/aaaa',
        initialDate: _filterData.startDate,
        firstDate: DateTime(2019),
        lastDate: DateTime.now(),
      );

      if (picked == null) {
        picked = DateTime.now();
      }

      setState(() {
        _filterData.startDate = picked;
      });
    } else {
      DatePicker.showDatePicker(
        context,
        showTitleActions: true,
        minTime: DateTime(2019),
        maxTime: DateTime.now(),
        theme: DatePickerTheme(
          itemStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          doneStyle: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        onConfirm: (date) {
          setState(() {
            _filterData.startDate = date;
            _checkIfCanContinue();
          });
        },
        currentTime: _filterData.startDate,
        locale: LocaleType.pt,
      );
    }
  }

  _selectFinishDate(BuildContext context) async {
    if (Platform.isAndroid) {
      DateTime picked = await showDatePicker(
        context: context,
        locale: Locale('pt', 'BR'),
        helpText: 'Data fim',
        fieldLabelText: 'Digite a data',
        fieldHintText: 'dd/mm/aaaa',
        initialDate: _filterData.finishDate,
        firstDate: _filterData.startDate,
        lastDate: DateTime.now(),
      );

      if (picked == null) {
        picked = DateTime.now();
      }

      setState(() {
        _filterData.finishDate = picked;
      });
    } else {
      DatePicker.showDatePicker(
        context,
        showTitleActions: true,
        minTime: _filterData.startDate,
        maxTime: DateTime.now(),
        theme: DatePickerTheme(
          itemStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          doneStyle: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        onConfirm: (date) {
          setState(() {
            _filterData.finishDate = date;
            _checkIfCanContinue();
          });
        },
        currentTime: _filterData.finishDate,
        locale: LocaleType.pt,
      );
    }
  }
}
