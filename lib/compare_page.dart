import 'package:billy/scraper/main_scraping.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imap_client/imap_client.dart';

import 'constants/constants.dart';
import 'icons/icon_content.dart';
import 'icons/reusable_icon.dart';

class ComparePage extends StatefulWidget {
  @override
  _ComparePageState createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0,),
        backgroundColor: kBackGroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            kMainLogo,
            kCompareLogo,
            SizedBox(
              height: 50.0,
            ),
            Center(
              child: GridView.count(
                crossAxisSpacing: 70,
                shrinkWrap: true,
                crossAxisCount: 2,
                // crossAxisSpacing: 20.0,
                children: <Widget>[
                  ReusableIcon(
                    onPress: () async {
                      //aboutUs(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MainScraping(companyType: 'tv')));
                    },
                    colour: Colors.white,
                    cardChild: IconContent(img: "tv.png"),
                  ),
                  ReusableIcon(
                    onPress: () async {
                      //aboutUs(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MainScraping(companyType: 'cellular',)));
                    },
                    colour: Colors.white,
                    cardChild: IconContent(img: "cellular.png"),
                  ),
                ],
              ),

            ),
          ],
        ),
      ),
    );
  }


  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<String> inputData() async{
    final User user = auth.currentUser;
    final uid = user.email;
    return 'Welcome ' + uid;
  }


}
