import 'package:flutter/material.dart';

import '../../../../common/app_text_styles.dart';

class DateTextWidget extends StatelessWidget {
  final DateTime? dateTime;
  final TextStyle? style;
  const DateTextWidget({super.key, this.style, required this.dateTime});

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatDate(dateTime),
      style: style ?? AppTextStyles.dateTimeSmall,
    );
  }
}

String _formatDate(DateTime? date) {
  if (date == null) return '--.--.----';

  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  final year = date.year.toString().padLeft(4, '0');
  return '$month.$day.$year';
}
