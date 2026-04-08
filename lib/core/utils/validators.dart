class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'E-posta gerekli';
    final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!emailRegex.hasMatch(value)) return 'Geçersiz e-posta formatı';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Şifre gerekli';
    if (value.length < 8) return 'En az 8 karakter olmalı';
    if (!value.contains(RegExp(r'[A-Z]'))) return 'En az bir büyük harf içermeli';
    if (!value.contains(RegExp(r'[0-9]'))) return 'En az bir rakam içermeli';
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.isEmpty) return 'Ad soyad gerekli';
    if (value.length < 2) return 'En az 2 karakter olmalı';
    return null;
  }

  static String? username(String? value) {
    if (value == null || value.isEmpty) return 'Kullanıcı adı gerekli';
    if (value.length < 3) return 'En az 3 karakter olmalı';
    return null;
  }
}
