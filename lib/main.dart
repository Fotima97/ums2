import 'package:flutter/material.dart';
import 'package:ums/helpers/app_constants.dart';
import 'package:ums/pages/chat_page.dart';
import 'package:ums/pages/help_page.dart';
import 'package:ums/pages/home_page.dart';
import 'package:ums/pages/internet_help_page.dart';
import 'package:ums/pages/internet_page.dart';
import 'package:ums/pages/language_page.dart';
import 'package:ums/pages/news_page.dart';
import 'package:ums/pages/services_page.dart';
import 'package:ums/pages/tariffs_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'UMS',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(primarySwatch: Colors.red, fontFamily: 'Roboto'),
      home: new HomePage(title: 'UMS Control'),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => HomePage(title: 'UMS Control'),
        '/help': (BuildContext context) =>
            HelpPage(title: languageType1 == uzbek ? 'Yordam' : 'Помощь'),
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
