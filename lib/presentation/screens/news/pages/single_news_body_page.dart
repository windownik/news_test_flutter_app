import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_flutter_app/common/app_text_styles.dart';
import 'package:news_flutter_app/presentation/screens/news/widgets/svg_button.dart';

import '../../../../common/app_icons.dart';
import '../../../../domain/entities/news_entity.dart';
import '../../../../l10n/app_localizations.dart';
import '../news_state.dart';
import '../widgets/date_text_widget.dart';
import '../widgets/favorite_icon_button.dart';

class SingleNewsPage extends StatelessWidget {
  const SingleNewsPage({
    super.key,
    required this.state,
    required this.onBack,
    required this.onToggleFavorite,
    required this.onOpenImage,
    required this.favoriteResolver,
  });

  final SingleNewsState state;
  final Future<void> Function() onBack;
  final Future<void> Function(NewsEntity n) onToggleFavorite;
  final void Function(String url) onOpenImage;
  final Future<bool> Function(String id) favoriteResolver;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(state.error!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onBack, child: Text(l10n.backButton)),
          ],
        ),
      );
    }
    final news = state.news;
    if (news == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.newsNotFound),
            const SizedBox(height: 16),
            FilledButton(onPressed: onBack, child: Text(l10n.backButton)),
          ],
        ),
      );
    }
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 16),
            SvgButton(asset: IconsAssets.back, onTap: onBack),
            const Spacer(),
            FavoriteIconButton(
              news: news,
              onToggle: () => onToggleFavorite(news),
              favoriteResolver: favoriteResolver,
            ),
            const SizedBox(width: 16),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(news.title, style: AppTextStyles.titleLarge),
                if (news.description != null)
                  Text(
                    news.description!,
                    style: AppTextStyles.subtitleTextInCard,
                  ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    if (news.sourceName != null)
                      Text(news.sourceName!, style: AppTextStyles.dateTimeBig),
                    const Spacer(),
                    DateTextWidget(
                      dateTime: news.publishedAt,
                      style: AppTextStyles.dateTimeBig,
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                if (news.urlToImage != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(27),
                    child: CachedNetworkImage(
                      imageUrl: news.urlToImage!,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (_, __, ___) =>
                          const Icon(Icons.broken_image, size: 64),
                    ),
                  ),
                const SizedBox(height: 18),
                Text(news.content ?? "", style: AppTextStyles.textInCard),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

String _detailText(NewsEntity n, AppLocalizations l10n) {
  final parts = <String>[];
  if (n.author != null && n.author!.isNotEmpty) {
    parts.add(l10n.newsAuthor(n.author!));
  }
  if (n.sourceName != null && n.sourceName!.isNotEmpty) {
    parts.add(n.sourceName!);
  }
  if (n.description != null && n.description!.isNotEmpty) {
    parts.add(n.description!);
  }
  if (n.content != null && n.content!.isNotEmpty) {
    parts.add(n.content!);
  }
  return parts.join('\n\n');
}
