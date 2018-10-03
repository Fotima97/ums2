import 'package:flutter/material.dart';
import 'package:ums/helpers/app_constants.dart';
import 'package:ums/pages/home_page.dart';
import 'package:flutter_html/flutter_html.dart';

class InternetHelpPage extends StatefulWidget {
  InternetHelpPage({Key key, this.content}) : super(key: key);
  final String content;
  @override
  _InternetHelpPageState createState() => new _InternetHelpPageState();
}

class _InternetHelpPageState extends State<InternetHelpPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(languageType1 == uzbek ? 'Yordam' : 'Помощь'),
      ),
      body: Container(
          child: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Html(
          data: widget.content,
        ),
      )),
    );
  }
}
