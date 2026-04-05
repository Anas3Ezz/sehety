import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../cubit/auth_cubit.dart';
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

  String? _emailError;
  String? _passwordError;

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

  void _clearFieldErrors() {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          _clearFieldErrors();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      },
      builder: (context, state) {
        final isEmailLoading = state is AuthLoading;
        final isGoogleLoading = state is AuthGoogleLoading;
        final errorMessage = state is AuthFailure ? state.message : null;

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

            // ── Fields ──────────────────────────────────────────────────────
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

            // ── Forgot Password ─────────────────────────────────────────────
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  final email = _emailController.text.trim();
                  if (email.isEmpty) {
                    setState(() => _emailError = 'Enter your email first.');
                    return;
                  }
                  context.read<AuthCubit>().sendPasswordResetEmail(
                    email: email,
                  );
                },
                child: const Text(
                  'Forgot password?',
                  style: AppTextStyles.link,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Firebase Error Banner ───────────────────────────────────────
            if (errorMessage != null) ...[
              _ErrorBanner(message: errorMessage),
              const SizedBox(height: 16),
            ],

            // ── Sign In Button ──────────────────────────────────────────────
            PrimaryButton(
              label: 'Sign in',
              isLoading: isEmailLoading,
              onTap: () {
                if (!_validate()) return;
                context.read<AuthCubit>().signInWithEmailAndPassword(
                  email: _emailController.text,
                  password: _passwordController.text,
                );
              },
            ),
            const SizedBox(height: 20),

            // ── Divider ─────────────────────────────────────────────────────
            _OrDivider(),
            const SizedBox(height: 16),

            // ── Google Button ───────────────────────────────────────────────
            GoogleSignInButton(
              isLoading: isGoogleLoading,
              onTap: () => context.read<AuthCubit>().signInWithGoogle(),
            ),
          ],
        );
      },
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
