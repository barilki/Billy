import 'dart:ui';

import 'package:billy/compare_page.dart';
import 'package:billy/login/auth_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:billy/icons/icon_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis/drive/v2.dart';
import 'companies/main_companies.dart';
import 'constants/constants.dart';
import 'icons/reusable_icon.dart';
import 'login/log_page.dart';


class CompaniesPage extends StatefulWidget {
  @override
  _CompaniesPageState createState() => _CompaniesPageState();

  void init() {
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid);
  }


}

class _CompaniesPageState extends State<CompaniesPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(('שלום ' + _auth.currentUser.displayName+'.'),textDirection: TextDirection.rtl,style: TextStyle(color: Colors.white, fontSize: 18),),
          ],
        ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
            elevation: 0.0,
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(onPressed: () async{
                  await _auth.signOut();
                  Navigator.push(context, MaterialPageRoute(builder: (
                      context) => AuthPage()));
                }, child: Text('התנתק',style: TextStyle(color: Colors.white),))
              ],
            ),),
        backgroundColor: kBackGroundColor,
        body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.hasData) return new Text(snapshot.data);
                else if (snapshot.hasError) return Text("");
                return Text("");
              },
            ),
            kMainLogo,
            kSmallLogo,
            SizedBox(height: 20,),
            Expanded(
              child: Center(
                child: GridView.count(
                  crossAxisSpacing: 10,
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  // crossAxisSpacing: 20.0,
                  children: <Widget>[
                    ReusableIcon(
                      onPress: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MainCompanies(companyName: 'חשמל')));
                      },
                      colour: Colors.white,
                      cardChild: IconContent(img: 'electric.png'),
                    ),
                    ReusableIcon(
                      onPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MainCompanies(companyName: 'מים')));
                      },
                      colour: Colors.white,
                      cardChild: IconContent(img: 'water.png'),
                    ),
                    ReusableIcon(
                      onPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MainCompanies(companyName: 'גז')));
                      },
                      colour: Colors.white,
                      cardChild: IconContent(img: 'gas.png'),
                    ),
                    ReusableIcon(
                      onPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainCompanies(
                                    companyName: 'ארנונה')));
                      },
                      colour: Colors.white,
                      cardChild: IconContent(img: 'arnona.png'),
                    ),
                    ReusableIcon(
                      onPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainCompanies(
                                    companyName: 'סלולר')));
                      },
                      colour: Colors.white,
                      cardChild: IconContent(img: 'smartphone.png'),
                    ),
                    ReusableIcon(
                      onPress: () async{
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MainCompanies(companyName: 'כבלים')));
                      },
                      colour: Colors.white,
                      cardChild: IconContent(img: 'television.png'),
                    ),
                    ReusableIcon(
                      onPress: () async {
                        //aboutUs(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ComparePage()));
                      },
                      colour: Colors.white,
                      cardChild: IconContent(img: "compare.png"),
                    )
                  ],
                ),

              ),
            ),



          ],
        ),
    );
  }




}
