import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:funid/core/theme/app_colors.dart';
import 'package:funid/core/theme/app_text_styles.dart';
import 'package:funid/providers/auth_provider.dart';
import 'package:funid/presentation/widgets/common/qs_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 6) return 'İyi Geceler';
    if (hour < 12) return 'Günaydın';
    if (hour < 18) return 'İyi Günler';
    if (hour < 22) return 'İyi Akşamlar';
    return 'İyi Geceler';
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: const Border(top: BorderSide(color: AppColors.borderSubtle, width: 1)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryPurple.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            )
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: AppColors.backgroundSurface,
          selectedItemColor: AppColors.accentGreen,
          unselectedItemColor: AppColors.textMuted,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: AppTextStyles.caption.copyWith(color: AppColors.accentGreen, fontWeight: FontWeight.bold),
          unselectedLabelStyle: AppTextStyles.caption,
          items: const [
            BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: 'Ana Sayfa', activeIcon: _ActiveIcon(LucideIcons.home)),
            BottomNavigationBarItem(icon: Icon(LucideIcons.shield), label: 'Güvenlik', activeIcon: _ActiveIcon(LucideIcons.shield)),
            BottomNavigationBarItem(icon: Icon(LucideIcons.users), label: 'Aile', activeIcon: _ActiveIcon(LucideIcons.users)),
            BottomNavigationBarItem(icon: Icon(LucideIcons.user), label: 'Profil', activeIcon: _ActiveIcon(LucideIcons.user)),
          ],
          onTap: (index) {
            setState(() => _currentIndex = index);
            if (index == 3) context.push('/profile');
          },
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_getGreeting()},',
                        style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                      ),
                      Text(
                        user?.fullName ?? 'Kullanıcı',
                        style: AppTextStyles.h2,
                      ),
                    ],
                  ),
                  Hero(
                    tag: 'profile_avatar',
                    child: CircleAvatar(
                      backgroundColor: AppColors.primaryPurple,
                      radius: 24,
                      child: Text(
                        user?.fullName.isNotEmpty == true ? user!.fullName.substring(0, 1).toUpperCase() : 'U',
                        style: AppTextStyles.h3.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn().slideX(),
              const SizedBox(height: 32),
              const _StatusOverview(),
              const SizedBox(height: 24),
              Text('Hızlı Erişim', style: AppTextStyles.h3),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  _QuickActionCard(
                    title: 'Kişisel Bilgiler',
                    icon: LucideIcons.user,
                    color: AppColors.primaryPurple,
                    onTap: () {},
                  ),
                  _QuickActionCard(
                    title: 'Güvenlik',
                    icon: LucideIcons.shieldCheck,
                    color: AppColors.accentGreen,
                    onTap: () {},
                  ),
                  _QuickActionCard(
                    title: 'Aktif Oturumlar',
                    icon: LucideIcons.monitor,
                    color: AppColors.warningAmber,
                    onTap: () {},
                  ),
                  _QuickActionCard(
                    title: 'Aile Grubu',
                    icon: LucideIcons.users,
                    color: Colors.blue,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Son Güvenlik Kayıtları', style: AppTextStyles.h3),
              const SizedBox(height: 16),
              const _SecurityLogPreview(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActiveIcon extends StatelessWidget {
  final IconData icon;
  const _ActiveIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 2,
          decoration: BoxDecoration(
            color: AppColors.accentGreen,
            borderRadius: BorderRadius.circular(1),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentGreen.withOpacity(0.5),
                blurRadius: 4,
              )
            ],
          ),
        ),
        const SizedBox(height: 4),
        Icon(icon, color: AppColors.accentGreen),
      ],
    );
  }
}

class _StatusOverview extends StatelessWidget {
  const _StatusOverview();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: QSCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(LucideIcons.shieldCheck, color: AppColors.accentGreen),
                const SizedBox(height: 12),
                Text('Güvenlik Durumu', style: AppTextStyles.caption),
                Text('Güvendesiniz', style: AppTextStyles.h3.copyWith(fontSize: 15, color: AppColors.accentGreen)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: QSCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(LucideIcons.activity, color: AppColors.warningAmber),
                const SizedBox(height: 12),
                Text('Aktif Oturumlar', style: AppTextStyles.caption),
                Text('2 Cihaz Etkin', style: AppTextStyles.h3.copyWith(fontSize: 15)),
              ],
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1);
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: QSCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecurityLogPreview extends StatelessWidget {
  const _SecurityLogPreview();

  @override
  Widget build(BuildContext context) {
    return QSCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(LucideIcons.logIn, color: AppColors.accentGreen),
            title: Text('Başarılı Giriş', style: AppTextStyles.body.copyWith(color: AppColors.textPrimary)),
            subtitle: Text('iPhone 15 Pro • İstanbul', style: AppTextStyles.caption),
            trailing: Text('10 dk önce', style: AppTextStyles.caption),
          ),
          Divider(color: AppColors.borderSubtle, height: 1),
          ListTile(
            leading: const Icon(LucideIcons.shieldAlert, color: AppColors.warningAmber),
            title: Text('Yeni Cihaz Onayı', style: AppTextStyles.body.copyWith(color: AppColors.textPrimary)),
            subtitle: Text('MacBook Pro • Ankara', style: AppTextStyles.caption),
            trailing: Text('Dün', style: AppTextStyles.caption),
          ),
        ],
      ),
    );
  }
}
