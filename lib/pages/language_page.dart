import 'dart:async';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:ums/helpers/app_constants.dart';
import 'package:ums/helpers/drawer.dart';
import 'package:ums/pages/home_page.dart';

class LanguagePage extends StatefulWidget {
  LanguagePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LanguagePageState createState() => new _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  int radiovalue;
  static const platform = const MethodChannel(channel);

  Future _call(String number) async {
    try {
      await platform.invokeMethod('callNumber', number);
    } catch (e) {
      print(e);
    }
  }

  void radioValueChanged(int value) {
    setState(() {
      radiovalue = value;
      saveLanguageType(value);
    });
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

  saveLanguageType(int value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      pref.setInt(languageType, value);
    });
  }

  @override
  void initState() {
    super.initState();
    if (languageType1 == uzbek) {
      radiovalue = 0;
    } else {
      radiovalue = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    getLanguagetype();
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
              languageType1 == uzbek ? 'Tilni o`zgartirish' : 'Сменить язык'),
        ),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text('O`zbekcha'),
                  trailing: Radio(
                    value: 0,
                    groupValue: radiovalue,
                    onChanged: (int value) {
                      radioValueChanged(value);
                      _call('*111*1*1%23');
                    },
                    activeColor: Colors.red,
                  ),
                ),
                Divider(
                  height: 4.0,
                ),
                ListTile(
                  title: Text('Русский'),
                  trailing: Radio(
                    value: 1,
                    groupValue: radiovalue,
                    onChanged: (int value) {
                      radioValueChanged(value);
                      _call('*111*1*1%23');
                    },
                    activeColor: Colors.red,
                  ),
                ),
              ],
            )));
  }
}
