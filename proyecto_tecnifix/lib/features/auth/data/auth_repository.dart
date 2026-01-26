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
    await _client.auth.signUp(email: email, password: password);
  }

  //Login con Google
  Future<void> signInWithGoogle() async {
    await _client.auth.signInWithOAuth(OAuthProvider.google);
  }

  //Mensaje de confirmación
  Future<void> resendConfirmationEmail(String email) async {
    await _client.auth.resend(type: OtpType.signup, email: email);
  }

  //Obtener Usuario
  User? get currentUser {
    // Devuelve el usuario actual autenticado (o null)
    return _client.auth.currentUser;
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

  //Cambio de estado de sesion
  Stream<AuthState> get authStateChanges {
    return _client.auth.onAuthStateChange;
  }
}
