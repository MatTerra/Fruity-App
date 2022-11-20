abstract class HTTPService {
  String _url = "";
  Map<String, String> _defaultHeaders = {};

  HTTPService(String url, {Map<String, String> defaultHeaders = const {}}){
    _url=url;
    _defaultHeaders=defaultHeaders;
  }

  Future<Map<String, dynamic>?> get(String path,
      {Map<String, String> query = const {}, Map<String, String>? headers});
}
