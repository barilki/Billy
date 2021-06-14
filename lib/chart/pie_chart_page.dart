import 'package:billy/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_linear_datepicker/flutter_datepicker.dart';
import 'indicators_widget.dart';
import 'pie_chart_sections.dart';
import 'package:flutter/material.dart';

class PieChartPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PieChartPageState();
}

class PieChartPageState extends State {
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
  Widget build(BuildContext context) => Card(
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: kBackGroundColor,
              automaticallyImplyLeading: true,
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Statistic'),
                ],
              )),
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
                        await statCalc(selectedMonth, selectedYear);
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
        ),
      );

  // calculate invoice sum for each company
  Future<void> statCalc(String month, String year) async {
    total = 0.0;
    iecSum = await calculateSum('IEC', month, year, total);
    waterSum = await calculateSum('Water company', month, year, total);
    gasSum = await calculateSum('Gas company', month, year, total);
    arnonaSum =
        await calculateSum('Property Taxes company', month, year, total);
    cellularSum = await calculateSum('Cellular company', month, year, total);
    tvSum = await calculateSum('Tv company', month, year, total);
    calculatePercent();
    setState(() {});
  }

  // retrieve invoiceSum from firestore and calculate sum for each company by month and year
  Future<double> calculateSum(
      String companyName, String month, String year, double total) async {
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection(companyName)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        res = result.get('invoiceDate');
        if (res.toString().split('/')[1] ==
            month) if (res.toString().split('/')[2] == year)
          total += double.parse(result.get('invoiceSum'));
      });
    });
    return total;
  }

  // calculate percent for each company by their total sum
  calculatePercent() async {
    double totalSum =
        iecSum + waterSum + gasSum + arnonaSum + cellularSum + tvSum;
    percentIEC = ((100 * iecSum) / totalSum).roundToDouble();
    percentWater = ((100 * waterSum) / totalSum).roundToDouble();
    percentGas = ((100 * gasSum) / totalSum).roundToDouble();
    percentArnona = ((100 * arnonaSum) / totalSum).roundToDouble();
    percentCellular = ((100 * cellularSum) / totalSum).roundToDouble();
    percentTv = ((100 * tvSum) / totalSum).roundToDouble();
  }
}
