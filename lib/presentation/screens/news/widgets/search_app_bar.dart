import 'package:flutter/material.dart';
import 'package:news_flutter_app/common/app_icons.dart';
import 'package:news_flutter_app/presentation/screens/news/widgets/svg_button.dart';

class SearchAppBar extends StatefulWidget {
  const SearchAppBar({
    super.key,
    required this.initialQuery,
    required this.onSearch,
  });

  final String initialQuery;
  final ValueChanged<String> onSearch;

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
    _focusNode = FocusNode();
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
    _focusNode.dispose();
    super.dispose();
  }

  void _onSubmit() {
    final searchResult = _controller.text.trim();
    return widget.onSearch.call(searchResult);
  }

  void _onClear() async {
    _controller.clear();
    setState(() {});
    widget.onSearch.call('');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(color: Colors.white),
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          textInputAction: TextInputAction.search,
          onChanged: (_) => setState(() {}),
          onSubmitted: (_) => _onSubmit(),
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 18),
            prefixIcon: SvgButton(
              asset: IconsAssets.search,
              onTap: () => _focusNode.requestFocus(),
            ),
            suffixIcon: _controller.text.isEmpty
                ? null
                : IconButton(
                    onPressed: _onClear,
                    icon: const Icon(Icons.close),
                  ),
          ),
        ),
      ),
    );
  }
}
