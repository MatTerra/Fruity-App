import 'package:fruity/infra/service/http_service.dart';

class DefaultHTTPService implements HTTPService{
  BaseClient httpClient;
  DefaultHTTPService(url, {defaultHeaders = const {}}) : super();

  @override
  Future<Map<String, dynamic>?> get(String path, {Map<String, String> query = const {}, Map<String, String>? headers}) {
    return Future(() => null);
  }
}