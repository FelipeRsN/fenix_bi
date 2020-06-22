
import 'dart:ui';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fenix_bi/res/colors.dart';

class SalesPerMonth {
  String monthName = "";
  double totalValue = 0.0;
  Color chartColor = AppColors.colorPrimary;

  charts.Color provideChartColor() {
    return charts.Color(
        r: chartColor.red,
        g: chartColor.green,
        b: chartColor.blue,
        a: chartColor.alpha);
  }
}
