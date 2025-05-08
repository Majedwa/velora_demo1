// lib/presentation/screens/map/map_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/path_model.dart';
import '../../providers/paths_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import 'widgets/map_control_button.dart';
import 'widgets/path_info_bottom_sheet.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  bool _isLoading = true;
  bool _showPathsFilter = false;
  String? _selectedPathId;
  LatLng _currentLocation = LatLng(
    AppConstants.defaultMapLatitude,
    AppConstants.defaultMapLongitude,
  );
  double _currentZoom = AppConstants.defaultMapZoom;
  
  // فلترة المسارات
  DifficultyLevel? _selectedDifficulty;
  ActivityType? _selectedActivity;
  
  @override
  void initState() {
    super.initState();
    _loadPaths();
  }
  
  Future<void> _loadPaths() async {
    setState(() {
      _isLoading = true;
    });
    
    // في تطبيق حقيقي، سنحتاج إلى جلب البيانات عبر API
    await Future.delayed(const Duration(milliseconds: 500));
    
    setState(() {
      _isLoading = false;
    });
    
    // استخدام موقع افتراضي (في تطبيق حقيقي سنستخدم الموقع الفعلي للمستخدم)
    _centerMapToInitialPosition();
  }
  
  void _centerMapToInitialPosition() {
    _mapController.move(_currentLocation, _currentZoom);
  }
  
  void _onMapTap(TapPosition tapPosition, LatLng point) {
    setState(() {
      _selectedPathId = null;
    });
    
    _showPathsFilter = false;
  }
  
  void _onMarkerTap(PathModel path) {
    setState(() {
      _selectedPathId = path.id;
    });
    
    // تحريك الخريطة إلى موقع المسار
    _mapController.move(path.coordinates.first, 13.0);
    
    // عرض معلومات المسار
    _showPathInfoBottomSheet(path);
  }
  
  void _onPathTap(PathModel path) {
    setState(() {
      _selectedPathId = path.id;
    });
    
    // عرض معلومات المسار
    _showPathInfoBottomSheet(path);
  }
  
  void _showPathInfoBottomSheet(PathModel path) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PathInfoBottomSheet(
        path: path,
        onViewDetails: () {
          Navigator.of(context).pop();
          context.go('/paths/${path.id}');
        },
      ),
    );
  }
  
  void _togglePathsFilter() {
    setState(() {
      _showPathsFilter = !_showPathsFilter;
    });
  }
  
  void _clearFilters() {
    setState(() {
      _selectedDifficulty = null;
      _selectedActivity = null;
    });
  }
  
  void _centerUserLocation() {
    // في تطبيق حقيقي، سنحتاج إلى جلب الموقع الفعلي للمستخدم
    _mapController.move(_currentLocation, 13.0);
  }
  
  @override
  Widget build(BuildContext context) {
    final pathsProvider = Provider.of<PathsProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final paths = pathsProvider.paths;
    
    // تطبيق الفلترة
    final filteredPaths = paths.where((path) {
      if (_selectedDifficulty != null && path.difficulty != _selectedDifficulty) {
        return false;
      }
      
      if (_selectedActivity != null && !path.activities.contains(_selectedActivity)) {
        return false;
      }
      
      return true;
    }).toList();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('الخريطة'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _showPathsFilter ? PhosphorIcons.funnel_fill : PhosphorIcons.funnel,
              color: _showPathsFilter ? AppColors.primary : null,
            ),
            onPressed: _togglePathsFilter,
          ),
        ],
      ),
      body: Stack(
        children: [
          // الخريطة
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation,
              initialZoom: _currentZoom,
              minZoom: 4.0,
              maxZoom: 18.0,
              onTap: _onMapTap,
            ),
            children: [
              // طبقة الخريطة
              TileLayer(
                urlTemplate: settingsProvider.mapType == 'satellite'
                    ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
                    : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.velora',
              ),
              
              // طبقة مسارات الخريطة
              PolylineLayer(
                polylines: filteredPaths.map((path) {
                  return Polyline(
                    points: path.coordinates,
                    color: path.id == _selectedPathId
                        ? AppColors.secondary
                        : AppColors.primary,
                    strokeWidth: path.id == _selectedPathId ? 5.0 : 3.0,
                  );
                }).toList(),
              ),
              
              // طبقة النقاط
              MarkerLayer(
                markers: [
                  // نقطة موقع المستخدم
                  Marker(
                    point: _currentLocation,
                    width: 40,
                    height: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.tertiary.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: AppColors.tertiary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // نقاط بداية المسارات
                  ...filteredPaths.map((path) {
                    return Marker(
                      point: path.coordinates.first,
                      width: 40,
                      height: 40,
                      child: GestureDetector(
                        onTap: () => _onMarkerTap(path),
                        child: Icon(
                          path.id == _selectedPathId
                              ? PhosphorIcons.map_pin_fill
                              : PhosphorIcons.map_pin,
                          color: path.id == _selectedPathId
                              ? AppColors.secondary
                              : AppColors.primary,
                          size: path.id == _selectedPathId ? 36 : 30,
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ],
          ),
          
          // تحميل البيانات
          if (_isLoading)
            const LoadingIndicator(
              message: 'جاري تحميل المسارات...',
            ),
          
          // فلترة المسارات
          if (_showPathsFilter)
            Positioned(
              top: 8,
              left: 16,
              right: 16,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'فلتر المسارات',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(PhosphorIcons.x),
                            onPressed: _togglePathsFilter,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      
                      // فلتر مستوى الصعوبة
                      const Text(
                        'مستوى الصعوبة',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: DifficultyLevel.values.map((difficulty) {
                          return FilterChip(
                            label: Text(_getDifficultyText(difficulty)),
                            selected: _selectedDifficulty == difficulty,
                            onSelected: (selected) {
                              setState(() {
                                _selectedDifficulty = selected ? difficulty : null;
                              });
                            },
                            selectedColor: _getDifficultyColor(difficulty).withOpacity(0.3),
                            checkmarkColor: _getDifficultyColor(difficulty),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),
                      
                      // فلتر نوع النشاط
                      const Text(
                        'نوع النشاط',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: ActivityType.values.map((activity) {
                          return FilterChip(
                            label: Text(_getActivityText(activity)),
                            selected: _selectedActivity == activity,
                            onSelected: (selected) {
                              setState(() {
                                _selectedActivity = selected ? activity : null;
                              });
                            },
                            selectedColor: AppColors.primary.withOpacity(0.2),
                            checkmarkColor: AppColors.primary,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      
                      // زر مسح الفلاتر
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: _clearFilters,
                          child: const Text('مسح الفلاتر'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          
          // أزرار تحكم الخريطة
          Positioned(
            bottom: 24,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MapControlButton(
                  icon: PhosphorIcons.plus,
                  onPressed: () {
                    _mapController.move(
                      _mapController.camera.center, 
                      _mapController.camera.zoom + 1,
                    );
                  },
                ),
                const SizedBox(height: 8),
                MapControlButton(
                  icon: PhosphorIcons.minus,
                  onPressed: () {
                    _mapController.move(
                      _mapController.camera.center, 
                      _mapController.camera.zoom - 1,
                    );
                  },
                ),
                const SizedBox(height: 8),
                MapControlButton(
                  icon: PhosphorIcons.map_pin,
                  onPressed: _centerUserLocation,
                ),
                const SizedBox(height: 8),
                MapControlButton(
                  icon: settingsProvider.mapType == 'satellite'
                      ? PhosphorIcons.map_pin
                      : PhosphorIcons.tree,
                  onPressed: () {
                    final newType = settingsProvider.mapType == 'satellite'
                        ? 'standard'
                        : 'satellite';
                    settingsProvider.setMapType(newType);
                  },
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
}