import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:funid/core/constants/app_strings.dart';
import 'package:funid/core/theme/app_colors.dart';
import 'package:funid/core/theme/app_text_styles.dart';
import 'package:funid/core/utils/validators.dart';
import 'package:funid/providers/auth_provider.dart';
import 'package:funid/presentation/widgets/common/qs_button.dart';
import 'package:funid/presentation/widgets/common/qs_text_field.dart';
import 'package:funid/presentation/widgets/common/qs_toast.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordAgainController = TextEditingController();
  bool _obscurePassword = true;
  double _passwordStrength = 0;
  String _strengthText = '';
  Color _strengthColor = Colors.grey;

  void _checkPasswordStrength(String value) {
    double strength = 0;
    if (value.length >= 8) strength += 0.25;
    if (value.contains(RegExp(r'[A-Z]'))) strength += 0.25;
    if (value.contains(RegExp(r'[0-9]'))) strength += 0.25;
    if (value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.25;

    setState(() {
      _passwordStrength = strength;
      if (strength <= 0.25) {
        _strengthText = 'Zayıf';
        _strengthColor = AppColors.dangerRed;
      } else if (strength <= 0.5) {
        _strengthText = 'Orta';
        _strengthColor = AppColors.warningAmber;
      } else if (strength <= 0.75) {
        _strengthText = 'Güçlü';
        _strengthColor = Colors.green;
      } else {
        _strengthText = 'Çok Güçlü';
        _strengthColor = AppColors.accentGreen;
      }
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryPurple,
              onPrimary: Colors.white,
              surface: AppColors.backgroundCard,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _birthDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      extendBodyBehindAppBar: true,
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
                child: Image.asset('assets/images/logo.png', width: 60),
              ),
              const SizedBox(height: 16),
              Text(AppStrings.createAccount, style: AppTextStyles.h2),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    QSTextField(
                      label: AppStrings.fullName,
                      prefixIcon: LucideIcons.user,
                      controller: _nameController,
                      validator: Validators.name,
                    ),
                    const SizedBox(height: 16),
                    QSTextField(
                      label: AppStrings.username,
                      prefixIcon: LucideIcons.atSign,
                      controller: _usernameController,
                      validator: Validators.username,
                    ),
                    const SizedBox(height: 16),
                    QSTextField(
                      label: AppStrings.email,
                      prefixIcon: LucideIcons.mail,
                      controller: _emailController,
                      validator: Validators.email,
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _selectDate,
                      child: AbsorbPointer(
                        child: QSTextField(
                          label: AppStrings.birthDate,
                          prefixIcon: LucideIcons.calendar,
                          controller: _birthDateController,
                          validator: (v) => v == null || v.isEmpty ? 'Doğum tarihi gerekli' : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    QSTextField(
                      label: AppStrings.password,
                      prefixIcon: LucideIcons.lock,
                      isPassword: _obscurePassword,
                      controller: _passwordController,
                      validator: Validators.password,
                      onChanged: _checkPasswordStrength,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? LucideIcons.eye : LucideIcons.eyeOff,
                          color: AppColors.textMuted,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Strength Indicator
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: _passwordStrength,
                              backgroundColor: AppColors.borderSubtle,
                              color: _strengthColor,
                              minHeight: 4,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(_strengthText, style: AppTextStyles.caption.copyWith(color: _strengthColor)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    QSTextField(
                      label: AppStrings.passwordAgain,
                      prefixIcon: LucideIcons.checkCircle,
                      isPassword: _obscurePassword,
                      controller: _passwordAgainController,
                      validator: (value) {
                        if (value != _passwordController.text) return 'Şifreler uyuşmuyor';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    QSButton(
                      label: AppStrings.register,
                      isLoading: authProvider.isLoading,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final success = await authProvider.register(
                            email: _emailController.text,
                            password: _passwordController.text,
                            fullName: _nameController.text,
                            username: _usernameController.text,
                            birthDate: _birthDateController.text,
                          );
                          if (success && mounted) {
                            QSToast.show(context, 'Hesabınız başarıyla oluşturuldu', isSuccess: true);
                            context.go('/home');
                          } else if (mounted) {
                            QSToast.show(
                              context,
                              authProvider.lastError ?? 'Kayıt sırasında bir hata oluştu',
                              isError: true,
                            );
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => context.pop(),
                      child: Text(AppStrings.alreadyHaveAccount, style: AppTextStyles.body),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
