import 'dart:convert';

import 'package:tiket/Helpers/api.dart';
import 'package:tiket/Helpers/helper.dart';
import 'package:tiket/Helpers/widget_helper.dart';
import 'package:tiket/Pages/Acara/pesertaPage.dart';
import 'package:tiket/Pages/pesertaAllPage.dart';
import 'package:tiket/Routes.dart';
import 'package:tiket/Widget/adminDrawer.dart';

import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class AcaraAllPage extends StatefulWidget {
  static const String routeName = '/acaraall';
  AcaraAllPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _AcaraAllPageState createState() => _AcaraAllPageState();
}

class _AcaraAllPageState extends State<AcaraAllPage> {
  var userData;

  List data;
  bool _isLoading = true;
  var _message = '';
  var _hasError = false;

  @override
  void initState() {
    super.initState();
    this.setState(() {
      _isLoading=true;
    });
    this._loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _loadData() async {
    var _emptyData = Map<String,dynamic>();
    var res = await CallApi().getData(_emptyData, 'events/showall/');
    var body = json.decode(res.body);

    if(body['success'] && res.statusCode==200){
      data = body['data']['events'];
    }
    else{
      var errorMessage = body['message']+((res.statusCode==200)?'':'. Kesalahan pada server : '+res.statusCode.toString());
      showErrorToast(context, errorMessage);
    }
    setState(() {
      _isLoading=false;
    });
  }

  void _showPesertaPage(BuildContext context, acara_id) {
    Navigator.push(context, new MaterialPageRoute<Null>(
        settings: RouteSettings(name: Routes.pesertaall),
        builder: (BuildContext context) => PesertaAllPage(acaraId: acara_id.toString(),)
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Semua Acara"),
      ),
      drawer: AdminDrawer(),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 90,
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                gradient: LinearGradient(
                    colors: [ACCENT_COLOR, PRIMARY_COLOR],
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 100, right: 100),
                child: Center(
                  child:
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: 50.0,
                        ),
                        Text('Daftar Semua Acara', style: TextStyle(color: Colors.white),)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child:
              _isLoading ?
              loadingWidgetCenter(context)
                  :
              (data.isEmpty)?
              Text("Tidak ada acara")
                  :
              LiquidPullToRefresh(
                onRefresh: ()=>_loadData(),
                backgroundColor: PRIMARY_COLOR,
                color: Colors.white,
                child: ListView.builder(
                  itemCount: data.isEmpty ? 0 : data.length,
                  itemBuilder: (BuildContext context, int index){
                    return Card(
                      elevation: 5,
                      child: ListTile(
                        onTap: (){_showPesertaPage(context, data[index]['id']);},
                        /*leading: Icon(data[index]['finished']?Icons.check_circle:Icons.cancel,
                          size: 50.0, color: data[index]['finished']?Colors.greenAccent:Colors.redAccent,),*/
                        //play_arrow, done_all, pause
                        title: Text(data[index]['title'], style: TextStyle(height: 1.5),),
                        subtitle:
                        Container(
                          child: (
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(data[index]['time'], style: TextStyle(fontSize: 13)),
                                  !isNullOrEmpty(data[index]['venue_name'])?Text(data[index]['venue_name'], style: TextStyle(fontSize: 11)):Text('-', style: TextStyle(fontSize: 11)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Chip(
                                        elevation: 3,
                                        backgroundColor: Colors.green,
                                        padding: EdgeInsets.all(0),
                                        label: Text(data[index]['present'].toString()+' Peserta', style: TextStyle(color: Colors.white)),
                                      ),
                                      Chip(
                                        elevation: 3,
                                        backgroundColor: Colors.red,
                                        padding: EdgeInsets.all(0),
                                        label: Text(data[index]['absent'].toString()+' Peserta', style: TextStyle(color: Colors.white)),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                          ),
                        ),
                        trailing: Icon(Icons.navigate_next),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
