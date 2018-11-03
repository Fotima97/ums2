import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ums/helpers/app_constants.dart';
import 'package:ums/helpers/dialog_box.dart';
import 'package:ums/helpers/drawer.dart';
import 'package:ums/helpers/internet_packages_model.dart';
import 'package:ums/pages/home_page.dart';
import 'package:ums/pages/internet_help_page.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class InternetPage extends StatefulWidget {
  InternetPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _InternetPageState createState() => new _InternetPageState();
}

class _InternetPageState extends State<InternetPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
    static const platform = const MethodChannel(channel);

  Future _call(String number) async {
    try {
      await platform.invokeMethod('callNumber', number);
    } catch (e) {
      print(e);
    }
  }
  var dir;
  var jsonFile;
  var fileExists;

  int _selectedTab = 0;
  List<InternetPackages> parsePacks(String responseBody) {
    final parsed = json.decode(responseBody);
    var jsonData;
    if (_selectedTab == 0) {
      jsonData = (parsed['default']).cast<Map<String, dynamic>>();
    } else if (_selectedTab == 1) {
      jsonData = (parsed['night']).cast<Map<String, dynamic>>();
    } else if (_selectedTab == 2) {
      jsonData = (parsed['onnet']).cast<Map<String, dynamic>>();
    }
    return jsonData
        .map<InternetPackages>((json) => InternetPackages.fromJson(json))
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

  Future<List<InternetPackages>> _getServicesJsonFromPhoneStorage() async {
    var _internetJson;

    Directory directory = await getApplicationDocumentsDirectory();
    dir = directory;
    jsonFile = new File(dir.path + '/internetPacks.json');
    fileExists = jsonFile.existsSync();

    if (fileExists) {
      _internetJson = jsonFile.readAsStringSync();
      return parsePacks(_internetJson);
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

  Future<List<InternetPackages>> fetchPackages() async {
    var client = http.Client();
    if (connectivity == ConnectivityResult.mobile ||
        connectivity == ConnectivityResult.wifi) {
      final response = await client.get(languageType1 == uzbek
          ? 'http://umscontrol.dst.uz/packages/inet/uz'
          : 'http://umscontrol.dst.uz/packages/inet/ru');

      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        _saveJsonToFileSystem('internetPacks.json', body);
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
    super.initState();
    checkConnectivity();
    tabController = new TabController(vsync: this, length: 3);
    tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {
      _selectedTab = tabController.index;
    });
  }

  @override
  dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    Widget createTabBody() {
      return FutureBuilder<List<InternetPackages>>(
        future: fetchPackages(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              primary: true,
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                var packages = snapshot.data[index];
                var itemList = snapshot.data[index].itemList;
                return Column(children: <Widget>[
                  MaterialButton(
                    padding: EdgeInsets.only(
                        top: 10.0, bottom: 0.0, left: 15.0, right: 15.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            packages.title,
                            style: TextStyle(color: Colors.grey),
                          ),
                          Icon(Icons.help, color: Colors.grey[300]),
                        ]),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InternetHelpPage(
                                    content: packages.description,
                                  )));
                    },
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    padding: EdgeInsets.only(top: 0.0),
                    itemCount: itemList.length,
                    itemBuilder: (context, index) {
                      var item = itemList[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(item.title),
                              trailing: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 15.0),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Text(
                                  item.price,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              onTap: () {
                                showDialogBox2(
                                  context,
                                  item.title,
                                  item.ussd,
                                  languageType1 == uzbek
                                      ? 'Xizmatni yoqishni istaysizmi?'
                                      : 'Вы хотите активировать эту услугу?',
                                  languageType1 == uzbek
                                      ? 'Yoqish'
                                      : 'Активировать',
                                );
                              },
                            ),
                            Divider(
                              height: 1.0,
                            )
                          ],
                        ),
                      );
                    },
                  )
                ]);
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      );
    }

    createBottomSheet(BuildContext context) {
      showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return Container(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                child: ListView(
                  itemExtent: 45.0,
                  padding: EdgeInsets.all(0.0),
                  children: <Widget>[
                    ListTile(
                      contentPadding: EdgeInsets.all(0.0),
                      title: Text(
                          languageType1 == uzbek
                              ? 'Mobil internetni boshqarish'
                              : 'Управление интернетом',
                          style: TextStyle(color: Colors.grey, fontSize: 16.0)),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.all(0.0),
                      title: Text(
                        languageType1 == uzbek
                            ? 'Qoldiqni tekshirish'
                            : 'Проверить остаток',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 16.0),
                      ),
                      onTap: () {
                                  if(Platform.isAndroid){
                                                           _call('*102%23');


                  }
                  else{
                                         _call('*102#');


                  }
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.all(0.0),
                      title: Text(
                        languageType1 == uzbek
                            ? 'Internet sozlanmalarini olish'
                            : 'Получить настройки интернета',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      onTap: () {
                         
                              if(Platform.isAndroid){
                         _call('*111*0011%23');


                  }
                  else{
                   _call('*111*0011#');


                  }

                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.all(0.0),
                      title: Text(
                        languageType1 == uzbek
                            ? 'Mobil internetni yoqish'
                            : 'Включить мобильный интернет',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      onTap: () {
                                               
     if(Platform.isAndroid){
                        _call('*111*0011%23');


                  }
                  else{
                   _call('*111*0011#');


                  }
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.all(0.0),
                      title: Text(
                        languageType1 == uzbek
                            ? 'Mobil internetni o`chirish'
                            : 'Отключить мобильный интернет',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      onTap: () {
                         if(Platform.isAndroid){
                        _call('*111*0010%23');


                  }
                  else{
                   _call('*111*0010#');


                  }
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.all(0.0),
                      title: Text(
                        languageType1 == uzbek
                            ? 'OnNet paketini o`chirish'
                            : 'Отключить пакет OnNet остаток',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      onTap: () {
                        
                         if(Platform.isAndroid){
                       _call('*202*0%23');


                  }
                  else{
                 _call('*202*0#');


                  }
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.all(0.0),
                      title: Text(
                        languageType1 == uzbek ? 'Bekor qilish' : 'Отмена',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ));
          });
    }

    return new Scaffold(
        appBar: new AppBar(
          actions: <Widget>[
            MaterialButton(
              minWidth: 20.0,
              child: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {
                createBottomSheet(context);
              },
            )
          ],
          title: new Text(widget.title),
          bottom: TabBar(
            controller: tabController,
            tabs: <Widget>[
              Tab(
                text: languageType1 == uzbek ? 'Paketlar' : 'Пакеты',
              ),
              Tab(
                text: languageType1 == uzbek ? 'Tungi' : 'Ночные',
              ),
              Tab(
                text: languageType1 == uzbek ? 'OnNet' : 'OnNet',
              )
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: <Widget>[
            createTabBody(),
            createTabBody(),
            createTabBody()
          ],
        ));
  }
}
