import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/spacing.dart';
import '../constants/typography.dart';

class QuickActions extends StatelessWidget {
  final Function() onBillPay;
  final Function() onDonations;
  final Function() onDeposit;
  final Function() onMore;

  const QuickActions({
    Key? key,
    required this.onBillPay,
    required this.onDonations,
    required this.onDeposit,
    required this.onMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final actions = [
      {'icon': Icons.receipt, 'label': 'Bill Pay', 'onTap': onBillPay},
      {'icon': Icons.volunteer_activism, 'label': 'Donations', 'onTap': onDonations},
      {'icon': Icons.savings, 'label': 'Deposit', 'onTap': onDeposit},
      {'icon': Icons.more_horiz, 'label': 'More', 'onTap': onMore},
    ];

    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 1,
      children: actions
          .map(
            (action) => _ActionButton(
              icon: action['icon'] as IconData,
              label: action['label'] as String,
              onTap: action['onTap'] as Function(),
            ),
          )
          .toList(),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function() onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
              border: Border.all(
                color: AppColors.borderColor,
              ),
            ),
            child: Icon(
              icon,
              color: AppColors.textPrimary,
              size: 24,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
