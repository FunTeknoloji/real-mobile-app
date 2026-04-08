import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:funid/data/models/user_model.dart';
import 'package:funid/core/utils/error_translator.dart';

class AuthProvider extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;
  UserModel? _user;
  bool _isLoading = false;
  String? _lastError;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get lastError => _lastError;
  bool get isAuthenticated => _client.auth.currentSession != null;

  AuthProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final session = _client.auth.currentSession;
    if (session != null) {
      await fetchUserProfile(session.user.id);
    }
  }

  Future<void> fetchUserProfile(String userId) async {
    try {
      final data = await _client.from('profiles').select().eq('id', userId).single();
      _user = UserModel.fromJson(data);
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching profile: $e');
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _lastError = null;
    notifyListeners();
    try {
      final response = await _client.auth.signInWithPassword(email: email, password: password);
      if (response.user != null) {
        await fetchUserProfile(response.user!.id);
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } on AuthException catch (e) {
      _lastError = ErrorTranslator.translate(e.message);
    } catch (e) {
      _lastError = ErrorTranslator.translate(e.toString());
    }
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
    required String username,
    required String birthDate,
  }) async {
    _isLoading = true;
    _lastError = null;
    notifyListeners();
    try {
      final response = await _client.auth.signUp(email: email, password: password);
      if (response.user != null) {
        await _client.from('profiles').insert({
          'id': response.user!.id,
          'email': email,
          'full_name': fullName,
          'username': username,
          'birth_date': birthDate,
          'role': 'user',
          'status': 'active',
          'plan': 'free',
        });
        await fetchUserProfile(response.user!.id);
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } on AuthException catch (e) {
      _lastError = ErrorTranslator.translate(e.message);
    } catch (e) {
      _lastError = ErrorTranslator.translate(e.toString());
    }
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    await _client.auth.signOut();
    _user = null;
    notifyListeners();
  }
}
