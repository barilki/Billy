import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:billy/components/icon_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'companies/main_companies.dart';
import 'components/reusable_icon.dart';
import 'components/constants.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:imap_client/imap_client.dart';
import 'ocrpage.dart';

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
                if (snapshot.hasData) return Text(snapshot.data);
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
                                  companyName: 'Property Taxes company')));
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
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.details),
                onPressed: () {
                  aboutUs(context);
                },
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.chat),
                onPressed: () async {
                },
              ),
            ],
          ),
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



  //Get url as a string and open inside alert dialog
  Future<void> aboutUs(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Row(
                  children:[
                    Text('Application Build by'),
                  ]
              ),
            );
          });
        });
  }



  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<String> inputData() async{
    final User user = auth.currentUser;
    final uid = user.email;
    return 'Welcome ' + uid;
  }


}
