import 'package:flutter_test/flutter_test.dart';
import 'package:fruity/infra/service/default_http_service.dart';
import 'package:fruity/infra/service/http_service.dart';

void main(){
  test('should instantiate', (){
    HTTPService service = DefaultHTTPService("https://test.com");
    expect(service.runtimeType, DefaultHTTPService);
  });

}