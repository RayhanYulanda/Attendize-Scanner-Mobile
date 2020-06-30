import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:tiket/Helpers/api.dart';
import 'package:tiket/Helpers/helper.dart';
import 'package:tiket/Helpers/widget_helper.dart';
import 'package:tiket/adminMain.dart';

import '../Widget/bezierContainer.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  /*bool _isRefresh = false;
  bool _isMounted = false;*/
  bool _isLoading = false;
  var _message = '';
  var _hasError = false;

  bool autoValidate = false;
  bool readOnly = false;
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'A',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: PRIMARY_COLOR,
          ),
          children: [
            TextSpan(
              text: '-',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'Tiket+',
              style: TextStyle(color: SECONDARY_COLOR, fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        FormBuilder(
          key: _fbKey,
          autovalidate: autoValidate,
          initialValue: {},
          readOnly: readOnly,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: FormBuilderTextField(
                    attribute: "email",
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      fillColor: Color(0xfff3f3f4),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                    ),
                    /*onChanged: _onChanged,*/
                    validators: [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.email(),
                    ]
                ),
              ),
              FormBuilderTextField(
                  attribute: "password",
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    fillColor: Color(0xfff3f3f4),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                  ),
                  obscureText: true,
                  maxLines: 1,
                  /*onChanged: _onChanged,*/
                  validators: [
                    FormBuilderValidators.required(),
                  ]
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _submitButton() {
    return InkWell(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [PRIMARY_COLOR, SECONDARY_COLOR])),
        child: Text(
          _isLoading ? 'Loging...' : 'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      onTap: (){
        if (_fbKey.currentState.saveAndValidate()) {
          _isLoading ? null : _login();
          //print(_fbKey.currentState.value);
          //kalo berhasil untuk submit
        }
        else {
          //kalo tidak berhasil submit
          //print(_fbKey.currentState.value);
          print("validation failed");
        }
      },
    );
  }

  void _login() async{

    setState(() {_isLoading = true;});

    var data = _fbKey.currentState.value;

    var res = await CallApi().getData(data, 'secure');
    var body = json.decode(res.body);
    if(body['success'] && res.statusCode ==200){
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('api_token', body['api_token']);
      localStorage.setString('user', json.encode(body['first_name']));
      Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
              builder: (context) => AdminMain()));
    }
    else{
      var errorMessage = body['message']+((res.statusCode==200)?'':'. Kesalahan pada server : '+res.statusCode.toString());
      showErrorToast(context, errorMessage);
    }

    setState(() {_isLoading = false;});
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
          body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: SizedBox(),
                          ),
                          _title(),
                          SizedBox(
                            height: 50,
                          ),
                          _emailPasswordWidget(),
                          SizedBox(
                            height: 20,
                          ),
                          _submitButton(),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.centerRight,
                          ),
                          Expanded(
                            flex: 2,
                            child: SizedBox(),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Developer Contact',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () => launch('https://api.whatsapp.com/send?phone=YOUR_PHONE_NUMBER'),
                              child: Icon(
                                Icons.phone,
                                color: Colors.green,
                                size: 24.0,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        top: -MediaQuery.of(context).size.height * .15,
                        right: -MediaQuery.of(context).size.width * .4,
                        child: BezierContainer())
                  ],
                ),
              )
          )
      )
    ;
  }
}
