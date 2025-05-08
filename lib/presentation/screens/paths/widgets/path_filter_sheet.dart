import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/path_model.dart';
import '../../../providers/paths_provider.dart';

class PathFilterSheet extends StatefulWidget {
  const PathFilterSheet({super.key});

  @override
  State<PathFilterSheet> createState() => _PathFilterSheetState();
}

class _PathFilterSheetState extends State<PathFilterSheet> {
  ActivityType? selectedActivity;
  DifficultyLevel? selectedDifficulty;
  String? selectedLocation;
  
  @override
  void initState() {
    super.initState();
    // لا نحتاج لقراءة القيم من provider هنا
    // لأن هذه filter sheet مستقلة
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'فلتر المسارات',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          
          // Activity type filter
          Text(
            'نوع النشاط',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ActivityType.values.map((activity) {
              return FilterChip(
                label: Text(_getActivityText(activity)),
                selected: selectedActivity == activity,
                onSelected: (selected) {
                  setState(() {
                    selectedActivity = selected ? activity : null;
                  });
                },
                selectedColor: AppColors.primary.withOpacity(0.2),
                checkmarkColor: AppColors.primary,
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          
          // Difficulty filter
          Text(
            'مستوى الصعوبة',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: DifficultyLevel.values.map((difficulty) {
              return FilterChip(
                label: Text(_getDifficultyText(difficulty)),
                selected: selectedDifficulty == difficulty,
                onSelected: (selected) {
                  setState(() {
                    selectedDifficulty = selected ? difficulty : null;
                  });
                },
                selectedColor: _getDifficultyColor(difficulty).withOpacity(0.2),
                checkmarkColor: _getDifficultyColor(difficulty),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          
          // Location filter
          Text(
            'الموقع',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['الشمال', 'الوسط', 'الجنوب'].map((location) {
              return FilterChip(
                label: Text(location),
                selected: selectedLocation == location,
                onSelected: (selected) {
                  setState(() {
                    selectedLocation = selected ? location : null;
                  });
                },
                selectedColor: AppColors.primary.withOpacity(0.2),
                checkmarkColor: AppColors.primary,
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      selectedActivity = null;
                      selectedDifficulty = null;
                      selectedLocation = null;
                    });
                  },
                  child: const Text('مسح الكل'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final provider = context.read<PathsProvider>();
                    provider.setActivityFilter(selectedActivity);
                    provider.setDifficultyFilter(selectedDifficulty);
                    provider.setLocationFilter(selectedLocation);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: const Text('تطبيق'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
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
        return AppColors.success;
      case DifficultyLevel.medium:
        return AppColors.warning;
      case DifficultyLevel.hard:
        return AppColors.error;
    }
  }
}