// lib/presentation/widgets/profile/completed_trips_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../providers/paths_provider.dart';
import '../../screens/paths/widgets/path_card.dart';

class CompletedTripsSheet extends StatelessWidget {
  const CompletedTripsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final pathsProvider = Provider.of<PathsProvider>(context);
    // للتوضيح: نأخذ أول 3 مسارات كرحلات مكتملة
    final completedPaths = pathsProvider.paths.take(3).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // مؤشر السحب والعنوان
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'الرحلات المكتملة',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    IconButton(
                      icon: const Icon(PhosphorIcons.x),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // قائمة الرحلات
          Expanded(
            child: completedPaths.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          PhosphorIcons.check_circle,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'لا توجد رحلات مكتملة',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'ابدأ برحلتك الأولى الآن!',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            context.go('/paths');
                          },
                          icon: const Icon(PhosphorIcons.map_trifold),
                          label: const Text('استكشف المسارات'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: completedPaths.length,
                    itemBuilder: (context, index) {
                      final path = completedPaths[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: PathCard(
                          path: path,
                          onTap: () {
                            Navigator.pop(context);
                            context.go('/paths/${path.id}');
                          },
                        ),
                      );
                    },
                  ),
          ),
          
          // إحصائيات في الأسفل
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatChip(
                  icon: PhosphorIcons.check_circle,
                  label: 'مكتملة',
                  value: completedPaths.length.toString(),
                  color: AppColors.success,
                ),
                _StatChip(
                  icon: PhosphorIcons.clock,
                  label: 'إجمالي الوقت',
                  value: '${completedPaths.fold<int>(0, (sum, path) => sum + path.estimatedDuration.inHours)} ساعة',
                  color: AppColors.primary,
                ),
                _StatChip(
                  icon: PhosphorIcons.ruler,
                  label: 'إجمالي المسافة',
                  value: '${completedPaths.fold<double>(0, (sum, path) => sum + path.length).toStringAsFixed(1)} كم',
                  color: AppColors.tertiary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}