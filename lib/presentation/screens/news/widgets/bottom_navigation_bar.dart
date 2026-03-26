import 'package:flutter/material.dart';
import 'package:news_flutter_app/common/app_styles.dart';
import 'package:news_flutter_app/presentation/screens/news/widgets/svg_button.dart';

import '../../../../common/app_colors.dart';
import '../../../../common/app_icons.dart';
import '../news_state.dart';

class BottomNavBar extends StatelessWidget {
  final NewsState activeState;
  final ValueChanged<NewsState> updateStateCallback;
  const BottomNavBar({
    super.key,
    required this.activeState,
    required this.updateStateCallback,
  });

  void _updateNewsState(NewsState newState) {
    updateStateCallback.call(newState);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      margin: EdgeInsets.symmetric(horizontal: 19),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: AppStyles.cardShadows,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color.fromRGBO(206, 206, 206, 1), width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        children: [
          SvgButton(
            asset: IconsAssets.allNews,
            padding: const EdgeInsets.only(bottom: 6.0),
            colorFilter: ColorFilter.mode(
              activeState is AllNewsState ? AppColors.blue : AppColors.grey,
              BlendMode.srcIn,
            ),
            onTap: () => _updateNewsState(AllNewsState()),
          ),
          SvgButton(
            asset: activeState is FavoriteNewsState
                ? IconsAssets.allFavoritesActive
                : IconsAssets.allFavorites,
            onTap: () => _updateNewsState(FavoriteNewsState()),
          ),
        ],
      ),
    );
  }
}
