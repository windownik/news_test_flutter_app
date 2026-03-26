import '../../domain/entities/news_entity.dart';

/// DTO / модель данных для JSON и Hive (как Map через JSON).
class NewsModel {
  const NewsModel({
    required this.id,
    required this.title,
    this.body,
    this.imageUrl,
    this.thumbnailUrl,
    this.publishedAt,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String?,
      imageUrl: json['imageUrl'] as String? ?? json['url'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      publishedAt: json['publishedAt'] != null
          ? DateTime.tryParse(json['publishedAt'] as String)
          : null,
    );
  }

  factory NewsModel.fromEntity(NewsEntity e) => NewsModel(
        id: e.id,
        title: e.title,
        body: e.body,
        imageUrl: e.imageUrl,
        thumbnailUrl: e.thumbnailUrl,
        publishedAt: e.publishedAt,
      );

  final String id;
  final String title;
  final String? body;
  final String? imageUrl;
  final String? thumbnailUrl;
  final DateTime? publishedAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'imageUrl': imageUrl,
        'thumbnailUrl': thumbnailUrl,
        'publishedAt': publishedAt?.toIso8601String(),
      };

  NewsEntity toEntity() => NewsEntity(
        id: id,
        title: title,
        body: body,
        imageUrl: imageUrl,
        thumbnailUrl: thumbnailUrl,
        publishedAt: publishedAt,
      );
}
