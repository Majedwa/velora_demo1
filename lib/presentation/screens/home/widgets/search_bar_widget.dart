// lib/presentation/screens/home/widgets/search_bar_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // تهيئة أدوات الاستجابة
    ResponsiveUtils.init(context);
    final screenWidth = MediaQuery.of(context).size.width;
    
    return GestureDetector(
      onTap: () => context.go('/search'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              PhosphorIcons.magnifying_glass,
              color: AppColors.textSecondary,
              size: screenWidth < 360 ? 18 : 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'ابحث عن مسار أو مكان...',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: screenWidth < 360 ? 14 : 16,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                PhosphorIcons.sliders,
                color: AppColors.primary,
                size: screenWidth < 360 ? 16 : 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}