// lib/presentation/screens/map/widgets/path_info_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/path_model.dart';

class PathInfoBottomSheet extends StatelessWidget {
  final PathModel path;
  final VoidCallback onViewDetails;

  const PathInfoBottomSheet({
    super.key,
    required this.path,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // مؤشر السحب
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // صورة المسار
          Container(
            margin: const EdgeInsets.all(16),
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  // الصورة
                  CachedNetworkImage(
                    imageUrl: path.images[0],
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        PhosphorIcons.image,
                        color: Colors.grey,
                        size: 48,
                      ),
                    ),
                  ),
                  
                  // تدرج شفاف للصورة لتحسين قراءة النص
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                          stops: const [0.6, 1.0],
                        ),
                      ),
                    ),
                  ),
                  
                  // مؤشر الصعوبة
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getDifficultyColor(path.difficulty).withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _getDifficultyIcon(path.difficulty),
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _getDifficultyText(path.difficulty),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // اسم المسار
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Text(
                      path.nameAr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // معلومات المسار
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الموقع
                Row(
                  children: [
                    const Icon(
                      PhosphorIcons.map_pin,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        path.locationAr,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // مؤشرات المسار
                Row(
                  children: [
                    Expanded(
                      child: _InfoItem(
                        icon: PhosphorIcons.ruler,
                        value: '${path.length}',
                        unit: 'كم',
                      ),
                    ),
                    Expanded(
                      child: _InfoItem(
                        icon: PhosphorIcons.clock,
                        value: '${path.estimatedDuration.inHours}',
                        unit: 'ساعات',
                      ),
                    ),
                    Expanded(
                      child: _InfoItem(
                        icon: PhosphorIcons.star,
                        value: '${path.rating}',
                        unit: '(${path.reviewCount})',
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // الأنشطة
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: path.activities.take(3).map((activity) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getActivityIcon(activity),
                            size: 14,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _getActivityText(activity),
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                
                // الوصف
                Text(
                  path.descriptionAr,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                
                // زر عرض التفاصيل
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onViewDetails,
                    icon: const Icon(PhosphorIcons.arrow_square_out),
                    label: const Text('عرض التفاصيل'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getDifficultyText(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return 'سهل';
      case DifficultyLevel.medium:
        return 'متوسط';
      case DifficultyLevel.hard:
        return 'صعب';
    }
  }

  Color _getDifficultyColor(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return AppColors.difficultyEasy;
      case DifficultyLevel.medium:
        return AppColors.difficultyMedium;
      case DifficultyLevel.hard:
        return AppColors.difficultyHard;
    }
  }

  IconData _getDifficultyIcon(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return PhosphorIcons.heart_straight;
      case DifficultyLevel.medium:
        return PhosphorIcons.lightning;
      case DifficultyLevel.hard:
        return PhosphorIcons.warning;
    }
  }
  
  String _getActivityText(ActivityType activity) {
    switch (activity) {
      case ActivityType.hiking:
        return 'المشي';
      case ActivityType.camping:
        return 'التخييم';
      case ActivityType.climbing:
        return 'التسلق';
      case ActivityType.religious:
        return 'ديني';
      case ActivityType.cultural:
        return 'ثقافي';
      case ActivityType.nature:
        return 'طبيعة';
      case ActivityType.archaeological:
        return 'أثري';
    }
  }

  IconData _getActivityIcon(ActivityType activity) {
    switch (activity) {
      case ActivityType.hiking:
        return PhosphorIcons.person_simple_walk;
      case ActivityType.camping:
        return PhosphorIcons.campfire;
      case ActivityType.climbing:
        return PhosphorIcons.mountains;
      case ActivityType.religious:
        return PhosphorIcons.star;
      case ActivityType.cultural:
        return PhosphorIcons.book_open;
      case ActivityType.nature:
        return PhosphorIcons.tree;
      case ActivityType.archaeological:
        return PhosphorIcons.buildings;
    }
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String unit;
  final Color? color;

  const _InfoItem({
    required this.icon,
    required this.value,
    required this.unit,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: color ?? AppColors.primary,
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color ?? AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 2),
        Text(
          unit,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}