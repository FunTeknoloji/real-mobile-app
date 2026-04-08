import 'package:flutter/material.dart';
import 'package:funid/core/theme/app_colors.dart';

class QSCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Border? border;

  const QSCard({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: border ?? Border.all(color: AppColors.borderSubtle.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: child,
    );
  }
}
