import 'dart:convert';

import 'package:tiket/Helpers/helper.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CallApi{
  final String _url = APP_URL;

  postData(data, apiUrl) async {
    var fullUrl = _url + apiUrl + await _getToken();
    return await http.post(
        fullUrl,
        body: jsonEncode(data),
        headers: _setHeaders()
    );
  }

  getData(data, apiUrl) async {
    data['api_token'] = await _getToken();
    var tempUrl = _url + apiUrl;
    Uri uri = Uri.parse(tempUrl);
    var fullUrl = uri.replace(queryParameters: data);
    return await http.get(
        fullUrl,
        headers: _setHeaders()
    );
  }

  _setHeaders() => {
    'Content-type' : 'application/json',
    'Accept' : 'application/json',
    'App-Token' : APP_TOKEN
  };

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('api_token');
    return token;
  }
}
