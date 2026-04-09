import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/auth_repository.dart';
import '../../data/models/user_model.dart';
import '../../../../core/services/firestore_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthRepository _authRepository = AuthRepository.instance;
  final FirestoreService _firestoreService = FirestoreService.instance;

  // ── Email Sign In ─────────────────────────────────────────────────────────────

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final credential =
          await _authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch user profile from Firestore after sign in
      await getCurrentUser(credential.user!.uid);

      emit(AuthSuccess('Signed in successfully! 👋'));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(AuthRepository.getErrorMessage(e)));
    }
  }

  // ── Register ──────────────────────────────────────────────────────────────────

  Future<void> createUserWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      // AuthRepository handles both Firebase Auth + Firestore save
      final credential =
          await _authRepository.createUserWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
      );

      // Fetch the saved user back from Firestore
      await getCurrentUser(credential.user!.uid);

      emit(AuthSuccess('Welcome, ${name.trim()}! 🎉'));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(AuthRepository.getErrorMessage(e)));
    } catch (e) {
      emit(AuthFailure('Something went wrong. Please try again.'));
    }
  }

  // ── Google Sign In ────────────────────────────────────────────────────────────

  Future<void> signInWithGoogle() async {
    emit(AuthGoogleLoading());
    try {
      final credential = await _authRepository.signInWithGoogle();

      // User cancelled the Google picker
      if (credential == null) {
        emit(AuthInitial());
        return;
      }

      // Fetch user profile from Firestore
      await getCurrentUser(credential.user!.uid);

      emit(AuthSuccess(
        'Welcome, ${credential.user?.displayName ?? 'User'}! 🎉',
      ));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(AuthRepository.getErrorMessage(e)));
    } catch (_) {
      emit(AuthFailure('Google sign-in failed. Please try again.'));
    }
  }

  // ── Get User from Firestore ───────────────────────────────────────────────────

  Future<void> getCurrentUser(String uid) async {
    emit(AuthLoading());
    try {
      final user = await _firestoreService.getUser(uid);

      if (user == null) {
        emit(AuthFailure('User profile not found.'));
        return;
      }

      emit(AuthUserLoaded(user));
    } catch (_) {
      emit(AuthFailure('Failed to load user profile.'));
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

  // ── Reset ─────────────────────────────────────────────────────────────────────

  void reset() => emit(AuthInitial());
}
