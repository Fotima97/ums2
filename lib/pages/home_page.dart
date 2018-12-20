import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ussdcontrol/helpers/app_constants.dart';
import 'package:ussdcontrol/helpers/drawer.dart';

String languageType1;
var connectivity;

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double iconWidth = 60.0;
  double iconHeight = 60.0;
  double spaceBetweenRows = 40.0;
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  void _navigateToItemDetail(Map<String, dynamic> message) {
    // Clear away dialogs
    Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
    Navigator.pushNamed(context, '/news');
  }

  var textStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0);
  @override
  void initState() {
    super.initState();
    checkConnectivity();
    checkFirstLog();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('onMessage $message');
      },
      onResume: (Map<String, dynamic> message) {
        _navigateToItemDetail(message);
        //   Navigator.pushNamed(context, '/news');
      },
      onLaunch: (Map<String, dynamic> message) {
        _navigateToItemDetail(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  getLanguagetype() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      if (preferences.getInt(languageType) != null) {
        if (preferences.getInt(languageType) == 0) {
          languageType1 = uzbek;
        } else {
          languageType1 = russian;
        }
      } else {
        languageType1 = russian;
      }
    });
  }

  checkFirstLog() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getInt('firstLog') == null ||
        preferences.getInt('firstLog') == 0) {
      preferences.setInt('firstLog', 1);
      try {
        _firebaseMessaging.subscribeToTopic('news');
      } catch (e) {
        print(e);
      }
    } else {
      print('not firstLog registred');
    }
  }

  @override
  Widget build(BuildContext context) {
    getLanguagetype();
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        drawer: DrawerContainer(),
        body: Container(
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0),
          child: ListView(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Image.asset('assets/ussdControl.png'),
                    ),
                    flex: 2,
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      languageType1 == uzbek
                          ? 'Boshqar! Nazorat qil! Zamon bilan hamnafas bo\'l!'
                          : 'Управляй! Контролируй! Будь в тренде!',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                      softWrap: true,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  FlatButton(
                    splashColor: Colors.red[50],
                    highlightColor: Colors.red[50],
                    child: Column(
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/Internet.svg',
                          allowDrawingOutsideViewBox: true,
                          height: iconHeight,
                          width: iconWidth,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(languageType1 == uzbek ? 'Internet' : 'Интернет',
                            style: textStyle)
                      ],
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/internet');
                    },
                  ),
                  FlatButton(
                    splashColor: Colors.red[50],
                    highlightColor: Colors.red[50],
                    child: Column(
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/Muloqot.svg',
                          allowDrawingOutsideViewBox: true,
                          height: iconHeight,
                          width: iconWidth,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(languageType1 == uzbek ? 'Muloqot' : 'Общение',
                            style: textStyle)
                      ],
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/chat');
                    },
                  ),
                ],
              ),
              SizedBox(
                height: spaceBetweenRows,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  FlatButton(
                    splashColor: Colors.red[50],
                    highlightColor: Colors.red[50],
                    child: Column(
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/Tarif_rejalar.svg',
                          allowDrawingOutsideViewBox: true,
                          height: iconHeight,
                          width: iconWidth,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(languageType1 == uzbek ? 'Tariflar' : 'Тарифы',
                            style: textStyle)
                      ],
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/tariffs');
                    },
                  ),
                  FlatButton(
                    splashColor: Colors.red[50],
                    highlightColor: Colors.red[50],
                    child: Column(
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/Yordam.svg',
                          allowDrawingOutsideViewBox: true,
                          height: iconHeight,
                          width: iconWidth,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(languageType1 == uzbek ? 'Yordamchi' : 'Помощник',
                            style: textStyle)
                      ],
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/help');
                    },
                  ),
                ],
              ),
              SizedBox(
                height: spaceBetweenRows,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  FlatButton(
                    splashColor: Colors.red[50],
                    highlightColor: Colors.red[50],
                    child: Column(
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/Hizmatlar.svg',
                          allowDrawingOutsideViewBox: true,
                          height: iconHeight,
                          width: iconWidth,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(languageType1 == uzbek ? 'Xizmatlar' : 'Услуги',
                            style: textStyle)
                      ],
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/services');
                    },
                  ),
                  FlatButton(
                    splashColor: Colors.red[50],
                    highlightColor: Colors.red[50],
                    child: Column(
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/News.svg',
                          allowDrawingOutsideViewBox: true,
                          height: iconHeight,
                          width: iconWidth,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(languageType1 == uzbek ? 'Yangiliklar' : 'Новости',
                            style: textStyle)
                      ],
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/news');
                    },
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

class _firebaseMessaging {}

void checkConnectivity() async {
  connectivity = await (new Connectivity().checkConnectivity());
}
