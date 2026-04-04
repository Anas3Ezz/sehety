import 'package:fire_project/core/theme/app_colors.dart';
import 'package:fire_project/features/auth/data/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import 'auth_text_field.dart';
import 'google_sign_in_button.dart';
import 'primary_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isEmailLoading = false;
  bool _isGoogleLoading = false;

  String? _emailError;
  String? _passwordError;
  String? _generalError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── Validation ───────────────────────────────────────────────────────────────

  bool _validate() {
    bool valid = true;
    setState(() {
      _emailError = null;
      _passwordError = null;
      _generalError = null;

      if (_emailController.text.trim().isEmpty) {
        _emailError = 'Email is required.';
        valid = false;
      } else if (!_emailController.text.contains('@')) {
        _emailError = 'Please enter a valid email.';
        valid = false;
      }

      if (_passwordController.text.isEmpty) {
        _passwordError = 'Password is required.';
        valid = false;
      }
    });
    return valid;
  }

  // ── Email Sign In ────────────────────────────────────────────────────────────

  Future<void> _handleEmailSignIn() async {
    if (!_validate()) return;

    setState(() => _isEmailLoading = true);

    try {
      await AuthRepository.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (!mounted) return;
      _showSuccessSnackBar('Signed in successfully! 👋');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() => _generalError = AuthRepository.getErrorMessage(e));
    } finally {
      if (mounted) setState(() => _isEmailLoading = false);
    }
  }

  // ── Google Sign In ────────────────────────────────────────────────────────────

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isGoogleLoading = true;
      _generalError = null;
    });

    try {
      final credential = await AuthRepository.instance.signInWithGoogle();

      // User cancelled the Google picker
      if (credential == null) {
        setState(() => _isGoogleLoading = false);
        return;
      }

      if (!mounted) return;
      _showSuccessSnackBar(
        'Welcome, ${credential.user?.displayName ?? 'User'}! 🎉',
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() => _generalError = AuthRepository.getErrorMessage(e));
    } catch (e) {
      if (!mounted) return;
      setState(() => _generalError = 'Google sign-in failed. Try again.');
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  // ── Forgot Password ───────────────────────────────────────────────────────────

  Future<void> _handleForgotPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() => _emailError = 'Enter your email first.');
      return;
    }

    try {
      await AuthRepository.instance.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      _showSuccessSnackBar('Reset email sent! Check your inbox.');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() => _generalError = AuthRepository.getErrorMessage(e));
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Welcome back', style: AppTextStyles.headingMedium),
        const SizedBox(height: 4),
        const Text(
          'Sign in to your account to continue',
          style: AppTextStyles.bodySmall,
        ),
        const SizedBox(height: 28),

        // ── Fields ────────────────────────────────────────────────────────────
        AuthTextField(
          label: 'Email',
          hint: 'you@example.com',
          prefixIcon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
          controller: _emailController,
          errorText: _emailError,
        ),
        const SizedBox(height: 16),
        AuthTextField(
          label: 'Password',
          hint: '••••••••',
          prefixIcon: Icons.lock_outline_rounded,
          isPassword: true,
          controller: _passwordController,
          errorText: _passwordError,
        ),
        const SizedBox(height: 12),

        // ── Forgot Password ───────────────────────────────────────────────────
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: _handleForgotPassword,
            child: const Text('Forgot password?', style: AppTextStyles.link),
          ),
        ),
        const SizedBox(height: 20),

        // ── General Error ─────────────────────────────────────────────────────
        if (_generalError != null) ...[
          _ErrorBanner(message: _generalError!),
          const SizedBox(height: 16),
        ],

        // ── Sign In Button ────────────────────────────────────────────────────
        PrimaryButton(
          label: 'Sign in',
          onTap: _handleEmailSignIn,
          isLoading: _isEmailLoading,
        ),
        const SizedBox(height: 20),

        // ── Divider ───────────────────────────────────────────────────────────
        _OrDivider(),
        const SizedBox(height: 16),

        // ── Google Button ─────────────────────────────────────────────────────
        GoogleSignInButton(
          onTap: _handleGoogleSignIn,
          isLoading: _isGoogleLoading,
        ),
      ],
    );
  }
}

class _OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border, thickness: 0.5)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'or continue with',
            style: AppTextStyles.caption.copyWith(fontSize: 11),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.border, thickness: 0.5)),
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;

  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 15,
            color: AppColors.error,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.caption.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
