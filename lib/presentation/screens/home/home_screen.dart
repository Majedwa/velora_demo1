// lib/presentation/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../data/models/path_model.dart';
import '../../providers/user_provider.dart';
import '../../providers/paths_provider.dart';
import '../../providers/saved_paths_provider.dart';
import '../paths/widgets/path_card.dart';
import 'widgets/featured_paths_carousel.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/home_category_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoadingPaths = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoadingPaths = true;
    });
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    setState(() {
      _isLoadingPaths = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveUtils.init(context);
    
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    
    final pathsProvider = Provider.of<PathsProvider>(context);
    final featuredPaths = pathsProvider.featuredPaths;
    final suggestedPaths = pathsProvider.paths.take(3).toList();
    
    final savedPathsProvider = Provider.of<SavedPathsProvider>(context);
    final savedPaths = savedPathsProvider.savedPaths.take(2).toList();
    
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadData,
        color: AppColors.primary,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              pinned: true,
              backgroundColor: Colors.white,
              elevation: 0,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 32,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Velora',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              centerTitle: false,
              actions: [
                // زر الإشعارات
                IconButton(
                  icon: Stack(
                    children: [
                      const Icon(
                        PhosphorIcons.bell,
                        color: AppColors.textPrimary,
                      ),
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
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('لا توجد إشعارات جديدة'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                // زر الإعدادات
                IconButton(
                  icon: const Icon(
                    PhosphorIcons.gear,
                    color: AppColors.textPrimary,
                  ),
                  onPressed: () {
                    context.go('/profile/settings');
                  },
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  padding: const EdgeInsets.only(top: 90, left: 16, right: 16),
                  child: user != null ? Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: AppColors.primary,
                        child: user.profileImageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(22),
                                child: Image.network(
                                  user.profileImageUrl!,
                                  width: 44,
                                  height: 44,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Text(
                                user.name.substring(0, 1).toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'مرحباً، ${user.name}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'استمتع باستكشاف فلسطين اليوم!',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ) : null,
                ),
              ),
            ),
            
            // شريط البحث والأزرار السريعة
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  children: [
                    const SearchBarWidget(),
                    const SizedBox(height: 16),
                    
                    // الأزرار السريعة مع وظائف عاملة
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _QuickActionChip(
                            icon: PhosphorIcons.compass,
                            label: 'استكشف',
                            onTap: () => context.go('/explore'),
                          ),
                          _QuickActionChip(
                            icon: PhosphorIcons.map_trifold,
                            label: 'المسارات',
                            onTap: () => context.go('/paths'),
                          ),
                          _QuickActionChip(
                            icon: PhosphorIcons.mountains,
                            label: 'التسلق',
                            onTap: () {
                              context.go('/paths');
                              Future.delayed(const Duration(milliseconds: 100), () {
                                final pathsProvider = Provider.of<PathsProvider>(context, listen: false);
                                pathsProvider.setActivityFilter(ActivityType.climbing);
                              });
                            },
                          ),
                          _QuickActionChip(
                            icon: PhosphorIcons.campfire,
                            label: 'التخييم',
                            onTap: () {
                              context.go('/paths');
                              Future.delayed(const Duration(milliseconds: 100), () {
                                final pathsProvider = Provider.of<PathsProvider>(context, listen: false);
                                pathsProvider.setActivityFilter(ActivityType.camping);
                              });
                            },
                          ),
                          _QuickActionChip(
                            icon: PhosphorIcons.tree,
                            label: 'الطبيعة',
                            onTap: () {
                              context.go('/paths');
                              Future.delayed(const Duration(milliseconds: 100), () {
                                final pathsProvider = Provider.of<PathsProvider>(context, listen: false);
                                pathsProvider.setActivityFilter(ActivityType.nature);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // المسارات المميزة
            SliverToBoxAdapter(
              child: Column(
                children: [
                  HomeCategoryHeader(
                    title: 'مسارات مميزة',
                    onViewAll: () => context.go('/paths'),
                  ),
                  if (_isLoadingPaths)
                    const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else
                    FeaturedPathsCarousel(paths: featuredPaths),
                ],
              ),
            ),
            
            // المسارات المحفوظة
            if (savedPaths.isNotEmpty)
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    HomeCategoryHeader(
                      title: 'محفوظاتك',
                      onViewAll: () => context.go('/profile/saved'),
                    ),
                    Container(
                      height: 220,
                      padding: const EdgeInsets.only(left: 16),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: savedPaths.length,
                        itemBuilder: (context, index) {
                          final path = savedPaths[index];
                          return Container(
                            width: 280,
                            padding: const EdgeInsets.only(right: 16),
                            child: PathCard(
                              path: path,
                              onTap: () => context.go('/paths/${path.id}'),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            
            // مغامرات مقترحة
            SliverToBoxAdapter(
              child: Column(
                children: [
                  HomeCategoryHeader(
                    title: 'مغامرات مقترحة',
                    onViewAll: () => context.go('/paths'),
                  ),
                  if (_isLoadingPaths)
                    const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: suggestedPaths.map((path) {
                          return PathCard(
                            path: path,
                            onTap: () => context.go('/paths/${path.id}'),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),
            
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: AppColors.primary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}