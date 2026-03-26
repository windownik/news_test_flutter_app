import 'package:flutter/material.dart';

import '../../../domain/entities/news_entity.dart';
import '../../../domain/repositories_interfaces/i_news_repository.dart';
import '../../../domain/services/i_image_export_port.dart';
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

  @override
  void initState() {
    super.initState();
    _wrapper = NewsViewWrapper(widget.newsRepository);
    _wrapper.showAll();
  }

  @override
  void dispose() {
    _wrapper.dispose();
    super.dispose();
  }

  Future<void> _onNavChanged(int index) async {
    setState(() => _navIndex = index);
    if (index == 0) {
      await _wrapper.showAll();
    } else {
      await _wrapper.showFavorites();
    }
  }

  void _openImage(String url) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => OpenImageNewsScreen(
          imageUrl: url,
          imageExport: widget.imageExport,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
        actions: [
          IconButton(
            tooltip: 'All news',
            icon: const Icon(Icons.list_alt),
            onPressed: () async {
              setState(() => _navIndex = 0);
              await _wrapper.showAll();
            },
          ),
          IconButton(
            tooltip: 'Favorites',
            icon: const Icon(Icons.star),
            onPressed: () async {
              setState(() => _navIndex = 1);
              await _wrapper.showFavorites();
            },
          ),
        ],
      ),
      body: StreamBuilder<NewsState>(
        stream: _wrapper.stream,
        initialData: _wrapper.currentState,
        builder: (context, snapshot) {
          final state = snapshot.data ?? _wrapper.currentState;
          return switch (state) {
            AllNewsState s => _AllNewsBody(
                state: s,
                onTap: (id) => _wrapper.showDetails(id),
                onToggleFavorite: (n) => _wrapper.toggleFavorite(n),
                onOpenImage: _openImage,
                favoriteResolver: _wrapper.isFavorite,
              ),
            FavoriteNewsState s => _FavoriteNewsBody(
                state: s,
                onTap: (id) => _wrapper.showDetails(id),
                onToggleFavorite: (n) => _wrapper.toggleFavorite(n),
                onOpenImage: _openImage,
                favoriteResolver: _wrapper.isFavorite,
              ),
            SingleNewsState s => _SingleNewsBody(
                state: s,
                onBack: () async {
                  if (_navIndex == 1) {
                    await _wrapper.showFavorites();
                  } else {
                    await _wrapper.showAll();
                  }
                },
                onToggleFavorite: (n) => _wrapper.toggleFavorite(n),
                onOpenImage: _openImage,
                favoriteResolver: _wrapper.isFavorite,
              ),
          };
        },
      ),
      bottomNavigationBar: StreamBuilder<NewsState>(
        stream: _wrapper.stream,
        initialData: _wrapper.currentState,
        builder: (context, snapshot) {
          final hide = snapshot.data is SingleNewsState;
          if (hide) return const SizedBox.shrink();
          return NavigationBar(
            selectedIndex: _navIndex,
            onDestinationSelected: _onNavChanged,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.article_outlined),
                selectedIcon: Icon(Icons.article),
                label: 'All',
              ),
              NavigationDestination(
                icon: Icon(Icons.star_outline),
                selectedIcon: Icon(Icons.star),
                label: 'Favorites',
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AllNewsBody extends StatelessWidget {
  const _AllNewsBody({
    required this.state,
    required this.onTap,
    required this.onToggleFavorite,
    required this.onOpenImage,
    required this.favoriteResolver,
  });

  final AllNewsState state;
  final Future<void> Function(String id) onTap;
  final Future<void> Function(NewsEntity n) onToggleFavorite;
  final void Function(String url) onOpenImage;
  final Future<bool> Function(String id) favoriteResolver;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.error != null) {
      return Center(child: Text(state.error!, textAlign: TextAlign.center));
    }
    if (state.items.isEmpty) {
      return const Center(child: Text('No news'));
    }
    return ListView.separated(
      itemCount: state.items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final n = state.items[i];
        return _NewsListTile(
          news: n,
          onTap: () => onTap(n.id),
          onToggleFavorite: () => onToggleFavorite(n),
          onOpenImage: n.imageUrl != null ? () => onOpenImage(n.imageUrl!) : null,
          favoriteResolver: favoriteResolver,
        );
      },
    );
  }
}

class _FavoriteNewsBody extends StatelessWidget {
  const _FavoriteNewsBody({
    required this.state,
    required this.onTap,
    required this.onToggleFavorite,
    required this.onOpenImage,
    required this.favoriteResolver,
  });

  final FavoriteNewsState state;
  final Future<void> Function(String id) onTap;
  final Future<void> Function(NewsEntity n) onToggleFavorite;
  final void Function(String url) onOpenImage;
  final Future<bool> Function(String id) favoriteResolver;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.error != null) {
      return Center(child: Text(state.error!, textAlign: TextAlign.center));
    }
    if (state.items.isEmpty) {
      return const Center(child: Text('No favorites yet'));
    }
    return ListView.separated(
      itemCount: state.items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final n = state.items[i];
        return _NewsListTile(
          news: n,
          onTap: () => onTap(n.id),
          onToggleFavorite: () => onToggleFavorite(n),
          onOpenImage: n.imageUrl != null ? () => onOpenImage(n.imageUrl!) : null,
          favoriteResolver: favoriteResolver,
        );
      },
    );
  }
}

class _SingleNewsBody extends StatelessWidget {
  const _SingleNewsBody({
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
            FilledButton(onPressed: onBack, child: const Text('Back')),
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
            const Text('News not found'),
            const SizedBox(height: 16),
            FilledButton(onPressed: onBack, child: const Text('Back')),
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
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: onBack,
              ),
              Expanded(
                child: Text(
                  n.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              _FavoriteIconButton(
                news: n,
                onToggle: () => onToggleFavorite(n),
                favoriteResolver: favoriteResolver,
              ),
            ],
          ),
        ),
        if (n.imageUrl != null)
          AspectRatio(
            aspectRatio: 16 / 9,
            child: InkWell(
              onTap: () => onOpenImage(n.imageUrl!),
              child: Image.network(
                n.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, size: 64),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(n.body ?? ''),
        ),
      ],
    );
  }
}

class _NewsListTile extends StatelessWidget {
  const _NewsListTile({
    required this.news,
    required this.onTap,
    required this.onToggleFavorite,
    required this.onOpenImage,
    required this.favoriteResolver,
  });

  final NewsEntity news;
  final VoidCallback onTap;
  final Future<void> Function() onToggleFavorite;
  final VoidCallback? onOpenImage;
  final Future<bool> Function(String id) favoriteResolver;

  @override
  Widget build(BuildContext context) {
    final thumb = news.thumbnailUrl ?? news.imageUrl;
    return ListTile(
      leading: thumb != null
          ? GestureDetector(
              onTap: onOpenImage,
              child: Image.network(
                thumb,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
              ),
            )
          : const Icon(Icons.article),
      title: Text(news.title, maxLines: 2, overflow: TextOverflow.ellipsis),
      onTap: onTap,
      trailing: _FavoriteIconButton(
        news: news,
        onToggle: onToggleFavorite,
        favoriteResolver: favoriteResolver,
      ),
    );
  }
}

class _FavoriteIconButton extends StatefulWidget {
  const _FavoriteIconButton({
    required this.news,
    required this.onToggle,
    required this.favoriteResolver,
  });

  final NewsEntity news;
  final Future<void> Function() onToggle;
  final Future<bool> Function(String id) favoriteResolver;

  @override
  State<_FavoriteIconButton> createState() => _FavoriteIconButtonState();
}

class _FavoriteIconButtonState extends State<_FavoriteIconButton> {
  bool? _fav;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant _FavoriteIconButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.news.id != widget.news.id) {
      _load();
    }
  }

  Future<void> _load() async {
    final v = await widget.favoriteResolver(widget.news.id);
    if (mounted) setState(() => _fav = v);
  }

  @override
  Widget build(BuildContext context) {
    final fav = _fav ?? false;
    return IconButton(
      icon: Icon(fav ? Icons.star : Icons.star_border),
      onPressed: () async {
        await widget.onToggle();
        if (mounted) await _load();
      },
    );
  }
}
