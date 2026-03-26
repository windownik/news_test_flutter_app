import 'package:flutter/material.dart';
import 'package:news_flutter_app/common/app_text_styles.dart';

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
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final String selectedCategory;
  final Future<void> Function(String category) onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      height: 54,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
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
      child: Container(
        width: 114,
        height: 44,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(22),
        ),
        alignment: Alignment.center,
        child: Text(label, style: AppTextStyles.buttonWhite),
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
