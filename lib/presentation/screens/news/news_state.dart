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
    this.isLoadingMore = false,
    this.hasMore = true,
    this.error,
  });

  final List<NewsEntity> items;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? error;

  AllNewsState copyWith({
    List<NewsEntity>? items,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? error,
  }) {
    return AllNewsState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      error: error ?? this.error,
    );
  }
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
  const SingleNewsState({this.news, this.isLoading = false, this.error});

  final NewsEntity? news;
  final bool isLoading;
  final String? error;
}
