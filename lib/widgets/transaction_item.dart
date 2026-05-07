import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../constants/colors.dart';
import '../constants/spacing.dart';
import '../constants/typography.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final amountColor = isIncome ? AppColors.primaryBlue : AppColors.accentRed;
    final amountPrefix = isIncome ? '+' : '-';

    return Container(
      height: 86,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderColor.withValues(alpha: 0.35),
          ),
        ),
      ),
      child: Row(
        children: [
          _TransactionIcon(icon: _getIconForTransaction()),
          const SizedBox(width: 22),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.name,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w400,
                      height: 1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    _formatTransactionDate(transaction.dateTime),
                    style: AppTypography.captionSmall.copyWith(
                      color: AppColors.textPrimary.withValues(alpha: 0.68),
                      fontSize: 14,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            '$amountPrefix ${_formatAmount(transaction.amount)}',
            style: AppTypography.heading2.copyWith(
              color: amountColor,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTransactionDate(DateTime dateTime) {
    return DateFormat('h:mm a • MM-dd-yyyy').format(dateTime).toLowerCase();
  }

  String _formatAmount(double amount) {
    if (amount == amount.roundToDouble()) {
      return amount.toStringAsFixed(0);
    }
    return amount.toStringAsFixed(2);
  }

  IconData _getIconForTransaction() {
    final name = transaction.name.toLowerCase();
    if (name.contains('wallet')) {
      return transaction.id == '3'
          ? Icons.language_rounded
          : Icons.account_balance_wallet_outlined;
    } else if (name.contains('shopping')) {
      return Icons.storefront_outlined;
    } else if (name.contains('fee')) {
      return Icons.account_balance_outlined;
    } else if (name.contains('saving')) {
      return Icons.paid_outlined;
    }
    return Icons.receipt_long_outlined;
  }
}

class _TransactionIcon extends StatelessWidget {
  final IconData icon;

  const _TransactionIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.darkGrey.withValues(alpha: 0.34),
        border: Border.all(
          color: AppColors.borderLight.withValues(alpha: 0.95),
          width: 1.4,
        ),
      ),
      child: Icon(icon, color: AppColors.textPrimary, size: 24),
    );
  }
}
