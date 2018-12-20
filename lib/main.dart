import 'package:flutter/material.dart';
import 'package:ussdcontrol/helpers/app_constants.dart';
import 'package:ussdcontrol/pages/chat_page.dart';
import 'package:ussdcontrol/pages/help_page.dart';
import 'package:ussdcontrol/pages/home_page.dart';
import 'package:ussdcontrol/pages/internet_help_page.dart';
import 'package:ussdcontrol/pages/internet_page.dart';
import 'package:ussdcontrol/pages/language_page.dart';
import 'package:ussdcontrol/pages/news_page.dart';
import 'package:ussdcontrol/pages/services_page.dart';
import 'package:ussdcontrol/pages/tariffs_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'USSD Control',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(primarySwatch: Colors.red, fontFamily: 'Roboto'),
      home: new HomePage(title: 'USSD Control'),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => HomePage(title: 'USSD Control'),
        '/help': (BuildContext context) =>
            HelpPage(title: languageType1 == uzbek ? 'Yordamchi' : 'Помощник'),
        '/internet': (BuildContext context) => InternetPage(
            title: languageType1 == uzbek ? 'Internet' : 'Интернет'),
        '/tariffs': (BuildContext context) =>
            TariffsPage(title: languageType1 == uzbek ? 'Tariflar' : 'Тарифы'),
        '/chat': (BuildContext context) =>
            ChatPage(title: languageType1 == uzbek ? 'Muloqot' : 'Общение'),
        '/services': (BuildContext context) => ServicesPage(
            title: languageType1 == uzbek ? 'Xizmatlar' : 'Услуги'),
        '/news': (BuildContext context) =>
            NewsPage(title: languageType1 == uzbek ? 'Yangiliklar' : 'Новости'),
        '/language': (BuildContext context) => LanguagePage(
            title:
                languageType1 == uzbek ? 'Tilni o`zgartirish' : 'Сменить язык'),
        '/internetHelp': (BuildContext context) => InternetHelpPage(),
      },
    );
  }
}
