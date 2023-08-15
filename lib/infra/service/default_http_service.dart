import 'package:fruity/infra/service/http_service.dart';
import 'package:http/http.dart';

class DefaultHTTPService implements HTTPService{
  Client httpClient = Client();
  String url;
  Map<String,String> defaultHeaders;
  DefaultHTTPService(this.url, {this.defaultHeaders = const {}}) : super();

  @override
  Future<Map<String, dynamic>?> get(String path, {Map<String, String> query = const {}, Map<String, String>? headers}) {
    return Future(() => null);
  }
}