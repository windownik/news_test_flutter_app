import '../../../domain/entities/news_entity.dart';
import '../../../domain/repositories_interfaces/i_news_repository.dart';
import '../../base/base_view_wrapper.dart';
import 'news_state.dart';

/// Управляет потоком [NewsState] и загрузкой из сети / локального хранилища.
class NewsViewWrapper extends BaseViewWrapper<NewsState> {
  NewsViewWrapper(this._repository) : super(const AllNewsState(isLoading: true));

  final INewsRepository _repository;

  /// Загрузить все новости из сети и показать список.
  Future<void> showAll() async {
    emit(const AllNewsState(isLoading: true));
    try {
      final items = await _repository.fetchNews();
      emit(AllNewsState(items: items));
    } catch (e, st) {
      emit(AllNewsState(error: '$e\n$st'));
    }
  }

  /// Показать избранное из NoSQL (Hive).
  Future<void> showFavorites() async {
    emit(const FavoriteNewsState(isLoading: true));
    try {
      final items = await _repository.getFavoriteNews();
      emit(FavoriteNewsState(items: items));
    } catch (e, st) {
      emit(FavoriteNewsState(error: '$e\n$st'));
    }
  }

  /// Детали новости по [id] (кэш после [showAll] или избранное).
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
      emit(AllNewsState(items: current.items));
    } else if (current is SingleNewsState && current.news != null) {
      emit(SingleNewsState(news: current.news));
    }
  }

  Future<bool> isFavorite(String id) => _repository.isFavorite(id);
}
