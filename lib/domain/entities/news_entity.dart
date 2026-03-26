/// Domain entity for a news item (NewsAPI + favorites).
class NewsEntity {
  const NewsEntity({
    required this.id,
    this.sourceId,
    this.sourceName,
    this.author,
    required this.title,
    this.description,
    required this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  final String id;
  final String? sourceId;
  final String? sourceName;
  final String? author;
  final String title;
  final String? description;
  final String url;
  final String? urlToImage;
  final DateTime? publishedAt;
  final String? content;
}
