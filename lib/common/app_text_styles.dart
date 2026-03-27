import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTextStyles {
  static const TextStyle titleLarge = TextStyle(
    fontFamily: 'Satoshi',
    fontSize: 33,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
    height: 1.1,
  );

  static const TextStyle titleInCard = TextStyle(
    fontFamily: 'Satoshi',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
    height: 1.1,
  );

  static const TextStyle subtitleTextInCard = TextStyle(
    fontFamily: 'Satoshi',
    fontSize: 27,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
    height: 1.1,
  );

  static const TextStyle textInCard = TextStyle(
    fontFamily: 'Satoshi',
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
    height: 1.1,
  );

  static const TextStyle dateTimeBig = TextStyle(
    fontFamily: 'Satoshi',
    fontSize: 19,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
    height: 1.1,
  );

  static const TextStyle dateTimeSmall = TextStyle(
    fontFamily: 'Satoshi',
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
    height: 1.1,
  );

  static const TextStyle buttonWhite = TextStyle(
    fontFamily: 'Satoshi',
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
    height: 1.1,
  );
}
