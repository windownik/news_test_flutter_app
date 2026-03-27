import '../../../domain/entities/news_entity.dart';
import '../../../domain/repositories_interfaces/i_news_repository.dart';
import '../../base/base_view_wrapper.dart';
import 'news_state.dart';

/// Manages the [NewsState] stream and loading from network or local storage.
class NewsViewWrapper extends BaseViewWrapper<NewsState> {
  NewsViewWrapper(this._repository)
    : super(const AllNewsState(isLoading: true));

  final INewsRepository _repository;
  String _selectedCategory = 'general';
  String _searchQuery = '';

  /// Loads all news from the network and shows the list.
  Future<void> showAll({String? category, String? query}) async {
    final resolvedCategory = category ?? _selectedCategory;
    final resolvedQuery = query ?? _searchQuery;
    _selectedCategory = resolvedCategory;
    _searchQuery = resolvedQuery;
    emit(const AllNewsState(isLoading: true));
    try {
      final items = await _repository.fetchNews(
        category: resolvedCategory,
        query: resolvedQuery,
      );
      emit(AllNewsState(items: items, hasMore: _repository.hasMoreNews));
    } catch (e, st) {
      emit(AllNewsState(error: '$e\n$st'));
    }
  }

  Future<void> loadMore() async {
    final current = currentState;
    if (current is! AllNewsState ||
        current.isLoading ||
        current.isLoadingMore ||
        !current.hasMore) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));
    try {
      final items = await _repository.fetchNews(
        category: _selectedCategory,
        query: _searchQuery,
        loadMore: true,
      );
      emit(AllNewsState(items: items, hasMore: _repository.hasMoreNews));
    } catch (_) {
      emit(current);
    }
  }

  /// Shows favorites from NoSQL storage (Hive).
  Future<void> showFavorites() async {
    emit(const FavoriteNewsState(isLoading: true));
    try {
      final items = await _repository.getFavoriteNews();
      emit(FavoriteNewsState(items: items));
    } catch (e, st) {
      emit(FavoriteNewsState(error: '$e\n$st'));
    }
  }

  /// Shows news details by [id] from cache after [showAll] or favorites.
  Future<void> showDetails(String id) async {
    emit(const SingleNewsState(isLoading: true));
    try {
      final news = await _repository.getNewsById(id);
      emit(SingleNewsState(news: news));
    } catch (e, st) {
      emit(SingleNewsState(error: '$e\n$st'));
    }
  }

  Future<void> toggleFavorite(NewsEntity news) async {
    final fav = await _repository.isFavorite(news.id);
    if (fav) {
      await _repository.removeFromFavorites(news.id);
    } else {
      await _repository.addToFavorites(news);
    }
    final current = currentState;
    if (current is FavoriteNewsState) {
      await showFavorites();
    } else if (current is AllNewsState) {
      emit(current.copyWith());
    } else if (current is SingleNewsState && current.news != null) {
      emit(SingleNewsState(news: current.news));
    }
  }

  Future<bool> isFavorite(String id) => _repository.isFavorite(id);
}
