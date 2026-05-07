import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/typography.dart';

class QuickActions extends StatelessWidget {
  final Function() onBillPay;
  final Function() onDonations;
  final Function() onDeposit;
  final Function() onMore;

  const QuickActions({
    super.key,
    required this.onBillPay,
    required this.onDonations,
    required this.onDeposit,
    required this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAction(
        imagePath: 'assets/icons/billPay.png',
        label: 'Bill Pay',
        onTap: (){},
      ),
      _QuickAction(
        imagePath: 'assets/icons/donation.png',
        label: 'Donations',
        onTap: (){},
      ),
      _QuickAction(
        imagePath: 'assets/icons/deposit.png',
        label: 'Deposit',
        onTap: (){},
      ),
      _QuickAction(
        imagePath: 'assets/icons/grid_view.png',
        label: 'More',
        onTap: (){},
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = (constraints.maxWidth / 680).clamp(0.52, 1.0);

        return Container(
          height: 178 * scale,
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.borderColor.withValues(alpha: 0.45),
            ),
          ),
          child: Row(
            children: [
              for (var i = 0; i < actions.length; i++) ...[
                Expanded(
                  child: _ActionButton(
                    imagePath: actions[i].imagePath,
                    label: actions[i].label,
                    onTap: actions[i].onTap,
                    scale: scale,
                  ),
                ),
                if (i != actions.length - 1)
                  SizedBox(
                    height: 90 * scale,
                    child: VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: AppColors.borderLight.withValues(alpha: 0.65),
                    ),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _QuickAction {
  final String imagePath;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.imagePath,
    required this.label,
    required this.onTap,
  });
}

class _ActionButton extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;
  final double scale;

  const _ActionButton({
    required this.imagePath,
    required this.label,
    required this.onTap,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72 * scale,
            height: 72 * scale,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.darkGrey.withValues(alpha: 0.45),
            ),
            child: Center(
              child: Image.asset(
                imagePath,
                width: 38 * scale,
                height: 38 * scale,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(height: 22 * scale),
          Text(
            label,
            style: AppTypography.heading3.copyWith(
              color: AppColors.textPrimary,
              fontSize: 24 * scale,
              fontWeight: FontWeight.w700,
              height: 1,
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
