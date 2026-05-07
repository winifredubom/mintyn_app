import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/typography.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final bool centerTitle;
  final List<Widget>? actions;
  final Widget? leading;
  final double elevation;
  final Color backgroundColor;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.centerTitle = true,
    this.actions,
    this.leading,
    this.elevation = 0,
    this.backgroundColor = AppColors.darkGrey,
  }) : assert(title != null || titleWidget != null);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title:
          titleWidget ??
          Text(
            title!,
            style: AppTypography.heading3.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
      centerTitle: centerTitle,
      actions: actions,
      leading: leading,
      elevation: elevation,
      backgroundColor: backgroundColor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
