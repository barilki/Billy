import 'package:fl_chart/fl_chart.dart';
import 'indicators_widget.dart';
import 'pie_chart_sections.dart';
import 'package:flutter/material.dart';

class PieChartPage extends StatefulWidget {
  final String date;
  @override
  State<StatefulWidget> createState() => PieChartPageState();
  PieChartPage({this.date});
}

class PieChartPageState extends State {

  @override
  Widget build(BuildContext context) => Card(
    child: Column(
      children: <Widget>[
        Expanded(
          child: PieChart(
            PieChartData(
              borderData: FlBorderData(show: false),
              sectionsSpace: 0,
              centerSpaceRadius: 40,
              sections: getSections(),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(30),
              child: IndicatorsWidget(),
            ),
          ],
        ),
      ],
    ),
  );
}