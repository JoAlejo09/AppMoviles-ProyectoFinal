import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/auth_repository.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository _repository;
  AuthController(this._repository);

  //PARAMETROS BASE
  bool _isLoading = false;
  String? _error;

  // GETTERS DE ESTADO
  bool get isLoading => _isLoading;
  String? get error => _error;
  //VARIABLES PARA MENSAJE
  String? _oneTimeMessage;
  String? get oneTimeMessage => _oneTimeMessage;

  bool get isLoggedIn => _repository.isLoggedIn;
  bool get isEmailConfirmed => _repository.isEmailConfirmed;
  Object? get currentUser => _repository.currentUser; // Para el usuario actual
  String? get userEmail => _repository.currentUserEmail;
  String? get userId => _repository.currentUserId;

  //Metodos de cambio y notificacion de la app
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _error = message;
    notifyListeners();
  }

  void _setOneTimeMessage(String message) {
    _oneTimeMessage = message;
    notifyListeners();
  }

  void clearOneTimeMessage() {
    _oneTimeMessage = null;
  }

  // LOGIN
  Future<void> login(String email, String password) async {
    try {
      _setLoading(true);
      _setError(null);
      await _repository.signIn(email: email, password: password);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // REGISTRO
  Future<void> register(String email, String password) async {
    try {
      _setLoading(true);
      _setError(null);
      await _repository.signUp(email: email, password: password);
      _setOneTimeMessage(
        'Usuario creado. Acceda a su correo para activar la cuenta.',
      );
    } catch (e) {
      final mensaje = e.toString();
      if (mensaje.contains('alredy registered') || mensaje.contains('email')) {
        _setError('Este correo ya se encuentra registrado. Inicie sesión.');
      } else {
        _setError(e.toString());
      }
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // LOGIN GOOGLE
  Future<void> loginWithGoogle() async {
    try {
      _setLoading(true);
      _setError(null);
      await _repository.signInWithGoogle();
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // REENVIAR EMAIL
  Future<void> resendEmail(String email) async {
    await _repository.resendConfirmationEmail(email);
  }

  //RECUPERAR CONTRASEÑA
  Future<void> recoverPassword(String email) async {
    if (email.isEmpty) {
      throw Exception('El correo electronico es obligatorio');
    }
    await _repository.sendPasswordRecoverybyEmail(email);
  }

  //ACTUALIZAR CONTRASEÑA
  Future<void> updatePassword(String contrasena) async {
    if (contrasena.length < 6) {
      throw Exception('La contraseña debe tener al menos 6 caracteres');
    }
    await _repository.updatePassword(contrasena);
  }

  //CERRAR SESION
  Future<void> logout() async {
    await _repository.logout();
    notifyListeners();
  }

  // STREAM AUTH
  Stream get authChanges => _repository.authStateChanges;
}
