import 'package:tiket/Pages/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:tiket/Routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(icon: Icons.event, text: 'Acara', onTap: () => Navigator.pushReplacementNamed(context, Routes.acara)),
          _createDrawerItem(icon: Icons.calendar_today, text: 'Semua Acara', onTap: () => Navigator.pushReplacementNamed(context, Routes.acaraall)),
          Expanded(child: Container()),
          Divider(),
          Column(
            children: <Widget>[
              _createFooterItem(icon: Icons.exit_to_app, text: 'Logout', onTap: () => _logout(context))
            ],
          )
        ],
      ),
    );
  }

  Widget _createFooterItem({IconData icon, String text, GestureTapCallback onTap}){
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/drawer_header_background.png'))),
        child: Stack(children: <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text("A-Tiket+",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500))),
        ]));
  }

  Widget _createDrawerItem({IconData icon, String text, GestureTapCallback onTap}){
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  void _logout(BuildContext context) async{
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('api_token');
      Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
              builder: (context) => LoginPage()));
  }
}
