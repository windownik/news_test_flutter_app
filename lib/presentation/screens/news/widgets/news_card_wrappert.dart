import 'package:flutter/material.dart';

import '../../../../domain/entities/news_entity.dart';

class NewsCardWidget extends StatelessWidget {
  const NewsCardWidget({
    super.key,
    required this.news,
    required this.onTap,
    this.onImageTap,
    this.action,
  });

  final NewsEntity news;
  final VoidCallback onTap;
  final VoidCallback? onImageTap;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Container(
            height: 112,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                _NewsCardImage(imageUrl: news.urlToImage, onTap: onImageTap),
                Expanded(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                right: action == null ? 0 : 40,
                              ),
                              child: Text(
                                news.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  height: 1.05,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _subtitle(news),
                              maxLines: 2,
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
                      if (action != null)
                        Positioned(top: 6, right: 6, child: action!),
                    ],
                  ),
                ),
              ],
            ),
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

    if (parts.isEmpty) return 'No subtitle';
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
    final borderRadius = const BorderRadius.horizontal(
      left: Radius.circular(24),
    );
    final child = imageUrl == null
        ? Container(
            width: 126,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: borderRadius,
            ),
            child: const Icon(Icons.image_outlined, size: 40),
          )
        : Image.network(
            imageUrl!,
            width: 126,
            height: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 126,
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
        width: 126,
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
