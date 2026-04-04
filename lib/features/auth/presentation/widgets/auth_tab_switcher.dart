import 'package:fire_project/core/theme/app_colors.dart' show AppColors;
import 'package:fire_project/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class AuthTabSwitcher extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const AuthTabSwitcher({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _TabItem(
            label: 'Sign in',
            isSelected: selectedIndex == 0,
            onTap: () => onTabChanged(0),
          ),
          _TabItem(
            label: 'Create account',
            isSelected: selectedIndex == 1,
            onTap: () => onTabChanged(1),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(0.18)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            border: isSelected
                ? Border.all(color: AppColors.primary.withOpacity(0.35))
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: isSelected
                  ? AppColors.primaryLight
                  : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
