import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../constants/colors.dart';
import '../constants/spacing.dart';
import '../constants/typography.dart';
import '../utils/formatters.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionItem({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final amountColor = isIncome ? AppColors.success : AppColors.accentRed;
    final amountPrefix = isIncome ? '+' : '-';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
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
              _getIconForTransaction(),
              color: AppColors.textPrimary,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.name,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  AppFormatters.formatDateTime(transaction.dateTime),
                  style: AppTypography.captionSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$amountPrefix${AppFormatters.formatCurrency(transaction.amount)}',
            style: AppTypography.labelMedium.copyWith(
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForTransaction() {
    final name = transaction.name.toLowerCase();
    if (name.contains('wallet')) {
      return Icons.account_balance_wallet;
    } else if (name.contains('shopping')) {
      return Icons.shopping_cart;
    } else if (name.contains('fee')) {
      return Icons.account_balance;
    } else if (name.contains('saving')) {
      return Icons.savings;
    }
    return Icons.receipt;
  }
}
