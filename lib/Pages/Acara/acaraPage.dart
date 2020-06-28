import 'package:tiket/Helpers/api.dart';
import 'package:tiket/Helpers/helper.dart';
import 'package:tiket/Helpers/widget_helper.dart';
import 'package:tiket/Pages/Acara/pesertaPage.dart';
import 'package:tiket/Routes.dart';
import 'package:tiket/Widget/adminDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'dart:convert';

class AcaraPage extends StatefulWidget {
  static const String routeName = '/acara';

  AcaraPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _AcaraPageState createState() => _AcaraPageState();
}

class _AcaraPageState extends State<AcaraPage> {
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
    var res = await CallApi().getData(_emptyData, 'events/showtoday/');
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
        settings: RouteSettings(name: Routes.peserta),
        builder: (BuildContext context) => PesertaPage(acaraId: acara_id.toString(),)
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Acara"),
      ),
      drawer: AdminDrawer(),
      body:
      Container(
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
                          Icons.event,
                          color: Colors.white,
                          size: 50.0,
                        ),
                        Text('Acara Hari Ini', style: TextStyle(color: Colors.white),)
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
              Text("Tidak ada acara pada hari ini")
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
                        onTap: (){(data[index]['is_started_scan'])?_showPesertaPage(context, data[index]['id']):showErrorToast(context, 'Acara belum dimulai atau sudah lewat');},
                        leading: Icon(data[index]['is_started_scan']?Icons.check_circle:Icons.cancel,
                          size: 50.0, color: data[index]['is_started_scan']?Colors.greenAccent:Colors.redAccent,),
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
