import '../../domain/entities/news_entity.dart';
import '../../domain/repositories_interfaces/i_news_repository.dart';
import '../datasources/local/news_local_datasource.dart';
import '../datasources/remote/news_remote_datasource.dart';
import '../models/news_object.dart';

class NewsRepositoryImpl implements INewsRepository {
  NewsRepositoryImpl({
    required NewsRemoteDataSource remote,
    required NewsLocalDataSource local,
  })  : _remote = remote,
        _local = local;

  final NewsRemoteDataSource _remote;
  final NewsLocalDataSource _local;

  List<NewsEntity>? _cachedRemote;
  String _currentCategory = 'general';

  @override
  Future<List<NewsEntity>> fetchNews({String category = 'general'}) async {
    _currentCategory = category;
    final models = await _remote.fetchNews(category: category);
    _cachedRemote = models.map((m) => m.toEntity()).toList();
    return _cachedRemote!;
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
    if (_cachedRemote != null) {
      for (final e in _cachedRemote!) {
        if (e.id == id) return e;
      }
    }
    await fetchNews(category: _currentCategory);
    for (final e in _cachedRemote ?? <NewsEntity>[]) {
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
