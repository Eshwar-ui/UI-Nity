import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'dart:typed_data';
import '../utils/app_logger.dart';

class AuthService extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  User? get user => Supabase.instance.client.auth.currentUser;

  Future<void> signInWithEmail(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      appLogger.i('Signing in with email: $email');
      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      appLogger.e('AuthException during sign in', error: e);
      throw e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUpWithEmail(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      appLogger.i('Signing up with email: $email');
      await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      appLogger.e('AuthException during sign up', error: e);
      throw e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();
    appLogger.i('Signing out user');
    await Supabase.instance.client.auth.signOut();
    _isLoading = false;
    notifyListeners();
  }

  bool get isAuthenticated => user != null;

  Future<Map<String, dynamic>?> getUserProfile() async {
    final user = this.user;
    if (user == null) return null;
    appLogger.i('Fetching user profile for ${user.email}');
    final response = await Supabase.instance.client
        .from('users')
        .select('name, photo')
        .eq('id', user.id)
        .maybeSingle();
    return response;
  }

  /// Upsert user profile with id, email, name, and photo (as base64 string)
  Future<void> upsertUserProfile({
    required String id,
    required String email,
    required String name,
    required Uint8List? photoBytes,
  }) async {
    String? photoBase64;
    if (photoBytes != null) {
      photoBase64 = base64Encode(photoBytes);
    }
    await Supabase.instance.client.from('users').upsert({
      'id': id,
      'email': email,
      'name': name,
      'photo': photoBase64, // store as base64 string
    });
  }

  Future<String?> sendPasswordResetEmail(String email) async {
    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(email);
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'An error occurred. Please try again.';
    }
  }
}
