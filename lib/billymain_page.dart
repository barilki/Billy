import 'package:billy/compare_page.dart';
import 'package:billy/scraper/main_scraping.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:billy/icons/icon_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'companies/main_companies.dart';
import 'constants/constants.dart';
import 'icons/reusable_icon.dart';
import 'package:imap_client/imap_client.dart';


class BillyMainPage extends StatefulWidget {
  @override
  _BillyMainPageState createState() => _BillyMainPageState();
}

class _BillyMainPageState extends State<BillyMainPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
      ),
    );
  }

  Future<void> _main() async {
    // print log, helpful for debugging
    printImapClientDebugLog();
    ImapClient client = new ImapClient();
    // connect
    await client.connect("imap.gmail.com", 993, true);
    // authenticate
    await client
        .authenticate(ImapPlainAuth("shaymanasherov@gmail.com", "barshay123!"));
    // get folder
    ImapFolder inbox = await client.getFolder("Inbox");
    // get "BODY" for message 1
    print(await inbox.fetch(['BODY[TEXT]'],
        messageIds: await inbox.search('shalom', uid: true)));
    // get "BODYSTRUCTURE" for message 1
    //print(await inbox.fetch(["BODYSTRUCTURE"], messageIds: [1]));
    // close connection
    await client.logout();
  }



  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<String> inputData() async{
    final User user = auth.currentUser;
    final uid = user.email;
    return 'Welcome ' + uid;
  }


}
