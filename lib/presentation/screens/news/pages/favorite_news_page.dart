import 'package:flutter/material.dart';

import '../../../../domain/entities/news_entity.dart';
import '../../../../l10n/app_localizations.dart';
import '../news_state.dart';
import '../widgets/news_card_widget.dart';

class FavoriteNewsPage extends StatelessWidget {
  const FavoriteNewsPage({
    super.key,
    required this.state,
    required this.onTap,
    required this.onToggleFavorite,
    required this.favoriteResolver,
  });

  final FavoriteNewsState state;
  final Future<void> Function(String id) onTap;
  final Future<void> Function(NewsEntity n) onToggleFavorite;
  final Future<bool> Function(String id) favoriteResolver;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.error != null) {
      return Center(child: Text(state.error!, textAlign: TextAlign.center));
    }
    if (state.items.isEmpty) {
      return Center(child: Text(l10n.noFavoritesYet));
    }
    return Column(
      children: [
        const SizedBox(height: 60),
        Expanded(
          child: ListView.separated(
            itemCount: state.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, i) {
              final n = state.items[i];
              return NewsCardWidget(
                news: n,
                onTap: () => onTap(n.id),
                favoriteResolver: favoriteResolver,
                onToggleFavorite: onToggleFavorite,
              );
            },
          ),
        ),
      ],
    );
  }
}
