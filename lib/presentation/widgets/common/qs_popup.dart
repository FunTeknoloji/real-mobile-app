import 'package:flutter/material.dart';
import 'package:funid/core/theme/app_colors.dart';
import 'package:funid/core/theme/app_text_styles.dart';
import 'package:lucide_icons/lucide_icons.dart';

class QSPopup extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget>? actions;
  final bool isError;
  final bool isSuccess;

  const QSPopup({
    super.key,
    required this.title,
    required this.content,
    this.actions,
    this.isError = false,
    this.isSuccess = false,
  });

  static void show(
    BuildContext context, {
    required String title,
    required Widget content,
    List<Widget>? actions,
    bool isError = false,
    bool isSuccess = false,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QSPopup(
        title: title,
        content: content,
        actions: actions,
        isError: isError,
        isSuccess: isSuccess,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color accentColor = AppColors.primaryPurple;
    IconData? icon;

    if (isError) {
      accentColor = AppColors.dangerRed;
      icon = LucideIcons.xCircle;
    } else if (isSuccess) {
      accentColor = AppColors.accentGreen;
      icon = LucideIcons.checkCircle;
    }

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: accentColor.withOpacity(0.5), width: 1),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.1),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderSubtle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            if (icon != null) ...[
              Icon(icon, color: accentColor, size: 48),
              const SizedBox(height: 16),
            ],
            Text(
              title,
              style: AppTextStyles.h2.copyWith(color: icon != null ? accentColor : AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            content,
            if (actions != null) ...[
              const SizedBox(height: 24),
              Row(
                children: actions!
                    .map((a) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: a,
                          ),
                        ))
                    .toList(),
              ),
            ],
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
