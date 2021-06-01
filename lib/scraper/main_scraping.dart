
import 'package:billy/constants/constants.dart';
import 'package:billy/scraper/scraping.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_scraper/web_scraper.dart';

import 'companies.dart';

void main() => runApp(MainScraping());

class MainScraping extends StatefulWidget {
  @override
  _MainScrapingState createState() => _MainScrapingState();
}

class _MainScrapingState extends State<MainScraping> {
  final List<Company> company = [];

  @override
  Widget build(BuildContext context) {

    final progress = Column(
      children: [
        SizedBox(height: 15),
        Center(
          child:CircularProgressIndicator(backgroundColor: Colors.amber,),
        )

      ]
    );

    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(
          backgroundColor: kBackGroundColor,
          automaticallyImplyLeading: true,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Compare Page'),
            ],
          )),
      body: CustomScrollView(
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
    );
  }


  scrap(String companyName, String image, String url, String path) async {
    final webScraper = WebScraper(url);
    if (await webScraper.loadWebPage(path)) {

      setState(() {
        //Price of each plan
        var price = webScraper.getElement('.search__p_h_2_price', ['price']);
        //Title of each plan
        var plan = webScraper.getElement('.__h2', ['plan']);
        //Description of each plan
        var aboutPlan = webScraper.getElement('.search__p_h_2_tn > :nth-child(3)', ['aboutPlan']);

        print(plan);
        for(int i=0; i<6 ; i++){
          company.add(Company(
              name: companyName,
              plan: plan[i]['title'],
              priceAddress: price[i]['title'],
              descAddress: aboutPlan[i]['title'],
              image: 'images/$image'));
        }

      });



    }

  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrap('hotMobile' ,'hotmobile.png','https://www.haboreret.co.il', '/%d7%94%d7%95%d7%98-%d7%9e%d7%95%d7%91%d7%99%d7%99%d7%9c/');
  }
  
}


