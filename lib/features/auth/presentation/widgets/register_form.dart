import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/auth_cubit.dart';
import 'auth_text_field.dart';
import 'primary_button.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _nameError;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── Validation ───────────────────────────────────────────────────────────────

  bool _validate() {
    bool valid = true;
    setState(() {
      _nameError = null;
      _emailError = null;
      _passwordError = null;

      if (_nameController.text.trim().isEmpty) {
        _nameError = 'Name is required.';
        valid = false;
      }

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
      } else if (_passwordController.text.length < 6) {
        _passwordError = 'Password must be at least 6 characters.';
        valid = false;
      }
    });
    return valid;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          setState(() {
            _nameError = null;
            _emailError = null;
            _passwordError = null;
          });
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
        final isLoading = state is AuthLoading;
        final errorMessage = state is AuthFailure ? state.message : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Create account', style: AppTextStyles.headingMedium),
            const SizedBox(height: 4),
            const Text(
              'Join and start your health journey',
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 28),

            // ── Fields ──────────────────────────────────────────────────────
            AuthTextField(
              label: 'Full name',
              hint: 'Your name',
              prefixIcon: Icons.person_outline_rounded,
              controller: _nameController,
              errorText: _nameError,
            ),
            const SizedBox(height: 16),
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
              hint: 'Min. 6 characters',
              prefixIcon: Icons.lock_outline_rounded,
              isPassword: true,
              controller: _passwordController,
              errorText: _passwordError,
            ),
            const SizedBox(height: 24),

            // ── Firebase Error Banner ───────────────────────────────────────
            if (errorMessage != null) ...[
              _ErrorBanner(message: errorMessage),
              const SizedBox(height: 16),
            ],

            // ── Register Button ─────────────────────────────────────────────
            PrimaryButton(
              label: 'Create account',
              isLoading: isLoading,
              onTap: () {
                if (!_validate()) return;
                context.read<AuthCubit>().createUserWithEmailAndPassword(
                  name: _nameController.text,
                  email: _emailController.text,
                  password: _passwordController.text,
                );
              },
            ),
            const SizedBox(height: 16),

            // ── Terms ───────────────────────────────────────────────────────
            Center(
              child: Text.rich(
                TextSpan(
                  text: 'By continuing, you agree to our ',
                  style: AppTextStyles.caption,
                  children: [
                    TextSpan(text: 'Terms', style: AppTextStyles.link),
                    const TextSpan(text: ' and '),
                    TextSpan(text: 'Privacy Policy', style: AppTextStyles.link),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
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
