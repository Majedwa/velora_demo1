import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/path_model.dart';
import '../../widgets/navigation/bottom_nav_bar.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  ActivityType? selectedActivity;
  DifficultyLevel? selectedDifficulty;
  String? selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('استكشف'),
      ),
      body: Column(
        children: [
          // Filters section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'فلتر حسب',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                
                // Activity type filter
                Text(
                  'نوع النشاط',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
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
                const SizedBox(height: 16),
                
                // Difficulty filter
                Text(
                  'مستوى الصعوبة',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
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
                const SizedBox(height: 16),
                
                // Location filter
                Text(
                  'الموقع',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
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
              ],
            ),
          ),
          
          // Results section
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: 6, // Replace with actual data
              itemBuilder: (context, index) {
                return _ExploreCard();
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
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

class _ExploreCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                image: const DecorationImage(
                  image: NetworkImage('https://example.com/image.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مسار وادي قانا',
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      PhosphorIcons.map_pin,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'سلفيت',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      PhosphorIcons.star_fill,
                      size: 14,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '4.8',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}