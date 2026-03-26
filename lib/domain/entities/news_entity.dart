/// Доменная сущность новости.
class NewsEntity {
  const NewsEntity({
    required this.id,
    required this.title,
    this.body,
    this.imageUrl,
    this.thumbnailUrl,
    this.publishedAt,
  });

  final String id;
  final String title;
  final String? body;
  final String? imageUrl;
  final String? thumbnailUrl;
  final DateTime? publishedAt;
}
