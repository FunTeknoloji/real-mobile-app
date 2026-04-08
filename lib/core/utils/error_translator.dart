class ErrorTranslator {
  static String translate(String error) {
    final lowerError = error.toLowerCase();

    if (lowerError.contains('invalid login credentials')) {
      return 'E-posta veya şifre hatalı.';
    }
    if (lowerError.contains('user already exists')) {
      return 'Bu e-posta adresi ile zaten bir kullanıcı mevcut.';
    }
    if (lowerError.contains('email not confirmed')) {
      return 'Lütfen e-posta adresinizi doğrulayın.';
    }
    if (lowerError.contains('network error')) {
      return 'Ağ bağlantısı hatası. Lütfen internetinizi kontrol edin.';
    }
    if (lowerError.contains('too many requests')) {
      return 'Çok fazla deneme yaptınız. Lütfen daha sonra tekrar deneyin.';
    }
    if (lowerError.contains('password is too short')) {
      return 'Şifre çok kısa.';
    }

    return 'Bir hata oluştu: $error';
  }
}
