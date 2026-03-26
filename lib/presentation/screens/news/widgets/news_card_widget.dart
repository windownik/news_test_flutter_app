import 'package:flutter/material.dart';

import '../../../../domain/entities/news_entity.dart';

const borderRadiusValue = 16.0;

class NewsCardWidget extends StatelessWidget {
  const NewsCardWidget({
    super.key,
    required this.news,
    required this.onTap,
    this.onImageTap,
  });

  final NewsEntity news;
  final VoidCallback onTap;
  final VoidCallback? onImageTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 19),
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          height: 112,
          child: Stack(
            children: [
              Container(
                height: 112,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(borderRadiusValue),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.15),
                      blurRadius: 6.1,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _NewsCardImage(
                      imageUrl: news.urlToImage,
                      onTap: onImageTap,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 5, 11, 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              news.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                height: 1.05,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _subtitle(news),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w400,
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.78,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                _formatDate(news.publishedAt),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 112,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(borderRadiusValue),
                  border: Border.all(
                    color: Color.fromRGBO(206, 206, 206, 1),
                    width: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _subtitle(NewsEntity news) {
    final parts = <String>[
      if (news.description != null && news.description!.trim().isNotEmpty)
        news.description!.trim(),
      if (news.sourceName != null && news.sourceName!.trim().isNotEmpty)
        news.sourceName!.trim(),
      if (news.author != null && news.author!.trim().isNotEmpty)
        news.author!.trim(),
    ];

    if (parts.isEmpty) return '';
    return parts.first;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '--.--.----';

    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final year = date.year.toString().padLeft(4, '0');
    return '$month.$day.$year';
  }
}

class _NewsCardImage extends StatelessWidget {
  const _NewsCardImage({required this.imageUrl, required this.onTap});

  final String? imageUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.horizontal(
      left: Radius.circular(borderRadiusValue),
    );
    final child = imageUrl == null
        ? Container(
            width: 123,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: borderRadius,
            ),
            child: const Icon(Icons.image_outlined, size: 40),
          )
        : Image.network(
            imageUrl!,
            width: 123,
            height: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 123,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: borderRadius,
              ),
              child: const Icon(Icons.broken_image_outlined, size: 40),
            ),
          );

    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        width: 123,
        height: double.infinity,
        child: onTap == null
            ? child
            : GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onTap,
                child: child,
              ),
      ),
    );
  }
}
