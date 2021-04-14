import 'package:flutter/cupertino.dart';
import 'package:charts_flutter/flutter.dart' as charts;


class Chart extends StatefulWidget {
  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  final List<Company> data = [
    Company(month: '11', year: '2021',price: 100),
    Company(month: '8', year: '2021',price: 200),
    Company(month: '4', year: '2021',price: 100)];
  @override
  Widget build(BuildContext context) {
    return widget;
  }
}


class Company{
  String month;
  String year;
  int price;
  final charts.Color color;
  Company({this.month,
    this.year, this.price, this.color});

}