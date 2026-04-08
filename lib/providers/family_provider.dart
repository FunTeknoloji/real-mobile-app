import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FamilyProvider extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;
  List<dynamic> _members = [];
  bool _isLoading = false;

  List<dynamic> get members => _members;
  bool get isLoading => _isLoading;

  Future<void> fetchFamilyMembers() async {
    _isLoading = true;
    notifyListeners();
    try {
      // Logic depends on schema, assuming family_members table exists and has a user_id or group_id
      // Since it's empty, we might need to mock or just show empty state
      final userId = _client.auth.currentUser?.id;
      if (userId != null) {
         final response = await _client.from('family_members').select('*, profiles(*)').eq('user_id', userId);
         _members = response;
      }
    } catch (e) {
      print('Family fetch error: $e');
    }
    _isLoading = false;
    notifyListeners();
  }
}
