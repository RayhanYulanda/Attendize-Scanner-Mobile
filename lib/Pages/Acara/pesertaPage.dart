import 'dart:convert';

import 'package:tiket/Helpers/api.dart';
import 'package:tiket/Helpers/helper.dart';
import 'package:tiket/Helpers/widget_helper.dart';
import 'package:tiket/Pages/Acara/barcodePage.dart';
import 'package:tiket/Routes.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class PesertaPage extends StatefulWidget {
  static const String routeName = '/peserta';
  final acaraId;
  PesertaPage({Key key, @required this.acaraId}) : super(key: key);
  @override
  _PesertaPageState createState() => _PesertaPageState();
}

class _PesertaPageState extends State<PesertaPage>{
  List data;
  bool _isLoading = true;
  var _message = '';
  var _hasError = false;
  var _acaraId;
  List filteredList;

  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    this.setState(() {
      _isLoading=true;
      _acaraId=widget.acaraId;
    });

    this._loadData();
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
      filteredList=data;
    });
  }

  _loadCheckInOut(_privateReferenceNumber, _inOut) async {
    var _sendData = Map<String,dynamic>();
    _sendData['event_id'] = _acaraId.toString();
    _sendData['private_reference_number'] = _privateReferenceNumber;
    _sendData['checking'] = _inOut;

    var res = await CallApi().getData(_sendData, 'attendees/checkinattendee/');
    var body = json.decode(res.body);

    if(body['success'] && res.statusCode==200){
      showSuccessToast(context, body['message']);
      _loadData();
    }
    else{
      var errorMessage = body['message']+((res.statusCode==200)?'':'. Kesalahan pada server : '+res.statusCode.toString());
      showErrorToast(context, errorMessage);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, new MaterialPageRoute<Null>(
              settings: RouteSettings(name: Routes.qrcode),
              builder: (BuildContext context) => BarcodePage(acaraId: _acaraId,)
          ));
        },
        child: ImageIcon(
          AssetImage("assets/images/qr-code.png"),
          color: Colors.white,
        ),
        backgroundColor: SECONDARY_COLOR,
      ),
      appBar: AppBar(
        title: Text("Peserta"),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 90,
              margin: EdgeInsets.only(bottom: 5),
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
            Container(
              margin: EdgeInsets.only(bottom: 5, top: 5),
              child: SizedBox(
                height: 50,
                width: 350,
                child: TextField(
                  onChanged: (stringToSearch) {
                    setState(() {
                      filteredList = data.where((u) => (
                          u['first_name'].toLowerCase().contains(stringToSearch.toLowerCase()) ||
                          u['last_name'].toLowerCase().contains(stringToSearch.toLowerCase()))
                      ).toList();
                    });
                  },
                  controller: editingController,
                  decoration: InputDecoration(
                      labelText: "Search",
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                ),
              ),
            ),
            Expanded(
              child:
              _isLoading ?
              loadingWidgetCenter(context)
                  :
              (filteredList.isEmpty)?
              Text("Tidak ada yang mendaftar pada acara ini")
                  :
              LiquidPullToRefresh(
                onRefresh: ()=>_loadData(),
                backgroundColor: PRIMARY_COLOR,
                color: Colors.white,
                child:
                ListView.builder(
                  padding: EdgeInsets.only(left:6, right: 6),
                  itemCount: filteredList.isEmpty ? 0 : filteredList.length,
                  itemBuilder: (BuildContext context, int index){
                    return Card(
                      elevation: 5,
                      color: filteredList[index]['has_arrived']==0 ? Color(0xFFffb0b9) : Color(0xFF6bed96),
                      child: ListTile(
                        title: Text(filteredList[index]['first_name']+' '+filteredList[index]['last_name'], style: TextStyle(color: Colors.white),),
                        subtitle:
                        Container(
                          child: (
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(filteredList[index]['email']??'-', style: TextStyle(fontSize: 13, color: filteredList[index]['has_arrived']==0 ?Color(0xFFa10618):Color(0xFF007326))),
                                  Text(filteredList[index]['order_reference']??'-', style: TextStyle(fontSize: 12, color: Colors.white)),
                                  Text(filteredList[index]['phone_number']??'-', style: TextStyle(fontSize: 10, color: Colors.white)),
                                  Text(filteredList[index]['school']??'-', style: TextStyle(fontSize: 10, color: Colors.white)),
                                ],
                              )
                          ),
                        ),
                        trailing: InkWell(
                          onTap: () {
                            var _inOut = filteredList[index]['has_arrived']==0?'in':'out';
                            var _privateReferenceNumber = filteredList[index]['private_reference_number'];
                            _loadCheckInOut(_privateReferenceNumber, _inOut);
                            },
                          child: Badge(
                            elevation: 5,
                            padding: EdgeInsets.all(15),
                            badgeColor: filteredList[index]['has_arrived']==0 ? Color(0xFF1e9e49) : Color(0xFFd13446),
                            badgeContent: Text(filteredList[index]['has_arrived']==0 ?'Hadir':'Batal', style: TextStyle(color: Colors.white),),
                            toAnimate: false,
                            borderRadius: 20,
                            shape: BadgeShape.square,
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
