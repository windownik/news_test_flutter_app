import '../../domain/entities/news_entity.dart';
import '../../domain/repositories_interfaces/i_news_repository.dart';
import '../datasources/local/news_local_datasource.dart';
import '../datasources/remote/news_remote_datasource.dart';
import '../models/news_object.dart';

class NewsRepositoryImpl implements INewsRepository {
  static const int _pageSize = 20;

  NewsRepositoryImpl({
    required NewsRemoteDataSource remote,
    required NewsLocalDataSource local,
  }) : _remote = remote,
       _local = local;

  final NewsRemoteDataSource _remote;
  final NewsLocalDataSource _local;

  List<NewsEntity> _cachedRemote = <NewsEntity>[];
  String _currentCategory = 'general';
  String _currentQuery = '';
  int _currentPage = 0;
  bool _hasMoreRemote = true;
  bool _isLoadingMore = false;

  @override
  bool get hasMoreNews => _hasMoreRemote;

  @override
  Future<List<NewsEntity>> fetchNews({
    String category = 'general',
    String? query,
    bool loadMore = false,
  }) async {
    final resolvedQuery = query?.trim() ?? '';
    final shouldReset =
        !loadMore ||
        _currentCategory != category ||
        _currentQuery != resolvedQuery;

    if (shouldReset) {
      _currentCategory = category;
      _currentQuery = resolvedQuery;
      _currentPage = 0;
      _hasMoreRemote = true;
      _cachedRemote = <NewsEntity>[];
    } else if (_isLoadingMore || !_hasMoreRemote) {
      return List<NewsEntity>.unmodifiable(_cachedRemote);
    }

    final nextPage = loadMore ? _currentPage + 1 : 1;
    _isLoadingMore = loadMore;

    try {
      final models = await _remote.fetchNews(
        category: category,
        query: _currentQuery,
        page: nextPage,
        pageSize: _pageSize,
      );
      final incoming = models.map((m) => m.toEntity()).toList();

      if (nextPage == 1) {
        _cachedRemote = incoming;
      } else {
        final knownIds = _cachedRemote.map((item) => item.id).toSet();
        for (final item in incoming) {
          if (knownIds.add(item.id)) {
            _cachedRemote.add(item);
          }
        }
      }

      _currentPage = nextPage;
      _hasMoreRemote = models.length == _pageSize;
      return List<NewsEntity>.unmodifiable(_cachedRemote);
    } finally {
      _isLoadingMore = false;
    }
  }

  @override
  Future<List<NewsEntity>> getFavoriteNews() async {
    final models = await _local.getFavorites();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<NewsEntity?> getNewsById(String id) async {
    final local = await _local.getById(id);
    if (local != null) return local.toEntity();
    for (final e in _cachedRemote) {
      if (e.id == id) return e;
    }
    await fetchNews(category: _currentCategory, query: _currentQuery);
    for (final e in _cachedRemote) {
      if (e.id == id) return e;
    }
    return null;
  }

  @override
  Future<void> addToFavorites(NewsEntity news) async {
    await _local.saveFavorite(NewsObject.fromEntity(news));
  }

  @override
  Future<void> removeFromFavorites(String id) async {
    await _local.removeFavorite(id);
  }

  @override
  Future<bool> isFavorite(String id) => _local.isFavorite(id);
}
