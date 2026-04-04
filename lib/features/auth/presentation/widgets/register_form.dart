import 'package:fire_project/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

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
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    setState(() => _isLoading = true);
    // TODO: FirebaseAuth.instance.createUserWithEmailAndPassword(
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
        const Text('Create account', style: AppTextStyles.headingMedium),
        const SizedBox(height: 4),
        const Text(
          'Join and start your health journey',
          style: AppTextStyles.bodySmall,
        ),
        const SizedBox(height: 28),
        AuthTextField(
          label: 'Full name',
          hint: 'Your name',
          prefixIcon: Icons.person_outline_rounded,
          controller: _nameController,
        ),
        const SizedBox(height: 16),
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
          hint: 'Min. 8 characters',
          prefixIcon: Icons.lock_outline_rounded,
          isPassword: true,
          controller: _passwordController,
        ),
        const SizedBox(height: 28),
        PrimaryButton(
          label: 'Create account',
          onTap: _handleRegister,
          isLoading: _isLoading,
        ),
        const SizedBox(height: 16),
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
  }
}
