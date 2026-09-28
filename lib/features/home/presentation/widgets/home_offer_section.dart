import 'package:flutter/material.dart';

class HomeOfferSection extends StatelessWidget {
  const HomeOfferSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 22, 20, 20),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.onPrimary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              child: Text(
                'Limited offer',
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Free delivery on\nyour first order',
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontSize: 28,
              height: 1.12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Use code BITE10 at checkout',
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 30,
                  height: 7,
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 8),
                for (var index = 0; index < 2; index++) ...[
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: colorScheme.onPrimary.withValues(alpha: 0.55),
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (index == 0) const SizedBox(width: 8),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
