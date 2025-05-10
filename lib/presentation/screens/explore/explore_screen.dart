// lib/presentation/screens/explore/explore_screen.dart - النسخة النهائية
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/path_model.dart';
import '../../../data/models/activity_model.dart';
import '../../providers/paths_provider.dart';
import '../paths/widgets/path_card.dart';
import '../../widgets/common/loading_indicator.dart';
import 'widgets/explore_card.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  ActivityType? selectedActivity;
  DifficultyLevel? selectedDifficulty;
  String? selectedLocation;
  bool _isSearching = false;
  
  late TabController _tabController;
  final List<Map<String, dynamic>> _tabHeaders = [
    {'title': 'المسارات', 'icon': PhosphorIcons.map_trifold},
    {'title': 'المناطق', 'icon': PhosphorIcons.map_pin},
    {'title': 'الأنشطة', 'icon': PhosphorIcons.compass},
  ];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabHeaders.length, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }
  
  List<PathModel> _getFilteredPaths(List<PathModel> allPaths) {
    return allPaths.where((path) {
      // فلترة بناءً على البحث
      bool matchesSearch = _searchQuery.isEmpty ||
          path.nameAr.toLowerCase().contains(_searchQuery) ||
          path.name.toLowerCase().contains(_searchQuery) ||
          path.descriptionAr.toLowerCase().contains(_searchQuery) ||
          path.locationAr.toLowerCase().contains(_searchQuery);
      
      // فلترة بناءً على النشاط
      bool matchesActivity = selectedActivity == null ||
          path.activities.contains(selectedActivity);
      
      // فلترة بناءً على الصعوبة
      bool matchesDifficulty = selectedDifficulty == null ||
          path.difficulty == selectedDifficulty;
      
      // فلترة بناءً على الموقع
      bool matchesLocation = selectedLocation == null ||
          path.locationAr.contains(selectedLocation!);
      
      return matchesSearch && matchesActivity && matchesDifficulty && matchesLocation;
    }).toList();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // شريط التطبيق
            SliverAppBar(
              expandedHeight: 60,
              pinned: true,
              backgroundColor: Colors.white,
              elevation: 0,
              title: Row(
                children: [
                  Text(
                    'استكشف',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    PhosphorIcons.compass,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: Stack(
                    children: [
                      Icon(
                        PhosphorIcons.funnel,
                        color: AppColors.primary,
                      ),
                      if (selectedActivity != null || selectedDifficulty != null || selectedLocation != null)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.secondary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                  onPressed: _showFilterBottomSheet,
                ),
              ],
            ),
            
            // شريط البحث
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: _buildSearchBar(),
              ),
            ),
            
            // شريط التبويبات
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 3,
                      ),
                      insets: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textSecondary,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                    tabs: _tabHeaders.map((tab) => Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(tab['icon'], size: 18),
                          const SizedBox(width: 6),
                          Text(tab['title']),
                        ],
                      ),
                    )).toList(),
                  ),
                ),
              ),
            ),
          ];
        },
        body: Consumer<PathsProvider>(
          builder: (context, pathsProvider, child) {
            if (pathsProvider.isLoading) {
              return const LoadingIndicator();
            }
            
            final allPaths = pathsProvider.paths;
            final filteredPaths = _getFilteredPaths(allPaths);
            
            return TabBarView(
              controller: _tabController,
              children: [
                // تبويب المسارات
                _buildPathsTab(filteredPaths),
                
                // تبويب المناطق
                _buildRegionsTab(allPaths),
                
                // تبويب الأنشطة
                _buildActivitiesTab(allPaths),
              ],
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildSearchBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(24),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'ابحث عن مسار، مكان أو نشاط...',
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 15,
          ),
          prefixIcon: Icon(
            PhosphorIcons.magnifying_glass,
            color: AppColors.textSecondary,
            size: 20,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    PhosphorIcons.x,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        style: const TextStyle(fontSize: 15),
      ),
    );
  }
  
  Widget _buildPathsTab(List<PathModel> filteredPaths) {
    if (filteredPaths.isEmpty) {
      return _buildEmptyState(
        icon: PhosphorIcons.map_trifold,
        title: 'لا توجد مسارات متاحة',
        subtitle: 'جرب تغيير الفلترات أو البحث عن شيء آخر',
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: filteredPaths.length,
      itemBuilder: (context, index) {
        final path = filteredPaths[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ExploreCard(
            path: path,
            onTap: () => context.go('/paths/${path.id}'),
          ),
        );
      },
    );
  }
  
  Widget _buildRegionsTab(List<PathModel> allPaths) {
    final regions = <String, List<PathModel>>{};
    
    for (final path in allPaths) {
      // تصنيف المسارات حسب المنطقة
      String region;
      if (path.locationAr.contains('الشمال') || path.locationAr.contains('الجليل')) {
        region = 'الشمال';
      } else if (path.locationAr.contains('الوسط') || path.locationAr.contains('رام الله') || path.locationAr.contains('نابلس')) {
        region = 'الوسط';
      } else {
        region = 'الجنوب';
      }
      
      regions[region] ??= [];
      regions[region]!.add(path);
    }
    
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: regions.entries.length,
      itemBuilder: (context, index) {
        final entry = regions.entries.elementAt(index);
        final region = entry.key;
        final paths = entry.value;
        
        // اختيار أيقونة المنطقة
        IconData regionIcon;
        Color regionColor;
        if (region == 'الشمال') {
          regionIcon = PhosphorIcons.mountains;
          regionColor = Colors.blue;
        } else if (region == 'الوسط') {
          regionIcon = PhosphorIcons.buildings;
          regionColor = Colors.orange;
        } else {
          regionIcon = PhosphorIcons.tree;
          regionColor = Colors.green;
        }
        
        return _buildRegionSection(
          region: region,
          paths: paths,
          icon: regionIcon,
          color: regionColor,
        );
      },
    );
  }
  
  Widget _buildRegionSection({
    required String region,
    required List<PathModel> paths,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'منطقة $region',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${paths.length} مسار متوفر',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedLocation = region;
                    _tabController.animateTo(0);
                  });
                },
                child: const Text('عرض الكل'),
              ),
            ],
          ),
        ),
        
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: paths.take(5).length,
            itemBuilder: (context, index) {
              final path = paths[index];
              return Container(
                width: 320,
                margin: const EdgeInsets.only(right: 12),
                child: ExploreCard(
                  path: path,
                  onTap: () => context.go('/paths/${path.id}'),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
  
  Widget _buildActivitiesTab(List<PathModel> allPaths) {
    final activities = ActivityModel.getAllActivities();
    
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        final pathsCount = allPaths
            .where((path) => path.activities.contains(
                ActivityType.values.byName(activity.id)))
            .length;
        
        return _buildActivityCard(activity, pathsCount);
      },
    );
  }
  
  Widget _buildActivityCard(ActivityModel activity, int pathsCount) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedActivity = ActivityType.values.byName(activity.id);
          _tabController.animateTo(0);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: activity.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                activity.icon,
                color: activity.color,
                size: 30,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              activity.nameAr,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              '$pathsCount مسار${pathsCount > 10 ? '' : ''}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // العنوان والخط المؤشر
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'تصفية النتائج',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(PhosphorIcons.x),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // فلتر النشاط
              Text(
                'نوع النشاط',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: ActivityType.values.map((activity) {
                  final isSelected = selectedActivity == activity;
                  return _buildFilterChip(
                    label: _getActivityText(activity),
                    isSelected: isSelected,
                    onSelected: (selected) {
                      setModalState(() {
                        setState(() {
                          selectedActivity = selected ? activity : null;
                        });
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              
              // فلتر الصعوبة
              Text(
                'مستوى الصعوبة',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: DifficultyLevel.values.map((difficulty) {
                  final isSelected = selectedDifficulty == difficulty;
                  final color = _getDifficultyColor(difficulty);
                  return _buildFilterChip(
                    label: _getDifficultyText(difficulty),
                    isSelected: isSelected,
                    color: color,
                    onSelected: (selected) {
                      setModalState(() {
                        setState(() {
                          selectedDifficulty = selected ? difficulty : null;
                        });
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              
              // فلتر المنطقة
              Text(
                'المنطقة',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: ['الشمال', 'الوسط', 'الجنوب'].map((location) {
                  final isSelected = selectedLocation == location;
                  return _buildFilterChip(
                    label: location,
                    isSelected: isSelected,
                    onSelected: (selected) {
                      setModalState(() {
                        setState(() {
                          selectedLocation = selected ? location : null;
                        });
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 40),
              
              // عداد النتائج
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      PhosphorIcons.map_trifold,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Consumer<PathsProvider>(
                      builder: (context, provider, child) {
                        final filteredPaths = _getFilteredPaths(provider.paths);
                        return Text(
                          '${filteredPaths.length} مسار متوفر',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // أزرار الإجراءات
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
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('مسح الفلترات'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('تطبيق الفلترات'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required Function(bool) onSelected,
    Color? color,
  }) {
    final chipColor = color ?? AppColors.primary;
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? chipColor : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: Colors.white,
      selectedColor: chipColor.withOpacity(0.1),
      checkmarkColor: chipColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
        side: BorderSide(
          color: isSelected ? chipColor : Colors.grey[300]!,
          width: 1,
        ),
      ),
      elevation: 0,
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
        return AppColors.difficultyEasy;
      case DifficultyLevel.medium:
        return AppColors.difficultyMedium;
      case DifficultyLevel.hard:
        return AppColors.difficultyHard;
    }
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverAppBarDelegate(this.child);

  @override
  double get minExtent => 48;
  
  @override
  double get maxExtent => 48;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}