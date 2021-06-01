import 'package:fl_chart/fl_chart.dart';
import 'pie_data.dart';
import 'package:flutter/material.dart';
import 'pie_chart_page.dart';

List<PieChartSectionData> getSections() => PieData(iec: PieChartPageState.percentIEC,water: PieChartPageState.percentWater,gas: PieChartPageState.percentGas,arnona: PieChartPageState.percentArnona,cellular: PieChartPageState.percentCellular,tv: PieChartPageState.percentTv).data
    .asMap()
    .map<int, PieChartSectionData>((index, data) {
  final double fontSize = 16;
  final double radius =  80;

  final value = PieChartSectionData(
    color: data.color,
    value: data.percent,
    title: '${data.percent}%',
    radius: radius,
    titleStyle: TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: const Color(0xffffffff),
    ),
  );

  return MapEntry(index, value);
})
    .values
    .toList();