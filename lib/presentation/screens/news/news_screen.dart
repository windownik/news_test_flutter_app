import 'package:flutter/material.dart';
import 'package:news_flutter_app/presentation/screens/news/pages/all_news_page.dart';
import 'package:news_flutter_app/presentation/screens/news/pages/favorite_news_page.dart';
import 'package:news_flutter_app/presentation/screens/news/pages/single_news_body_page.dart';
import '../../../domain/repositories_interfaces/i_news_repository.dart';
import '../../../domain/services/i_image_export_port.dart';
import '../../../l10n/app_localizations.dart';
import '../open_image/open_image_news_screen.dart';
import 'news_state.dart';
import 'news_view_wrapper.dart';

/// Экран новостей: один [StreamBuilder] переключает список / избранное / детали.
class NewsScreen extends StatefulWidget {
  const NewsScreen({
    super.key,
    required this.newsRepository,
    required this.imageExport,
  });

  final INewsRepository newsRepository;
  final IImageExportPort imageExport;

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late final NewsViewWrapper _wrapper;
  int _navIndex = 0;
  String _selectedCategory = 'general';

  @override
  void initState() {
    super.initState();
    _wrapper = NewsViewWrapper(widget.newsRepository);
    _wrapper.showAll(category: _selectedCategory);
  }

  @override
  void dispose() {
    _wrapper.dispose();
    super.dispose();
  }

  Future<void> _onNavChanged(int index) async {
    setState(() => _navIndex = index);
    if (index == 0) {
      await _wrapper.showAll(category: _selectedCategory);
    } else {
      await _wrapper.showFavorites();
    }
  }

  Future<void> _onCategorySelected(String category) async {
    if (_selectedCategory == category) return;
    setState(() => _selectedCategory = category);
    await _wrapper.showAll(category: category);
  }

  void _openImage(String url) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) =>
            OpenImageNewsScreen(imageUrl: url, imageExport: widget.imageExport),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Material(
      child: Column(
        children: [
          const SizedBox(height: 90),
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
                    onCategorySelected: _onCategorySelected,
                    onTap: (id) => _wrapper.showDetails(id),
                    onToggleFavorite: (n) => _wrapper.toggleFavorite(n),
                    onOpenImage: _openImage,
                    favoriteResolver: _wrapper.isFavorite,
                  ),
                  FavoriteNewsState s => FavoriteNewsPage(
                    state: s,
                    onTap: (id) => _wrapper.showDetails(id),
                    onToggleFavorite: (n) => _wrapper.toggleFavorite(n),
                    onOpenImage: _openImage,
                    favoriteResolver: _wrapper.isFavorite,
                  ),
                  SingleNewsState s => SingleNewsPage(
                    state: s,
                    onBack: () async {
                      if (_navIndex == 1) {
                        await _wrapper.showFavorites();
                      } else {
                        await _wrapper.showAll(category: _selectedCategory);
                      }
                    },
                    onToggleFavorite: (n) => _wrapper.toggleFavorite(n),
                    onOpenImage: _openImage,
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
              final hide = snapshot.data is SingleNewsState;
              if (hide) return const SizedBox.shrink();
              return NavigationBar(
                selectedIndex: _navIndex,
                onDestinationSelected: _onNavChanged,
                destinations: [
                  NavigationDestination(
                    icon: Icon(Icons.article_outlined),
                    selectedIcon: Icon(Icons.article),
                    label: l10n.allTabLabel,
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.star_outline),
                    selectedIcon: Icon(Icons.star),
                    label: l10n.favoritesTabLabel,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
