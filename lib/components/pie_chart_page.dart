import 'package:billy/components/pie_data.dart';
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
  static double percentIEC,percentWater,percentGas,percentArnona,percentCellular,percentTv;
  static double total = 0.0;
  String selectedYear;
  String selectedMonth;
  var res;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSections();
  }

  @override
  Widget build(BuildContext context) => Card(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: LinearDatePicker(
                        startDate: "2000/01/01", //yyyy/mm/dd
                        endDate: "2050/12/31",
                        initialDate: "2021/11/15",
                        dateChangeListener: (String selectedDate) {
                          selectedYear = selectedDate.split('/')[0];
                          selectedMonth = selectedDate.split('/')[1];
                        },
                        showDay: false,  //false -> shows only year & month // true -> shows day & month & year
                        fontFamily: 'sans',
                        showLabels: true, // to show column captions, eg. year, month, etc.
                        textColor: Colors.black,
                        selectedColor: Colors.deepOrange,
                        unselectedColor: Colors.blueGrey,
                        yearText: "Year",
                        monthText: "Month",
                        dayText: "Day",
                        columnWidth: 100
                    ),
                  ),
                  TextButton(onPressed: () {
                    statCalc(selectedMonth, selectedYear);
                    setState(() {
                      getSections();
                    });
                  }, child: Text('Search'))
                ],
              ),
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
        ),
      );

  void statCalc(String month, String year) async {
    iecSum = await calculateSum('IEC', month, year);
    waterSum = await calculateSum('Water company', month, year);
    gasSum = await calculateSum('Gas company', month, year);
    arnonaSum = await calculateSum('Arnona company', month, year);
    cellularSum = await calculateSum('Cellular company', month, year);
    tvSum = await calculateSum('TV company', month, year);
    await calculatePercent();
  }

  // retrieve invoiceSum from firestore and calculate for each company
  Future<double> calculateSum(
      String companyName, String month, String year) async {
    final user = FirebaseAuth.instance.currentUser;
    total = 0.0;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection(companyName)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        res = result.get('invoiceDate');
        if (res.toString().split('/')[1] == month)
          if (res.toString().split('/')[2] == year)
            total += double.parse(result.get('invoiceSum'));
      });
    });
    return total;
  }

  calculatePercent() async{
    double totalSum = iecSum + waterSum + gasSum + arnonaSum + cellularSum + tvSum;
    percentIEC = ((100 * iecSum)/totalSum).roundToDouble();
    percentWater = ((100 * waterSum)/totalSum).roundToDouble();
    percentGas = ((100 * gasSum)/totalSum).roundToDouble();
    percentArnona = ((100 * arnonaSum)/totalSum).roundToDouble();
    percentCellular = ((100 * cellularSum)/totalSum).roundToDouble();
    percentTv = ((100 * tvSum)/totalSum).roundToDouble();

  }



}
