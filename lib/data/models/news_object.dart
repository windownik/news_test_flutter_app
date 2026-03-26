import '../../domain/entities/news_entity.dart';

class Source {
  final String? id;
  final String? name;

  Source({this.id, this.name});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json['id'] as String?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}

/// DTO for the NewsAPI response and Hive serialization.
class NewsObject {
  NewsObject({
    this.source,
    this.author,
    this.title = '',
    this.description,
    this.url = '',
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  factory NewsObject.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? sourceMap;
    final raw = json['source'];
    if (raw is Map) {
      sourceMap = Map<String, dynamic>.from(raw);
    }

    final publishedRaw = json['publishedAt'];
    DateTime? published;
    if (publishedRaw is String) {
      published = DateTime.tryParse(publishedRaw);
    }

    return NewsObject(
      source: sourceMap != null ? Source.fromJson(sourceMap) : null,
      author: json['author'] as String?,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      url: json['url'] as String? ?? '',
      urlToImage: json['urlToImage'] as String?,
      publishedAt: published,
      content: json['content'] as String?,
    );
  }

  factory NewsObject.fromEntity(NewsEntity e) => NewsObject(
        source: (e.sourceId != null || e.sourceName != null)
            ? Source(id: e.sourceId, name: e.sourceName)
            : null,
        author: e.author,
        title: e.title,
        description: e.description,
        url: e.url,
        urlToImage: e.urlToImage,
        publishedAt: e.publishedAt,
        content: e.content,
      );

  final Source? source;
  final String? author;
  final String title;
  final String? description;
  final String url;
  final String? urlToImage;
  final DateTime? publishedAt;
  final String? content;

  /// Stable key for cache and Hive because NewsAPI does not provide a separate article ID.
  String get id => url.isNotEmpty ? url : 'news_${title.hashCode}_${publishedAt?.millisecondsSinceEpoch ?? 0}';

  Map<String, dynamic> toJson() => {
        'source': source?.toJson(),
        'author': author,
        'title': title,
        'description': description,
        'url': url,
        'urlToImage': urlToImage,
        'publishedAt': publishedAt?.toIso8601String(),
        'content': content,
      };

  NewsEntity toEntity() => NewsEntity(
        id: id,
        sourceId: source?.id,
        sourceName: source?.name,
        author: author,
        title: title,
        description: description,
        url: url,
        urlToImage: urlToImage,
        publishedAt: publishedAt,
        content: content,
      );
}
