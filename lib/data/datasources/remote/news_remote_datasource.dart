import 'package:dio/dio.dart';

import '../../../core/errors/app_exceptions.dart';
import '../../models/news_model.dart';

/// Удалённое получение новостей через [Dio].
class NewsRemoteDataSource {
  NewsRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<NewsModel>> fetchNews() async {
    try {
      final response = await _dio.get<List<dynamic>>('/photos?_limit=30');
      final raw = response.data ?? <dynamic>[];
      return raw
          .map(
            (e) => NewsModel.fromJson(
              Map<String, dynamic>.from(e as Map<dynamic, dynamic>),
            ),
          )
          .toList();
    } on DioException catch (e) {
      throw NetworkException(e.message ?? 'Request failed', e);
    }
  }
}
