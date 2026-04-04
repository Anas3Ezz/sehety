import 'package:fire_project/core/theme/app_colors.dart';
import 'package:fire_project/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class AuthTextField extends StatefulWidget {
  final String label;
  final String hint;
  final IconData prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextEditingController? controller;

  const AuthTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.controller,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _obscure = true;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label.toUpperCase(), style: AppTextStyles.labelSmall),
        const SizedBox(height: 7),
        Focus(
          onFocusChange: (focused) => setState(() => _isFocused = focused),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: _isFocused
                  ? AppColors.primary.withOpacity(0.06)
                  : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isFocused
                    ? AppColors.primary.withOpacity(0.5)
                    : AppColors.border,
              ),
            ),
            child: TextField(
              controller: widget.controller,
              obscureText: widget.isPassword && _obscure,
              keyboardType: widget.keyboardType,
              style: AppTextStyles.bodyMedium,
              cursorColor: AppColors.primary,
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textHint,
                ),
                prefixIcon: Icon(
                  widget.prefixIcon,
                  size: 18,
                  color: _isFocused
                      ? AppColors.primaryLight
                      : AppColors.textSecondary,
                ),
                suffixIcon: widget.isPassword
                    ? GestureDetector(
                        onTap: () => setState(() => _obscure = !_obscure),
                        child: Icon(
                          _obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 18,
                          color: AppColors.textSecondary,
                        ),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
