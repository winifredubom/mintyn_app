import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/typography.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final String cardBrand;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.cardBrand,
  });

  String get _formattedBalance {
    if (balance == balance.roundToDouble()) {
      return balance.toStringAsFixed(0);
    }
    return balance.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      child: AspectRatio(
        aspectRatio: 682 / 411,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final scale = (constraints.maxWidth / 682).clamp(0.72, 1.0);

            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.borderLight.withValues(alpha: 0.75),
                  width: 1.2,
                ),
                image: const DecorationImage(
                  image: AssetImage('assets/icons/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: CustomPaint(
                painter: _BalanceCardTexturePainter(),
                child: Stack(
                  children: [
                    Positioned(
                      left: 45 * scale,
                      top: 82 * scale,
                      child: Text(
                        'Total Balance',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textPrimary.withValues(alpha: 0.76),
                          fontSize: 20,
                          height: 1,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 45 * scale,
                      top: 120 * scale,
                      child: Text(
                        '$_formattedBalance\$',
                        style: AppTypography.heading1.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 34,
                          height: 1,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 24 * scale,
                      top: 14 * scale,
                      child: _buildCardBrandLogo(scale),
                    ),
                    Positioned(
                      right: 65 * scale,
                      top: 105 * scale,
                      child: _CircularAssetButton(
                        asset: 'assets/icons/Frame.png',
                        size: 68 * scale,
                        iconSize: 31 * scale,
                      ),
                    ),
                    Positioned(
                      left: 45 * scale,
                      right: 64 * scale,
                      bottom: 30 * scale,
                      child: Row(
                        children: [
                          Expanded(
                            child: _BalanceActionButton(
                              icon: Icons.add,
                              label: 'Add Cash',
                              height: 55 * scale,
                              iconSize: 37 * scale,
                              fontSize: 20 * scale,
                              onPressed: () {},
                            ),
                          ),
                          SizedBox(width: 53 * scale),
                          Expanded(
                            child: _BalanceActionButton(
                              icon: Icons.arrow_outward,
                              label: 'Send Money',
                              height: 55 * scale,
                              iconSize: 34 * scale,
                              fontSize: 28 * scale,
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCardBrandLogo(double scale) {
    if (cardBrand.toLowerCase() == 'mastercard') {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/icons/Vector.png',
            width: 74 * scale,
            height: 57 * scale,
            fit: BoxFit.contain,
          ),
          Transform.translate(
            offset: Offset(0, -5 * scale),
            child: Text(
              '',
              style: AppTypography.caption.copyWith(
                color: AppColors.textPrimary,
                fontSize: 14 * scale,
                fontWeight: FontWeight.w600,
                height: 1,
              ),
            ),
          ),
        ],
      );
    }
    return const SizedBox();
  }
}

class _CircularAssetButton extends StatelessWidget {
  final String asset;
  final double size;
  final double iconSize;

  const _CircularAssetButton({
    required this.asset,
    required this.size,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.textPrimary.withValues(alpha: 0.06),
      ),
      child: Center(
        child: Image.asset(
          asset,
          width: iconSize,
          height: iconSize,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _BalanceActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final double height;
  final double iconSize;
  final double fontSize;
  final VoidCallback onPressed;

  const _BalanceActionButton({
    required this.icon,
    required this.label,
    required this.height,
    required this.iconSize,
    required this.fontSize,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: iconSize),
        label: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            maxLines: 1,
            style: AppTypography.heading3.copyWith(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1,
            ),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.symmetric(horizontal: 28 * (height / 77)),
          iconColor: AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _BalanceCardTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textPrimary.withValues(alpha: 0.08)
      ..strokeWidth = 1;

    for (var i = 0; i < 620; i++) {
      final x = ((i * 47) % size.width.toInt()).toDouble();
      final y = ((i * 83) % size.height.toInt()).toDouble();
      final radius = i % 5 == 0 ? 1.1 : 0.7;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    final shadowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.transparent, AppColors.darkBg.withValues(alpha: 0.12)],
      ).createShader(Offset.zero & size);

    canvas.drawRect(Offset.zero & size, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
