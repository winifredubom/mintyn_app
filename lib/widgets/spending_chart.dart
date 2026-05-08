// lib/widgets/spending_chart.dart

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../constants/colors.dart';
import '../constants/spacing.dart';
import '../constants/typography.dart';

class SpendingChart extends StatefulWidget {
  final List<double> monthlyData;
  final List<String> months;
  final String totalSpend;
  final String selectedPeriod;
  final Function(String) onPeriodChanged;

  const SpendingChart({
    Key? key,
    required this.monthlyData,
    required this.months,
    this.totalSpend = '30',
    this.selectedPeriod = 'Weekly',
    required this.onPeriodChanged,
  }) : super(key: key);

  @override
  State<SpendingChart> createState() => _SpendingChartState();
}

class _SpendingChartState extends State<SpendingChart> {
  late String _selectedPeriod;
  int? _touchedIndex;
  double? _touchedValue;

  @override
  void initState() {
    super.initState();
    _selectedPeriod = widget.selectedPeriod;
  }

  @override
  void didUpdateWidget(SpendingChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedPeriod != widget.selectedPeriod) {
      setState(() {
        _selectedPeriod = widget.selectedPeriod;
        _touchedIndex = null;
        _touchedValue = null;
      });
    }
  }

  // Extend line to edges with padding spots
  List<FlSpot> get _spots {
    final spots = <FlSpot>[];
    spots.add(FlSpot(-0.5, widget.monthlyData.first));
    for (int i = 0; i < widget.monthlyData.length; i++) {
      spots.add(FlSpot(i.toDouble(), widget.monthlyData[i]));
    }
    spots.add(FlSpot(
      widget.monthlyData.length - 0.5,
      widget.monthlyData.last,
    ));
    return spots;
  }

  double get _maxY {
    final max = widget.monthlyData.reduce((a, b) => a > b ? a : b);
    return max * 1.3;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.only(
        top: AppSpacing.lg,
        bottom: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        border: Border.all(color: AppColors.borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header Row ───────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Total Spend',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      '\$${widget.totalSpend}',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                _buildPeriodDropdown(),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // ── Chart ────────────────────────────────────────────────
          SizedBox(
            height: 220,
            child: LineChart(
              _buildLineChartData(),
              duration: const Duration(milliseconds: 300),
            ),
          ),
        ],
      ),
    );
  }

  LineChartData _buildLineChartData() {
    return LineChartData(
      backgroundColor: Colors.transparent,
      clipData: const FlClipData.all(),

      // ── Grid ─────────────────────────────────────────────────────
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        drawHorizontalLine: true,
        horizontalInterval: _maxY / 4,
        getDrawingHorizontalLine: (_) => FlLine(
          color: AppColors.borderColor.withOpacity(0.2),
          strokeWidth: 1,
        ),
      ),

      borderData: FlBorderData(show: false),

      // ── Axes — padded so Jan & Jun are fully visible ──────────────
      minX: -0.5,
      maxX: (widget.monthlyData.length - 1).toDouble() + 0.5,
      minY: -(_maxY * 0.12),
      maxY: _maxY,

      titlesData: FlTitlesData(
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: 36,
            getTitlesWidget: (value, meta) {
              // Only show labels at exact integer positions
              if (value != value.roundToDouble()) return const SizedBox();
              final index = value.toInt();
              if (index < 0 || index >= widget.months.length) {
                return const SizedBox();
              }
              return Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(
                  widget.months[index],
                  style: AppTypography.captionSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              );
            },
          ),
        ),
      ),

      // ── Touch ─────────────────────────────────────────────────────
      lineTouchData: LineTouchData(
        enabled: true,
        touchCallback: (event, response) {
          setState(() {
            if (response?.lineBarSpots != null &&
                response!.lineBarSpots!.isNotEmpty) {
              _touchedIndex = response.lineBarSpots!.first.x.toInt();
              _touchedValue = response.lineBarSpots!.first.y;
            } else if (event is FlPointerExitEvent) {
              _touchedIndex = null;
              _touchedValue = null;
            }
          });
        },
        getTouchedSpotIndicator: (barData, spotIndexes) {
          return spotIndexes.map((index) {
            return TouchedSpotIndicatorData(
              FlLine(
                color: AppColors.textSecondary.withOpacity(0.6),
                strokeWidth: 1,
                dashArray: [4, 4],
              ),
              FlDotData(
                getDotPainter: (spot, percent, bar, idx) =>
                    FlDotCirclePainter(
                  radius: 6,
                  color: AppColors.textPrimary,
                  strokeWidth: 2,
                  strokeColor: AppColors.primaryBlue,
                ),
              ),
            );
          }).toList();
        },
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (_) => AppColors.textPrimary,
          tooltipBorderRadius:
              BorderRadius.circular(AppSpacing.radiusMedium),
          tooltipPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              return LineTooltipItem(
                '\$${spot.y.toStringAsFixed(0)}',
                AppTypography.labelMedium.copyWith(
                  color: AppColors.darkBg,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList();
          },
        ),
      ),

      // ── Line + Fill ───────────────────────────────────────────────
      lineBarsData: [
        LineChartBarData(
          spots: _spots,
          isCurved: true,
          curveSmoothness: 0.4,
          color: AppColors.primaryBlue,
          barWidth: 2.5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryBlue.withOpacity(0.6),
                AppColors.primaryBlue.withOpacity(0.3),
                AppColors.primaryBlue.withOpacity(0.05),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodDropdown() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        setState(() => _selectedPeriod = value);
        widget.onPeriodChanged(value);
      },
      color: AppColors.cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        side: const BorderSide(color: AppColors.borderColor),
      ),
      itemBuilder: (_) => ['Weekly', 'Monthly', 'Yearly']
          .map(
            (period) => PopupMenuItem<String>(
              value: period,
              child: Text(
                period,
                style: AppTypography.bodySmall.copyWith(
                  color: _selectedPeriod == period
                      ? AppColors.primaryBlue
                      : AppColors.textPrimary,
                ),
              ),
            ),
          )
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryBlue),
          borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.expand_more,
              color: AppColors.textSecondary,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              _selectedPeriod,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}