import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthRepository _authRepository = AuthRepository.instance;

  // ── Email Sign In ────────────────────────────────────────────────────────────

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      await _authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(AuthSuccess('Signed in successfully! 👋'));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(AuthRepository.getErrorMessage(e)));
    }
  }

  // ── Register ─────────────────────────────────────────────────────────────────

  Future<void> createUserWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final credential = await _authRepository.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(name.trim());
      emit(AuthSuccess('Welcome, ${name.trim()}! 🎉'));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(AuthRepository.getErrorMessage(e)));
    }
  }

  // ── Google Sign In ───────────────────────────────────────────────────────────

  Future<void> signInWithGoogle() async {
    emit(AuthGoogleLoading());
    try {
      final credential = await _authRepository.signInWithGoogle();

      // User cancelled the Google picker
      if (credential == null) {
        emit(AuthInitial());
        return;
      }

      emit(
        AuthSuccess('Welcome, ${credential.user?.displayName ?? 'User'}! 🎉'),
      );
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(AuthRepository.getErrorMessage(e)));
    } catch (_) {
      emit(AuthFailure('Google sign-in failed. Please try again.'));
    }
  }

  // ── Forgot Password ───────────────────────────────────────────────────────────

  Future<void> sendPasswordResetEmail({required String email}) async {
    emit(AuthLoading());
    try {
      await _authRepository.sendPasswordResetEmail(email: email);
      emit(AuthSuccess('Reset email sent! Check your inbox.'));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(AuthRepository.getErrorMessage(e)));
    }
  }

  // ── Sign Out ──────────────────────────────────────────────────────────────────

  Future<void> signOut() async {
    await _authRepository.signOut();
    emit(AuthInitial());
  }

  // ── Reset state ───────────────────────────────────────────────────────────────

  void reset() => emit(AuthInitial());
}
