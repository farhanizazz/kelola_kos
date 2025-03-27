import 'package:flutter/material.dart';

class TonalButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsets padding;
  final Widget? icon;

  const TonalButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.borderRadius = 12.0,
    this.backgroundColor,
    this.foregroundColor,
    this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FilledButton.tonal(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        maximumSize: const Size(double.infinity, 50),
        backgroundColor:
            backgroundColor ?? theme.colorScheme.secondaryContainer,
        foregroundColor:
            foregroundColor ?? theme.colorScheme.onSecondaryContainer,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: 0, // Match Material 3's tonal button style
      ),
      child: icon == null
          ? child
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [icon!, const SizedBox(width: 8), child],
            ),
    );
  }
}
