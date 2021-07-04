import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'pie_chart_page.dart';

class BarChartSample3 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BarChartSample3State();

}

class BarChartSample3State extends State<BarChartSample3> {
  List<int> intList = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14];
  @override
  Widget build(BuildContext context) {
    setState(() {

    });
    return AspectRatio(
      aspectRatio: 1.7,
      child: Scaffold(
        body: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          color: const Color(0xffd3d3d3),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 2000,
              barTouchData: BarTouchData(
                enabled: false,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Colors.transparent,
                  tooltipPadding: const EdgeInsets.all(0),
                  tooltipMargin: 8,
                  getTooltipItem: (
                      BarChartGroupData group,
                      int groupIndex,
                      BarChartRodData rod,
                      int rodIndex,
                      ) {
                    return BarTooltipItem(
                      rod.y.round().toString(),
                      TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (value) => const TextStyle(
                      color: Color(0xff7589a2), fontWeight: FontWeight.bold, fontSize: 14),
                  margin: 20,
                  getTitles: (double value) {
                      switch (value.toInt()) {
                        case 0:
                            if(value.toInt() < PieChartPageState.newMap.length) {
                              return PieChartPageState.newMap.keys.elementAt(value.toInt());
                            }
                          return "";
                        case 1:
                          if(value.toInt() < PieChartPageState.newMap.length) {
                            return PieChartPageState.newMap.keys.elementAt(value.toInt());
                          }
                          return "";
                        case 2:
                          if(value.toInt() < PieChartPageState.newMap.length) {
                            return PieChartPageState.newMap.keys.elementAt(value.toInt());
                          }
                          return "";
                        case 3:
                          if(value.toInt() < PieChartPageState.newMap.length) {
                            return PieChartPageState.newMap.keys.elementAt(value.toInt());
                          }
                          return "";
                        case 4:
                          if(value.toInt() < PieChartPageState.newMap.length) {
                            return PieChartPageState.newMap.keys.elementAt(value.toInt());
                          }
                          return "";
                        case 5:
                          if(value.toInt() < PieChartPageState.newMap.length) {
                            return PieChartPageState.newMap.keys.elementAt(value.toInt());
                          }
                          return "";
                        case 6:
                          if(value.toInt() < PieChartPageState.newMap.length) {
                            return PieChartPageState.newMap.keys.elementAt(value.toInt());
                          }
                          return "";
                        case 7:
                          if(value.toInt() < PieChartPageState.newMap.length) {
                            return PieChartPageState.newMap.keys.elementAt(value.toInt());
                          }
                          return "";
                        case 8:
                          if(value.toInt() < PieChartPageState.newMap.length) {
                            return PieChartPageState.newMap.keys.elementAt(value.toInt());
                          }
                          return "";
                        case 9:
                          if(value.toInt() < PieChartPageState.newMap.length) {
                            return PieChartPageState.newMap.keys.elementAt(value.toInt());
                          }
                          return "";
                        case 10:
                          if(value.toInt() < PieChartPageState.newMap.length) {
                            return PieChartPageState.newMap.keys.elementAt(value.toInt());
                          }
                          return "";
                        default:
                          return "";
                      }
                  }
                ),
                leftTitles: SideTitles(showTitles: false),
              ),
              borderData: FlBorderData(
                show: false,
              ),
              barGroups: setValues(),
            ),
          ),
        ),
      ),
    );
  }

  setValues() {
    List<BarChartGroupData> barChartList =[];
    for (var i=0; i < PieChartPageState.newMap.length ; i++) {
      barChartList.add(BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(y: double.parse(PieChartPageState.newMap.values.elementAt(i)))
        ],
        showingTooltipIndicators: intList,
      ));
    }
    setState(() {

    });
    return barChartList;
  }


}