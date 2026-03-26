import 'package:dio/dio.dart';

/// Обёртка над [Dio] с единой точкой настройки.
class NetworkClient {
  NetworkClient({Dio? dio, String? baseUrl})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl ?? 'https://jsonplaceholder.typicode.com',
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 15),
                headers: const {'Accept': 'application/json'},
              ),
            );

  final Dio _dio;

  Dio get dio => _dio;
}
