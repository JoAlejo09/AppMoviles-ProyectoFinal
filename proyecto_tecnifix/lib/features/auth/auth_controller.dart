import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'data/auth_repository.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository _repository;

  AuthController(this._repository);

  // =========================
  // GETTERS DE ESTADO
  // =========================

  bool get isLoggedIn => _repository.isLoggedIn;

  bool get isEmailConfirmed => _repository.isEmailConfirmed;

  // 🔑 EXPONER USUARIO ACTUAL
  User? get currentUser => _repository.currentUser;

  // =========================
  // LOGIN
  // =========================
  Future<void> login(String email, String password) async {
    await _repository.signIn(email: email, password: password);
    notifyListeners();
  }

  // =========================
  // REGISTRO
  // =========================
  Future<void> register(String email, String password) async {
    await _repository.signUp(email: email, password: password);
  }

  // =========================
  // LOGIN GOOGLE
  // =========================
  Future<void> loginWithGoogle() async {
    await _repository.signInWithGoogle();
    notifyListeners();
  }

  // =========================
  // REENVIAR EMAIL
  // =========================
  Future<void> resendEmail(String email) async {
    await _repository.resendConfirmationEmail(email);
  }

  // =========================
  // STREAM AUTH
  // =========================
  Stream get authChanges => _repository.authStateChanges;
}
