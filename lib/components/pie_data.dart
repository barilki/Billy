import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PieData {
  static List<Data> data = [
    Data(name: 'IEC', percent: 5, color: Colors.blue),
    Data(name: 'Water Company', percent: 10, color: Colors.lightGreen),
    Data(name: 'Gas Company', percent: 15, color: Colors.black),
    Data(name: 'Arnona Company', percent: 20, color: Colors.pinkAccent),
    Data(name: 'Cellular Company', percent: 25, color: Colors.red),
    Data(name: 'TV Company', percent: 25, color: Colors.orange),
  ];
}

class Data {
  final String name;

  final double percent;

  final Color color;

  Data({this.name, this.percent, this.color});
}