import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../../models/news_object.dart';

/// Local NoSQL storage for favorite news (Hive).
class NewsLocalDataSource {
  NewsLocalDataSource(this._box);

  static const String boxName = 'favorite_news';

  final Box<String> _box;

  Future<List<NewsObject>> getFavorites() async {
    return _box.values
        .map((s) => NewsObject.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveFavorite(NewsObject model) async {
    await _box.put(model.id, jsonEncode(model.toJson()));
  }

  Future<void> removeFavorite(String id) async {
    await _box.delete(id);
  }

  Future<NewsObject?> getById(String id) async {
    final raw = _box.get(id);
    if (raw == null) return null;
    return NewsObject.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<bool> isFavorite(String id) async => _box.containsKey(id);
}
