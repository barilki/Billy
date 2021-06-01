import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_scraper/web_scraper.dart';

import 'companies.dart';

class Scraping extends StatefulWidget {
  final Company company;
  final List<Company> companies = [];
  Scraping(this.company);

  @override
  _ScrapingState createState() => _ScrapingState();
}

class _ScrapingState extends State<Scraping> {

  @override
  Widget build(BuildContext context) {

    final companyThumbnail = new Container(
      margin: new EdgeInsets.symmetric(
          vertical: 16.0
      ),
      alignment: FractionalOffset.centerLeft,
      child: Image.asset(
        widget.company.image,
        width: 92.0,
        height: 92.0,
      ),
    );

    final baseTextStyle = const TextStyle(
        fontFamily: 'Poppins'
    );
    final regularTextStyle = baseTextStyle.copyWith(
        color: Colors.black,
        fontSize: 9.0,
        fontWeight: FontWeight.w400
    );
    final subHeaderTextStyle = regularTextStyle.copyWith(
        fontSize: 12.0
    );
    final headerTextStyle = baseTextStyle.copyWith(
        color: Colors.black,
        fontSize: 18.0,
        fontWeight: FontWeight.w600
    );

    Widget _planetValue({String value, String image}) {
      return new Row(
          children: <Widget>[
            new Image.asset(image, height: 12.0),
            new Container(width: 8.0),
            new Text("test", style: regularTextStyle),
          ]
      );
    }


    final planetCardContent = new Container(
      margin: new EdgeInsets.fromLTRB(76.0, 16.0, 16.0, 16.0),
      constraints: new BoxConstraints.expand(),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(height: 4.0),
          new Row(
            children: [
              new Text(widget.company.priceAddress, style: headerTextStyle),
              new Container(width: 3.0),
              new Text("|", style: headerTextStyle),
              new Container(width: 3.0),
              new Text(widget.company.plan, style: headerTextStyle, textDirection: TextDirection.rtl),
            ],
          ),
          new Container(height: 10.0),
          new Text(widget.company.descAddress, style: subHeaderTextStyle, textDirection: TextDirection.rtl),
          // new Container(
          //     margin: new EdgeInsets.symmetric(vertical: 8.0),
          //     height: 2.0,
          //     width: 18.0,
          //     color: new Color(0xff00c6ff)
          // ),
        ],
      ),
    );


    final planetCard = new Container(
      child: planetCardContent,
      height: 124.0,
      margin: new EdgeInsets.only(left: 46.0),
      decoration: new BoxDecoration(
        color: Colors.white70,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0),
          ),
        ],
      ),
    );


    return new Container(
        height: 120.0,
        margin: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 24.0,
        ),
        child: new Stack(
          children: <Widget>[
            planetCard,
            companyThumbnail,
          ],
        )
    );
  }


}




