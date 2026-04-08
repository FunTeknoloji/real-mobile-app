import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:funid/core/theme/app_colors.dart';
import 'package:funid/core/theme/app_text_styles.dart';

class QSToast {
  static void show(BuildContext context, String message, {bool isError = false, bool isSuccess = false}) {
    Color accentColor = AppColors.primaryPurple;
    IconData icon = LucideIcons.info;

    if (isError) {
      accentColor = AppColors.dangerRed;
      icon = LucideIcons.xCircle;
    } else if (isSuccess) {
      accentColor = AppColors.accentGreen;
      icon = LucideIcons.checkCircle;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.backgroundCard.withOpacity(0.95),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: accentColor.withOpacity(0.5), width: 1),
            boxShadow: [
              BoxShadow(
                color: accentColor.withOpacity(0.2),
                blurRadius: 10,
              )
            ],
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: accentColor,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.body.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
