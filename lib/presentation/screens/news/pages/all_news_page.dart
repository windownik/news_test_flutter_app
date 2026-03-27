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
    required this.onLoadMore,
    required this.onTap,
    required this.onToggleFavorite,
    required this.favoriteResolver,
  });

  final AllNewsState state;
  final String selectedCategory;
  final String searchQuery;
  final Future<void> Function(String category) onCategorySelected;
  final Future<void> Function(String query) onSearch;
  final Future<void> Function() onLoadMore;
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
      content = NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          final isNearBottom =
              notification.metrics.pixels >=
              notification.metrics.maxScrollExtent - 200;
          if (isNearBottom && state.hasMore && !state.isLoadingMore) {
            onLoadMore();
          }
          return false;
        },
        child: ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, i) {
            if (i >= state.items.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final n = state.items[i];
            return NewsCardWidget(news: n, onTap: () => onTap(n.id));
          },
        ),
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
