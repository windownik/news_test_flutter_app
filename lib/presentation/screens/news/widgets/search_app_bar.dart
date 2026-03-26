import 'package:flutter/material.dart';

class SearchAppBar extends StatefulWidget {
  const SearchAppBar({
    super.key,
    required this.initialQuery,
    required this.onSearch,
  });

  final String initialQuery;
  final Future<void> Function(String query) onSearch;

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
  }

  @override
  void didUpdateWidget(covariant SearchAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialQuery == _controller.text) return;
    _controller.value = TextEditingValue(
      text: widget.initialQuery,
      selection: TextSelection.collapsed(offset: widget.initialQuery.length),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() => widget.onSearch(_controller.text.trim());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(color: Colors.white),
        child: TextField(
          controller: _controller,
          textInputAction: TextInputAction.search,
          onChanged: (_) => setState(() {}),
          onSubmitted: (_) => _submit(),
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 18),
            prefixIcon: const Icon(Icons.search, size: 34, color: Colors.grey),
            suffixIcon: _controller.text.isEmpty
                ? null
                : IconButton(
                    onPressed: () async {
                      _controller.clear();
                      setState(() {});
                      await widget.onSearch('');
                    },
                    icon: const Icon(Icons.close),
                  ),
          ),
        ),
      ),
    );
  }
}
