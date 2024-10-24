import 'dart:convert';
import 'dart:io';

import 'package:fruity/infra/service/http_service.dart';
import 'package:http/http.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class DefaultHTTPService implements HTTPService{
  Client httpClient = SentryHttpClient();
  String url;
  Map<String,String> defaultHeaders;
  DefaultHTTPService(this.url, {this.defaultHeaders = const {}}) : super();

  @override
  Future<dynamic> get(String path, {Map<String, String> query = const {}, Map<String, String>? headers}) async {
    headers = prepareHeaders(headers ?? {});
    var queryString = prepareQuery(query);
    var response = await httpClient.get(Uri.parse("${url}${path}${queryString}"), headers: headers);
    if (response.statusCode < 400){
      return jsonDecode(response.body);
    }
    throw Exception('Failed to execute get request');
  }

  Map<String, String> prepareHeaders(Map<String, String> headers) {
    headers.addAll(defaultHeaders);
    return headers;
  }

  String prepareQuery(Map<String, String> query){
    if(query.isEmpty){
      return "";
    }
    var queryString = "?";
    query.forEach((key, value) {
      queryString += "${key}=${value}";
      queryString += "&";
    });
    return queryString.substring(0, queryString.length - 1);
  }

  @override
  Future<dynamic> post(String path, String body, {Map<String, String>? headers}) async {
    headers = prepareHeaders(headers ?? {});
    headers.addAll({HttpHeaders.contentTypeHeader: "application/json"});
    var jsonBody = body;
    var response = await httpClient.post(Uri.parse("${url}${path}"), body: jsonBody, headers: headers);
    if (response.statusCode < 400){
      return jsonDecode(response.body);
    }
    throw Exception('Failed to execute post request');
  }
}