import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppStyles {
  static const double cardRadius = 24;
  static const double chipRadius = 22;
  static const double imageWidth = 126;

  static const EdgeInsets screenPadding = EdgeInsets.all(16);
  static const EdgeInsets cardPadding = EdgeInsets.fromLTRB(20, 18, 20, 16);
  static const EdgeInsets horizontalPagePadding = EdgeInsets.symmetric(
    horizontal: 16,
  );

  static const BorderRadius cardBorderRadius = BorderRadius.all(
    Radius.circular(cardRadius),
  );

  static const BorderRadius imageBorderRadius = BorderRadius.horizontal(
    left: Radius.circular(cardRadius),
  );

  static const List<BoxShadow> cardShadows = [
    BoxShadow(
      color: AppColors.shadow,
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];
}
