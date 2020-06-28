import 'package:tiket/Helpers/helper.dart';
import 'package:tiket/Pages/acaraAllPage.dart';
import 'package:tiket/Pages/Acara/pesertaPage.dart';
import 'package:flutter/material.dart';
import 'package:tiket/Routes.dart';
import 'package:tiket/Pages/Acara/acaraPage.dart';

class AdminMain extends StatefulWidget {
  AdminMain({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _AdminMainState createState() => _AdminMainState();
}

class _AdminMainState extends State<AdminMain> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Main',
      theme: ThemeData(
          primarySwatch: THEME_COLOR
      ),
      home: AcaraPage(),
      routes:  {
        Routes.acara: (context) => AcaraPage(),
        Routes.acaraall: (context) => AcaraAllPage(),
        Routes.peserta: (context) => PesertaPage(),
      },
    );
  }
}

