import 'package:flutter/material.dart';
import '../theme.dart';

class TotaleWidget extends StatelessWidget {
  final double totale;

  const TotaleWidget({
    super.key,
    required this.totale,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.successColor.withValues(alpha: 0.06),
        border: Border(
          top: BorderSide(
            color: AppTheme.successColor.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'TOTALE',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: AppTheme.textSecondary,
            ),
          ),
          Text(
            '€${totale.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.successColor,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}
