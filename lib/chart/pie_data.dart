import 'package:flutter/material.dart';


class PieData{
  final double iec;
  final double water;
  final double gas;
  final double arnona;
  final double cellular;
  final double tv;
  List<Data> data = [];
  List<double> newData = [];
  List<String> companyName = [];
  List<Color> colors = [];
  static int count = 0;
  PieData({this.iec, this.water, this.gas, this.arnona, this.cellular, this.tv}) {
    makeData();
  }

  makeData() {
    colors = [Colors.orange, Colors.blue, Colors.black, Colors.grey, Colors.pink, Colors.green];
    companyName = ['IEC', 'Water company', 'Gas company', 'Arnona company', 'Cellular company', 'Tv company'];
    newData = [iec,water,gas,arnona,cellular,tv];
    if (iec.toString() != 'NaN') {
      for (var i = 0; i < newData.length; i++) {
        if (newData[i] != 0.0)
          data += [Data(name: companyName[i], percent: newData[i], color: colors[i])];
      }
    }
    else
      data = [Data()];
  }


}

class Data {
  final String name;
  final double percent;
  final Color color;

  Data({this.name, this.percent, this.color});
}