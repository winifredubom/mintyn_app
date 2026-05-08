// lib/screens/transaction_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/colors.dart';
import '../constants/spacing.dart';
import '../constants/typography.dart';
import '../providers/account_provider.dart';
import '../models/account_model.dart';
import '../models/transaction_model.dart';
import '../widgets/spending_chart.dart';
import '../widgets/transaction_item.dart';
import '../widgets/card_carousel.dart';
import '../widgets/common/async_state.dart';

class TransactionScreen extends ConsumerWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountAsync = ref.watch(accountProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: accountAsync.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          onRetry: () => ref.read(accountProvider.notifier).refresh(),
        ),
        data: (account) => _TransactionContent(account: account),
      ),
    );
  }
}

// ── Content widget (holds local state for period selection) ──────────────────

class _TransactionContent extends StatefulWidget {
  final Account account;

  const _TransactionContent({required this.account});

  @override
  State<_TransactionContent> createState() => _TransactionContentState();
}

class _TransactionContentState extends State<_TransactionContent> {
  String _selectedPeriod = 'Weekly';

  final Map<String, List<double>> _spendingData = {
    'Weekly': [1200, 2800, 1800, 3657, 2200, 4100],
    'Monthly': [3200, 4500, 2800, 5100, 3900, 4800],
    'Yearly': [18000, 22000, 19500, 25000, 21000, 28000],
  };

  final Map<String, String> _totalSpend = {
    'Weekly': '30',
    'Monthly': '120',
    'Yearly': '1,440',
  };

  final List<String> _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];

  List<Transaction> get _recentTransactions =>
      widget.account.transactions.take(5).toList();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── App Bar ────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Card Transaction',
                    style: AppTypography.heading3.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Icon(Icons.more_horiz, color: AppColors.textPrimary),
                ],
              ),
            ),
          ),

          // ── Card Preview ───────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: SizedBox(
                height: 200,
                child: CardWidget(card: widget.account.cards.first),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),

          // ── Spending Chart ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: SpendingChart(
                monthlyData: _spendingData[_selectedPeriod]!,
                months: _months,
                totalSpend: _totalSpend[_selectedPeriod]!,
                selectedPeriod: _selectedPeriod,
                onPeriodChanged: (period) {
                  setState(() => _selectedPeriod = period);
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),

          // ── Transaction History Header ─────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transaction History',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'See all',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),

          // ── Transaction List ───────────────────────────────────────
          SliverPadding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => TransactionItem(
                  transaction: _recentTransactions[index],
                ),
                childCount: _recentTransactions.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
        ],
      ),
    );
  }
}