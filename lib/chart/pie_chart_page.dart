import 'dart:ui';

import 'package:billy/chart/graph.dart';
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
  static double totalPerCompany = 0.0;
  String selectedYear;
  String selectedMonth;
  String startYear, endYear,selectedCompany;
  var res;
  var statisticType;
  static var testMap = {};
  var companiesDetails;
  final List<String> _companies = ['חברת חשמל', 'מים', 'גז', 'ארנונה', 'סלולר', 'כבלים'].toList();
  final List<String> _startYears = ['2000', '2001', '2002', '2003','2004', '2005', '2006', '2007','2008', '2009', '2010', '2011', '2012', '2013','2014', '2015', '2016', '2017', '2018', '2019','2020', '2021', '2022', '2023',].toList();
  final List<String> _endYears = ['2000', '2001', '2002', '2003','2004', '2005', '2006', '2007','2008', '2009', '2010', '2011', '2012', '2013','2014', '2015', '2016', '2017', '2018', '2019','2020', '2021', '2022', '2023',].toList();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedCompany = _companies.first;
    startYear = _startYears.first;
    endYear = _endYears.last;
    statisticType = pieChartBody();
  }

  @override
  Widget build(BuildContext context) =>
      Card(
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: kBackGroundColor,
              automaticallyImplyLeading: true,
              actions: [
                IconButton(
                    icon: Icon(
                      Icons.pie_chart,
                      color: Colors.yellow,
                    ),
                    onPressed: () {
                      setState(() {
                        statisticType = pieChartBody();
                      });
                    }),
                IconButton(
                    icon: Icon(
                      Icons.bar_chart,
                      color: Colors.blueAccent,
                    ),
                    onPressed: () {
                      setState(() {
                        statisticType = lineChartBody();
                      });
                    }),
              ],
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('סטטיסטיקה'),
                ],
              )),
          body: statisticType,
        ),
      );

  // calculate invoice sum for each company
  Future<void> statCalc(String month, String year) async {
    total = 0.0;
    iecSum = await calculateSum('חברת חשמל', month, year, total);
    waterSum = await calculateSum('מים', month, year, total);
    gasSum = await calculateSum('גז', month, year, total);
    arnonaSum = await calculateSum('ארנונה', month, year, total);
    cellularSum = await calculateSum('סלולר', month, year, total);
    tvSum = await calculateSum('כבלים', month, year, total);
    calculatePercent();
    setState(() {});
  }

  // retrieve invoiceSum from firestore and calculate sum for each company by month and year
  Future<double> calculateSum(String companyName, String month, String year,
      double total) async {
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

  //Date picker for calculate statistics
  datePicker() {
    return LinearDatePicker(
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
        yearText: "שנה",
        monthText: "חודש",
        dayText: "Day",
        columnWidth: 100);
  }

  companyAndYearPicker() {
    return showDialog(
        context: context,
        builder: (context) {
      return StatefulBuilder(builder: (context, setState)
      {
        return AlertDialog(
          title: Text('אנא בחר סוג חברה ותאריך', textDirection: TextDirection.rtl,),
          actions: [
            Text('בחר חברה', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 15),),
            DropdownButton<String>(
              focusColor: Colors.white,
              value: selectedCompany,
              style: TextStyle(color: Colors.white),
              iconEnabledColor: Colors.black,
              items: _companies.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: TextStyle(color: Colors.black),),
                );
              }).toList(),
              hint: Text(
                "בחר חברה",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              onChanged: (String value) {
                setState(() {
                  selectedCompany = value;
                });
              },
            ),
            Text('בחר תאריך התחלה', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 15),),
            DropdownButton<String>(
              focusColor: Colors.white,
              value: startYear,
              style: TextStyle(color: Colors.white),
              iconEnabledColor: Colors.black,
              items: _startYears.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: TextStyle(color: Colors.black),),
                );
              }).toList(),
              hint: Text(
                "תאריך התחלה",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              onChanged: (String value) {
                setState(() {
                  startYear = value;
                });
              },
            ),
            Text('בחר תאריך סיום', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15),),
            DropdownButton<String>(
              focusColor: Colors.white,
              value: endYear,
              style: TextStyle(color: Colors.white),
              iconEnabledColor: Colors.black,
              items: _endYears.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: TextStyle(color: Colors.black),),
                );
              }).toList(),
              hint: Text(
                "תאריך סיום",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              onChanged: (String value) {
                setState(() {
                  endYear = value;
                });
              },
            ),
            Row(
              children: [
                TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await lineStatisticCalc(
                          startYear, endYear, selectedCompany);
                    },
                    child: Text('חיפוש')),
                TextButton(onPressed: () {
                  Navigator.pop(context);
                }, child: Text("ביטול")),
              ],
            ),
          ],

        );
      });
        });
  }

  pieChartBody() {
    return Column(
      children: <Widget>[
        Column(
          children: [
            TextButton(
              onPressed: () {
                return showDialog(
                    context: context,
                    builder: (context) =>
                        AlertDialog(
                          actions: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: datePicker(),
                            ),
                            Row(
                              children: [
                                TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      await statCalc(
                                          selectedMonth, selectedYear);
                                    },
                                    child: Text('חיפוש')),
                                TextButton(onPressed: () {
                                  Navigator.pop(context);
                                }, child: Text("ביטול")),
                              ],
                            )
                          ],
                        ));
              },
              child: Text("תאריך לבחירה"),
            ),
          ],
        ),
        Expanded(
          child: PieChart(
              PieChartData(
                borderData: FlBorderData(show: false),
                sectionsSpace: 0,
                centerSpaceRadius: 60,
                sections: getSections(),
              )
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
    );
  }

  lineChartBody() {
    return Column(
      children: <Widget>[
        Column(
          children: [
            TextButton(
              onPressed: () {
                companyAndYearPicker();
              },
              child: Text("תאריך לבחירה וסוג חברה"),
            ),
          ],
        ),
        Expanded(
          child: BarChartSample3(),
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
    );
  }

  lineStatisticCalc(String startYear, String endYear,String selectedCompany) async {
    final user = FirebaseAuth.instance.currentUser;
    bool flag = false;
    await FirebaseFirestore.instance.collection("users").doc(user.uid).collection(selectedCompany).get().then((value) {
      value.docs.forEach((element) async {
        int res = int.parse(element.get('invoiceDate').toString().split('/')[2]); // take year from specific invoice (yyyy)
        if ((res >= int.parse(startYear)) && res <= int.parse(endYear)){
          totalPerCompany = double.parse(element.get('invoiceSum')); // take sum from specific invoice
          //testMap.addAll({res : totalPerCompany});
          // if (testMap.containsKey(res)) {
          //   testMap.update(res, (value) => value + totalPerCompany);
          // }
          //totalPerCompany =0;
          testMap.forEach((key, value) {
            if (key == res && value != totalPerCompany) {
              testMap.update(key, (value) => totalPerCompany +value);
            }
          });
        }
      });
    });
    print(testMap);
  }



}


