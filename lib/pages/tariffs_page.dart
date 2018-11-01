import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flushbar/flushbar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ums/helpers/app_constants.dart';
import 'package:ums/helpers/dialog_box.dart';
import 'package:ums/helpers/drawer.dart';
import 'package:ums/helpers/tariff_model.dart';
import 'package:ums/pages/home_page.dart';
import 'package:connectivity/connectivity.dart';

class TariffsPage extends StatefulWidget {
  TariffsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TariffsPageState createState() => new _TariffsPageState();
}

class _TariffsPageState extends State<TariffsPage> {
  PageController pageController;
  var dir;
  var jsonFile;
  var fileExists;

  List<TarrifModel> parsePacks(String responseBody) {
    final parsed = json.decode(responseBody);
    var jsonData;
    jsonData = (parsed).cast<Map<String, dynamic>>();

    return jsonData
        .map<TarrifModel>((json) => TarrifModel.fromJson(json))
        .toList();
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

  Future<List<TarrifModel>> _getTariffsJsonFromPhoneStorage() async {
    var _tariffJson;

    Directory directory = await getApplicationDocumentsDirectory();
    dir = directory;
    jsonFile = new File(dir.path + '/tariff.json');
    fileExists = jsonFile.existsSync();

    if (fileExists) {
      _tariffJson = jsonFile.readAsStringSync();
      return parsePacks(_tariffJson);
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

  Future<List<TarrifModel>> fetchTariffs() async {
    var client = http.Client();
    if (connectivity == ConnectivityResult.mobile ||
        connectivity == ConnectivityResult.wifi) {
      final response = await client.get(languageType1 == uzbek
          ? 'http://umscontrol.dst.uz/tariffs/uz'
          : 'http://umscontrol.dst.uz/tariffs/ru');

      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        _saveJsonToFileSystem('tariff.json', body);
        return parsePacks(body);
      } else {
        return _getTariffsJsonFromPhoneStorage();
      }
    } else {
      return _getTariffsJsonFromPhoneStorage();
    }
  }

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    pageController = new PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  Widget chooseIcon(String icon) {
    if (icon == smsIcon) {
      return Icon(Icons.sms);
    } else if (icon == callIcon) {
      return Icon(Icons.call);
    } else if (icon == internetIcon) {
      return SvgPicture.asset(
        'assets/signal.svg',
        color: Colors.grey[600],
        allowDrawingOutsideViewBox: true,
        height: 20.0,
        width: 20.0,
      );
    } else {
      return Icon(Icons.call);
    }
  }

  Widget createTextRow(String title) {
    if (languageType1 == uzbek) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 25.0, color: Colors.grey[900]),
          ),
          SizedBox(
            height: 3.0,
          ),
          Text(
            'Tarif rejasi',
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.grey[600]),
          )
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Тарифный план',
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.grey[600]),
          ),
          SizedBox(
            height: 3.0,
          ),
          Text(
            title,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 25.0, color: Colors.grey[900]),
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: FutureBuilder<List<TarrifModel>>(
          future: fetchTariffs(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                  color: Colors.red,
                  child: ListView.builder(
                    primary: true,
                    // controller: pageController,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      var tarrif = snapshot.data[index];
                      var description = tarrif.description;
                      return Container(
                          width: 310.0,
                          height: 300.0,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 20.0),
                          margin: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                          decoration: BoxDecoration(
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    blurRadius: 5.0,
                                    color: Colors.black,
                                    offset: Offset(0.5, 0.5))
                              ],
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: createTextRow(tarrif.title),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    padding: EdgeInsets.only(top: 5.0),
                                    alignment: Alignment.topCenter,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(tarrif.price,
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30.0)),
                                        SizedBox(
                                          width: 3.0,
                                        ),
                                        Text(
                                            languageType1 == uzbek
                                                ? 'oyiga'
                                                : 'месяц',
                                            style: TextStyle(
                                                fontSize: 19.0,
                                                color: Colors.grey[600]))
                                      ],
                                    ),
                                  )),
                              Divider(
                                height: 1.0,
                                color: Colors.grey[300],
                              ),
                              Expanded(
                                  flex: 5,
                                  child: Container(
                                    child: ListView.builder(
                                      primary: false,
                                      shrinkWrap: true,
                                      itemCount: description.length,
                                      itemBuilder: (context, index) {
                                        Description desc = description[index];
                                        return ListView(
                                            shrinkWrap: true,
                                            primary: false,
                                            children: <Widget>[
                                              ListTile(
                                                leading: chooseIcon(desc.icon),
                                                title: Text(desc.title,
                                                    overflow: TextOverflow.clip,
                                                    style: TextStyle(
                                                        color:
                                                            Colors.grey[600])),
                                                trailing: Text(
                                                  desc.value,
                                                  style: TextStyle(
                                                      color: Colors.grey[600]),
                                                ),
                                              ),
                                              Divider(
                                                height: .5,
                                                color: Colors.grey[300],
                                              ),
                                            ]);
                                      },
                                    ),
                                  )),
                              Expanded(
                                child: Container(),
                                flex: 1,
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  child: MaterialButton(
                                    color: Colors.green,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.shopping_cart,
                                          color: Colors.white,
                                        ),
                                        Text(
                                            languageType1 == uzbek
                                                ? 'Tarif rejasiga o\'tish'
                                                : 'Перейти на тариф',
                                            style:
                                                TextStyle(color: Colors.white))
                                      ],
                                    ),
                                    onPressed: () {
                                      showDialogBox2(
                                        context,
                                        tarrif.title,
                                        tarrif.ussd,
                                        languageType1 == uzbek
                                            ? 'Siz ushbu tarif rejaga o\'tishni xohlaysizmi?'
                                            : 'Вы хотите перейте на этот тарифный план?',
                                        languageType1 == uzbek
                                            ? 'Tarif rejasiga o\'tish'
                                            : 'Перейти на тариф',
                                      );
                                    },
                                  ),
                                ),
                              )
                            ],
                          ));
                    },
                  ));
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
