import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ums/helpers/app_constants.dart';
import 'package:ums/helpers/drawer.dart';
import 'package:ums/pages/home_page.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatefulWidget {
  HelpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HelpPageState createState() => new _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  static const platform = const MethodChannel(channel);

  Future _call(String number) async {
   
    try {
      await platform.invokeMethod('callNumber', number);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          children: <Widget>[
            ListTile(
              title: Text(
                languageType1 == uzbek
                    ? 'Hisobni tekshirish'
                    : 'Проверка баланса',
              ),
              onTap: () {
                // launch('tel:*100%23');
                _call('*100%23');
              },
            ),
            Divider(
              height: 2.0,
            ),
            ListTile(
                title: Text(
                  languageType1 == uzbek
                      ? 'Oxirgi to`lov'
                      : 'Последняя оплата баланса',
                ),
                onTap: () {
                                    _call('*111*015%23');

                }),
            Divider(
              height: 2.0,
            ),
            ListTile(
                title: Text(
                  languageType1 == uzbek
                      ? 'Mening xarajatlarim'
                      : 'Мои расходы',
                ),
                onTap: () {
                  _call('*111*025%23');
                }),
            Divider(
              height: 2.0,
            ),
            ListTile(
                title: Text(
                  languageType1 == uzbek
                      ? 'Reklamalarni taqiqlash'
                      : 'Запрет рассылок',
                ),
                onTap: () {}),
            Divider(
              height: 2.0,
            ),
            ListTile(
                title: Text(
                  languageType1 == uzbek
                      ? 'Yoqilgan xizmatlar'
                      : 'Подключенные услуги',
                ),
                onTap: () {
                  _call('140%23');
                }),
            Divider(
              height: 2.0,
            ),
            ListTile(
                title: Text(
                  languageType1 == uzbek ? 'Mening raqamim' : 'Мой номер',
                ),
                onTap: () {
                  _call('*150%23');
                }),
            Divider(
              height: 2.0,
            ),
            ListTile(
                title: Text(
                  languageType1 == uzbek
                      ? 'Mening barcha raqamlarim'
                      : 'Все мои номера',
                ),
                onTap: () {
                  _call('*151%23');
                }),
            Divider(
              height: 2.0,
            ),
            ListTile(
              title: Text(
                languageType1 == uzbek
                    ? 'Yordam berish xizmati'
                    : 'Службы поддержки',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                _call('0890');
              },
              trailing: Icon(Icons.call),
            ),
            Divider(
              height: 2.0,
            ),
          ],
        ));
  }
}
