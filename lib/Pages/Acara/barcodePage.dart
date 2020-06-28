import 'dart:convert';

import 'package:tiket/Helpers/api.dart';
import 'package:tiket/Helpers/helper.dart';
import 'package:tiket/Helpers/widget_helper.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:barcode_platform_view/barcode_scanner_view.dart';
import 'package:assets_audio_player/assets_audio_player.dart';


class BarcodePage extends StatefulWidget {
  static const String routeName = '/barcode';
  final acaraId;
  BarcodePage({Key key, @required this.acaraId}) : super(key: key);
  @override
  _BarcodePageState createState() => _BarcodePageState();
}

class _BarcodePageState extends State<BarcodePage>{
  var _message = '';
  var _hasError = false;

  var _acaraId;

  final AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();
  final assets = <String>[
    "assets/audios/beep.mp3",
  ];

  String barcode = "";
  BarcodeScannerController scannerController;

  @override
  void initState() {
    this.setState(() {
      _acaraId=widget.acaraId;
    });
    super.initState();
  }

  /*_loadData() async {
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
  }*/

  @override
  Widget build(BuildContext context) {

    BarcodeScannerView scannerView = new BarcodeScannerView(
      onScannerCreated: onScannerCreated,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Qr-Code"),
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
                        ImageIcon(
                          AssetImage("assets/images/qr-code.png"),
                          color: Colors.white,
                          size: 50,
                        ),
                        Text('Scan Qr-Code', style: TextStyle(color: Colors.white),)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child:Container(
                child: Center(
                  child: new SizedBox(
                    width: 350.0,
                    height: 500.0,
                    child: scannerView
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _loadScan() async {
    var _sendData = Map<String,dynamic>();
    _sendData['event_id'] = _acaraId.toString();
    _sendData['private_reference_number'] = barcode;
    _sendData['checking'] = 'in';

    var res = await CallApi().getData(_sendData, 'attendees/checkinattendee/');
    var body = json.decode(res.body);

    if(body['success'] && res.statusCode==200){
      showSuccessToast(context, body['message']);
    }
    else{
      var errorMessage = body['message']+((res.statusCode==200)?'':'. Kesalahan pada server : '+res.statusCode.toString());
      showErrorToast(context, errorMessage);
    }

  }

  void codeRead(String code) async{
    setState(() {
      barcode = code;
    });

    //beep
    _assetsAudioPlayer.open('assets/audios/beep.mp3');
    _assetsAudioPlayer.play();

    this._loadScan();
    scannerController.startCamera();
  }

  void onScannerCreated(scannerController){
    this.scannerController = scannerController;
    this.scannerController.startCamera();
    this.scannerController.addBarcodeScannerReadCallback(codeRead);
  }


}
