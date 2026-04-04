import 'package:fire_project/core/theme/app_colors.dart';
import 'package:fire_project/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

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
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    // TODO: FirebaseAuth.instance.signInWithEmailAndPassword(
    //   email: _emailController.text.trim(),
    //   password: _passwordController.text.trim(),
    // );
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);
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
        AuthTextField(
          label: 'Email',
          hint: 'you@example.com',
          prefixIcon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
          controller: _emailController,
        ),
        const SizedBox(height: 16),
        AuthTextField(
          label: 'Password',
          hint: '••••••••',
          prefixIcon: Icons.lock_outline_rounded,
          isPassword: true,
          controller: _passwordController,
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              // TODO: navigate to forgot password screen
            },
            child: const Text('Forgot password?', style: AppTextStyles.link),
          ),
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          label: 'Sign in',
          onTap: _handleLogin,
          isLoading: _isLoading,
        ),
        const SizedBox(height: 20),
        _OrDivider(),
        const SizedBox(height: 16),
        GoogleSignInButton(
          onTap: () {
            // TODO: Google sign-in
          },
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
