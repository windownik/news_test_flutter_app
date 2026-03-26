import 'package:flutter/material.dart';

import '../../../../domain/entities/news_entity.dart';

class FavoriteIconButton extends StatefulWidget {
  const FavoriteIconButton({
    super.key,
    required this.news,
    required this.onToggle,
    required this.favoriteResolver,
  });

  final NewsEntity news;
  final Future<void> Function() onToggle;
  final Future<bool> Function(String id) favoriteResolver;

  @override
  State<FavoriteIconButton> createState() => _FavoriteIconButtonState();
}

class _FavoriteIconButtonState extends State<FavoriteIconButton> {
  bool? _fav;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant FavoriteIconButton oldWidget) {
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
