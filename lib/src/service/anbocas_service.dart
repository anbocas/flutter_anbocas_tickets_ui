import 'package:dio/dio.dart';

abstract class AnbocasService {
  late final Dio _dio;

  AnbocasService({
    required String baseUrl,
    Dio? dio,
    Map<String, String>? apiHeaders,
  }) {
    _dio = dio ?? Dio();
    _dio.options.baseUrl = baseUrl;
    dio?.interceptors.add(_logInterceptor());
    if (apiHeaders != null) {
      _dio.options.headers.addAll(apiHeaders);
    }
  }

  LogInterceptor _logInterceptor() {
    return LogInterceptor(
        requestBody: true, responseBody: true, requestHeader: true);
  }

  Future<Response<T>> doGet<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.get(path, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> doPost<T>(
    String path,
    dynamic data, {
    Options? options,
  }) async {
    return _dio.post(path, data: data, options: options);
  }

  void dispose() => _dio.close();
}
