import '../../../domain/entities/news_entity.dart';

/// Состояния экрана новостей (список / избранное / детали).
sealed class NewsState {
  const NewsState();
}

/// Все новости с сети.
class AllNewsState extends NewsState {
  const AllNewsState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  final List<NewsEntity> items;
  final bool isLoading;
  final String? error;
}

/// Избранное из Hive.
class FavoriteNewsState extends NewsState {
  const FavoriteNewsState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  final List<NewsEntity> items;
  final bool isLoading;
  final String? error;
}

/// Детали одной новости.
class SingleNewsState extends NewsState {
  const SingleNewsState({
    this.news,
    this.isLoading = false,
    this.error,
  });

  final NewsEntity? news;
  final bool isLoading;
  final String? error;
}
