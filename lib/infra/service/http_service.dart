abstract class HTTPService {
  String _url = "";
  Map<String, String> _defaultHeaders = {};

  HTTPService(String url, {Map<String, String> defaultHeaders = const {}}) {
    _url = url;
    _defaultHeaders = defaultHeaders;
  }

  Future<dynamic> get(String path,
      {Map<String, String> query = const {}, Map<String, String>? headers});

  Future<dynamic> post(String path, String body,
      {Map<String, String>? headers});
}
