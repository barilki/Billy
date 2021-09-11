import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flip;
  static final companyName = ['חשמל', 'מים', 'גז', 'ארנונה', 'סלולר', 'כבלים'];
  String dueDate;
  static DateTime _now = DateTime.now();
  PushNotificationService({this.flip}){
    getDue();
}

//Return companyName and invoiceID of invoice that Due Date equal to Current Date.
  Future<void> getDue() async {
    final user = FirebaseAuth.instance.currentUser;
    for (var i=0; i<companyName.length; i++) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection(companyName[i])
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          if (dateNowSplit() == result.get('invoiceDueDate')) {
            _showNotificationWithDefaultSound(flip, companyName[i].toString());
            print(result.get('invoiceID') + ' ' + companyName[i].toString());
          }
        });
      });
    }
  }


  //Verify that Date formart is DD/MM/YYYY and return as a string
  static String dateNowSplit() {
    if (_now.month < 10) {
      return _now.day.toString() + '/0' + _now.month.toString() + '/' +
          _now.year.toString();
    }
    else if (_now.day < 10) {
      return '0' + _now.day.toString() + '/' + _now.month.toString() + '/' +
          _now.year.toString();
    }
    else if (_now.day < 10 && _now.month < 10) {
      return '0' + _now.day.toString() + '/0' + _now.month.toString() + '/' +
          _now.year.toString();
    }
    else {
      return _now.day.toString() + '/' + _now.month.toString() + '/' +
          _now.year.toString();
    }
  }

  Future _showNotificationWithDefaultSound(flip,companyName) async {

    // Show a notification after every 15 minute with the first
    // appearance happening a minute after invoking the method
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id',
        'your channel name',
        'your channel description',
        importance: Importance.max,
        priority: Priority.high
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();

    // initialise channel platform for both Android and iOS device.
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics
    );
    await flip.show(0, 'Billy',
        'התראת תשלום - שלם את חשבון חברת ה-$companyName',
        platformChannelSpecifics, payload: 'Default_Sound'
    );
  }



}