import 'package:flutter/material.dart';
import '../app_theme.dart';

class AvatarWidget extends StatelessWidget {
  final String initials;
  final double size;
  final bool showOnline;
  final bool hasStory;
  final Color? color;

  const AvatarWidget({
    super.key,
    required this.initials,
    this.size = 48,
    this.showOnline = false,
    this.hasStory = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final avatarColors = [
      const Color(0xFF7C3AED),
      const Color(0xFF2563EB),
      const Color(0xFF059669),
      const Color(0xFFDC2626),
      const Color(0xFFD97706),
    ];
    final colorIndex = initials.codeUnits.fold(0, (a, b) => a + b) % avatarColors.length;
    final bgColor = color ?? avatarColors[colorIndex];

    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: hasStory
                ? Border.all(color: AppTheme.primary, width: 2.5)
                : null,
            gradient: hasStory
                ? const LinearGradient(
                    colors: [AppTheme.primary, AppTheme.accent],
                  )
                : null,
            color: hasStory ? null : bgColor,
          ),
          child: Container(
            margin: hasStory ? const EdgeInsets.all(2.5) : EdgeInsets.zero,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bgColor,
            ),
            child: Center(
              child: Text(
                initials.length > 2 ? initials.substring(0, 2) : initials,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size * 0.32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        if (showOnline)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: size * 0.26,
              height: size * 0.26,
              decoration: BoxDecoration(
                color: AppTheme.online,
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.background, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}
