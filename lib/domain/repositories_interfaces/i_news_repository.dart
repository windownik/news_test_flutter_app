import '../entities/news_entity.dart';

/// News repository contract for network data and local favorites.
abstract class INewsRepository {
  /// Loads the news list from the remote API.
  Future<List<NewsEntity>> fetchNews({
    String category = 'general',
    String? query,
  });

  /// Returns favorite news from local storage.
  Future<List<NewsEntity>> getFavoriteNews();

  /// Returns news by identifier from the cache after [fetchNews], then favorites.
  Future<NewsEntity?> getNewsById(String id);

  Future<void> addToFavorites(NewsEntity news);

  Future<void> removeFromFavorites(String id);

  Future<bool> isFavorite(String id);
}
