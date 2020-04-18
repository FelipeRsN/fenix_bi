import 'dart:io';

import 'package:fenix_bi/res/colors.dart';
import 'package:fenix_bi/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  static const FILTER_TYPE_MONTHLY = 1;
  static const FILTER_TYPE_ANUALY = 2;

  var _filterTypeSelected;
  var _selectedAllStores;

  var _startDateSelected = false;
  var _startDate = DateTime.now();

  var _finishDateSelected = false;
  var _finishDate = DateTime.now();

  var _storeList = [
    'Albania',
    'Andorra',
    'Armenia',
    'Austria',
    'Azerbaijan',
    'Belarus',
    'Belgium',
    'Bosnia and Herzegovina',
    'Bulgaria',
    'Croatia',
    'Cyprus',
    'Czech Republic',
    'Denmark',
    'Estonia',
    'Finland',
    'France',
    'Georgia'
  ];

  @override
  void initState() {
    super.initState();
    _filterTypeSelected = FILTER_TYPE_MONTHLY;
    _selectedAllStores = false;
  }

  @override
  Widget build(BuildContext context) {
    return _buildBaseScreen();
  }

  Widget _buildBaseScreen() {
    return Scaffold(
      backgroundColor: AppColors.colorPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.colorPrimary,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            "Bem vindo, Felipe!",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(context, AppRoutes.route_login);
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
    );
  }

  Widget _buildScreenBody() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 16),
          alignment: Alignment.center,
          child: Text(
            'Filtro',
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 16, right: 16, top: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Tipo:',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Container(
                width: 80,
                height: 30,
                margin: EdgeInsets.only(left: 16),
                child: RaisedButton(
                  onPressed: () {
                    setState(() {
                      _filterTypeSelected = FILTER_TYPE_MONTHLY;
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'Mensal',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _filterTypeSelected == FILTER_TYPE_MONTHLY
                            ? AppColors.colorPrimary
                            : Colors.white),
                  ),
                  color: _filterTypeSelected == FILTER_TYPE_MONTHLY
                      ? Colors.white
                      : AppColors.colorPrimary,
                  elevation: 0,
                ),
              ),
              Container(
                width: 80,
                height: 30,
                margin: EdgeInsets.only(left: 8),
                child: RaisedButton(
                  onPressed: () {
                    setState(() {
                      _filterTypeSelected = FILTER_TYPE_ANUALY;
                    });
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(8.0)),
                  child: Text(
                    'Anual',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _filterTypeSelected == FILTER_TYPE_ANUALY
                            ? AppColors.colorPrimary
                            : Colors.white),
                  ),
                  color: _filterTypeSelected == FILTER_TYPE_ANUALY
                      ? Colors.white
                      : AppColors.colorPrimary,
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
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
                  width: 100,
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
                      _startDateSelected
                          ? '${_startDate.day.toString().padLeft(2, '0')}/${_startDate.month.toString().padLeft(2, '0')}/${_startDate.year}'
                          : 'Data inicio',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 16),
                  child: Text(
                    'Até:',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ),
                Container(
                  width: 100,
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
                      _finishDateSelected
                          ? '${_finishDate.day.toString().padLeft(2, '0')}/${_finishDate.month.toString().padLeft(2, '0')}/${_finishDate.year}'
                          : 'Data fim',
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
                    child: Checkbox(
                      value: _selectedAllStores,
                      onChanged: (bool value) {
                        setState(() {
                          _selectedAllStores = value;
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
                      });
                    },
                    child: Container(
                      height: 24,
                      padding: EdgeInsets.only(right: 16),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Todas',
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
                child: FlatButton(
                  onPressed: () {
                    setState(() {
                      _selectedAllStores = false;
                    });
                  },
                  padding: EdgeInsets.only(left: 16, right: 0),
                  child: Text(
                    'Limpar Seleção',
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
                itemCount: _storeList.length,
                itemBuilder: (context, index) {
                  return _buildStoreItem(_storeList[index]);
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
            onPressed: () {},
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(12.0),
            ),
            child: Text(
              'Continuar',
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

  Widget _buildStoreItem(String item) {
    return InkWell(
      onTap: () {},
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
                  value: _selectedAllStores,
                  onChanged: (bool value) {
                    setState(() {
                      _selectedAllStores = true;
                    });
                  },
                  checkColor: Colors.white, // color of tick Mark
                  activeColor: AppColors.colorPrimary,
                ),
              ),
            ),
            Text(
              item,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> _selectStartDate(BuildContext context) async {
    if (!Platform.isAndroid) {
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: _startDate,
          firstDate: DateTime(2019),
          lastDate: DateTime.now());
      if (picked != null && picked != _startDate)
        setState(() {
          _startDateSelected = true;
          _startDate = picked;
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
            _startDateSelected = true;
            _startDate = date;
          });
        },
        currentTime: _startDate,
        locale: LocaleType.pt,
      );
    }
  }

  Future<Null> _selectFinishDate(BuildContext context) async {
    if (Platform.isAndroid) {
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: _finishDate,
          firstDate: DateTime(2019),
          lastDate: DateTime.now());
      if (picked != null && picked != _finishDate)
        setState(() {
          _finishDateSelected = true;
          _finishDate = picked;
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
            _finishDateSelected = true;
            _finishDate = date;
          });
        },
        currentTime: _finishDate,
        locale: LocaleType.pt,
      );
    }
  }
}
