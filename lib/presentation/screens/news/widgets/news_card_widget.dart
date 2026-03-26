import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_flutter_app/common/app_colors.dart';
import 'package:news_flutter_app/common/app_text_styles.dart';

import '../../../../domain/entities/news_entity.dart';
import 'date_text_widget.dart';
import 'favorite_icon_button.dart';

const borderRadiusValue = 16.0;

class NewsCardWidget extends StatelessWidget {
  const NewsCardWidget({
    super.key,
    required this.news,
    required this.onTap,
    this.onImageTap,
    this.onTapFavorite,
    this.onToggleFavorite,
    this.favoriteResolver,
  });

  final NewsEntity news;
  final VoidCallback onTap;
  final VoidCallback? onTapFavorite;
  final Future<void> Function(NewsEntity n)? onToggleFavorite;
  final Future<bool> Function(String id)? favoriteResolver;
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
                  color: AppColors.white,
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
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    news.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.titleInCard,
                                  ),
                                ),
                                if (onToggleFavorite != null)
                                  FavoriteIconButton(
                                    news: news,
                                    onToggle: () => onToggleFavorite!(news),
                                    favoriteResolver: favoriteResolver!,
                                    width: 33,
                                    height: 32,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _subtitle(news),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.dateTimeBig,
                            ),
                            const Spacer(),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: DateTextWidget(dateTime: news.publishedAt),
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
}

class _NewsCardImage extends StatelessWidget {
  const _NewsCardImage({required this.imageUrl, required this.onTap});

  final String? imageUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.horizontal(
      left: Radius.circular(borderRadiusValue),
    );
    final child = imageUrl == null
        ? Container(
            width: 123,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: borderRadius,
            ),
            child: const Icon(Icons.image_outlined, size: 40),
          )
        : CachedNetworkImage(
            imageUrl: imageUrl!,
            width: 123,
            height: double.infinity,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(
              width: 123,
              color: theme.colorScheme.surfaceContainerHighest,
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (_, __, ___) => Container(
              width: 123,
              color: AppColors.white,
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
