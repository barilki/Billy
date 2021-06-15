import 'package:billy/compare_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:billy/icons/icon_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'companies/main_companies.dart';
import 'constants/constants.dart';
import 'icons/reusable_icon.dart';


class BillyMainPage extends StatefulWidget {
  @override
  _BillyMainPageState createState() => _BillyMainPageState();
}

class _BillyMainPageState extends State<BillyMainPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBackGroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: inputData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) return new Text(snapshot.data);
                else if (snapshot.hasError) return Text("data error (see futurebuilder)");
                return Text("Await for data");
              },
            ),
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
                                  MainCompanies(companyName: 'IEC')));
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
                                  MainCompanies(companyName: 'Water company')));
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
                                  MainCompanies(companyName: 'Gas company')));
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
                                  companyName: 'Arnona company')));
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
                                  companyName: 'Cellular company')));
                    },
                    colour: Colors.white,
                    cardChild: IconContent(img: 'smartphone.png'),
                  ),
                  ReusableIcon(
                    onPress: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MainCompanies(companyName: 'Tv company')));
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
          ],
        ),
    );
  }


  Future<String> inputData() async{
    return 'Welcome ' + auth.currentUser.displayName;
  }


}
