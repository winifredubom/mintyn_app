// lib/widgets/card_carousel.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../constants/colors.dart';
import '../constants/spacing.dart';
import '../constants/typography.dart';
import '../models/card_model.dart';

// ── Card Carousel ────────────────────────────────────────────────────────────────

class CardCarousel extends StatefulWidget {
  final List<CardDetails> cards;

  const CardCarousel({super.key, required this.cards});

  @override
  State<CardCarousel> createState() => _CardCarouselState();
}

class _CardCarouselState extends State<CardCarousel> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.80,
      initialPage: widget.cards.length > 1 ? 1 : 0,
    );
    _currentIndex = widget.cards.length > 1 ? 1 : 0;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 185,
          child: PageView.builder(
            controller: _pageController,
            clipBehavior: Clip.none,
            padEnds: false,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemCount: widget.cards.length,
            itemBuilder: (context, index) {
              final isSelected = index == _currentIndex;
              return AnimatedScale(
                duration: const Duration(milliseconds: 180),
                scale: isSelected ? 1 : 0.85,
                child: FlippableCardWidget(card: widget.cards[index]),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildIndicators(),
      ],
    );
  }

  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.cards.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentIndex == index ? 22 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentIndex == index
                ? AppColors.primaryBlue
                : AppColors.textSecondary,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

// ── Flippable Card (used in Card screen carousel) ────────────────────────────────

class FlippableCardWidget extends StatefulWidget {
  final CardDetails card;

  const FlippableCardWidget({super.key, required this.card});

  @override
  State<FlippableCardWidget> createState() => _FlippableCardWidgetState();
}

class _FlippableCardWidgetState extends State<FlippableCardWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  bool _showFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleFlip() {
    if (_showFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() => _showFront = !_showFront);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleFlip,
      child: ListenableBuilder(
        listenable: _animation,
        builder: (context, _) {
          final angle = _animation.value * 3.14159;
          final isShowingFront = angle <= 1.5708; // pi/2

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: isShowingFront
                ? CardWidget(card: widget.card)
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(3.14159),
                    child: _CardBack(card: widget.card),
                  ),
          );
        },
      ),
    );
  }
}

// ── Static Card (used in Transaction screen preview) ─────────────────────────────

class CardWidget extends StatelessWidget {
  final CardDetails card;

  const CardWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.borderLight.withValues(alpha: 0.65),
        ),
        image: DecorationImage(
          image: AssetImage('assets/icons/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: CustomPaint(
        painter: _CardTexturePainter(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [const _MastercardLogo()],
              ),
              const Spacer(),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/chip.svg',
                    width: 50,
                    height: 50,
                  ),
                  SizedBox(width: AppSpacing.sm),
                  SvgPicture.asset(
                    'assets/icons/Vector.svg',
                    width: 23,
                    height: 23,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                '•••• •••• •••• ${card.cardNumber.substring(card.cardNumber.length - 4)}',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.6,
                  height: 1,
                ),
                maxLines: 1,
                overflow: TextOverflow.clip,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CardMeta(label: 'Card Holder', value: card.holderName),
                  _CardMeta(label: 'Valid', value: card.expiryDate),
                  _CardMeta(label: 'CVV', value: card.cvv),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Card Back (shows balance after flip) ─────────────────────────────────────────

class _CardBack extends StatelessWidget {
  final CardDetails card;

  const _CardBack({required this.card});

  @override
  Widget build(BuildContext context) {
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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [_MastercardLogo()],
            ),
            const Spacer(),
            Center(
              child: Column(
                children: [
                  Text(
                    'Balance',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '\$${card.balance.toStringAsFixed(2)}',
                    style: AppTypography.heading2.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Magnetic strip
            Container(
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.darkGrey,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared Subwidgets ────────────────────────────────────────────────────────────

class _CardMeta extends StatelessWidget {
  final String label;
  final String value;

  const _CardMeta({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.captionSmall.copyWith(
            color: AppColors.textSecondary,
            height: 1,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: AppTypography.caption.copyWith(
            color: AppColors.textPrimary,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _MastercardLogo extends StatelessWidget {
  const _MastercardLogo();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/icons/Vector.png',
          width: 36,
          height: 28,
          fit: BoxFit.contain,
        ),
        Transform.translate(
          offset: const Offset(0, -3),
          child: Text(
            'mastercard',
            style: AppTypography.captionSmall.copyWith(
              color: AppColors.textPrimary,
              fontSize: 5,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}

class _CardTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textPrimary.withValues(alpha: 0.08)
      ..strokeWidth = 1;

    for (var i = 0; i < 360; i++) {
      final x = ((i * 41) % size.width.toInt()).toDouble();
      final y = ((i * 67) % size.height.toInt()).toDouble();
      canvas.drawCircle(Offset(x, y), i % 6 == 0 ? 1 : 0.55, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
