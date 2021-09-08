import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../constants/url_constants.dart';


class PaymentPage extends StatelessWidget {
  String companyName;
  String invoiceID;
  String invoiceSum;
  List<String> siteList = [IEC,Watercompany,Gascompany,Arnonacompany,Cellularcompany,Tvcompany];
  List<String> companies = ['חשמל','מים','גז','ארנונה','סלולר','כבלים'];
  PaymentPage(this.companyName);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: getPaymentSite(),
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }

  getPaymentSite() {
    for (var i=0; i<companies.length; i++) {
      if (companyName == companies[i])
        return siteList[i];
    }
    }
}


