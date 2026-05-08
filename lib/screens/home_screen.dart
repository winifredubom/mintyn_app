// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mintyn_app/widgets/common/async_state.dart';
import '../constants/colors.dart';
import '../constants/spacing.dart';
import '../constants/typography.dart';
import '../providers/account_provider.dart';
import '../models/account_model.dart';
import '../screens/card_screen.dart';
import '../screens/profile_screen.dart';
import '../widgets/balance_card.dart';
import '../widgets/quick_actions.dart';
import '../widgets/transaction_item.dart';
import '../models/transaction_model.dart';
import '../widgets/common/app_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedTab = 0; // 0=Weekly, 1=Monthly, 2=Today
  bool _appNotification = true;
  final List<String> _tabs = ['Weekly', 'Monthly', 'Today'];


 List<Transaction> _filteredTransactions(Account account) {
  return account.transactions;
}

  @override
  Widget build(BuildContext context) {
     final accountAsync = ref.watch(accountProvider);

   return accountAsync.when(
  data: (account) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      drawer: _ProfileNavigationDrawer(
        account: account,
        appNotification: _appNotification,
        onNotificationChanged: (value) {
          setState(() => _appNotification = value);
        },
        onLogout: () => _showSnackBar(context, 'Logout'),
      ),
      appBar: CustomAppBar(
        titleWidget: RichText(
          text: TextSpan(
            text: 'Welcome ',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            children: [
              TextSpan(
                text: account.user.name,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(
                Icons.menu,
                color: AppColors.textPrimary,
                size: 24,
              ),
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.textPrimary.withValues(alpha: 0.06),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/icons/Bell_Notification.png',
                    width: 20,
                    height: 20,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),

            // ── Balance Card ─────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: BalanceCard(
                  balance: account.totalBalance,
                  cardBrand: account.cards.isNotEmpty ? account.cards.first.cardBrand : 'mastercard',
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),

            // ── Quick Actions ────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: QuickActions(
                  onBillPay: () => _showSnackBar(context, 'Bill Pay'),
                  onDonations: () => _showSnackBar(context, 'Donations'),
                  onDeposit: () => _showSnackBar(context, 'Deposit'),
                  onMore: () => _showSnackBar(context, 'More'),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),

            // ── Transaction History Header ───────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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
                          color: AppColors.lightBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),

            // ── Tab Filter ───────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Row(
                  children: List.generate(
                    _tabs.length,
                    (index) => Padding(
                      padding: EdgeInsets.only(
                        right: index == _tabs.length - 1 ? 0 : AppSpacing.md,
                      ),
                      child: _TabChip(
                        label: _tabs[index],
                        isSelected: _selectedTab == index,
                        onTap: () => setState(() => _selectedTab = index),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),

            // ── Transaction List ─────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final tx = _filteredTransactions(account)[index];
                  return TransactionItem(transaction: tx);
                }, childCount: _filteredTransactions(account).length)
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),
          ],
        ),
      ),
        );
  },
  loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          onRetry: () => ref.read(accountProvider.notifier).refresh(),
        ),
);
  }

  void _showSnackBar(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label tapped'),
        backgroundColor: AppColors.cardBg,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

class _ProfileNavigationDrawer extends StatelessWidget {
  final Account account;
  final bool appNotification;
  final ValueChanged<bool> onNotificationChanged;
  final VoidCallback onLogout;

  const _ProfileNavigationDrawer({
    required this.account,
    required this.appNotification,
    required this.onNotificationChanged,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Drawer(
      width: width < 390 ? width * 0.86 : 328,
      backgroundColor: AppColors.darkBg,
      shape: const RoundedRectangleBorder(),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          child: ListView(
            children: [
              _DrawerProfileHeader(account: account),
              const SizedBox(height: AppSpacing.lg),
              const _DrawerSectionTitle('Profile Settings'),
              const SizedBox(height: AppSpacing.md),
              _DrawerNavItem(
                icon: Icons.description_outlined,
                label: 'E-Statement',
                onTap: () {},
              ),
              _DrawerNavItem(
                icon: Icons.credit_card_outlined,
                label: 'Credit Card',
                onTap: () => _openScreen(context, const CardScreen()),
              ),
              _DrawerNavItem(
                icon: Icons.settings_outlined,
                label: 'Settings',
                onTap: () => _openScreen(context, const ProfileScreen()),
              ),
              const SizedBox(height: AppSpacing.xl),
              const _DrawerSectionTitle('Notification'),
              const SizedBox(height: AppSpacing.md),
              _DrawerToggleItem(
                imagePath: 'assets/icons/Bell_Notification.png',
                label: 'App Notification',
                value: appNotification,
                onChanged: onNotificationChanged,
              ),
              const SizedBox(height: AppSpacing.xl),
              const _DrawerSectionTitle('More'),
              const SizedBox(height: AppSpacing.md),
              _DrawerNavItem(
                icon: Icons.g_translate_outlined,
                label: 'Language',
                onTap: () {},
              ),
              _DrawerNavItem(
                icon: Icons.location_pin,
                label: 'Country',
                onTap: () {},
              ),
              const SizedBox(height: AppSpacing.lg),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: onLogout,
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.lightGreen,
                    foregroundColor: AppColors.accentredlight,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                    textStyle: AppTypography.labelMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Logout'),

                      const SizedBox(width: 8),

                      const Icon(Icons.logout, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openScreen(BuildContext context, Widget screen) {
    Navigator.pop(context);
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }
}

class _DrawerProfileHeader extends StatelessWidget {
  final Account account;

  const _DrawerProfileHeader({required this.account});

  @override
  Widget build(BuildContext context) {
    final initial = account.user.name.isNotEmpty
        ? account.user.name.characters.first.toUpperCase()
        : 'U';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: AssetImage('assets/icons/profile.jpg'),
            ),
            Positioned(
              right: -2,
              bottom: 0,
              child: Container(
                width: 17,
                height: 17,
                decoration: const BoxDecoration(
                  color: AppColors.textPrimary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.border_color_outlined,
                  color: AppColors.primaryBlue,
                  size: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Welcome',
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary,
            height: 1,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          account.user.name,
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _DrawerSectionTitle extends StatelessWidget {
  final String title;

  const _DrawerSectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTypography.heading3.copyWith(color: AppColors.textPrimary),
    );
  }
}

class _DrawerNavItem extends StatelessWidget {
  final IconData? icon;
  final String? imagePath;
  final String label;
  final VoidCallback onTap;

  const _DrawerNavItem({
    super.key,
    this.icon,
    this.imagePath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _DrawerItemShell(
      onTap: onTap,
      child: Row(
        children: [
          _DrawerIcon(icon: icon, imagePath: imagePath),

          const SizedBox(width: AppSpacing.md),

          Expanded(
            child: Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontSize: 18,
              ),
            ),
          ),

          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textPrimary,
            size: 30,
          ),
        ],
      ),
    );
  }
}

class _DrawerToggleItem extends StatelessWidget {
  final String imagePath;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _DrawerToggleItem({
    required this.imagePath,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _DrawerItemShell(
      child: Row(
        children: [
          _DrawerIcon(imagePath: imagePath),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontSize: 18,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.textPrimary,
            activeTrackColor: AppColors.primaryBlue,
          ),
        ],
      ),
    );
  }
}

class _DrawerItemShell extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _DrawerItemShell({required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 60,
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
        ),
        child: child,
      ),
    );
  }
}

class _DrawerIcon extends StatelessWidget {
  final IconData? icon;
  final String? imagePath;

  const _DrawerIcon({super.key, this.icon, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      child: imagePath != null
          ? Image.asset(
              imagePath!,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
              color: AppColors.primaryBlue,
            )
          : Icon(icon, color: AppColors.primaryBlue, size: 24),
    );
  }
}

// ── Tab Chip Widget ──────────────────────────────────────────────────────────

class _TabChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 90,
        height: 30,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTypography.captionSmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w400,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}
