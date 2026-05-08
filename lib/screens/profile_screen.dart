// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mintyn_app/widgets/common/async_state.dart';
import '../constants/colors.dart';
import '../constants/spacing.dart';
import '../constants/typography.dart';
import '../models/account_model.dart';
import '../providers/account_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _appNotification = true;

  @override
  Widget build(BuildContext context) {
    final accountAsync = ref.watch(accountProvider);
    
   return accountAsync.when(
  data: (account) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(22, 36, 22, 96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile',
                style: AppTypography.heading1.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 22),
              _ProfileSummary(account: account),
              const SizedBox(height: 20),
              Divider(
                color: AppColors.borderColor.withValues(alpha: 0.35),
                height: 1,
              ),
              const SizedBox(height: 38),
              const _SectionTitle('Profile Settings'),
              const SizedBox(height: 22),
              _ProfileNavItem(
                icon: Icons.description_outlined,
                label: 'E-Statement',
                onTap: () {},
              ),
              _ProfileNavItem(
                icon: Icons.credit_card_outlined,
                label: 'Credit Card',
                onTap: () {},
              ),
              _ProfileNavItem(
                icon: Icons.settings_outlined,
                label: 'Settings',
                onTap: () {},
              ),
              const SizedBox(height: 30),
              const _SectionTitle('Notification'),
              const SizedBox(height: 22),
              _ProfileToggleItem(
                 imagePath: 'assets/icons/Bell_Notification.png',
                label: 'App Notification',
                value: _appNotification,
                onChanged: (value) {
                  setState(() => _appNotification = value);
                },
              ),
              const SizedBox(height: 40),
              const _SectionTitle('More'),
              const SizedBox(height: 22),
              _ProfileNavItem(
                icon: Icons.g_translate_outlined,
                label: 'Language',
                onTap: () {},
              ),
              _ProfileNavItem(
                icon: Icons.public_rounded,
                label: 'Country',
                onTap: () {},
              ),
              const SizedBox(height: 26),
               Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => _showLogoutDialog(context),
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
  },
   loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          onRetry: () => ref.read(accountProvider.notifier).refresh(),
        ),
);
}

}
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        ),
        title: Text(
          'Logout',
          style: AppTypography.heading3.copyWith(color: AppColors.textPrimary),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Logout',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.accentRed,
              ),
            ),
          ),
        ],
      ),
    );
  }


class _ProfileSummary extends StatelessWidget {
  final Account account;

  const _ProfileSummary({required this.account});

  @override
  Widget build(BuildContext context) {
    final initial = account.user.name.isNotEmpty
        ? account.user.name.characters.first.toUpperCase()
        : 'U';

    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: AppColors.textPrimary,
          child:CircleAvatar(
              radius: 28,
              backgroundImage: AssetImage('assets/icons/profile.jpg'),
            ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      account.user.name,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        height: 1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      account.user.title,
                      style: AppTypography.captionSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 9,
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                account.user.email,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textPrimary.withValues(alpha: 0.82),
                  height: 1,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTypography.heading3.copyWith(
        color: AppColors.textPrimary,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1,
      ),
    );
  }
}

class _ProfileNavItem extends StatelessWidget {
   final IconData? icon;
  final String? imagePath;
  final String label;
  final VoidCallback onTap;

  const _ProfileNavItem({
    super.key,
    this.icon,
    this.imagePath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _ProfileItemShell(
      onTap: onTap,
      child: Row(
        children: [
          _ProfileItemIcon(icon: icon, imagePath: imagePath ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontSize: 20,
                height: 1,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textPrimary,
            size: 34,
          ),
        ],
      ),
    );
  }
}

class _ProfileToggleItem extends StatelessWidget {
 final String imagePath;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ProfileToggleItem({
    required this.imagePath,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _ProfileItemShell(
      child: Row(
        children: [
          _ProfileItemIcon(imagePath: imagePath),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontSize: 20,
                height: 1,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.textPrimary,
            activeTrackColor: AppColors.primaryBlue,
            inactiveThumbColor: AppColors.textPrimary,
            inactiveTrackColor: AppColors.darkGrey,
          ),
        ],
      ),
    );
  }
}

class _ProfileItemShell extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _ProfileItemShell({required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 65,
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(6),
        ),
        child: child,
      ),
    );
  }
}

class _ProfileItemIcon extends StatelessWidget {
  final IconData? icon;
  final String? imagePath;

  const _ProfileItemIcon({this.icon, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.darkGrey.withValues(alpha: 0.35),
        shape: BoxShape.circle,
      ),
     child: imagePath != null
          ? Image.asset(
              imagePath!,
              scale: 0.7,
              color: AppColors.primaryBlue,
            )
          : Icon(icon, color: AppColors.primaryBlue, size: 24),
    );
  }
}
