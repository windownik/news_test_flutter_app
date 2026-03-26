import 'package:dio/dio.dart';

import '../../../core/errors/app_exceptions.dart';
import '../../models/news_object.dart';

/// Удалённое получение новостей через NewsAPI.
class NewsRemoteDataSource {
  NewsRemoteDataSource(this._dio, {String? apiKey})
    : _apiKey =
          apiKey ??
          const String.fromEnvironment('NEWS_API_KEY', defaultValue: 'key');

  final Dio _dio;
  final String _apiKey;

  /// GET top-headlines → список [NewsObject] из поля `articles`.
  Future<List<NewsObject>> fetchNews({
    String category = 'general',
    String? query,
  }) async {
    try {
      final resolvedQuery = query?.trim();
      final response = await _dio.get<Map<String, dynamic>>(
        '/top-headlines',
        queryParameters: <String, dynamic>{
          'country': 'us',
          'category': category,
          if (resolvedQuery != null && resolvedQuery.isNotEmpty)
            'q': resolvedQuery,
          'apiKey': _apiKey,
        },
      );
      final body = response.data;
      if (body == null) {
        throw const NetworkException('Empty response');
      }
      if (body['status'] == 'error') {
        final msg = body['message'] as String? ?? 'NewsAPI error';
        throw NetworkException(msg);
      }
      final articlesJson = body['articles'] as List<dynamic>? ?? <dynamic>[];
      return articlesJson
          .map(
            (dynamic e) => NewsObject.fromJson(
              Map<String, dynamic>.from(e as Map<dynamic, dynamic>),
            ),
          )
          .toList();
    } on DioException catch (e) {
      throw NetworkException(e.message ?? 'Request failed', e);
    }
  }
}
