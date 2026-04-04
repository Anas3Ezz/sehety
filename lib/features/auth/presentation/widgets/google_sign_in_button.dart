import 'package:fire_project/core/theme/app_colors.dart';
import 'package:fire_project/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLoading;

  const GoogleSignInButton({
    super.key,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: isLoading
              ? AppColors.surfaceLight.withOpacity(0.5)
              : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.textSecondary,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CustomPaint(painter: _GoogleLogoPainter()),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Continue with Google',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textPrimary.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    const sweepAngle = 3.14159 * 2;

    canvas.drawArc(
      rect,
      -1.5708,
      sweepAngle * 0.25,
      true,
      Paint()..color = const Color(0xFF4285F4),
    );
    canvas.drawArc(
      rect,
      -1.5708 + sweepAngle * 0.25,
      sweepAngle * 0.25,
      true,
      Paint()..color = const Color(0xFFEA4335),
    );
    canvas.drawArc(
      rect,
      -1.5708 + sweepAngle * 0.5,
      sweepAngle * 0.25,
      true,
      Paint()..color = const Color(0xFFFBBC05),
    );
    canvas.drawArc(
      rect,
      -1.5708 + sweepAngle * 0.75,
      sweepAngle * 0.25,
      true,
      Paint()..color = const Color(0xFF34A853),
    );

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.32,
      Paint()..color = AppColors.surfaceLight,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
