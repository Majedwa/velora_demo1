// lib/presentation/screens/achievements/achievements_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../providers/user_provider.dart';
import '../../widgets/common/custom_app_bar.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'الإنجازات',
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // User Stats Card
          Card(
            color: AppColors.primary.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      '${user?.achievements ?? 0}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'الإنجازات المكتملة',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'استمر في الاستكشاف لكسب المزيد!',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Achievements List
          const _AchievementCategory(
            title: 'المسارات',
            achievements: [
              _Achievement(
                title: 'مستكشف مبتدئ',
                description: 'أكمل 5 مسارات مختلفة',
                icon: PhosphorIcons.boat,
                isCompleted: true,
                progress: 1.0,
              ),
              _Achievement(
                title: 'مستكشف متوسط',
                description: 'أكمل 15 مسارًا مختلفًا',
                icon: PhosphorIcons.backpack,
                isCompleted: false,
                progress: 0.3,
                progressText: '5/15',
              ),
              _Achievement(
                title: 'مستكشف متقدم',
                description: 'أكمل 30 مسارًا مختلفًا',
                icon: PhosphorIcons.mountains,
                isCompleted: false,
                progress: 0.16,
                progressText: '5/30',
              ),
            ],
          ),
          
          const _AchievementCategory(
            title: 'المناطق',
            achievements: [
              _Achievement(
                title: 'مستكشف الشمال',
                description: 'زر 5 مسارات مختلفة في شمال فلسطين',
                icon: PhosphorIcons.tree,
                isCompleted: false,
                progress: 0.4,
                progressText: '2/5',
              ),
              _Achievement(
                title: 'مستكشف الوسط',
                description: 'زر 5 مسارات مختلفة في وسط فلسطين',
                icon: PhosphorIcons.buildings,
                isCompleted: true,
                progress: 1.0,
              ),
              _Achievement(
                title: 'مستكشف الجنوب',
                description: 'زر 5 مسارات مختلفة في جنوب فلسطين',
                icon: PhosphorIcons.campfire_light,
                isCompleted: false,
                progress: 0.6,
                progressText: '3/5',
              ),
            ],
          ),
          
          const _AchievementCategory(
            title: 'المساهمات',
            achievements: [
              _Achievement(
                title: 'مساهم نشط',
                description: 'أضف 3 تقييمات لمسارات مختلفة',
                icon: PhosphorIcons.star,
                isCompleted: false,
                progress: 0.66,
                progressText: '2/3',
              ),
              _Achievement(
                title: 'مصور مسارات',
                description: 'شارك 5 صور لمسارات مختلفة',
                icon: PhosphorIcons.camera,
                isCompleted: false,
                progress: 0.2,
                progressText: '1/5',
              ),
            ],
          ),
          
          const _AchievementCategory(
            title: 'التحديات',
            achievements: [
              _Achievement(
                title: 'محبّ الارتفاعات',
                description: 'أكمل 3 مسارات بدرجة صعوبة عالية',
                icon: PhosphorIcons.mountains_light,
                isCompleted: false,
                progress: 0.33,
                progressText: '1/3',
              ),
              _Achievement(
                title: 'مسافر ليلي',
                description: 'شارك في رحلة تخييم ليلية',
                icon: PhosphorIcons.moon_stars,
                isCompleted: true,
                progress: 1.0,
              ),
              _Achievement(
                title: 'هاوي الآثار',
                description: 'زر 4 مواقع أثرية مختلفة',
                icon: PhosphorIcons.columns,
                isCompleted: false,
                progress: 0.75,
                progressText: '3/4',
              ),
            ],
          ),
          
          const _AchievementCategory(
            title: 'متميّزة',
            achievements: [
              _Achievement(
                title: 'مستكشف البحر الميت',
                description: 'تجربة الطفو في البحر الميت',
                icon: PhosphorIcons.waves,
                isCompleted: true,
                progress: 1.0,
              ),
              _Achievement(
                title: 'عاشق التراث',
                description: 'زيارة 3 مواقع تراث عالمي فلسطينية',
                icon: PhosphorIcons.globe,
                isCompleted: false,
                progress: 0.66,
                progressText: '2/3',
              ),
              _Achievement(
                title: 'مغامر الصحراء',
                description: 'قضاء ليلة كاملة في مخيم صحراوي',
                icon: PhosphorIcons.campfire_fill,
                isCompleted: true,
                progress: 1.0,
              ),
            ],
          ),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _AchievementCategory extends StatelessWidget {
  final String title;
  final List<_Achievement> achievements;

  const _AchievementCategory({
    required this.title,
    required this.achievements,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ...achievements,
        const Divider(height: 32),
      ],
    );
  }
}

class _Achievement extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isCompleted;
  final double progress;
  final String? progressText;

  const _Achievement({
    required this.title,
    required this.description,
    required this.icon,
    required this.isCompleted,
    required this.progress,
    this.progressText,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isCompleted 
                  ? AppColors.primary 
                  : AppColors.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isCompleted 
                  ? Colors.white 
                  : AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Stack(
                    children: [
                      Container(
                        height: 4,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: progress,
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: isCompleted 
                              ? AppColors.success
                              : AppColors.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (progressText != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        progressText!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            isCompleted
                ? Icon(
                    PhosphorIcons.trophy,
                    color: Colors.amber,
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}