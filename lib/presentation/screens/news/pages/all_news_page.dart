import 'package:flutter/material.dart';

import '../../../../domain/entities/news_entity.dart';
import '../../../../l10n/app_localizations.dart';
import '../news_state.dart';
import '../widgets/category_bar.dart';
import '../widgets/news_card_widget.dart';

class AllNewsPage extends StatelessWidget {
  const AllNewsPage({
    super.key,
    required this.state,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onTap,
    required this.onToggleFavorite,
    required this.onOpenImage,
    required this.favoriteResolver,
  });

  final AllNewsState state;
  final String selectedCategory;
  final Future<void> Function(String category) onCategorySelected;
  final Future<void> Function(String id) onTap;
  final Future<void> Function(NewsEntity n) onToggleFavorite;
  final void Function(String url) onOpenImage;
  final Future<bool> Function(String id) favoriteResolver;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Widget content = CategoryBar(
      selectedCategory: selectedCategory,
      onCategorySelected: onCategorySelected,
    );

    if (state.isLoading) {
      content = Center(child: CircularProgressIndicator());
    }
    if (state.error != null) {
      content = Center(child: Text(state.error!, textAlign: TextAlign.center));
    }
    if (state.items.isEmpty) {
      content = Center(child: Text(l10n.noNews));
    }
    return Column(
      children: [
        content,
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: state.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, i) {
              final n = state.items[i];
              return NewsCardWidget(
                news: n,
                onTap: () => onTap(n.id),
                onImageTap: n.urlToImage != null
                    ? () => onOpenImage(n.urlToImage!)
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }
}
