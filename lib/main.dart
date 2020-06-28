import 'package:tiket/Helpers/helper.dart';
import 'package:tiket/Helpers/widget_helper.dart';
import 'package:tiket/adminMain.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiket/Pages/loginPage.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;
  bool _isLoading = true;

  @override
  void initState() {
    _checkIfLoggedIn();
    super.initState();
    setState(() {
      _isLoading=true;
    });
  }


  void _checkIfLoggedIn() async {
    // check if token is there
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('api_token');
    if(token!= null){
      setState(() {
        _isLoggedIn = true;
      });
    }
    setState(() {
      _isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: THEME_COLOR,
      ),
      /*debugShowCheckedModeBanner: false,*/
      home:

      _isLoading ? loadingWidget(context)
      :
      (_isLoggedIn ?
      AdminMain()
          :
      LoginPage()
      ),
    );
  }
}
