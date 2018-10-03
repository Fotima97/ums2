import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ums/helpers/app_constants.dart';
import 'package:ums/helpers/dialog_box.dart';
import 'package:ums/helpers/drawer.dart';
import 'package:ums/helpers/services_model.dart';
import 'package:ums/pages/home_page.dart';
import 'package:url_launcher/url_launcher.dart';

class ServicesPage extends StatefulWidget {
  ServicesPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ServicesPageState createState() => new _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  var dir;
  var jsonFile;
  var fileExists;


  @override
  void initState() {
    super.initState();
  }

  List<ServicesModel> parseServices(String responseBody) {
    final parsed = json.decode(responseBody);
    var jsonData;
    jsonData = (parsed).cast<Map<String, dynamic>>();

    return jsonData
        .map<ServicesModel>((json) => ServicesModel.fromJson(json))
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

  Future<List<ServicesModel>> _getServicesJsonFromPhoneStorage() async {
    var _serviceJson;

    Directory directory = await getApplicationDocumentsDirectory();
    dir = directory;
    jsonFile = new File(dir.path + '/services.json');
    fileExists = jsonFile.existsSync();

    if (fileExists) {
      _serviceJson = jsonFile.readAsStringSync();
      return parseServices(_serviceJson);
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

  Future<List<ServicesModel>> fetchServices() async {
    var client = http.Client();
    if (connectivity == ConnectivityResult.mobile ||
        connectivity == ConnectivityResult.wifi) {
      final response = await client.get(languageType1 == uzbek
          ? 'http://umscontrol.dst.uz/services/uz'
          : 'http://umscontrol.dst.uz/services/ru');

      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        _saveJsonToFileSystem('services.json', body);
        return parseServices(body);
      } else {
        return _getServicesJsonFromPhoneStorage();
      }
    } else {
      return _getServicesJsonFromPhoneStorage();
    }
  }

  IconData chooseIcon(String iconType) {
    if (iconType == manage) {
      return Icons.settings;
    } else if (iconType == switchOff) {
      return Icons.highlight_off;
    } else if (iconType == apply) {
      return Icons.done;
    } else if (iconType == use) {
      return Icons.add_circle_outline;
    } else if (iconType == activate || iconType == gets) {
      return Icons.shopping_cart;
    } else
      return Icons.settings;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: Container(
            //  color: Colors.red,
            child: FutureBuilder<List<ServicesModel>>(
          future: fetchServices(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  var service = snapshot.data[index];
                  return Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, left: 8.0, right: 8.0),
                              child: Text(
                                service.title,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(service.body),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                service.buttons.decline.title == 'declined'
                                    ? Container()
                                    : FlatButton(
                                        padding: EdgeInsets.all(0.0),
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 5.0),
                                              child: Icon(
                                                chooseIcon(service
                                                    .buttons.decline.icon),
                                                color: Colors.grey,
                                                size: 20.0,
                                              ),
                                            ),
                                            Text(
                                              service.buttons.decline.title,
                                              style: TextStyle(
                                                  color: Colors.grey),
                                            )
                                          ],
                                        ),
                                        onPressed: () {
                                          showDialogBox2(
                                            context,
                                            service.title,
                                            service.buttons.decline.ussd,
                                            languageType1 == uzbek
                                                ? 'Xizmatni o\'chirishni istaysizmi?'
                                                : 'Вы хотите отключить эту услугу?',
                                            languageType1 == uzbek
                                                ? 'O\'chirish'
                                                : 'Отключить',
                                          );
                                        },
                                      ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                FlatButton(
                                  padding: EdgeInsets.all(0.0),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5.0),
                                        child: Icon(
                                          chooseIcon(
                                              service.buttons.accept.icon),
                                          color: Colors.green,
                                          size: 20.0,
                                        ),
                                      ),
                                      Text(
                                        service.buttons.accept.title,
                                        style: TextStyle(color: Colors.green),
                                      )
                                    ],
                                  ),
                                  onPressed: () {
                                    showDialogBox2(
                                      context,
                                      service.title,
                                      service.buttons.accept.ussd,
                                      languageType1 == uzbek
                                          ? 'Xizmatni yoqishni istaysizmi?'
                                          : 'Вы хотите включить эту услугу?',
                                      languageType1 == uzbek
                                          ? 'Yoqish'
                                          : 'Включить',
                                    );
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
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
        )));
  }
}
