import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CustomDio {
  final _dio = Dio();

  Dio get dio => _dio;

  CustomDio(String endpoint) {
    _dio.options.baseUrl = 'https://parseapi.back4app.com/classes/$endpoint';
    _dio.options.headers['X-Parse-Application-Id'] =
        dotenv.get('BACK4APP_APPLICATIONID');
    _dio.options.headers['X-Parse-REST-API-Key'] =
        dotenv.get('BACK4APP_RESTAPIKEY');
    _dio.options.headers['Content-Type'] = 'application/json';
  }
}
