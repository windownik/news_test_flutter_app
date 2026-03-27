import 'package:flutter/material.dart';

import '../../../../domain/entities/news_entity.dart';
import '../../../../l10n/app_localizations.dart';
import '../news_state.dart';
import '../widgets/category_bar.dart';
import '../widgets/news_card_widget.dart';
import '../widgets/search_app_bar.dart';

class AllNewsPage extends StatelessWidget {
  const AllNewsPage({
    super.key,
    required this.state,
    required this.selectedCategory,
    required this.searchQuery,
    required this.onCategorySelected,
    required this.onSearch,
    required this.onTap,
    required this.onToggleFavorite,
    required this.favoriteResolver,
  });

  final AllNewsState state;
  final String selectedCategory;
  final String searchQuery;
  final Future<void> Function(String category) onCategorySelected;
  final Future<void> Function(String query) onSearch;
  final Future<void> Function(String id) onTap;
  final Future<void> Function(NewsEntity n) onToggleFavorite;
  final Future<bool> Function(String id) favoriteResolver;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Widget content;
    if (state.isLoading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (state.error != null) {
      content = Center(child: Text(state.error!, textAlign: TextAlign.center));
    } else if (state.items.isEmpty) {
      content = Center(child: Text(l10n.noNews));
    } else {
      content = ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: state.items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, i) {
          final n = state.items[i];
          return NewsCardWidget(news: n, onTap: () => onTap(n.id));
        },
      );
    }

    return Column(
      children: [
        SearchAppBar(initialQuery: searchQuery, onSearch: onSearch),
        CategoryBar(
          selectedCategory: selectedCategory,
          onCategorySelected: onCategorySelected,
        ),
        Expanded(child: content),
      ],
    );
  }
}
