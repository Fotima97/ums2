import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ums/helpers/app_constants.dart';
import 'package:ums/helpers/chat_model.dart';
import 'package:ums/helpers/dialog_box.dart';
import 'package:ums/helpers/drawer.dart';
import 'package:ums/pages/home_page.dart';
import 'package:ums/pages/internet_help_page.dart';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  ChatPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ChatPageState createState() => new _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatModel sms;
  ChatModel minutes;
  var dir;
  var jsonFile;
  var fileExists;
  List<ChatModel> models = new List<ChatModel>();
  static const platform = const MethodChannel(channel);

  List<ChatModel> parsePacks(String responseBody) {
    models = [];

    var parsed = json.decode(responseBody);
    sms = ChatModel.fromJson(parsed['sms']);
    minutes = ChatModel.fromJson(parsed['minutes']);
    models.add(minutes);
    models.add(sms);
    return models;
  }

  void _saveJsonToFileSystem(String fileName, String content) {
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir.path + "/" + fileName);
      fileExists = jsonFile.existsSync();
      jsonFile.writeAsStringSync(content);
      // if (fileExists) this.setState(() => fileContent = JSON.decode(jsonFile.readAsStringSync()));
    });
  }

  Future<List<ChatModel>> _getServicesJsonFromPhoneStorage() async {
    var _chatJson;

    Directory directory = await getApplicationDocumentsDirectory();
    dir = directory;
    jsonFile = new File(dir.path + '/chatPacks.json');
    fileExists = jsonFile.existsSync();

    if (fileExists) {
      _chatJson = jsonFile.readAsStringSync();
      return parsePacks(_chatJson);
    } else {
      Flushbar()
        ..title = "Проблемы с сервером"
        ..message = "Проверьте подключение к сети"
        ..duration = Duration(seconds: 1)
        ..icon = Icon(
          Icons.info,
          color: Colors.white,
        )
        ..backgroundColor = Colors.red
        ..show(context);
      return null;
    }
  }

  Future<List<ChatModel>> fetchChatpacks() async {
    var client = http.Client();

    if (connectivity == ConnectivityResult.mobile ||
        connectivity == ConnectivityResult.wifi) {
      final response = await client.get(languageType1 == uzbek
          ? 'http://umscontrol.dst.uz/packages/msms/uz'
          : 'http://umscontrol.dst.uz/packages/msms/ru');

      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        _saveJsonToFileSystem('chatPacks.json', body);

        return parsePacks(body);
      } else {
        return _getServicesJsonFromPhoneStorage();
      }
    } else {
      return _getServicesJsonFromPhoneStorage();
    }
  }

  @override
  void initState() {
    fetchChatpacks();

    super.initState();
  }

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
          actions: <Widget>[
            MaterialButton(
                minWidth: 20.0,
                child: new SvgPicture.asset(
                  'assets/money-bag.svg',
                  width: 20.0,
                  height: 20.0,
                  allowDrawingOutsideViewBox: true,
                  color: Colors.white,
                ),
                // Icon(
                //   Icons.show_chart,
                //   color: Colors.white,
                // ),
                onPressed: () {
                  _call('*100%23');
                })
          ],
          title: new Text(widget.title),
        ),
        body: FutureBuilder<List<ChatModel>>(
          future: fetchChatpacks(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: 2,
                itemBuilder: (context, index) {
                  var item = snapshot.data[index];
                  var itemList = snapshot.data[index].items;
                  return Container(
                    padding: EdgeInsets.all(5.0),
                    child: Column(
                      children: <Widget>[
                        MaterialButton(
                          padding: EdgeInsets.only(
                              top: 10.0, bottom: 0.0, left: 15.0, right: 15.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  item.title,
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Icon(Icons.help, color: Colors.grey[300]),
                              ]),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => InternetHelpPage(
                                          content: 'Help',
                                        )));
                          },
                        ),
                        ListView.builder(
                          primary: false,
                          padding: EdgeInsets.only(top: 0.0),
                          shrinkWrap: true,
                          itemCount: itemList.length,
                          itemBuilder: (context, index) {
                            var pack = itemList[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    onTap: () {
                                      showDialogBox2(
                                        context,
                                        pack.title,
                                        pack.ussd,
                                        languageType1 == uzbek
                                            ? 'Xizmatni yoqishni istaysizmi?'
                                            : 'Вы хотите активировать эту услугу?',
                                        languageType1 == uzbek
                                            ? 'Yoqish'
                                            : 'Активировать',
                                      );
                                    },
                                    title: Text(pack.title),
                                    trailing: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 15.0),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: Text(
                                        pack.price,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    height: 1.0,
                                  )
                                ],
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
