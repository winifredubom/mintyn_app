// lib/screens/card_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mintyn_app/screens/transaction_screen.dart';
import '../constants/colors.dart';
import '../constants/spacing.dart';
import '../constants/typography.dart';
import '../providers/account_provider.dart';
import '../models/account_model.dart';
import '../models/card_model.dart';
import '../widgets/card_carousel.dart';

class CardScreen extends StatefulWidget {
  const CardScreen({super.key});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  late Account _account;
  bool _isPhysical = true;

  // Card settings toggles
  bool _changePinEnabled = true;
  bool _qrPaymentEnabled = true;
  bool _onlineShoppingEnabled = false;
  bool _tapPayEnabled = true;

  @override
  void initState() {
    super.initState();
    _account = AccountProvider.getMockAccount();
  }
   void _openScreen(BuildContext context, Widget screen) {
    Navigator.pop(context);
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  List<CardDetails> get _displayCards => _account.cards;

  int get _physicalCardCount =>
      _account.cards.where((card) => card.type == CardType.physical).length;

  int get _virtualCardCount =>
      _account.cards.where((card) => card.type == CardType.virtual).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── App Bar ──────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 30, 28, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Card',
                      style: AppTypography.heading1.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 31,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                    const Icon(
                      Icons.more_horiz,
                      color: AppColors.textPrimary,
                      size: 28,
                    ),
                  ],
                ),
              ),
            ),

            // ── Card Count Subtitle ──────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 28,
                  top: AppSpacing.sm,
                  bottom: 26,
                ),
                child: Text(
                  '$_physicalCardCount Physical Card, $_virtualCardCount Virtual Card',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1,
                  ),
                ),
              ),
            ),

            // ── Physical / Virtual Tab ───────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: _CardTypeToggle(
                  isPhysical: _isPhysical,
                  onToggle: (val) => setState(() => _isPhysical = val),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 36)),

            // ── Card Carousel ────────────────────────────────────────
            SliverToBoxAdapter(
              child: _displayCards.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.xl,
                      ),
                      child: Center(
                        child: Text(
                          'No cards',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: CardCarousel(cards: _displayCards),
                    ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 22)),

            // ── Card Actions Row ─────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _CardActionButton(
                      icon: Icons.ac_unit_rounded,
                      label: 'Freeze Card',
                      onTap: () {},
                    ),
                    _CardActionButton(
                      icon: Icons.visibility_off_rounded,
                      label: 'Reveal',
                      onTap: () {},
                    ),
                    _CardActionButton(
                      icon: Icons.ac_unit_rounded,
                      label: 'Freeze Card',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Divider(
                  color: AppColors.borderColor.withValues(alpha: 0.45),
                  height: 1,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 28)),

            // ── Card Settings Header ─────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Text(
                  'Card Settings',
                  style: AppTypography.heading1.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 32,
                    fontWeight: FontWeight.w400,
                    height: 1,
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),

            // ── Settings Items ───────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _SettingsToggleItem(
                    icon: Icons.password,
                    label: 'Change Pin',
                    value: _changePinEnabled,
                    onChanged: (val) => setState(() => _changePinEnabled = val),
                  ),
                  _SettingsToggleItem(
                    icon: Icons.qr_code_2,
                    label: 'QR Payment',
                    value: _qrPaymentEnabled,
                    onChanged: (val) => setState(() => _qrPaymentEnabled = val),
                  ),
                  _SettingsToggleItem(
                    icon: Icons.storefront_rounded,
                    label: 'Online Shopping',
                    value: _onlineShoppingEnabled,
                    onChanged: (val) =>
                        setState(() => _onlineShoppingEnabled = val),
                  ),
                  _SettingsNavItem(
                    icon: Icons.credit_card_outlined,
                    label: 'Card Transactions',
                    onTap:  () => _openScreen(context, const TransactionScreen()),
                  ),
                  _SettingsToggleItem(
                    svgPath: 'assets/icons/Vector.svg',
                    label: 'Tap Pay',
                    value: _tapPayEnabled,
                    onChanged: (val) => setState(() => _tapPayEnabled = val),
                  ),
                ]),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
          ],
        ),
      ),
    );
  }
}

// ── Card Type Toggle ─────────────────────────────────────────────────────────

class _CardTypeToggle extends StatelessWidget {
  final bool isPhysical;
  final ValueChanged<bool> onToggle;

  const _CardTypeToggle({required this.isPhysical, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ToggleOption(
          label: 'Physical Card',
          isSelected: isPhysical,
          onTap: () => onToggle(true),
        ),
        const SizedBox(width: AppSpacing.lg),
        _ToggleOption(
          label: 'Virtual Card',
          isSelected: !isPhysical,
          onTap: () => onToggle(false),
        ),
      ],
    );
  }
}

class _ToggleOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleOption({
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
        duration: const Duration(milliseconds: 180),
        width: 138,
        height: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.transparent : AppColors.cardBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : Colors.transparent,
            width: 1.4,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

// ── Card Action Button ───────────────────────────────────────────────────────

class _CardActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _CardActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.textPrimary, size: 30),
          ),
          const SizedBox(height: 14),
          Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontSize: 18,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Settings Toggle Item ─────────────────────────────────────────────────────

class _SettingsToggleItem extends StatelessWidget {
  final IconData? icon;
  final String? imagePath;
  final String? svgPath;

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsToggleItem({
    super.key,
    this.icon,
    this.imagePath,
    this.svgPath,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  Widget _buildIcon() {
    if (svgPath != null) {
      return SvgPicture.asset(
        svgPath!,
        width: 28,
        height: 28,
        colorFilter: const ColorFilter.mode(
          AppColors.textPrimary,
          BlendMode.srcIn,
        ),
      );
    }

    if (imagePath != null) {
      return Image.asset(
        imagePath!,
        width: 28,
        height: 28,
        fit: BoxFit.contain,
      );
    }

    return Icon(
      icon,
      color: AppColors.textPrimary,
      size: 28,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildIcon(),

          const SizedBox(width: 18),

          Expanded(
            child: Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontSize: 24,
                height: 1,
              ),
            ),
          ),

          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.textPrimary,
            activeTrackColor: AppColors.primaryBlue,
            inactiveTrackColor: AppColors.darkGrey,
            inactiveThumbColor: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }
}

// ── Settings Nav Item ────────────────────────────────────────────────────────

class _SettingsNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SettingsNavItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 65,
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.symmetric(horizontal: 22),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textPrimary, size: 28),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 24,
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
      ),
    );
  }
}
