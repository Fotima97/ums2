import 'package:flutter/material.dart';
import 'package:ums/helpers/app_constants.dart';
import 'package:ums/helpers/drawer.dart';
import 'package:ums/pages/home_page.dart';

class NewsMorePage extends StatefulWidget {
  NewsMorePage({Key key, this.title, this.body}) : super(key: key);

  final String title;
  final String body;

  @override
  _NewsMorePageState createState() => new _NewsMorePageState();
}

class _NewsMorePageState extends State<NewsMorePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(languageType1 == uzbek ? 'Yangiliklar' : 'Новости'),
        ),
        body: Container(
          padding: EdgeInsets.all(15.0),
          child: ListView(
            children: <Widget>[
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                widget.body,
                softWrap: true,
              )
            ],
          ),
        ));
  }
}
