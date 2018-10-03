import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ums/helpers/app_constants.dart';
import 'dart:io';

import 'package:ums/pages/home_page.dart';
import 'package:url_launcher/url_launcher.dart';

showDialogBox2(BuildContext context, String title, String ussd, String body,
    String okAction) {
  CupertinoAlertDialog iosDialog = CupertinoAlertDialog(
    title: Text(title),
    content: Text(body),
    actions: <Widget>[
      CupertinoDialogAction(
        child: Text(
          languageType1 == uzbek ? 'Bekor qilish' : 'Отмена',
        ),
        onPressed: () {
          Navigator.pop(context, 'Cancel');
        },
      ),
      CupertinoDialogAction(
        child: Text(okAction
            //  style: TextStyle(color: primaryColor),
            ),
        onPressed: () {
          launch('tel:' + ussd.substring(0, ussd.length - 1) + '%23');
        },
      )
    ],
  );
  AlertDialog androidDialog = AlertDialog(
    title: Text(title),
    content: Text(body),
    actions: <Widget>[
      FlatButton(
        child: Text(languageType1 == uzbek ? 'Bekor qilish' : 'Отмена'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      FlatButton(
        child: Text(okAction),
        onPressed: () {
          launch('tel:' + ussd.substring(0, ussd.length - 1) + '%23');
        },
      )
    ],
  );
  if (Platform.isAndroid) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return androidDialog;
        });
  }
  if (Platform.isIOS) {
    showDialog(context: context, child: iosDialog);
  }
}
