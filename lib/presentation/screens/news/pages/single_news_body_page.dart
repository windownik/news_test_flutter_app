import 'package:flutter/material.dart';

import '../../../../domain/entities/news_entity.dart';
import '../../../../l10n/app_localizations.dart';
import '../news_state.dart';
import '../widgets/favorite_icon_button.dart';

class SingleNewsPage extends StatelessWidget {
  const SingleNewsPage({
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
    final n = state.news;
    if (n == null) {
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              IconButton(icon: const Icon(Icons.arrow_back), onPressed: onBack),
              Expanded(
                child: Text(
                  n.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              FavoriteIconButton(
                news: n,
                onToggle: () => onToggleFavorite(n),
                favoriteResolver: favoriteResolver,
              ),
            ],
          ),
        ),
        if (n.urlToImage != null)
          AspectRatio(
            aspectRatio: 16 / 9,
            child: InkWell(
              onTap: () => onOpenImage(n.urlToImage!),
              child: Image.network(
                n.urlToImage!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, size: 64),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(_detailText(n, l10n)),
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
