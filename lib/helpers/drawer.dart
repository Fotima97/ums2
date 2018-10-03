import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ums/helpers/app_constants.dart';
import 'package:ums/pages/home_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

class DrawerContainer extends StatefulWidget {
  @override
  _DrawerContainerState createState() => new _DrawerContainerState();
}

class _DrawerContainerState extends State<DrawerContainer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.all(0.0),
              child: Center(
                  child: Image.asset(
                'assets/ums.png',
                width: 150.0,
              )),
            ),
            ListTileTheme(
              child: ListTile(
                title: Text(
                  languageType1 == uzbek ? 'Bosh sahifa' : 'Главная',
                  softWrap: true,
                  overflow: TextOverflow.clip,
                  style: TextStyle(color: Colors.black),
                ),
                leading: new SvgPicture.asset(
                  'assets/if_Streamline.svg',
                  width: 20.0,
                  height: 20.0,
                  color: Colors.red,
                  allowDrawingOutsideViewBox: true,
                ),
                onTap: () {
                  Navigator.pop(context);

                  Navigator.popAndPushNamed(context, '/home');
                  // Navigator.pushNamedAndRemoveUntil(
                  //     context, '/home', ModalRoute.withName('/'));
                },
              ),
            ),
            Divider(
              height: 5.0,
            ),
            ListTileTheme(
              child: ListTile(
                title: Text(
                  languageType1 == uzbek ? 'Yordam' : 'Помощь',
                  softWrap: true,
                  overflow: TextOverflow.clip,
                  style: TextStyle(color: Colors.black),
                ),
                leading: new SvgPicture.asset(
                  'assets/Yordam.svg',
                  width: 20.0,
                  height: 20.0,
                  allowDrawingOutsideViewBox: true,
                  color: Colors.red,
                ),
                onTap: () {
                  // Navigator.popUntil(
                  //     context, ModalRoute.withName(Navigator.defaultRouteName));
                  Navigator.pop(context);

                  Navigator.pushNamed(context, '/help');
                },
              ),
            ),
            Divider(
              height: 5.0,
            ),
            ListTileTheme(
              child: ListTile(
                title: Text(
                  languageType1 == uzbek ? 'Internet' : 'Интернет',
                  softWrap: true,
                  overflow: TextOverflow.clip,
                  style: TextStyle(color: Colors.black),
                ),
                leading: SvgPicture.asset(
                  'assets/Internet.svg',
                  width: 20.0,
                  height: 20.0,
                  allowDrawingOutsideViewBox: true,
                  color: Colors.red,
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Navigator.popUntil(
                  //     context, ModalRoute.withName(Navigator.defaultRouteName));
                  Navigator.pushNamed(context, '/internet');
                },
              ),
            ),
            Divider(
              height: 5.0,
            ),
            ListTileTheme(
              child: ListTile(
                title: Text(
                  languageType1 == uzbek ? 'Tariflar' : 'Тарифы',
                  softWrap: true,
                  overflow: TextOverflow.clip,
                  style: TextStyle(color: Colors.black),
                ),
                leading: SvgPicture.asset('assets/Tarif_rejalar.svg',
                    width: 20.0,
                    height: 20.0,
                    allowDrawingOutsideViewBox: true,
                    color: Colors.red),
                onTap: () {
                  Navigator.pop(context);
                  // Navigator.popUntil(
                  //     context, ModalRoute.withName(Navigator.defaultRouteName));

                  Navigator.pushNamed(context, '/tariffs');
                },
              ),
            ),
            Divider(
              height: 5.0,
            ),
            ListTileTheme(
              child: ListTile(
                title: Text(
                  languageType1 == uzbek ? 'Muloqot' : 'Общение',
                  softWrap: true,
                  overflow: TextOverflow.clip,
                  style: TextStyle(color: Colors.black),
                ),
                leading: SvgPicture.asset(
                  'assets/Muloqot.svg',
                  width: 20.0,
                  height: 20.0,
                  allowDrawingOutsideViewBox: true,
                  color: Colors.red,
                ),
                onTap: () {
                  // Navigator.popUntil(
                  //     context, ModalRoute.withName(Navigator.defaultRouteName));
                  Navigator.pop(context);

                  Navigator.pushNamed(context, '/chat');
                },
              ),
            ),
            Divider(
              height: 5.0,
            ),
            ListTileTheme(
              child: ListTile(
                title: Text(
                  languageType1 == uzbek ? 'Xizmatlar' : 'Услуги',
                  softWrap: true,
                  overflow: TextOverflow.clip,
                  style: TextStyle(color: Colors.black),
                ),
                leading: SvgPicture.asset(
                  'assets/Hizmatlar.svg',
                  width: 20.0,
                  height: 20.0,
                  allowDrawingOutsideViewBox: true,
                  color: Colors.red,
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Navigator.popUntil(
                  //     context, ModalRoute.withName(Navigator.defaultRouteName));

                  Navigator.pushNamed(context, '/services');
                },
              ),
            ),
            Divider(
              height: 5.0,
            ),
            ListTileTheme(
              child: ListTile(
                title: Text(languageType1 == uzbek ? 'Yangiliklar' : 'Новости',
                    softWrap: true,
                    overflow: TextOverflow.clip,
                    style: TextStyle(color: Colors.black)),
                leading: SvgPicture.asset(
                  'assets/News.svg',
                  width: 20.0,
                  height: 20.0,
                  allowDrawingOutsideViewBox: true,
                  color: Colors.red,
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Navigator.popUntil(
                  //     context, ModalRoute.withName(Navigator.defaultRouteName));

                  Navigator.pushNamed(context, '/news');
                },
              ),
            ),
            Divider(
              height: 5.0,
            ),
            ListTileTheme(
              child: ListTile(
                title: Text(
                  languageType1 == uzbek
                      ? 'Tilni o`zgartirish'
                      : 'Сменить язык',
                  softWrap: true,
                  overflow: TextOverflow.clip,
                  style: TextStyle(color: Colors.black),
                ),
                leading: SvgPicture.asset(
                  'assets/if_Translate.svg',
                  width: 20.0,
                  height: 20.0,
                  color: Colors.red,
                  allowDrawingOutsideViewBox: true,
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Navigator.popUntil(
                  //     context, ModalRoute.withName(Navigator.defaultRouteName));
                  Navigator.pushNamed(context, '/language');
                },
              ),
            ),
            Divider(
              height: 5.0,
            ),
            ListTileTheme(
              child: ListTile(
                title: Text(
                  languageType1 == uzbek
                      ? 'Ilovani baholash'
                      : 'Оценить приложение',
                  softWrap: true,
                  overflow: TextOverflow.clip,
                ),
                leading: SvgPicture.asset(
                  'assets/if_like_thumbs_up.svg',
                  width: 20.0,
                  height: 20.0,
                  color: Colors.red,
                  allowDrawingOutsideViewBox: true,
                ),
                onTap: () {
                  launch('https://play.google.com/store/apps?hl=ru');
                },
              ),
            ),
            Divider(
              height: 5.0,
            ),
            ListTileTheme(
              child: ListTile(
                title: Text(
                  languageType1 == uzbek ? 'Tavsiya qilish' : 'Поделиться',
                  softWrap: true,
                  overflow: TextOverflow.clip,
                ),
                leading: SvgPicture.asset(
                  'assets/if_share.svg',
                  width: 20.0,
                  height: 20.0,
                  color: Colors.red,
                  allowDrawingOutsideViewBox: true,
                ),
                onTap: () {
                  Share.share(
                    languageType1 == uzbek
                        ? 'UMS uchun yangi ilova https://play.google.com/store/apps?hl=ru'
                        : 'Новое приложение для пользователей UMS https://play.google.com/store/apps?hl=ru',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
