import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgButton extends StatelessWidget {
  final double? iconWidth;
  final double? iconHeight;
  final double? btnWidth;
  final double? btnHeight;
  final String asset;
  final GestureTapCallback? onTap;
  final ColorFilter? colorFilter;
  final EdgeInsets? padding;

  const SvgButton({
    super.key,
    this.iconWidth,
    this.iconHeight,
    this.btnWidth = 43,
    this.btnHeight = 41,
    this.onTap,
    required this.asset,
    this.colorFilter,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = DecoratedBox(
      decoration: BoxDecoration(color: Colors.transparent),
      child: Center(
        child: SvgPicture.asset(
          asset,
          colorFilter: colorFilter,
          width: iconWidth,
          height: iconHeight,
        ),
      ),
    );
    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(width: btnWidth, height: btnHeight, child: content),
    );
  }
}
