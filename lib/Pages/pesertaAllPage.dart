import 'dart:convert';

import 'package:tiket/Helpers/api.dart';
import 'package:tiket/Helpers/helper.dart';
import 'package:tiket/Helpers/widget_helper.dart';
import 'package:tiket/Routes.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class PesertaAllPage extends StatefulWidget {
  static const String routeName = '/pesertaall';
  final acaraId;
  PesertaAllPage({Key key, @required this.acaraId}) : super(key: key);
  @override
  _PesertaAllPageState createState() => _PesertaAllPageState();
}

class _PesertaAllPageState extends State<PesertaAllPage>{
  List data;
  bool _isLoading = true;
  var _message = '';
  var _hasError = false;
  var _acaraId;

  @override
  void initState() {
    super.initState();
    this.setState(() {
      _isLoading=true;
      _acaraId=widget.acaraId.toString();
    });

    this._loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _loadData() async {
    var _sendData = Map<String,dynamic>();
    _sendData['event_id'] = _acaraId.toString();
    var res = await CallApi().getData(_sendData, 'attendees/showattendeesevent/');
    var body = json.decode(res.body);

    if(body['success'] && res.statusCode==200){
      data = body['data']['attendees'];
    }
    else{
      var errorMessage = body['message']+((res.statusCode==200)?'':'. Kesalahan pada server : '+res.statusCode.toString());
      showErrorToast(context, errorMessage);
    }
    setState(() {
      _isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Semua Peserta"),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 90,
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
                          Icons.person,
                          color: Colors.white,
                          size: 50.0,
                        ),
                        Text('Daftar Peserta', style: TextStyle(color: Colors.white),)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            /*SizedBox(
              height: 70,
            ),*/
            Expanded(
              child:
              _isLoading ?
              loadingWidgetCenter(context)
                  :
              (data.isEmpty)?
              Text("Tidak ada yang mendaftar pada acara ini")
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
                      color: data[index]['has_arrived']==0 ? Color(0xFFffb0b9) : Color(0xFF6bed96),
                      child: ListTile(
                        title: Text(data[index]['first_name']+' '+data[index]['last_name'], style: TextStyle(color: Colors.white),),
                        subtitle:
                        Container(
                          child: (
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(data[index]['email']??'-', style: TextStyle(fontSize: 13, color: data[index]['has_arrived']==0 ?Color(0xFFa10618):Color(0xFF007326))),
                                  Text(data[index]['order_reference']??'-', style: TextStyle(fontSize: 12, color: Colors.white)),
                                  Text(data[index]['phone_number']??'-', style: TextStyle(fontSize: 10, color: Colors.white)),
                                  Text(data[index]['school']??'-', style: TextStyle(fontSize: 10, color: Colors.white)),
                                ],
                              )
                          ),
                        ),
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
