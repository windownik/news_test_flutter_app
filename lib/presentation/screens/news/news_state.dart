import '../../../domain/entities/news_entity.dart';

/// States for the news screen (list, favorites, details).
sealed class NewsState {
  const NewsState();
}

/// All news loaded from the network.
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

/// Favorites loaded from Hive.
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

/// Details for a single news item.
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
