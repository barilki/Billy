import 'package:billy/components/pie_chart_page.dart';
import 'package:flutter/material.dart';


class PieData{
  final double iec;
  final double water;
  final double gas;
  final double arnona;
  final double cellular;
  final double tv;
  List<Data> data = [];
  PieData({this.iec, this.water, this.gas, this.arnona, this.cellular, this.tv}) {
    //print(iec);
    //print(water);
      data = [
        Data(name: 'IEC', percent: iec, color: Colors.blue),
        Data(name: 'Water Company', percent: water, color: Colors.lightGreen),
        Data(name: 'Gas Company', percent: gas, color: Colors.black),
        Data(name: 'Arnona Company', percent: arnona, color: Colors.pinkAccent),
        Data(name: 'Cellular Company', percent: cellular, color: Colors.red),
        Data(name: 'TV Company', percent: tv, color: Colors.orange),
      ];
  }



}

class Data {
  final String name;
  final double percent;
  final Color color;

  Data({this.name, this.percent, this.color});
}