import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:funid/core/theme/app_colors.dart';
import 'package:funid/core/theme/app_text_styles.dart';
import 'package:funid/providers/auth_provider.dart';
import 'package:funid/presentation/widgets/common/qs_popup.dart';
import 'package:funid/presentation/widgets/common/qs_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showLogoutConfirm(BuildContext context) {
    QSPopup.show(
      context,
      title: 'Çıkış Yap',
      content: const Text(
        'Hesabınızdan çıkış yapmak istediğinize emin misiniz?',
        textAlign: TextAlign.center,
        style: TextStyle(color: AppColors.textSecondary),
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColors.borderSubtle),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text('İptal', style: AppTextStyles.body.copyWith(color: AppColors.textPrimary)),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<AuthProvider>().logout();
            context.go('/login');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.dangerRed,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text('Çıkış Yap', style: AppTextStyles.button),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.backgroundSurface, AppColors.backgroundDeep],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primaryPurple,
                child: Text(
                  user != null && user.fullName.isNotEmpty ? user.fullName.substring(0, 1).toUpperCase() : 'U',
                  style: AppTextStyles.h1.copyWith(fontSize: 40, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              Text(user?.fullName ?? '', style: AppTextStyles.h2),
              Text(user?.email ?? '', style: AppTextStyles.body),
              const SizedBox(height: 32),
              _buildSettingSection('Hesap', [
                _buildSettingTile(LucideIcons.user, 'Kişisel Bilgiler', () => _showNotImplemented(context)),
                _buildSettingTile(LucideIcons.shield, 'Güvenlik', () => _showNotImplemented(context)),
                _buildSettingTile(LucideIcons.users, 'Aile Grubu', () => _showNotImplemented(context)),
              ]),
              const SizedBox(height: 24),
              _buildSettingSection('Uygulama', [
                _buildSettingTile(LucideIcons.bell, 'Bildirimler', () => _showNotImplemented(context)),
                _buildSettingTile(LucideIcons.creditCard, 'Ödemeler', () => _showNotImplemented(context)),
                _buildSettingTile(LucideIcons.settings, 'Ayarlar', () => _showNotImplemented(context)),
                _buildSettingTile(LucideIcons.logOut, 'Çıkış Yap', () => _showLogoutConfirm(context), color: AppColors.dangerRed),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotImplemented(BuildContext context) {
    QSPopup.show(
      context,
      title: 'Yakında',
      content: const Text(
        'bu özellik bir sonraki güncelleme ile aktif olacaktır.',
        textAlign: TextAlign.center,
        style: TextStyle(color: AppColors.textSecondary),
      ),
      actions: [
        QSButton(label: 'Anladım', onPressed: () => Navigator.pop(context)),
      ],
    );
  }

  Widget _buildSettingSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(title, style: AppTextStyles.caption.copyWith(color: AppColors.accentPurpleLight, fontWeight: FontWeight.bold)),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundCard.withOpacity(0.4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingTile(IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.primaryPurple, size: 22),
      title: Text(title, style: AppTextStyles.body.copyWith(color: AppColors.textPrimary)),
      trailing: Icon(LucideIcons.chevronRight, size: 18, color: AppColors.textMuted),
      onTap: onTap,
    );
  }
}
