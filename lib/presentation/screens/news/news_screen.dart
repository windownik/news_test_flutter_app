import 'package:flutter/material.dart';
import 'package:news_flutter_app/common/app_colors.dart';
import 'package:news_flutter_app/presentation/screens/news/pages/all_news_page.dart';
import 'package:news_flutter_app/presentation/screens/news/pages/favorite_news_page.dart';
import 'package:news_flutter_app/presentation/screens/news/pages/single_news_body_page.dart';
import 'package:news_flutter_app/presentation/screens/news/widgets/bottom_navigation_bar.dart';
import '../../../domain/repositories_interfaces/i_news_repository.dart';
import 'news_state.dart';
import 'news_view_wrapper.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key, required this.newsRepository});

  final INewsRepository newsRepository;

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late final NewsViewWrapper _wrapper;
  NewsState oldState = AllNewsState();
  String _selectedCategory = 'general';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _wrapper = NewsViewWrapper(widget.newsRepository);
    _wrapper.showAll(category: _selectedCategory, query: _searchQuery);
  }

  @override
  void dispose() {
    _wrapper.dispose();
    super.dispose();
  }

  Future<void> _onNavChanged(NewsState newState) async {
    if (newState is AllNewsState) {
      oldState = AllNewsState();
      await _wrapper.showAll(category: _selectedCategory, query: _searchQuery);
    } else if (newState is FavoriteNewsState) {
      oldState = FavoriteNewsState();
      await _wrapper.showFavorites();
    }
    setState(() {});
  }

  Future<void> _onBack() async {
    print(["_onBack", oldState]);
    if (oldState is FavoriteNewsState) {
      await _wrapper.showFavorites();
    } else if (oldState is AllNewsState) {
      await _wrapper.showAll(category: _selectedCategory, query: _searchQuery);
    }
    setState(() {});
  }

  Future<void> _onCategorySelected(String category) async {
    if (_selectedCategory == category) return;
    setState(() => _selectedCategory = category);
    await _wrapper.showAll(category: category, query: _searchQuery);
  }

  Future<void> _onSearchChanged(String query) async {
    final resolvedQuery = query.trim();
    if (_searchQuery == resolvedQuery) return;
    setState(() => _searchQuery = resolvedQuery);
    await _wrapper.showAll(category: _selectedCategory, query: resolvedQuery);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<NewsState>(
                stream: _wrapper.stream,
                initialData: _wrapper.currentState,
                builder: (context, snapshot) {
                  final state = snapshot.data ?? _wrapper.currentState;
                  return switch (state) {
                    AllNewsState s => AllNewsPage(
                      state: s,
                      selectedCategory: _selectedCategory,
                      searchQuery: _searchQuery,
                      onCategorySelected: _onCategorySelected,
                      onSearch: _onSearchChanged,
                      onLoadMore: _wrapper.loadMore,
                      onTap: (id) => _wrapper.showDetails(id),
                      onToggleFavorite: (n) => _wrapper.toggleFavorite(n),
                      favoriteResolver: _wrapper.isFavorite,
                    ),
                    FavoriteNewsState s => FavoriteNewsPage(
                      state: s,
                      onTap: (id) => _wrapper.showDetails(id),
                      onToggleFavorite: (n) => _wrapper.toggleFavorite(n),
                      favoriteResolver: _wrapper.isFavorite,
                    ),
                    SingleNewsState s => SingleNewsPage(
                      state: s,
                      onBack: _onBack,
                      onToggleFavorite: (n) => _wrapper.toggleFavorite(n),
                      favoriteResolver: _wrapper.isFavorite,
                    ),
                  };
                },
              ),
            ),
            StreamBuilder<NewsState>(
              stream: _wrapper.stream,
              initialData: _wrapper.currentState,
              builder: (context, snapshot) {
                return BottomNavBar(
                  activeState: oldState,
                  updateStateCallback: _onNavChanged,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
