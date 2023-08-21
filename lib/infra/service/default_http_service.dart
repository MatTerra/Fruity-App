import 'dart:convert';

import 'package:fruity/infra/service/http_service.dart';
import 'package:http/http.dart';

class DefaultHTTPService implements HTTPService{
  Client httpClient = Client();
  String url;
  Map<String,String> defaultHeaders;
  DefaultHTTPService(this.url, {this.defaultHeaders = const {}}) : super();

  @override
  Future<dynamic> get(String path, {Map<String, String> query = const {}, Map<String, String>? headers}) async {
    var response = await httpClient.get(Uri.parse('http://10.0.2.2:8000/v1/species')/*Uri.parse(url+path), headers: this.defaultHeaders+headers*/);
    if (response.statusCode == 200){
      return jsonDecode(response.body);
    }
    throw Exception('Failed to execute get request');
  }
}