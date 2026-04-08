import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:funid/core/constants/app_strings.dart';
import 'package:funid/core/theme/app_colors.dart';
import 'package:funid/core/theme/app_text_styles.dart';
import 'package:funid/core/utils/validators.dart';
import 'package:funid/providers/auth_provider.dart';
import 'package:funid/presentation/widgets/common/qs_button.dart';
import 'package:funid/presentation/widgets/common/qs_text_field.dart';
import 'package:funid/presentation/widgets/common/qs_toast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF100030), Color(0xFF0A0A0F)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 100),
              Hero(
                tag: 'logo',
                child: Image.asset('assets/images/logo.png', width: 80),
              ),
              const SizedBox(height: 16),
              Text('FunID', style: AppTextStyles.h1.copyWith(fontSize: 40)),
              Text(AppStrings.welcomeBack, style: AppTextStyles.body),
              const SizedBox(height: 48),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    QSTextField(
                      label: AppStrings.email,
                      prefixIcon: LucideIcons.mail,
                      controller: _emailController,
                      validator: Validators.email,
                      keyboardType: TextInputType.emailAddress,
                    ).animate().slideY(begin: 0.2, duration: 400.ms).fadeIn(),
                    const SizedBox(height: 16),
                    QSTextField(
                      label: AppStrings.password,
                      prefixIcon: LucideIcons.lock,
                      isPassword: _obscurePassword,
                      controller: _passwordController,
                      validator: Validators.password,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? LucideIcons.eye : LucideIcons.eyeOff,
                          color: AppColors.textMuted,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ).animate().slideY(begin: 0.2, delay: 100.ms, duration: 400.ms).fadeIn(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          AppStrings.forgotPassword,
                          style: AppTextStyles.body.copyWith(color: AppColors.accentGreen),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    QSButton(
                      label: AppStrings.login,
                      isLoading: authProvider.isLoading,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final success = await authProvider.login(
                            _emailController.text,
                            _passwordController.text,
                          );
                          if (success && mounted) {
                            QSToast.show(context, 'Başarıyla giriş yapıldı', isSuccess: true);
                            context.go('/home');
                          } else if (mounted) {
                            QSToast.show(
                              context,
                              authProvider.lastError ?? 'Giriş başarısız. Lütfen bilgilerinizi kontrol edin.',
                              isError: true,
                            );
                          }
                        }
                      },
                    ).animate().slideY(begin: 0.2, delay: 200.ms, duration: 400.ms).fadeIn(),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppStrings.dontHaveAccount, style: AppTextStyles.body),
                  TextButton(
                    onPressed: () => context.push('/register'),
                    child: Text(
                      'Kayıt Ol',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.primaryPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
