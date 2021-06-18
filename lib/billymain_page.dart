import 'dart:ui';

import 'package:billy/compare_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:billy/icons/icon_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'companies/main_companies.dart';
import 'constants/constants.dart';
import 'icons/reusable_icon.dart';
import 'login/log_page.dart';


class BillyMainPage extends StatefulWidget {
  @override
  _BillyMainPageState createState() => _BillyMainPageState();

}


class _BillyMainPageState extends State<BillyMainPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Text(('שלום ' + _auth.currentUser.displayName),textDirection: TextDirection.rtl,),
            kMainLogo,
            kSmallLogo,
            SizedBox(
              height: 50.0,
            ),
            Center(
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
                                  MainCompanies(companyName: 'חברת חשמל')));
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
            TextButton(onPressed: () async{
              await _auth.signOut();
              Navigator.push(context, MaterialPageRoute(builder: (
                  context) => LoginPage()));
              Navigator.push(context, MaterialPageRoute(builder: (
                  context) => LoginPage()));
            }, child: Text('התנתק'))
          ],
        ),
    );
  }




}
