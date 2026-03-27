import '../entities/news_entity.dart';

abstract class INewsRepository {
  Future<List<NewsEntity>> fetchNews({
    String category = 'general',
    String? query,
    bool loadMore = false,
  });

  bool get hasMoreNews;

  /// Returns favorite news from local storage.
  Future<List<NewsEntity>> getFavoriteNews();

  Future<NewsEntity?> getNewsById(String id);

  Future<void> addToFavorites(NewsEntity news);

  Future<void> removeFromFavorites(String id);

  Future<bool> isFavorite(String id);
}
