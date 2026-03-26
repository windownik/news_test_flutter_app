import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

const List<_NewsCategory> _newsCategories = [
  _NewsCategory(value: 'business'),
  _NewsCategory(value: 'entertainment'),
  _NewsCategory(value: 'general'),
  _NewsCategory(value: 'health'),
  _NewsCategory(value: 'science'),
  _NewsCategory(value: 'sports'),
  _NewsCategory(value: 'technology'),
];

class CategoryBar extends StatelessWidget {
  const CategoryBar({
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final String selectedCategory;
  final Future<void> Function(String category) onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      height: 76,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        scrollDirection: Axis.horizontal,
        itemCount: _newsCategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = _newsCategories[index];
          final isSelected = category.value == selectedCategory;
          return _CategoryButton(
            label: _categoryLabel(l10n, category.value),
            isSelected: isSelected,
            onPressed: () => onCategorySelected(category.value),
          );
        },
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  const _CategoryButton({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected
        ? Color.fromRGBO(47, 120, 255, 1)
        : Color.fromRGBO(193, 193, 193, 1);
    return GestureDetector(
      onTap: onPressed,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 132),
        child: SizedBox(
          height: 44,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NewsCategory {
  const _NewsCategory({required this.value});

  final String value;
}

String _categoryLabel(AppLocalizations l10n, String category) {
  return switch (category) {
    'business' => l10n.categoryBusiness,
    'entertainment' => l10n.categoryEntertainment,
    'general' => l10n.categoryGeneral,
    'health' => l10n.categoryHealth,
    'science' => l10n.categoryScience,
    'sports' => l10n.categorySports,
    'technology' => l10n.categoryTechnology,
    _ => category,
  };
}
