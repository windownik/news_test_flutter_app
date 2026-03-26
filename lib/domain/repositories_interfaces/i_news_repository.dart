import '../entities/news_entity.dart';

/// Контракт репозитория новостей (сеть + локальное избранное).
abstract class INewsRepository {
  /// Загрузка списка новостей с удалённого API.
  Future<List<NewsEntity>> fetchNews({String category = 'general'});

  /// Избранные новости из локального хранилища.
  Future<List<NewsEntity>> getFavoriteNews();

  /// Новость по идентификатору (кэш после [fetchNews], затем избранное).
  Future<NewsEntity?> getNewsById(String id);

  Future<void> addToFavorites(NewsEntity news);

  Future<void> removeFromFavorites(String id);

  Future<bool> isFavorite(String id);
}
