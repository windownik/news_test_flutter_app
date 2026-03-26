import 'package:dio/dio.dart';

/// Обёртка над [Dio] с единой точкой настройки (NewsAPI v2).
class NetworkClient {
  NetworkClient({Dio? dio, String? baseUrl})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl ?? 'https://newsapi.org/v2',
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 15),
                headers: const {'Accept': 'application/json'},
              ),
            );

  final Dio _dio;

  Dio get dio => _dio;
}
