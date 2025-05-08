// lib/presentation/widgets/common/custom_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import '../../../core/constants/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool centerTitle;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final double? elevation;
  final Color? backgroundColor;
  final bool isTransparent;
  final bool useLightStatusBar;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.centerTitle = true,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.elevation,
    this.backgroundColor,
    this.isTransparent = false,
    this.useLightStatusBar = false,
  });

  @override
  Widget build(BuildContext context) {
    // تعديل شريط الحالة بناءً على الإعدادات
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: useLightStatusBar ? Brightness.light : Brightness.dark,
        statusBarBrightness: useLightStatusBar ? Brightness.dark : Brightness.light,
      ),
    );

    if (isTransparent) {
      return AppBar(
        title: Text(title),
        actions: actions,
        centerTitle: centerTitle,
        leading: leading,
        automaticallyImplyLeading: automaticallyImplyLeading,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: useLightStatusBar ? Colors.white : AppColors.textPrimary,
        iconTheme: IconThemeData(
          color: useLightStatusBar ? Colors.white : AppColors.primary,
        ),
      );
    }

    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: backgroundColor != null && backgroundColor!.computeLuminance() < 0.5 
              ? Colors.white 
              : AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: actions,
      centerTitle: centerTitle,
      leading: leading ?? (
        automaticallyImplyLeading && Navigator.of(context).canPop()
          ? IconButton(
              icon: const Icon(PhosphorIcons.caret_left),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null
      ),
      backgroundColor: backgroundColor ?? Colors.white,
      elevation: elevation ?? 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
      shadowColor: Colors.black12,
      iconTheme: IconThemeData(
        color: backgroundColor != null && backgroundColor!.computeLuminance() < 0.5 
            ? Colors.white 
            : AppColors.primary,
      ),
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: backgroundColor != null && backgroundColor!.computeLuminance() < 0.5 
            ? Colors.white 
            : AppColors.primary,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}