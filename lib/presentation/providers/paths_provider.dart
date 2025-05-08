import 'package:flutter/foundation.dart';

import '../../data/models/path_model.dart';
import '../../data/repositories/paths_repository.dart';

class PathsProvider extends ChangeNotifier {
  final PathsRepository _repository = PathsRepository();
  
  List<PathModel> _paths = [];
  List<PathModel> _featuredPaths = [];
  bool _isLoading = false;
  String? _error;
  
  // Filters
  ActivityType? _selectedActivity;
  DifficultyLevel? _selectedDifficulty;
  String? _selectedLocation;
  
  List<PathModel> get paths => _paths;
  List<PathModel> get featuredPaths => _featuredPaths;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  List<PathModel> get filteredPaths {
    return _paths.where((path) {
      bool matchesActivity = _selectedActivity == null || 
          path.activities.contains(_selectedActivity);
      bool matchesDifficulty = _selectedDifficulty == null ||
          path.difficulty == _selectedDifficulty;
      bool matchesLocation = _selectedLocation == null ||
          path.locationAr.contains(_selectedLocation!);
      
      return matchesActivity && matchesDifficulty && matchesLocation;
    }).toList();
  }
  
  PathsProvider() {
    loadPaths();
  }
  
  Future<void> loadPaths() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _paths = await _repository.getAllPaths();
      _featuredPaths = await _repository.getFeaturedPaths();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void setActivityFilter(ActivityType? activity) {
    _selectedActivity = activity;
    notifyListeners();
  }
  
  void setDifficultyFilter(DifficultyLevel? difficulty) {
    _selectedDifficulty = difficulty;
    notifyListeners();
  }
  
  void setLocationFilter(String? location) {
    _selectedLocation = location;
    notifyListeners();
  }
  
  void clearFilters() {
    _selectedActivity = null;
    _selectedDifficulty = null;
    _selectedLocation = null;
    notifyListeners();
  }
  
  PathModel? getPathById(String id) {
    try {
      return _paths.firstWhere((path) => path.id == id);
    } catch (e) {
      return null;
    }
  }
}