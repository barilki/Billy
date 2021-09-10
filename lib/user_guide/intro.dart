import 'package:billy/companies_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';

void main() => runApp(Intro());

class Intro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: OnBoardingPage(),
    );
  }
}

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => CompaniesPage()),
    );
  }

  Widget _buildFullscrenImage(String assetName) {
    return Image.asset(
      'assets/$assetName.png',
      height:400,
      width:900,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String assetName, double width, double height) {
    return Image.asset('assets/$assetName', width: width, height: height,);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600);

    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700,color: Colors.white),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.lightBlue,


    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: IntroductionScreen(
        key: introKey,
        color: Colors.orange,
        skipColor: Colors.red,
        doneColor: Colors.pinkAccent,
        nextColor: Colors.blue,
        globalBackgroundColor: Colors.lightBlue,
        pages: [
          PageViewModel(
            title: "ברוכים הבאים ל- Billy",
            body:
            "במדריך הבא תלמדו איך אפשר לשלוט על הוצאות הבית וגם לחסוך, מוכנים?\n"
            "\nלחצו על אחת הבועיות, לכניסה לחברה הרצויה.",
            image: _buildFullscrenImage("intro1"),
            decoration: pageDecoration.copyWith(
              contentMargin: const EdgeInsets.symmetric(horizontal: 18),
              fullScreen: false,
              bodyFlex:6,
              imageFlex: 9,
            ),
          ),
          PageViewModel(
            title: "חשבוניות",
            body:
            "לחצו על הלחצן האדום לפתיחת התפריט ובחרו את האפשרות המתאימה לכם להוספת החשבונית.\n"
            "\n"
              "הוספה ידנית: בעזרת הקלדה של פרטי החשבונית והעלאת תמונה.\n"
                "הוספה אוטומטית: בעזרת צילום וסריקת החשבונית.\n\n"
            "לתשלום לחצו לחיצה ארוכה על החשבונית למעבר לדף התשלום בחברה.",
            image: _buildFullscrenImage("intro2"),
            decoration: pageDecoration.copyWith(
              contentMargin: const EdgeInsets.symmetric(horizontal: 18),
              fullScreen: false,
              bodyFlex:8,
              imageFlex: 10,
            ),
          ),
        PageViewModel(
            title: "הוספה ידנית",
            body:
            "מלאו את השדות הבאים:\n"
                "-מספר לקוח עד 9 ספרות\n"
                "-מספר חשבונית עד 9 ספרות\n"
                "-תאריך בפורמט dd/mm/yyyy\n"
                "סכום עד 5 ספרות\n"
                "ניתן להוסיף חשבונית בעזרת העלאה\\צילום חשבונית",
            image: _buildFullscrenImage("intro3"),
            decoration: pageDecoration.copyWith(
              contentMargin: const EdgeInsets.symmetric(horizontal: 18),
              fullScreen: false,
              bodyFlex:6,
              imageFlex: 9,
            ),
          ),
          PageViewModel(
            title: "הוספה באמצעות צילום וסריקה",
            body:
            "1.קרבו את המצלמה לחשבונית\n"
                "2.הקפידו שהחשבונית תיכנס למסגרת הלבנה בהתאמה מלאה\n"
                "לחצו את לחצן ה-צלם\n\n"
                "*רצוי לצלם בסביבה מוארת*",
            image: _buildFullscrenImage("intro4"),
            decoration: pageDecoration.copyWith(
              contentMargin: const EdgeInsets.symmetric(horizontal: 18),
              fullScreen: false,
              bodyFlex:6,
              imageFlex: 9,
            ),
          ),
          PageViewModel(
            title: "סטטיסטיקה - חודשית",
            body:
            "לחצו על כפתור ה-תאריך לבחירה\n"
            "ובחרו את החודש והשנה בכדי לראות את ההוצאות בתאריך הנבחר. \n\n"
            "למעבר לדף ההוצאות השנתיות, לחצו על האייקון מס' 2.",
            image: _buildFullscrenImage("intro5"),
            decoration: pageDecoration.copyWith(
              contentMargin: const EdgeInsets.symmetric(horizontal: 18),
              fullScreen: false,
              bodyFlex:6,
              imageFlex: 9,
            ),
          ),
          PageViewModel(
            title: "סטטיסטיקה - שנתית",
            body:
            "לחצו על כפתור 'תאריך לבחירה וסוג חברה'\n"
            "בחרו חברה וטווח תאריכים להצגת הוצאות שנתיות.\n\n"
            "למעבר לדף ההוצאות החודשיות, לחצו על האייקון מס' 1.",
            image: _buildFullscrenImage("intro6"),
            decoration: pageDecoration.copyWith(
              contentMargin: const EdgeInsets.symmetric(horizontal: 18),
              fullScreen: false,
              bodyFlex:6,
              imageFlex: 9,
            ),
            // reverse: true,
          ),
          PageViewModel(
            title: "השוואת מחירים",
            body:
            "בלחיצה על השוואת מחירים בדף הראשי תועברו לדף נחיתה לצורך השוואת מסלולים ומחירים בשוק סלולר והטלוויזיה.\n"
                "לחצו על אחד מהאייקונים למעבר לדף ההשוואות.\n\n",
            image: Expanded(
              child: Row(
                children: [
              Image.asset('assets/intro7.png', width: 205, height: 330,),
              Image.asset('assets/intro8.png', width: 205, height: 330,),
                ],
              ),
            ),
            decoration: pageDecoration.copyWith(
              contentMargin: const EdgeInsets.symmetric(horizontal: 18),
              fullScreen: false,
              bodyFlex:6,
              imageFlex: 9,
            ),
            // reverse: true,
          ),
        ],
        onDone: () => _onIntroEnd(context),
        //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
        showSkipButton: true,
        skipFlex: 0,
        nextFlex: 0,
        //rtl: true, // Display as right-to-left
        skip: const Text('דלג', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
        next: const Icon(Icons.arrow_forward),
        done: const Text('עבור לאפליקציה', style: TextStyle(fontWeight: FontWeight.w600)),
        curve: Curves.fastLinearToSlowEaseIn,
        controlsMargin: const EdgeInsets.all(16),
        controlsPadding: kIsWeb
            ? const EdgeInsets.all(12.0)
            : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
        dotsDecorator: const DotsDecorator(
          size: Size(10.0, 10.0),
          color: Colors.white,
          activeSize: Size(22.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
        dotsContainerDecorator: const ShapeDecoration(
          color: Colors.white60,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
      ),
    );
  }
}
