import 'package:billy/chart/graph.dart';
import 'package:billy/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_linear_datepicker/flutter_datepicker.dart';
import 'indicators_widget.dart';
import 'pie_chart_sections.dart';
import 'package:flutter/material.dart';

class LineChartPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LineChartPageState();
}

class LineChartPageState extends State {
  double iecSum, waterSum, gasSum, arnonaSum, cellularSum, tvSum;
  static double percentIEC,
      percentWater,
      percentGas,
      percentArnona,
      percentCellular,
      percentTv;
  static double total = 0.0;
  String selectedYear;
  String selectedMonth;
  var res;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: LinearDatePicker(
                    startDate: "2000/01/01",
                    //yyyy/mm/dd
                    endDate: "2050/12/31",
                    initialDate: "2021/11/15",
                    dateChangeListener: (String selectedDate) {
                      selectedYear = selectedDate.split('/')[0];
                      selectedMonth = selectedDate.split('/')[1];
                    },
                    showDay: false,
                    //false -> shows only year & month // true -> shows day & month & year
                    fontFamily: 'sans',
                    showLabels: true,
                    // to show column captions, eg. year, month, etc.
                    textColor: Colors.black,
                    selectedColor: Colors.deepOrange,
                    unselectedColor: Colors.blueGrey,
                    yearText: "Year",
                    monthText: "Month",
                    dayText: "Day",
                    columnWidth: 100),
              ),
              TextButton(
                  onPressed: () async {
                  },
                  child: Text('Search'))
            ],
          ),
          Expanded(
            child: PieChart(
              PieChartData(
                borderData: FlBorderData(show: false),
                sectionsSpace: 0,
                centerSpaceRadius: 60,
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
}