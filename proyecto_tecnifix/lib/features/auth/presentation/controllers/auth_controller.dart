import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/auth_repository.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository _repository;

  bool isLoading = true;
  String? error;
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;
  bool get isEmailVerified => _repository.currentUser?.emailConfirmedAt != null;

  AuthController(this._repository) {
    _init();
  }

  void _init() {
    // Estado inicial
    _isAuthenticated = _repository.currentUser != null;
    isLoading = false;

    // 🔥 Listener GLOBAL de Supabase Auth
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final session = data.session;

      _isAuthenticated = session != null;
      notifyListeners();
    });
  }

  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      await _repository.login(email: email, password: password);
    } catch (e) {
      error = e.toString();
    }
    _setLoading(false);
  }

  /// OAuth → NO loading / NO notify aquí
  Future<void> signInWithGoogle() async {
    await _repository.signInWithGoogle();
  }

  Future<void> register(String email, String password) async {
    _setLoading(true);
    try {
      await _repository.register(email: email, password: password);
    } catch (e) {
      error = e.toString();
    }
    _setLoading(false);
  }

  Future<void> resetPassword(String email) async {
    _setLoading(true);
    try {
      await _repository.resetPassword(email);
    } catch (e) {
      error = e.toString();
    }
    _setLoading(false);
  }

  Future<void> resendVerificationEmail() async {
    try {
      final email = _repository.currentUser?.email;
      if (email != null) {
        await _repository.resendVerificationEmail(email);
      }
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    // El listener detecta session = null
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
