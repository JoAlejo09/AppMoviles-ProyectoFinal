//Comunicación con Supabase
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _client;

  AuthRepository(this._client);

  //Funcion para Login

  Future<void> signIn({required String email, required String password}) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  //Registro de Usuario
  Future<void> signUp({required String email, required String password}) async {
    await _client.auth.signUp(
      email: email,
      password: password,
      emailRedirectTo: 'https://tecnifix-62a19.web.app/login-callback',
    );
  }

  //Login con Google
  Future<void> signInWithGoogle() async {
    await _client.auth.signInWithOAuth(OAuthProvider.google);
  }

  //Mensaje de confirmación
  Future<void> resendConfirmationEmail(String email) async {
    await _client.auth.resend(
      type: OtpType.signup,
      email: email,
      emailRedirectTo: 'https://tecnifix-62a19.web.app/login-callback.html',
    );
  }

  //Obtener Usuario
  User? get currentUser {
    // Devuelve el usuario actual autenticado (o null)
    return _client.auth.currentUser;
  }

  String? get currentUserEmail {
    return _client.auth.currentUser?.email;
  }

  String? get currentUserId {
    return _client.auth.currentUser?.id;
  }

  /*VALIDACIONES DE SESION */
  //Sesion Activa
  bool get isLoggedIn {
    return currentUser != null;
  }

  //Email Confirmado
  bool get isEmailConfirmed {
    return currentUser?.emailConfirmedAt != null;
  }

  //Recuperar Contraseña
  Future<void> sendPasswordRecoverybyEmail(String email) async {
    await _client.auth.resetPasswordForEmail(
      email,
      redirectTo: 'https://tecnifix-62a19.web.app/reset-callback',
    );
  }

  //Actualizar la contraseña
  Future<void> updatePassword(String contrasena) async {
    await _client.auth.updateUser(UserAttributes(password: contrasena));
  }

  //CerrarSesion
  Future<void> logout() async {
    await _client.auth.signOut();
  }

  //Cambio de estado de sesion
  Stream<AuthState> get authStateChanges {
    return _client.auth.onAuthStateChange;
  }
}
