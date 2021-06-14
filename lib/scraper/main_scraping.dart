import 'package:billy/constants/constants.dart';
import 'package:billy/scraper/scraping.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_scraper/web_scraper.dart';

import 'companies.dart';

// void main() => runApp(MainScraping());

class MainScraping extends StatefulWidget {
  final String companyType;
  MainScraping({this.companyType});

  @override
  _MainScrapingState createState() => _MainScrapingState();
}

class _MainScrapingState extends State<MainScraping> {
  //List of scraped data
  final List<Company> company = [];
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackGroundColor,
      appBar: AppBar(
          backgroundColor: kBackGroundColor,
          automaticallyImplyLeading: true,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.companyType),
            ],
          )),
      body: Container(
        child: isLoading ? Center(child: CircularProgressIndicator(),) : Center(
          child: CustomScrollView(
            scrollDirection: Axis.vertical,
            shrinkWrap: false,
            slivers: <Widget>[
              new SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                sliver: new SliverList(
                  delegate: new SliverChildBuilderDelegate(
                    (context, index) {
                      return Scraping(company[index]);
                    },
                    childCount: company.length,
                  ),
                ),
              ),
            ],
          ),
        ),
        ),
      );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.companyType == 'Cellular' ) {
      scrap('hotMobile', 'hotmobile.png', 'https://www.haboreret.co.il',
          '/הוט-מובייל/');
      scrap('Partner', 'partner.png', 'https://www.haboreret.co.il', '/פרטנר/');
      scrap('Pelephone', 'pelephone.png', 'https://www.haboreret.co.il',
          '/פלאפון/');
      scrap('Cellcom', 'Cellcom.png', 'https://www.haboreret.co.il', '/סלקום/');
      scrap('GolanTelecom', 'GolanTelecom.png', 'https://www.haboreret.co.il',
          '/גולן-טלקום/');
      scrap(
          '012', 'GolanTelecom.png', 'https://www.haboreret.co.il', '/012-2/');
    }
    if(widget.companyType == 'Tv'){
      scrap('Hot', 'hot.png', 'https://www.haboreret.co.il', '/הוט/');
      scrap('Yes', 'yes.png', 'https://www.haboreret.co.il', '/yes/');
      scrap('Cellcom TV', 'cellcomtv.png', 'https://www.haboreret.co.il', '/סלקום-tv/');
      scrap('Sting TV', 'stingtv.png', 'https://www.haboreret.co.il', '/סטינג-טיוי/');
      scrap('Partner TV', 'partnertv.png', 'https://www.haboreret.co.il', '/פרטנר-tv/');

    }

  }

  //Web data extraction function (scraping)
  void scrap(String companyName, String image, String url, String path) async {
    final webScraper = WebScraper(url);

    if (await webScraper.loadWebPage(path)) {
      isLoading = false;
      //Price of each plan
      var price = webScraper.getElement('.search__p_h_2_price', ['price']);
      //Title of each plan
      var plan = webScraper.getElement('.__h2', ['plan']);
      //Description of each plan
      var aboutPlan = webScraper
          .getElement('.search__p_h_2_tn > :nth-child(3)', ['aboutPlan']);
      for (int i = 0; i < 10; i++) {
        setState(() {
          company.add(Company(
              name: companyName,
              plan: plan[i]['title'],
              priceAddress: price[i]['title'],
              descAddress: aboutPlan[i]['title'],
              image: 'images/$image'));
        });
      }
    }

  }

}
